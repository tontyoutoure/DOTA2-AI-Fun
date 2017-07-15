modifier_void_demon_quake_slow_lua = class({})

function modifier_void_demon_quake_slow_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end 

function modifier_void_demon_quake_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("quake_slow_percentage")
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
	local tUnits = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), none, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)
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