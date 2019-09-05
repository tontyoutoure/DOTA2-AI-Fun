--[[ ============================================================================================================
	Author: Rook
	Date: March 9, 2015
	Called when Shock is cast.
	Additional parameters: keys.DelayBeforeDamage
================================================================================================================= ]]

LinkLuaModifier("modifier_invoker_retro_shock_cast_range_calculator", "heroes/hero_invoker/invoker_retro_shock.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_shock_cast_range_calculator = class({})
function modifier_invoker_retro_shock_cast_range_calculator:IsHidden() return true end
function modifier_invoker_retro_shock_cast_range_calculator:IsPurgable() return false end
function modifier_invoker_retro_shock_cast_range_calculator:RemoveOnDeath() return false end
function modifier_invoker_retro_shock_cast_range_calculator:OnCreated()
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasScepter() then
			self:SetStackCount((hParent.iWexLevel+1)*self:GetAbility():GetSpecialValueFor('radius_level_wex')+self:GetAbility():GetSpecialValueFor('radius_base'))
		else
			self:SetStackCount((hParent.iWexLevel)*self:GetAbility():GetSpecialValueFor('radius_level_wex')+self:GetAbility():GetSpecialValueFor('radius_base'))
		end
	end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_shock_cast_range_calculator:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iWexLevel then
		if hParent:HasScepter() then
			self:SetStackCount((hParent.iWexLevel+1)*self:GetAbility():GetSpecialValueFor('radius_level_wex')+self:GetAbility():GetSpecialValueFor('radius_base'))
		else
			self:SetStackCount((hParent.iWexLevel)*self:GetAbility():GetSpecialValueFor('radius_level_wex')+self:GetAbility():GetSpecialValueFor('radius_base'))
		end
	end
end
invoker_retro_shock = class({})
function invoker_retro_shock:GetIntrinsicModifierName() return 'modifier_invoker_retro_shock_cast_range_calculator' end
function invoker_retro_shock:GetCastRange() return self.hModifier:GetStackCount() end
function invoker_retro_shock:OnSpellStart()	
	keys = {caster = self:GetCaster(), ability = self, DelayBeforeDamage = self:GetSpecialValueFor('delay_before_damage')}
	local caster_origin = keys.caster:GetAbsOrigin()
	local iWexLevel = keys.caster.iWexLevel
	if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end
	local damage = keys.ability:GetSpecialValueFor("damage_level_wex")*iWexLevel
	local radius = keys.ability:GetSpecialValueFor("radius_base")+keys.ability:GetSpecialValueFor("radius_level_wex")*iWexLevel
	
	keys.caster:EmitSound("retro_dota.shock_on_spell_start")

	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), caster_origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	--Display particle effects in the AoE and for each affected enemy.
	local shock_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_shock_ground.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(shock_particle_effect, 1, Vector(radius*1.12, 0, 0))
--	print(radius)

	for i, individual_unit in ipairs(nearby_enemy_units) do
		local shock_particle_effect_unit = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_shock_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
		ParticleManager:SetParticleControlEnt(shock_particle_effect_unit, 1, keys.caster, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", caster_origin, false)
		local shock_particle_effect_unit_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_shock_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
		ParticleManager:SetParticleControlEnt(shock_particle_effect_unit_2, 1, individual_unit, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", individual_unit:GetAbsOrigin(), false)
		
		individual_unit:EmitSound("Hero_razor.lightning")
	end
	
	--Dispel and damage the affected units after a delay.
	Timers:CreateTimer({
		endTime = keys.DelayBeforeDamage,
		callback = function()
			for i, individual_unit in ipairs(nearby_enemy_units) do
				--Purge(bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions) 
				individual_unit:Purge(true, false, false, false, false)

				ApplyDamageTestDummy({victim = individual_unit, attacker = keys.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,})
			end
		end
	})
end