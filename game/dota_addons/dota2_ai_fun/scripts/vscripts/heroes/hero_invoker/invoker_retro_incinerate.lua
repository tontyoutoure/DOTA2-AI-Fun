--[[ ============================================================================================================
	Author: Rook
	Date: March 8, 2015
	Called when Invoker begins channeling Incinerate.
================================================================================================================= ]]
function invoker_retro_incinerate_on_spell_start(keys)
	local target_point = keys.target_points[1]
	
	local exort_ability = keys.caster:FindAbilityByName("invoker_retro_exort")
	local exort_level = 1
	if exort_ability ~= nil then
		exort_level = exort_ability:GetLevel()
	end
	
	--Create a dummy unit at the spawn point.
	local incinerate_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_incinerate_unit", target_point, false, nil, nil, keys.caster:GetTeam())
	local dummy_unit_ability = incinerate_dummy_unit:FindAbilityByName("dummy_unit_passive")
	if dummy_unit_ability ~= nil then
		dummy_unit_ability:SetLevel(1)
	end
	
	keys.caster.incinerate_current_dummy_unit = incinerate_dummy_unit  --Store a reference to the current Incinerate dummy unit.  This is removed when Invoker stops channeling.
	incinerate_dummy_unit.incinerate_caster = keys.caster
	incinerate_dummy_unit.incinerate_exort_level = exort_level  --Store the current Exort level.  This helps when Invoker levels up Exort while channeling.
	
	--Give the dummy unit Invoker's current Incinerate spell.  This will ensure that even if Incinerate is leveled up while channeling, the spell will not go out of scope.
	incinerate_dummy_unit:AddAbility("invoker_retro_incinerate_level_" .. exort_level .. "_exort")
	local dummy_unit_incinerate_ability = incinerate_dummy_unit:FindAbilityByName("invoker_retro_incinerate_level_" .. exort_level .. "_exort")
	dummy_unit_incinerate_ability:SetLevel(exort_level)
	
	incinerate_dummy_unit:EmitSound("Hero_Warlock.Upheaval")
	
	dummy_unit_incinerate_ability:ApplyDataDrivenModifier(keys.caster, incinerate_dummy_unit, "modifier_invoker_retro_incinerate_channeling", nil)
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 9, 2015
	Called when Invoker stops channeling Incinerate.
================================================================================================================= ]]
function invoker_retro_incinerate_on_channel_finish(keys)
	if keys.caster.incinerate_current_dummy_unit ~= nil then
		local incinerate_dummy_unit = keys.caster.incinerate_current_dummy_unit
		incinerate_dummy_unit:SetDayTimeVisionRange(0)
		incinerate_dummy_unit:SetNightTimeVisionRange(0)

		incinerate_dummy_unit:StopSound("Hero_Warlock.Upheaval")
		
		keys.caster.incinerate_current_dummy_unit = nil

		Timers:CreateTimer({  --Destroy the dummy unit after the particle effects and sounds are sure to be finished.
			endTime = 3,
			callback = function()
				incinerate_dummy_unit:RemoveSelf()
			end
		})
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 9, 2015
	Called on the dummy unit when Invoker starts channeling Incinerate.
	Additional parameters: keys.DelayBetweenWaves, keys.DamagePerWave
================================================================================================================= ]]
function modifier_invoker_retro_incinerate_channeling_on_created(keys)
	--The number of waves, as well as the radius of each wave, is dependent on the level of Exort.
	if keys.target.incinerate_exort_level ~= nil then
		local num_waves = keys.ability:GetLevelSpecialValueFor("num_waves", keys.target.incinerate_exort_level - 1)
		local wave_radius = keys.ability:GetLevelSpecialValueFor("wave_radius", keys.target.incinerate_exort_level - 1)
		local wave_radius_increase_per_wave = keys.ability:GetLevelSpecialValueFor("wave_radius_increase_per_wave", keys.target.incinerate_exort_level - 1)

		--Spawn the waves so long as the caster continues channeling, with a delay between them.
		local waves_spawned_so_far = 0
		Timers:CreateTimer({
			endTime = keys.DelayBetweenWaves,
			callback = function()
				if waves_spawned_so_far < num_waves and keys.caster.incinerate_current_dummy_unit == keys.target then
					local current_wave_radius = wave_radius + (waves_spawned_so_far * wave_radius_increase_per_wave)
					local incinerate_wave_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_incinerate.vpcf", PATTACH_ABSORIGIN, keys.target)
					ParticleManager:SetParticleControl(incinerate_wave_particle_effect, 1, Vector(current_wave_radius, 0, 0))
					
					keys.target:SetDayTimeVisionRange(current_wave_radius)
					keys.target:SetNightTimeVisionRange(current_wave_radius)
					
					keys.target:EmitSound("Hero_Invoker.ForgeSpirit")
					
					--Damage nearby enemy units.
					local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, current_wave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					
					for i, individual_unit in ipairs(nearby_enemy_units) do
						ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = keys.DamagePerWave * (waves_spawned_so_far + 1), damage_type = DAMAGE_TYPE_MAGICAL,})
					end
					
					waves_spawned_so_far = waves_spawned_so_far + 1
					
					return keys.DelayBetweenWaves
				end
			end
		})
	end
end