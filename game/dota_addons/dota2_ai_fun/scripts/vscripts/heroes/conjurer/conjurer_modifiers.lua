modifier_conjurer_water_element = class({})

function modifier_conjurer_water_element:OnCreated()
	if IsClient() then return end
	self:GetParent():EmitSound("Hero_Morphling.IdleLoop")
end
function modifier_conjurer_water_element:OnDestroy()
	if IsClient() then return end
	self:GetParent():StopSound("Hero_Morphling.IdleLoop")
	self:GetParent():EmitSound("Hero_Morphling.Death")
end

function modifier_conjurer_water_element:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end

function modifier_conjurer_water_element:GetModifierAttackRangeBonus()
	return self:GetStackCount()
end

function modifier_conjurer_water_element:IsPurgable() return false end
function modifier_conjurer_water_element:RemoveOnDeath() return true end
function modifier_conjurer_water_element:IsHidden() return true end

modifier_conjurer_phoenix_splash = class({})
function modifier_conjurer_phoenix_splash:IsPurgable() return false end
function modifier_conjurer_phoenix_splash:IsHidden() return true end
function modifier_conjurer_phoenix_splash:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_conjurer_phoenix_splash:OnAttackLanded(keys)
	local hAbility = self:GetAbility()
	self.iRadius100 = hAbility:GetSpecialValueFor("splash_radius_100")
	self.iRadius50 = hAbility:GetSpecialValueFor("splash_radius_50")
	self.iRadius25 = hAbility:GetSpecialValueFor("splash_radius_25")
	if keys.attacker and keys.attacker == self:GetParent() and not keys.attacker:PassivesDisabled() then 
		for k, v in ipairs(FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetOrigin(), nil, self.iRadius25, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)) do
			if v ~= keys.target then
				if (v:GetOrigin()-keys.target:GetOrigin()):Length2D() < self.iRadius100 then
					ApplyDamage({damage = keys.original_damage, damage_type = DAMAGE_TYPE_PHYSICAL, attacker = keys.attacker, victim = v, ability = hAbility})
				elseif (v:GetOrigin()-keys.target:GetOrigin()):Length2D() < self.iRadius50 then
					ApplyDamage({damage = keys.original_damage/2, damage_type = DAMAGE_TYPE_PHYSICAL, attacker = keys.attacker, victim = v, ability = hAbility})
				else
					ApplyDamage({damage = keys.original_damage/4, damage_type = DAMAGE_TYPE_PHYSICAL, attacker = keys.attacker, victim = v, ability = hAbility})
				end
			end
		end
	end
end


modifier_conjurer_phoenix_immolation_aura = class({})
function modifier_conjurer_phoenix_immolation_aura:IsPurgable() return false end
function modifier_conjurer_phoenix_immolation_aura:IsAura() return true end
function modifier_conjurer_phoenix_immolation_aura:IsHidden() return true end
function modifier_conjurer_phoenix_immolation_aura:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_conjurer_phoenix_immolation_aura:GetModifierAura() return "modifier_conjurer_phoenix_immolation" end
function modifier_conjurer_phoenix_immolation_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_conjurer_phoenix_immolation_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_conjurer_phoenix_immolation_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_conjurer_phoenix_immolation_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_conjurer_phoenix_immolation_aura:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControl(self.iParticle, 2, Vector(150, 0, 0))
	ParticleManager:SetParticleControl(self.iParticle, 3, Vector(150, 0, 0))
end


function modifier_conjurer_phoenix_immolation_aura:OnDeath(keys)
	if keys.unit == self:GetParent() then
		self:Destroy()
	end
end
function modifier_conjurer_phoenix_immolation_aura:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	ParticleManager:DestroyParticle(self.iParticle, false)
	hParent:EmitSound("Hero_Phoenix.Death")
	Timers:CreateTimer(2.5, function () hParent:AddEffects(EF_NODRAW) end)
end

modifier_conjurer_phoenix_immolation = class({})
function modifier_conjurer_phoenix_immolation:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_conjurer_phoenix_immolation:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_conjurer_phoenix_immolation:OnTooltip() return self:GetAbility():GetSpecialValueFor("damage") end
function modifier_conjurer_phoenix_immolation:OnCreated()
	if IsClient() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", Vector(0,0,0), true)
	self:StartIntervalThink(0.1)
