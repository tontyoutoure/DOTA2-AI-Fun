modifier_felguard_color = class({})

function modifier_felguard_color:IsPurgable() return false end
function modifier_felguard_color:IsHidden() return true end
function modifier_felguard_color:RemoveOnDeath() return false end

function modifier_felguard_color:GetStatusEffectName() return "particles/status_fx/status_effect_gods_strength.vpcf" end
function modifier_felguard_color:StatusEffectPriority() return 10000 end
function modifier_felguard_color:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/ember_spirit/ember_spirit_vanishing_flame/ember_spirit_vanishing_flame_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	
end

modifier_felguard_fireblade_strike = class({})

function modifier_felguard_fireblade_strike:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
	self:GetParent():EmitSound("Hero_Sven.IronWill")
end

function modifier_felguard_fireblade_strike:UpdateHorizontalMotion(me, dt)	
	me:SetOrigin(me:GetOrigin()+dt*self.vSpeedHorizontal)
end

function modifier_felguard_fireblade_strike:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end

function modifier_felguard_fireblade_strike:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end

function modifier_felguard_fireblade_strike:GetOverrideAnimation() return ACT_DOTA_FLAIL end

function modifier_felguard_fireblade_strike:UpdateVerticalMotion(me, dt)	
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), me))
end

function modifier_felguard_fireblade_strike:OnDestroy()
	if IsClient() then return end
	hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)

end

function modifier_felguard_fireblade_strike:GetEffectName() return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf" end
function modifier_felguard_fireblade_strike:GetEffectAttachType() return PATTACH_POINT_FOLLOW end

modifier_felguard_felguard_wrath = class({})
function modifier_felguard_felguard_wrath:IsHidden() return true end
function modifier_felguard_felguard_wrath:IsPurgable() return false end
function modifier_felguard_felguard_wrath:OnCreated(keys)
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
	self:GetParent():EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
end

function modifier_felguard_felguard_wrath:UpdateHorizontalMotion(me, dt)	
	me:SetOrigin(me:GetOrigin()+dt*self.vSpeedHorizontal)
end

function modifier_felguard_felguard_wrath:UpdateVerticalMotion(me, dt)	
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), me))
end

function modifier_felguard_felguard_wrath:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end

function modifier_felguard_felguard_wrath:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end
function modifier_felguard_felguard_wrath:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end


function modifier_felguard_felguard_wrath:GetEffectName() return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf" end
function modifier_felguard_felguard_wrath:GetEffectAttachType() return PATTACH_POINT_FOLLOW end

function modifier_felguard_felguard_wrath:OnDestroy()
	if IsClient() then return end
	hParent = self:GetParent()
	hParent:StopSound("Hero_EmberSpirit.FireRemnant.Activate")
	hAbility = self:GetAbility()
	hParent:SetOrigin(self.vTarget)
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	
	local fRadius = hAbility:GetSpecialValueFor("radius")
	local fDuration = hAbility:GetSpecialValueFor("stun_duration")
	
	hParent:EmitSound("Hero_Centaur.HoofStomp")
	Timers:CreateTimer(0.04, function () 
		--local iParticle = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_ABSORIGIN, hParent)
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(fRadius, fRadius, fRadius))	
	end)
	local tTargets
	if hParent:FindAbilityByName("special_bonus_felguard_2") and hParent:FindAbilityByName("special_bonus_felguard_2"):GetLevel() > 0 then 
		tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	else
		tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	end
	local damageTable = {
		attacker = hParent,
		damage = hAbility:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	
	for k, v in pairs(tTargets) do
		v:AddNewModifier(hParent, hAbility, "modifier_stunned", {Duration = fDuration})
		damageTable.victim = v
		ApplyDamage(damageTable)
	end
end

modifier_felguard_strength_and_honor = class({})


function modifier_felguard_color:IsPurgable() return false end
function modifier_felguard_color:IsDebuff() return false end
function modifier_felguard_color:RemoveOnDeath() return false end


function modifier_felguard_strength_and_honor:DeclareFunctions()
	return {MODIFIER_EVENT_ON_HERO_KILLED, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_felguard_strength_and_honor:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_level")*self:GetStackCount()
end
function modifier_felguard_strength_and_honor:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	
	self.iKill = hParent:GetKills()
	self.iAssist = hParent:GetAssists()
	self.iDeath = hParent:GetDeaths()
end
function modifier_felguard_strength_and_honor:OnHeroKilled()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local iLevel = (hParent:GetKills()-self.iKill)*hAbility:GetSpecialValueFor("kill_level")+(hParent:GetAssists()-self.iAssist)*hAbility:GetSpecialValueFor("assist_level")+(hParent:GetDeaths()-self.iDeath)*hAbility:GetSpecialValueFor("death_level")
	local iMaxLevel 
	if hParent:FindAbilityByName("special_bonus_felguard_1") and hParent:FindAbilityByName("special_bonus_felguard_1"):GetLevel() > 0 then 
		iMaxLevel = hAbility:GetSpecialValueFor("max_level") *2
	else
		iMaxLevel = hAbility:GetSpecialValueFor("max_level") 
	end
	self:SetStackCount(self:GetStackCount()+iLevel)
	if self:GetStackCount() > iMaxLevel then self:SetStackCount(iMaxLevel) end
	if self:GetStackCount() < 0 then self:SetStackCount(0) end
	
	self.iKill = hParent:GetKills()
	self.iAssist = hParent:GetAssists()
	self.iDeath = hParent:GetDeaths()
end

modifier_felguard_overflow = class({})

function modifier_felguard_overflow:IsPurgable() return false end

function modifier_felguard_overflow:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()	
	self.iParticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_column.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.iParticle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_column.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.iParticle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_column.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	for i = 1,20 do
--		Timers:CreateTimer(0.025*i, function () hParent:SetModelScale(hParent:GetModelScale()+0.005) end )
	end
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	
	ParticleManager:SetParticleControlEnt( self.iParticle , 0, hParent, PATTACH_POINT_FOLLOW, "attach_weapon" , hParent:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.iParticle , 2, hParent, PATTACH_POINT_FOLLOW, "attach_head" ,hParent:GetOrigin(), true )
end

function modifier_felguard_overflow:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	ParticleManager:DestroyParticle(self.iParticle1, false)
	ParticleManager:DestroyParticle(self.iParticle2, false)
	ParticleManager:DestroyParticle(self.iParticle3, false)

	for i = 1,20 do
--		Timers:CreateTimer(0.025*i, function ()  hParent:SetModelScale(hParent:GetModelScale()-0.005) end )
	end
	ParticleManager:DestroyParticle(self.iParticle, false)
end



function modifier_felguard_overflow:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
end

function modifier_felguard_overflow:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor("bat")
end

function modifier_felguard_overflow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function modifier_felguard_overflow:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then return end
	local hAbility = self:GetAbility()
	DoCleaveAttack(keys.attacker, keys.target, hAbility, hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, 200, 350,hAbility:GetSpecialValueFor("cleave_range"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")
end

function modifier_felguard_overflow:GetAttackSound() return "Hero_Sven.GodsStrength.Attack" end