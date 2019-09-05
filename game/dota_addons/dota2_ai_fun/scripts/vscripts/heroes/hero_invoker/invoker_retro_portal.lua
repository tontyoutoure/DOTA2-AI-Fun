--[[ ============================================================================================================
	Author: Rook
	Date: February 16, 2015
	Called when Portal's cast point begins.  Starts the particle effect and sound.
	Additional parameters: keys.CastPoint
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_portal_quas_level", "heroes/hero_invoker/invoker_retro_portal.lua", LUA_MODIFIER_MOTION_NONE)

modifier_invoker_retro_portal_quas_level = class({})
function modifier_invoker_retro_portal_quas_level:IsHidden() return true end
function modifier_invoker_retro_portal_quas_level:IsPurgable() return false end
function modifier_invoker_retro_portal_quas_level:RemoveOnDeath() return false end
function modifier_invoker_retro_portal_quas_level:OnCreated()
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iQuasLevel+1)
		else
			self:SetStackCount(hParent.iQuasLevel)
		end
	end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_portal_quas_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iQuasLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iQuasLevel+1)
		else
			self:SetStackCount(hParent.iQuasLevel)
		end
	end
end




invoker_retro_portal = class({})
function invoker_retro_portal:GetIntrinsicModifierName() return 'modifier_invoker_retro_portal_quas_level' end
function invoker_retro_portal:GetCastRange()
	return self.hModifier:GetStackCount()*self:GetSpecialValueFor('cast_range_level_quas')+self:GetSpecialValueFor('cast_range_base')
end
function invoker_retro_portal:OnSpellStart()
	local keys = {target = self:GetCursorTarget(), caster = self:GetCaster(), ability = self}
	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end
	local target_origin = keys.target:GetAbsOrigin()
	local distance_to_target = keys.caster:GetRangeToUnit(keys.target)
	local portal_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_portal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)	
	local portal_particle_drain_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_portal_drain.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControlEnt(portal_particle_drain_effect, 1, keys.target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", keys.target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(portal_particle_drain_effect, 2, Vector(distance_to_target * 3.5, 0, 0))
	local endTime = keys.ability:GetSpecialValueFor('delay')
	
	local iWexLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) == keys.ability then
		iWexLevel = keys.caster.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end
	else
		iWexLevel = keys.target.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end	
	end
	
	local portal_damage = keys.ability:GetSpecialValueFor('damage_level_wex')*iWexLevel
	local caster_point = keys.caster:GetAbsOrigin()
	
	keys.target:EmitSound("Hero_Meepo.Poof.Channel")
	Timers:CreateTimer({
		endTime = endTime,
		callback = function()
			ParticleManager:DestroyParticle(portal_particle_effect, false)
			ParticleManager:DestroyParticle(portal_particle_drain_effect, false)
			keys.target:StopSound("Hero_Meepo.Poof.Channel")
			local point_difference_normalized = (keys.target:GetAbsOrigin() - caster_point):Normalized()
			local point_to_place_target = GetGroundPosition(caster_point + (point_difference_normalized * 64), nil)
			if keys.target:IsInvulnerable() or keys.target:IsMagicImmune() then return end
			FindClearSpaceForUnit(keys.target, point_to_place_target, false)  --Move the target to Invoker's position.
			keys.target:EmitSound("Hero_Meepo.Poof")
			
			ApplyDamageTestDummy({victim = keys.target, attacker = keys.caster, damage = portal_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability})
		end
	})
end
