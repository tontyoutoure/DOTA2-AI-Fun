modifier_hamsterlord_injure_knees_slow = class({})

function modifier_hamsterlord_injure_knees_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_hamsterlord_injure_knees_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("slow_per_stack") end

function modifier_hamsterlord_injure_knees_slow:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end
function modifier_hamsterlord_injure_knees_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_hamsterlord_injure_knees = class({})
function modifier_hamsterlord_injure_knees:IsPurgable() return false end
function modifier_hamsterlord_injure_knees:RemoveOnDeath() return false end
function modifier_hamsterlord_injure_knees:IsHidden() return true end

function modifier_hamsterlord_injure_knees:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ATTACK_FINISHED} end

function modifier_hamsterlord_injure_knees:OnAttackStart(keys)
	local hParent = self:GetParent()
	if keys.attacker ~= hParent or hParent:PassivesDisabled() then return end
	StartAnimation(hParent, {duration = 1/(1+hParent:GetIncreasedAttackSpeed()), activity=ACT_DOTA_CAST_ABILITY_5, rate=(1+hParent:GetIncreasedAttackSpeed())*0.2/0.3})
end

function modifier_hamsterlord_injure_knees:OnAttackFinished(keys)
	local hParent = self:GetParent()
	if keys.attacker ~= hParent then return end
	EndAnimation(hParent)
end

function modifier_hamsterlord_injure_knees:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or keys.target:IsBuilding() then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if not keys.target:HasModifier("modifier_hamsterlord_injure_knees_slow") then
		keys.target:AddNewModifier(self:GetParent(), hAbility, "modifier_hamsterlord_injure_knees_slow", {Duration = hAbility:GetSpecialValueFor("slow_duration")*CalculateStatusResist(keys.target)}):SetStackCount(1)
	elseif keys.target:FindModifierByName("modifier_hamsterlord_injure_knees_slow"):GetStackCount() < hAbility:GetSpecialValueFor("max_stack") then
		keys.target:FindModifierByName("modifier_hamsterlord_injure_knees_slow"):IncrementStackCount()
		keys.target:FindModifierByName("modifier_hamsterlord_injure_knees_slow"):SetDuration(hAbility:GetSpecialValueFor("slow_duration")*CalculateStatusResist(keys.target), true)
	else
		keys.target:EmitSound("Hero_Tusk.WalrusKick.Target")
		keys.target:AddNewModifier(hParent, hAbility, "modifier_hamsterlord_injure_knees_stun", {Duration = hAbility:GetSpecialValueFor("stun_duration")*CalculateStatusResist(hParent)})
		if hParent:HasAbility("special_bonus_hamsterlord_1") then
			ApplyDamage({victim = keys.target, damage = hParent:FindAbilityByName("special_bonus_hamsterlord_1"):GetSpecialValueFor("value")+hAbility:GetSpecialValueFor("damage"), damage_type = hAbility:GetAbilityDamageType(), attacker=hParent, ability = hAbility})
		else			
			ApplyDamage({victim = keys.target, damage = hAbility:GetSpecialValueFor("damage"), damage_type = hAbility:GetAbilityDamageType(), attacker=hParent, ability = hAbility})
		end
		if keys.target:FindModifierByName("modifier_hamsterlord_injure_knees_slow") then
			keys.target:FindModifierByName("modifier_hamsterlord_injure_knees_slow"):Destroy()
		end
	end
end

modifier_hamsterlord_injure_knees_stun = class({})
function modifier_hamsterlord_injure_knees_stun:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_hamsterlord_injure_knees_stun:IsPurgeException() return true end
function modifier_hamsterlord_injure_knees_stun:RemoveOnDeath() return false end
function modifier_hamsterlord_injure_knees_stun:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_hamsterlord_injure_knees_stun:GetEffectName() return "particles/units/heroes/hero_tusk/tusk_walruspunch_tgt.vpcf" end
function modifier_hamsterlord_injure_knees_stun:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_hamsterlord_injure_knees_stun:OnDeath(keys)
	if keys.unit == self:GetParent() then
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_hamsterlord_injure_knees_thinker", {Duration = 2}, self:GetParent():GetOrigin(), self:GetCaster():GetTeamNumber(), false)	
	end
