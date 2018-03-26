--[[ ============================================================================================================
	Author: Rook
	Date: March 9, 2015
	Called when Shock is cast.
	Additional parameters: keys.DelayBeforeDamage
================================================================================================================= ]]
function invoker_retro_shock_on_spell_start(keys)	
	local caster_origin = keys.caster:GetAbsOrigin()
	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_wex")  --The damage and radius depends on Wex.
	
	if wex_ability ~= nil then
		local damage = keys.ability:GetLevelSpecialValueFor("damage", wex_ability:GetLevel() - 1)
		local radius = keys.ability:GetLevelSpecialValueFor("radius", wex_ability:GetLevel() - 1)
		
		keys.caster:EmitSound("retro_dota.shock_on_spell_start")

		local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), caster_origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		--Display particle effects in the AoE and for each affected enemy.
		local shock_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_shock_ground.vpcf", PATTACH_ABSORIGIN, keys.caster)
		ParticleManager:SetParticleControl(shock_particle_effect, 1, Vector(radius, 0, 0))

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

					ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,})
				end
			end
		})
	end
end