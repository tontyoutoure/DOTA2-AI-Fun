--[[ ============================================================================================================
	Author: Rook
	Date: February 16, 2015
	Called when Icy Path is cast.
	Additional parameters: keys.NumWallElements and keys.WallElementSpacing
================================================================================================================= ]]
function invoker_retro_icy_path_on_spell_start(keys)
	keys.caster:EmitSound("Hero_Invoker.IceWall.Cast")
	
	local target_point = keys.target_points[1]
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
	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local icy_path_duration = 0
	if quas_ability ~= nil then
		icy_path_duration = keys.ability:GetLevelSpecialValueFor("duration", quas_ability:GetLevel() - 1)
	end
	
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