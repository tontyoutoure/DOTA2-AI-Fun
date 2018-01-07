modifier_void_demon_quake_slow_lua = class({})

function modifier_void_demon_quake_slow_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end 

function modifier_void_demon_quake_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	local fResist
	if IsClient() then 
		fResist = -self:GetStackCount()/1000
	else
		fResist = CalculateStatusResist(self:GetParent())
		self:SetStackCount(-fResist*1000)
	end
	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("quake_slow_percentage")
	return fResist*self.fSlow
end

modifier_void_demon_quake_aura_lua = class({})

function modifier_void_demon_quake_aura_lua:IsAura()
	return true
end

function modifier_void_demon_quake_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_void_demon_quake_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end

function modifier_void_demon_quake_aura_lua:GetModifierAura()
	return "modifier_void_demon_quake_slow_lua"
end

function modifier_void_demon_quake_aura_lua:GetAuraRadius()
	self.iRadius = self.iRadius or 100
	return self.iRadius
end

function modifier_void_demon_quake_aura_lua:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_void_demon_quake_aura_lua:OnIntervalThink()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	hParent:EmitSound("Hero_Leshrac.Split_Earth")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(particle, 1, Vector(self.iRadius, self.iRadius, self.iRadius))
	local tUnits = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)
	for k, v in pairs(tUnits) do
		local tDamageTable = {
			victim = v, 
			attacker = hCaster,
			ability = hAbility,
			damage_type = DAMAGE_TYPE_PURE,
			damage = self.fDamage
		}
		
		ApplyDamage(tDamageTable)
	end
end

modifier_void_demon_mass_haste = class({})

function modifier_void_demon_mass_haste:IsAura() return true end
function modifier_void_demon_mass_haste:GetModifierAura() 
	return "modifier_void_demon_mass_haste_accelerate" 
end
function modifier_void_demon_mass_haste:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_void_demon_mass_haste:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_void_demon_mass_haste:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_void_demon_mass_haste:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_void_demon_mass_haste:IsHidden() return true end
function modifier_void_demon_mass_haste:RemoveOnDeath() return false end
function modifier_void_demon_mass_haste:IsPurgable() return false end

modifier_void_demon_mass_haste_accelerate = class({})
function modifier_void_demon_mass_haste_accelerate:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_void_demon_mass_haste_accelerate:GetModifierMoveSpeedBonus_Percentage() 
	if self:GetCaster():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("movespeed_bonus") end
end
function modifier_void_demon_mass_haste_accelerate:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("attackspeed_bonus") end
end
	
function modifier_void_demon_mass_haste_accelerate:GetEffectName() return "particles/generic_gameplay/rune_haste_owner.vpcf" end
function modifier_void_demon_mass_haste_accelerate:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end