end
function modifier_hamsterlord_injure_knees_stun:OnRefresh()
	if IsClient() then return end
	local hParent = self:GetParent()
	local fDuration = self:GetDuration()
	self.vVerticalSpeed = Vector(0, 0, self:GetAbility():GetSpecialValueFor("max_height")/fDuration)
	self.vVerticalAcceleration = self.vVerticalSpeed*(-2)/fDuration
	self.fAngleSpeed = 360/fDuration
	self.dt = FrameTime()
	self:StartIntervalThink(self.dt)
	FindClearSpaceForUnit(hParent, GetGroundPosition(hParent:GetOrigin(), hParent), true)
	hParent:SetAngles(0,hParent:GetAnglesAsVector().y,hParent:GetAnglesAsVector().z)
	ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN, hParent)
end
function modifier_hamsterlord_injure_knees_stun:OnCreated()
	if IsClient() then return end
	local fDuration = self:GetDuration()
	local hParent = self:GetParent()
	self.vVerticalSpeed = Vector(0, 0, self:GetAbility():GetSpecialValueFor("max_height")/fDuration)
	self.vVerticalAcceleration = self.vVerticalSpeed*(-2)/fDuration
	self.fAngleSpeed = 360/fDuration
	self.dt = FrameTime()
	self:StartIntervalThink(self.dt)
	ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN, hParent)
end



function modifier_hamsterlord_injure_knees_stun:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
--	print("haha", hParent:GetAnglesAsVector())
	hParent:SetAngles(hParent:GetAnglesAsVector().x+self.fAngleSpeed*self.dt,hParent:GetAnglesAsVector().y,hParent:GetAnglesAsVector().z)	
	hParent:SetOrigin(hParent:GetOrigin()+self.dt*self.vVerticalSpeed+self.dt*self.dt*self.vVerticalAcceleration/2)
	self.vVerticalSpeed = self.vVerticalSpeed+self.dt*self.vVerticalAcceleration
end

function modifier_hamsterlord_injure_knees_stun:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:SetOrigin(GetGroundPosition(hParent:GetOrigin(), hParent))
	hParent:SetAngles(0,hParent:GetAnglesAsVector().y,hParent:GetAnglesAsVector().z)
end

modifier_hamsterlord_injure_knees_thinker = class({})
function modifier_hamsterlord_injure_knees_thinker:OnCreated()
	if IsClient() then return end
	self.dt = FrameTime()
	self:StartIntervalThink(self.dt)
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
end
function modifier_hamsterlord_injure_knees_thinker:OnIntervalThink()
	if IsClient() then return end
	self:GetParent():SetOrigin(self:GetParent():GetOrigin()+self.dt*Vector(0,0,4000))
end
function modifier_hamsterlord_injure_knees_thinker:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

modifier_hamsterlord_take_nap = class({})
function modifier_hamsterlord_take_nap:IsPurgable() return false end

function modifier_hamsterlord_take_nap:CheckState()
	self.hSpecial = Entities:First()	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_hamsterlord_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then
		return {
			[MODIFIER_STATE_NIGHTMARED] = true,
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
--			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
		}
	else
		return {
			[MODIFIER_STATE_NIGHTMARED] = true,
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
--			[MODIFIER_STATE_STUNNED] = true,
		}
	end
end

function modifier_hamsterlord_take_nap:GetEffectName() return "particles/units/heroes/hero_bane/bane_nightmare.vpcf" end
function modifier_hamsterlord_take_nap:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_hamsterlord_take_nap:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_EVENT_ON_ORDER}
end
function modifier_hamsterlord_take_nap:GetDisableAutoAttack()
	return 1
end


function modifier_hamsterlord_take_nap:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_second")*self:GetStackCount()
end

function modifier_hamsterlord_take_nap:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ias_per_second")*self:GetStackCount()
end

local tStopOrders = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[7] = true,
	[8] = true,
	[9] = true,
	[28] = true,
	[29] = true,
	[30] = true,	
}