end
function modifier_conjurer_phoenix_immolation:OnDestroy()	
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)
end
function modifier_conjurer_phoenix_immolation:OnIntervalThink()
	if IsClient() then return end
	if self:GetCaster():PassivesDisabled() then return end
	local hAbility = self:GetAbility()
	ApplyDamage({damage_type = hAbility:GetAbilityDamageType(), damage = hAbility:GetSpecialValueFor("damage")/10, ability= hAbility, attacker = self:GetCaster(), victim = self:GetParent()})
end
modifier_conjurer_phoenix_reincarnation = class({})
function modifier_conjurer_phoenix_reincarnation:IsPurgable() return false end
function modifier_conjurer_phoenix_reincarnation:IsHidden() return true end
function modifier_conjurer_phoenix_reincarnation:RemoveOnDeath() return false end

function modifier_conjurer_phoenix_reincarnation:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH, MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_conjurer_phoenix_reincarnation:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and keys.unit:GetHealth() == 0 then
		keys.unit:SetHealth(keys.unit:GetMaxHealth())
		keys.unit:AddEffects(EF_NODRAW)
		keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_conjurer_phoenix_reincarnation_phoenix", {})
		local hOwner = keys.unit:GetOwner() 
		local hAbility = self:GetAbility()
		local hEgg = CreateUnitByName("conjurer_phoenix_egg", keys.unit:GetOrigin(), true, hOwner, hOwner, hOwner:GetTeamNumber())
		local iAttackNumber = hAbility:GetSpecialValueFor("attack_number")
		hEgg:AddNewModifier(keys.unit, hAbility, "modifier_conjurer_phoenix_reincarnation_egg", {Duration=hAbility:GetSpecialValueFor("reincarnation_time")}).hPhoenix = keys.unit
		hEgg:SetMaxHealth(iAttackNumber)
		hEgg:SetBaseMaxHealth(iAttackNumber)
		hEgg:SetHealth(iAttackNumber)
	end
end


modifier_conjurer_phoenix_reincarnation_phoenix = class({})
function modifier_conjurer_phoenix_reincarnation_phoenix:CheckState() return {[MODIFIER_STATE_INVULNERABLE]=true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end

modifier_conjurer_phoenix_reincarnation_egg = class({})
function modifier_conjurer_phoenix_reincarnation_egg:IsPurgable() return false end
function modifier_conjurer_phoenix_reincarnation_egg:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self:StartIntervalThink(0.04)
	hParent:EmitSound("Hero_Phoenix.SuperNova.Begin")	
	hParent:EmitSound("Hero_Phoenix.SuperNova.Cast")
	self.iParticle=ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
end

function modifier_conjurer_phoenix_reincarnation_egg:OnIntervalThink()	
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:SetOrigin(Vector2D(hParent:GetOrigin())+Vector(0,0,GetGroundHeight(hParent:GetOrigin(), hParent)-156+self:GetRemainingTime()*40))
	iTheta = self:GetRemainingTime()*1
	hParent:SetForwardVector(Vector(math.cos(iTheta), math.sin(iTheta),0))
end
function modifier_conjurer_phoenix_reincarnation_egg:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:RemoveVerticalMotionController(self)
	ParticleManager:DestroyParticle(self.iParticle, true)
	StopSoundOn("Hero_Phoenix.SuperNova.Cast", hParent)
	if self:GetRemainingTime() > 0 then
		hParent:EmitSound("Hero_Phoenix.SuperNova.Death")
		self.hPhoenix:RemoveEffects(EF_NODRAW)
		hParent:AddEffects(EF_NODRAW)
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_ABSORIGIN, self.hPhoenix)
		ParticleManager:SetParticleControlEnt(iParticle, 1, self.hPhoenix, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hPhoenix:GetOrigin(), true)
	else
		hParent:EmitSound("Hero_Phoenix.SuperNova.Explode")
		hParent:AddEffects(EF_NODRAW)
		self.hPhoenix:RemoveEffects(EF_NODRAW)
		hParent:ForceKill(false)
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, self.hPhoenix)
	
		self.hPhoenix:RemoveModifierByName("modifier_conjurer_phoenix_reincarnation_phoenix")
		self.hPhoenix:AddNewModifier(self.hPhoenix, nil, "modifier_kill", {Duration = self.hPhoenix.iDuration})
		StartAnimation(self.hPhoenix, {duration = 1.5, rate=1, activity=ACT_DOTA_INTRO})
	end
