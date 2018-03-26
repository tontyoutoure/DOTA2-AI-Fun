--[[ ============================================================================================================
	Author: Rook
	Date: February 24, 2015
	Called when EMP is cast.
	Additional parameters: keys.DistanceToMove, keys.ProjectileSpeedPerSecond, keys.DelayBeforeExploding, keys.Radius
================================================================================================================= ]]
function invoker_retro_emp_on_spell_start(keys)	
	local caster_origin = keys.caster:GetAbsOrigin()
	
	--Calculate where and when the EMP should end up.
	local caster_forward_vector = keys.caster:GetForwardVector()
	local emp_time_to_final_position = keys.DistanceToMove / keys.ProjectileSpeedPerSecond
	local emp_velocity_per_frame = keys.caster:GetForwardVector() * (keys.ProjectileSpeedPerSecond * .03)
	
	--The amount of mana to burn depends on both Wex and Quas.
	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_wex")
	
	if quas_ability ~= nil and wex_ability ~= nil then		
		local average_level = (quas_ability:GetLevel() + wex_ability:GetLevel()) / 2
		average_level = math.floor(average_level + .5)  --Round to the nearest integer.
		
		--Ensure that the average level is in-bounds, just in case.
		if average_level < 1 then
			average_level = 1
		end
		if average_level > 8 then
			average_level = 8
		end
		
		local mana_to_burn = keys.ability:GetLevelSpecialValueFor("mana_burned", average_level - 1)
		
		--Create a dummy unit that will dictate the path of the EMP and provide sound.
		local emp_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_emp_unit", caster_origin + (caster_forward_vector * 100), false, nil, nil, keys.caster:GetTeam())
		local emp_dummy_unit_ability = emp_dummy_unit:FindAbilityByName("dummy_unit_passive")
		if emp_dummy_unit_ability ~= nil then
			emp_dummy_unit_ability:SetLevel(1)
		end
		
		keys.caster:EmitSound("Hero_Invoker.EMP.Cast")
		emp_dummy_unit:EmitSound("Hero_Invoker.EMP.Charge")  --Emit a sound that will follow the EMP.
		
		local emp_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_ABSORIGIN_FOLLOW, emp_dummy_unit)
		
		--Move the EMP dummy unit to its final position.
		local endTime = GameRules:GetGameTime() + emp_time_to_final_position
		Timers:CreateTimer({
			callback = function()
				emp_dummy_unit:SetAbsOrigin(emp_dummy_unit:GetAbsOrigin() + emp_velocity_per_frame)
				if GameRules:GetGameTime() > endTime then
					--Explode the EMP after it is in its final position and the delay has passed.
					Timers:CreateTimer({
						endTime = keys.DelayBeforeExploding,
						callback = function()
							ParticleManager:DestroyParticle(emp_effect, false)
							local emp_explosion_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf",  PATTACH_ABSORIGIN, emp_dummy_unit)
							
							emp_dummy_unit:EmitSound("Hero_Invoker.EMP.Discharge")
							
							local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), emp_dummy_unit:GetAbsOrigin(), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)

							for i, individual_unit in ipairs(nearby_enemy_units) do
								individual_unit:ReduceMana(mana_to_burn)
							end
							
							--Remove the dummy unit once the sound has stopped.
							Timers:CreateTimer({
								endTime = 4,
								callback = function()
									emp_dummy_unit:RemoveSelf()  --Note that this does cause a small dust cloud to appear in the dummy unit's location.
								end
							})
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