function modifier_hamsterlord_take_nap:OnOrder(keys)
	if keys.unit ~= self:GetParent() then return end
	if tStopOrders[keys.order_type] then
		self:Destroy()
	end
end
function modifier_hamsterlord_take_nap:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:EmitSound("Hero_Bane.Nightmare.Loop")
	self:StartIntervalThink(1)
	StartAnimation(hParent, {duration = self:GetDuration(), activity = ACT_DOTA_FLAIL, rate = 0.2})
end

function modifier_hamsterlord_take_nap:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local fHeal = self:GetAbility():GetSpecialValueFor("heal_per_second")
	local fHealAmount
	if hParent:GetMaxHealth()-hParent:GetHealth() > fHeal then
			fHealAmount = fHeal
		else
			fHealAmount = hParent:GetMaxHealth()-hParent:GetHealth()
	end
	if fHealAmount > 0 then
		iParticle = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent, hParent:GetPlayerOwner())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHealAmount, 0))
		ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHealAmount))+2,0))
		ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
	end
	hParent:Heal(fHeal ,hParent)
	self:IncrementStackCount()
end

function modifier_hamsterlord_take_nap:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local fDuration = hAbility:GetSpecialValueFor("buff_duration")
	if hParent:HasAbility("special_bonus_hamsterlord_0") then
		fDuration = fDuration+hParent:FindAbilityByName("special_bonus_hamsterlord_0"):GetSpecialValueFor("value")
	end
	EndAnimation(hParent)
	if self:GetStackCount() > 0 then
		hParent:EmitSound("Hero_Invoker.Alacrity")
		hParent:AddNewModifier(hParent, hAbility, "modifier_hamsterlord_take_nap_buff", {duration = fDuration}):SetStackCount(self:GetStackCount())
		
		if hParent:HasAbility("special_bonus_hamsterlord_5") and hParent:FindAbilityByName("special_bonus_hamsterlord_5"):GetLevel() > 0 then		
			local hBoy = Entities:First()	
			while hBoy do
				if hBoy.GetUnitName and (hBoy:GetUnitName() == "hamsterlord_pizza_house_deliver_boy" or hBoy:GetUnitName() == "hamsterlord_hamster" ) and hParent:GetPlayerOwnerID() == hBoy:GetOwner():GetPlayerID() then	
					hBoy:AddNewModifier(hParent, hAbility, "modifier_hamsterlord_take_nap_buff", {duration = fDuration}):SetStackCount(self:GetStackCount())		
				end			
				hBoy = Entities:Next(hBoy)
			end	
		end
	else
		hParent:StopSound("Hero_Bane.Nightmare.End")
	end
	hParent:StopSound("Hero_Bane.Nightmare.Loop")
end

modifier_hamsterlord_take_nap_buff = class({})
function modifier_hamsterlord_take_nap_buff:IsPurgable() return true end
function modifier_hamsterlord_take_nap_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_hamsterlord_take_nap_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}
end


function modifier_hamsterlord_take_nap_buff:GetStatusEffectName() return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf" end
function modifier_hamsterlord_take_nap_buff:GetEffectName() return "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf" end
function modifier_hamsterlord_take_nap_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_hamsterlord_take_nap_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_second")*self:GetStackCount()
end

function modifier_hamsterlord_take_nap_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ias_per_second")*self:GetStackCount()
end

modifier_hamsterlord_hamster_courage_of_the_hamster = class({})
function modifier_hamsterlord_hamster_courage_of_the_hamster:IsPurgable() return false end
function modifier_hamsterlord_hamster_courage_of_the_hamster:RemoveOnDeath() return false end
function modifier_hamsterlord_hamster_courage_of_the_hamster:IsHidden() return true end
function modifier_hamsterlord_hamster_courage_of_the_hamster:IsAura() return true end
function modifier_hamsterlord_hamster_courage_of_the_hamster:GetModifierAura() return "modifier_hamsterlord_hamster_courage_of_the_hamster_buff" end
function modifier_hamsterlord_hamster_courage_of_the_hamster:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_hamsterlord_hamster_courage_of_the_hamster:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_hamsterlord_hamster_courage_of_the_hamster:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_hamsterlord_hamster_courage_of_the_hamster:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end