end
function modifier_conjurer_phoenix_reincarnation_egg:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE]=true} end
function modifier_conjurer_phoenix_reincarnation_egg:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE} end
function modifier_conjurer_phoenix_reincarnation_egg:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_conjurer_phoenix_reincarnation_egg:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_conjurer_phoenix_reincarnation_egg:OnAttackLanded(keys)
	if keys.target == self:GetParent() and keys.attacker:IsRealHero() then
		if keys.target:GetHealth() > 1 then
			keys.target:SetHealth(keys.target:GetHealth()-1)
		else
			self:Destroy()
			self.hPhoenix:RemoveModifierByName("modifier_conjurer_phoenix_reincarnation_phoenix")
			self.hPhoenix:RemoveModifierByName("modifier_conjurer_phoenix_reincarnation")
			self.hPhoenix:Kill(nil, keys.attacker)
			keys.target:ForceKill(false)
		end
	end
end

modifier_conjurer_golem_hardened_skin = class({})
function modifier_conjurer_golem_hardened_skin:DeclareFunctions() return {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK} end
function modifier_conjurer_golem_hardened_skin:IsPurgable() return false end
function modifier_conjurer_golem_hardened_skin:IsHidden() return true end
function modifier_conjurer_golem_hardened_skin:RemoveOnDeath() return false end
function modifier_conjurer_golem_hardened_skin:GetModifierTotal_ConstantBlock(keys)
	if keys.target == self:GetParent() and not keys.target:PassivesDisabled() and keys.damage > self:GetAbility():GetSpecialValueFor("damage_threshold") then
		local iBlock = self:GetAbility():GetSpecialValueFor("damage_block")
		local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_block.vpcf", PATTACH_POINT_FOLLOW, keys.target)
		if keys.damage < iBlock then iBlock = keys.damage end
		ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, iBlock, 7))
		ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iBlock))+3, 100))
		ParticleManager:SetParticleControl(iParticle1, 3, Vector(205,133,63))
		return self:GetAbility():GetSpecialValueFor("damage_block")
	end
end

modifier_conjurer_golem_split = class({})
function modifier_conjurer_golem_split:IsPurgable() return false end
function modifier_conjurer_golem_split:IsHidden() return true end
function modifier_conjurer_golem_split:RemoveOnDeath() return false end
function modifier_conjurer_golem_split:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_conjurer_golem_split:OnDeath(keys) 
	if keys.unit == self:GetParent() then
		local iLevel = tonumber(string.sub(keys.unit:GetUnitName(),19))
		
		local iCount = self:GetAbility():GetSpecialValueFor("split_count")
		local hOwner = keys.unit:GetOwner() 
		local vSummonSpot = keys.unit:GetOrigin()
		local vForward = keys.unit:GetForwardVector() 
		keys.unit:EmitSound("n_mud_golem.Boulder.Cast")
		keys.unit:EmitSound("n_mud_golem.Boulder.Target") 
		for i = 1, iCount do
			local sName = "conjurer_golem_lv_"..tostring(iLevel-1)
			local hUnit = CreateUnitByName(sName, vSummonSpot, true, hOwner, hOwner, hOwner:GetTeamNumber())
			hUnit:SetControllableByPlayer(hOwner:GetPlayerOwnerID(), true)
			FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
			hUnit:SetForwardVector(vForward)
			hUnit.iDuration = keys.unit.iDuration
			hUnit:AddNewModifier(hOwner, nil, "modifier_kill", {Duration = keys.unit.iDuration}) 
			if iLevel > 2 then
				hUnit:AddAbility("conjurer_golem_split"):SetLevel(1)
			end 
		end
		
	end
end


















