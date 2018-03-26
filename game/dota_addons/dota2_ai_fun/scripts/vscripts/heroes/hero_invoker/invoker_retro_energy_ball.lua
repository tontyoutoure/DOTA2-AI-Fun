--[[ ============================================================================================================
	Author: Rook
	Date: March 05, 2015
	Called when Energy Ball is cast.
	Additional parameters: keys.ProjectileSpeedUpwardsPerSecond, keys.DelayBeforeExploding, keys.Radius
================================================================================================================= ]]
function invoker_retro_energy_ball_on_spell_start(keys)	
	local caster_origin = keys.caster:GetAbsOrigin()
	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_wex")  --The amount of damage to deal depends on Wex.
	
	local energy_ball_velocity_per_frame = Vector(0, 0, 1) * (keys.ProjectileSpeedUpwardsPerSecond * .03)
	
	if wex_ability ~= nil then		
		local damage_to_deal = keys.ability:GetLevelSpecialValueFor("damage", wex_ability:GetLevel() - 1)
		
		--Create a dummy unit will dictate the path of the EMP and provide sound.
		local energy_ball_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_energy_ball_unit", caster_origin, false, nil, nil, keys.caster:GetTeam())
		energy_ball_dummy_unit:SetAbsOrigin(energy_ball_dummy_unit:GetAbsOrigin() + Vector(0, 0, 50))
		local energy_ball_dummy_unit_ability = energy_ball_dummy_unit:FindAbilityByName("dummy_unit_passive")
		if energy_ball_dummy_unit_ability ~= nil then
			energy_ball_dummy_unit_ability:SetLevel(1)
		end
		
		keys.caster:EmitSound("Hero_Phoenix.SuperNova.Begin")
		energy_ball_dummy_unit:EmitSound("Hero_Phoenix.SuperNova.Cast")  --Emit a sound that will follow the energy ball.
		
		local energy_ball_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_energy_ball.vpcf", PATTACH_ABSORIGIN_FOLLOW, energy_ball_dummy_unit)
		
		--Move the energy ball dummy unit to its final position.
		local endTime = GameRules:GetGameTime() + keys.DelayBeforeExploding
		Timers:CreateTimer({
			callback = function()
				energy_ball_dummy_unit:SetAbsOrigin(energy_ball_dummy_unit:GetAbsOrigin() + energy_ball_velocity_per_frame)
				if GameRules:GetGameTime() > endTime then  --Explode the energy ball.
					ParticleManager:DestroyParticle(energy_ball_effect, false)

					energy_ball_dummy_unit:StopSound("Hero_Phoenix.SuperNova.Cast")
					energy_ball_dummy_unit:EmitSound("Hero_Phoenix.SuperNova.Explode")
					
					local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), GetGroundPosition(energy_ball_dummy_unit:GetAbsOrigin(), nil), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

					for i, individual_unit in ipairs(nearby_enemy_units) do  --Damage and zap each nearby unit.
						--Create a discharge particle connecting the central part of the energy ball with each hit unit.
						local energy_ball_discharge = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_energy_ball_discharge.vpcf", PATTACH_ABSORIGIN_FOLLOW, energy_ball_dummy_unit)
						ParticleManager:SetParticleControlEnt(energy_ball_discharge, 1, individual_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", individual_unit:GetAbsOrigin(), false)
						
						ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_MAGICAL,})
					end
					
					--Remove the dummy unit once the sound has stopped.
					Timers:CreateTimer({
						endTime = 4,
						callback = function()
							energy_ball_dummy_unit:RemoveSelf()
							ParticleManager:DestroyParticle(energy_ball_effect, false)
						end
					})
					
					return 
				else 
					return .03
				end
			end
		})
	end
end