--[[ ============================================================================================================
	Author: Rook
	Date: March 7, 2015
	Called when Inferno is cast.
	Additional parameters: keys.InfernoSpawnRadius, keys.InfernoExplosionDelay, keys.InfernoExplosionDuration,
		keys.InfernoRadius, keys.InfernoDelayBetweenSpawns
================================================================================================================= ]]
function invoker_retro_inferno_on_spell_start(keys)	
	--The number of infernos to spawn is dependent on the level of Wex.
	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_wex")
	local num_infernos = 0
	if wex_ability ~= nil then
		num_infernos = keys.ability:GetLevelSpecialValueFor("num_infernos", wex_ability:GetLevel() - 1)
	end
	
	--The damage per second dealt by infernos is dependent on the level of Exort.
	local exort_ability = keys.caster:FindAbilityByName("invoker_retro_exort")
	local inferno_damage_per_second = 0
	if exort_ability ~= nil then
		inferno_damage_per_second = keys.ability:GetLevelSpecialValueFor("inferno_damage_per_second", exort_ability:GetLevel() - 1)
	end
	
	--Spawn the infernos, with a slight delay in between each one.
	local infernos_spawned_so_far = 0
	Timers:CreateTimer({
		callback = function()
			local caster_point = keys.caster:GetAbsOrigin()
				
			--Select a random point within the radius around the caster.
			local random_x_offset = RandomInt(0, keys.InfernoSpawnRadius) - (keys.InfernoSpawnRadius / 2)
			local random_y_offset = RandomInt(0, keys.InfernoSpawnRadius) - (keys.InfernoSpawnRadius / 2)
			local inferno_point = Vector(caster_point.x + random_x_offset, caster_point.y + random_y_offset, caster_point.z)
			inferno_point = GetGroundPosition(inferno_point, nil)
			
			--Create a dummy unit at the spawn point.
			local inferno_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_inferno_unit", inferno_point, false, nil, nil, keys.caster:GetTeam())
			local dummy_unit_ability = inferno_dummy_unit:FindAbilityByName("dummy_unit_passive")
			if dummy_unit_ability ~= nil then
				dummy_unit_ability:SetLevel(1)
			end
			
			local ability_name = keys.ability:GetName()
			inferno_dummy_unit:AddAbility(ability_name)
			dummy_unit_inferno_ability = inferno_dummy_unit:FindAbilityByName(ability_name)
			dummy_unit_inferno_ability:SetLevel(keys.ability:GetLevel())
			
			inferno_dummy_unit:EmitSound("Hero_Invoker.SunStrike.Charge")
			
			--Store the DPS that the inferno should deal.
			inferno_dummy_unit.inferno_damage_per_second = inferno_damage_per_second
			
			--Display the pre-explosion particle effect at the dummy unit's point.
			local inferno_pre_explosion_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_inferno_pre_explosion.vpcf", PATTACH_ABSORIGIN, inferno_dummy_unit)
			
			--Explode the inferno after a delay.
			Timers:CreateTimer({
				endTime = keys.InfernoExplosionDelay,
				callback = function()
					dummy_unit_inferno_ability:ApplyDataDrivenModifier(keys.caster, inferno_dummy_unit, "modifier_invoker_retro_inferno_damage_over_time", nil)
					
					--Destroy the pre-explosion particle effect, and play the explosion particle effect.
					ParticleManager:DestroyParticle(inferno_pre_explosion_particle_effect, false)
					local inferno_explosion_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_inferno.vpcf", PATTACH_ABSORIGIN, inferno_dummy_unit)
					
					--Give vision over the explosion.
					inferno_dummy_unit:SetDayTimeVisionRange(keys.InfernoRadius)
					inferno_dummy_unit:SetNightTimeVisionRange(keys.InfernoRadius)
					
					inferno_dummy_unit:EmitSound("Hero_Invoker.SunStrike.Ignite")
					inferno_dummy_unit:EmitSound("Hero_Huskar.Burning_Spear")
					
					--Destroy the inferno after its duration ends.
					Timers:CreateTimer({
						endTime = keys.InfernoExplosionDuration,
						callback = function()
							inferno_dummy_unit:StopSound("Hero_Huskar.Burning_Spear")
							inferno_dummy_unit:RemoveSelf()
						end
					})
				end
			})
			
			infernos_spawned_so_far = infernos_spawned_so_far + 1
			if infernos_spawned_so_far >= num_infernos then 
				return
			else 
				return keys.InfernoDelayBetweenSpawns
			end
		end
	})
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 7, 2015
	Called regularly while an inferno is exploding.
	Additional parameters: keys.InfernoRadius, keys.InfernoDamageInterval
================================================================================================================= ]]
function modifier_invoker_retro_inferno_damage_over_time_on_interval_think(keys)
	--Damage nearby enemy units.
	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.InfernoRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for i, individual_unit in ipairs(nearby_enemy_units) do
		if keys.target.inferno_damage_per_second ~= nil then  --The damage per second should have been stored in the dummy unit.
			ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = keys.target.inferno_damage_per_second * keys.InfernoDamageInterval, damage_type = DAMAGE_TYPE_MAGICAL,})
		end
	end
end