--[[ ============================================================================================================
	Author: Rook
	Date: February 16, 2015
	Called when Icy Path is cast.
	Additional parameters: keys.NumWallElements and keys.WallElementSpacing
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_icy_path_quas_level", "heroes/hero_invoker/invoker_retro_icy_path.lua", LUA_MODIFIER_MOTION_NONE)
invoker_retro_icy_path = class({})
function invoker_retro_icy_path:OnSpellStart()
	local keys = {caster = self:GetCaster(), ability = self, NumWallElements = self:GetSpecialValueFor('num_wall_elements'), WallElementSpacing = self:GetSpecialValueFor("wall_element_spacing")}
	keys.caster:EmitSound("Hero_Invoker.IceWall.Cast")
	
	local target_point = self:GetCursorPosition()
	local caster_point = keys.caster:GetAbsOrigin()
	local direction_to_target_point = (target_point - caster_point):Normalized()
	local direction_to_target_point_normal = Vector(-direction_to_target_point.y, direction_to_target_point.x, direction_to_target_point.z)
	local vector_distance_from_center = (direction_to_target_point_normal * (keys.NumWallElements * keys.WallElementSpacing)) / 2
	local one_end_point = target_point - vector_distance_from_center
	
	--Display the Icy Path particles in a line.
	local icy_path_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(icy_path_particle_effect, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(icy_path_particle_effect, 1, target_point + vector_distance_from_center)
	
	local icy_path_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(icy_path_particle_effect_b, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(icy_path_particle_effect_b, 1, target_point + vector_distance_from_center)
	
	--Icy Path's duration is dependent on the level of Quas.
	local iQuasLevel
	if keys.caster:HasScepter() then
		iQuasLevel = keys.caster.iQuasLevel+1
	else
		iQuasLevel = keys.caster.iQuasLevel
	end
	local icy_path_duration = keys.ability:GetSpecialValueFor("duration_level_quas")*iQuasLevel
	
	--Remove the Icy Path particles after the duration ends.
	Timers:CreateTimer({
		endTime = icy_path_duration,
		callback = function()
			ParticleManager:DestroyParticle(icy_path_particle_effect, false)
			ParticleManager:DestroyParticle(icy_path_particle_effect_b, false)
		end
	})
	
	--Create dummy units in a line that slow nearby enemies with their aura.
	for i=0, keys.NumWallElements, 1 do
		local icy_path_unit = CreateUnitByName("npc_dota_invoker_retro_icy_path_unit", one_end_point + direction_to_target_point_normal * (keys.WallElementSpacing * i), false, nil, nil, keys.caster:GetTeam())
		local icy_path_unit_ability = icy_path_unit:FindAbilityByName("invoker_retro_icy_path_unit_ability")
		if icy_path_unit_ability ~= nil then
			icy_path_unit_ability:SetLevel(1)
		end
	
		--Remove the Icy Path units after the duration ends.
		Timers:CreateTimer({
			endTime = icy_path_duration,
			callback = function()
				icy_path_unit:RemoveSelf()
			end
		})
	end
end
function invoker_retro_icy_path:GetIntrinsicModifierName() return 'modifier_invoker_retro_icy_path_quas_level' end
function invoker_retro_icy_path:GetCastRange()
	local hCaster = self:GetCaster()
	local iQuasLevel = self.hModifier:GetStackCount()
	
	return iQuasLevel*self:GetSpecialValueFor('cast_range_level_quas')+self:GetSpecialValueFor('cast_range_base')
end

modifier_invoker_retro_icy_path_quas_level = class({})
function modifier_invoker_retro_icy_path_quas_level:IsHidden() return true end
function modifier_invoker_retro_icy_path_quas_level:IsPurgable() return false end
function modifier_invoker_retro_icy_path_quas_level:RemoveOnDeath() return false end
function modifier_invoker_retro_icy_path_quas_level:OnCreated()
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
function modifier_invoker_retro_icy_path_quas_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iQuasLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iQuasLevel+1)
		else
			self:SetStackCount(hParent.iQuasLevel)
		end
	end
end
