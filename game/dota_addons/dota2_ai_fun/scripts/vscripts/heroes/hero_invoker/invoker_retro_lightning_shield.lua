--[[ ============================================================================================================
	Author: Rook, based on Noya's code for Shroud of Flames.
	Date: March 11, 2015
	Called when Lightning Shield is cast.
================================================================================================================= ]]
function invoker_retro_lightning_shield_on_spell_start(keys)
	local iWexLevel
	if keys.caster:HasScepter() then
		iWexLevel = keys.caster.iWexLevel+1
	else
		iWexLevel = keys.caster.iWexLevel
	end
	local iDamagePerSecond = iWexLevel*keys.ability:GetSpecialValueFor('damage_per_second_level_wex')
	local iDuration = iWexLevel*keys.ability:GetSpecialValueFor('duration_level_wex')
	keys.target:EmitSound("Hero_Zuus.StaticField")
	keys.target:AddNewModifier(keys.caster, keys.ability, 'modifier_invoker_retro_lightning_shield', {Duration = iDuration, iDamagePerSecond = iDamagePerSecond})
end

LinkLuaModifier('modifier_invoker_retro_lightning_shield', 'heroes/hero_invoker/invoker_retro_lightning_shield', LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_lightning_shield = class({})
function modifier_invoker_retro_lightning_shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_invoker_retro_lightning_shield:GetEffectName() return "particles/units/heroes/hero_invoker/invoker_retro_lightning_shield.vpcf" end

function modifier_invoker_retro_lightning_shield:OnCreated(keys)
	if IsClient() then return end
	local hAbility = self:GetAbility()
	self.iRadius = hAbility:GetSpecialValueFor('range')
	self.iDamage = keys.iDamagePerSecond*hAbility:GetSpecialValueFor('damage_interval')
	self.hCaster = self:GetCaster()
	self:StartIntervalThink(hAbility:GetSpecialValueFor('damage_interval'))
end

function modifier_invoker_retro_lightning_shield:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	
	local nearby_units = FindUnitsInRadius(self.hCaster:GetTeam(), hParent:GetAbsOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for i, individual_unit in ipairs(nearby_units) do
		if hParent ~= individual_unit then  --The carrier of Lightning Shield cannot damage itself.
			ApplyDamageTestDummy({victim = individual_unit, attacker = self.hCaster, damage = self.iDamage, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end