modifier_hamsterlord_hamster_courage_of_the_hamster_buff = class({})
function modifier_hamsterlord_hamster_courage_of_the_hamster_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_hamsterlord_hamster_courage_of_the_hamster_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_hamsterlord_hamster_courage_of_the_hamster_buff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movespeed_bonus") end
function modifier_hamsterlord_hamster_courage_of_the_hamster_buff:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("armor_bonus") end

modifier_hamsterlord_hamster_terror_of_the_hamster = class({})
function modifier_hamsterlord_hamster_terror_of_the_hamster:IsPurgable() return false end
function modifier_hamsterlord_hamster_terror_of_the_hamster:RemoveOnDeath() return false end
function modifier_hamsterlord_hamster_terror_of_the_hamster:IsHidden() return true end
function modifier_hamsterlord_hamster_terror_of_the_hamster:IsAura() return true end
function modifier_hamsterlord_hamster_terror_of_the_hamster:GetModifierAura() return "modifier_hamsterlord_hamster_terror_of_the_hamster_debuff" end
function modifier_hamsterlord_hamster_terror_of_the_hamster:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_hamsterlord_hamster_terror_of_the_hamster:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_hamsterlord_hamster_terror_of_the_hamster:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_hamsterlord_hamster_terror_of_the_hamster:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end


modifier_hamsterlord_hamster_terror_of_the_hamster_debuff = class({})
function modifier_hamsterlord_hamster_terror_of_the_hamster_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_hamsterlord_hamster_terror_of_the_hamster_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_hamsterlord_hamster_terror_of_the_hamster_debuff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movespeed_slow") end
function modifier_hamsterlord_hamster_terror_of_the_hamster_debuff:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("armor_reduction") end

modifier_hamsterlord_hamster_flaming_hamster_grenade = class({})


function modifier_hamsterlord_hamster_flaming_hamster_grenade:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vHorizantalSpeed)
end

function modifier_hamsterlord_hamster_flaming_hamster_grenade:UpdateVerticalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vVerticalSpeed+dt*dt*self.vVerticalAcceleration/2)
	self.vVerticalSpeed = self.vVerticalSpeed+dt*self.vVerticalAcceleration
end

function modifier_hamsterlord_hamster_flaming_hamster_grenade:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MUTED] = true,	
		[MODIFIER_STATE_DISARMED] = true,		
	}
end

function modifier_hamsterlord_hamster_flaming_hamster_grenade:IsHidden() return true end
function modifier_hamsterlord_hamster_flaming_hamster_grenade:IsPurgable() return false end
function modifier_hamsterlord_hamster_flaming_hamster_grenade:IsDebuff() return false end

function modifier_hamsterlord_hamster_flaming_hamster_grenade:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_hamsterlord_hamster_flaming_hamster_grenade:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local fDamage = hAbility:GetSpecialValueFor("damage_per_health")*hParent:GetHealth()
	local fRadius = hAbility:GetSpecialValueFor("radius")
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	hParent:SetOrigin(self.vDestination)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(iParticle, 2, Vector(fRadius*2, 0, 0))
	ParticleManager:SetParticleControl(iParticle, 15, Vector(RandomInt(0,255), RandomInt(0,255), RandomInt(0,255)))
	hParent:EmitSound("Hero_Techies.Suicide")
	
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = hParent,
		damage = fDamage,
		damage_type = hAbility:GetAbilityDamageType(),
		ability = hAbility
	}
	for k, v in pairs(tTargets) do
		damageTable.victim = v
		ApplyDamage(damageTable)
		v:AddNewModifier(hParent, hAbility, "modifier_stunned", {Duration=hAbility:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
	end
	hParent:Kill(hAbility, hParent)
end

modifier_special_bonus_hamsterlord_5 = class({})
function modifier_special_bonus_hamsterlord_5:IsHidden() return true end
function modifier_special_bonus_hamsterlord_5:IsPurgable() return false end
function modifier_special_bonus_hamsterlord_5:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE]=true} end
function modifier_special_bonus_hamsterlord_5:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_special_bonus_hamsterlord_5:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end