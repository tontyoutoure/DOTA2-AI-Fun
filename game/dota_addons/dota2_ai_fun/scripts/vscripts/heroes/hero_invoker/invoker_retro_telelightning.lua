--[[ ============================================================================================================
	Author: wFX
	Date: March 05, 2015
	Called when Telelightning's cast point finishes.  Moves Invoker to the target and damages them.
================================================================================================================= ]]
function invoker_retro_telelightning_on_spell_start(event)
	local caster = event.caster
	local ability = event.ability
	local wex_ability = caster:FindAbilityByName("invoker_retro_wex")
	local target = event.target
	
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	target:EmitSound("Hero_Zuus.ArcLightning.Target")
	
	--Instead of placing the Invoker right on top of the target, place him a little away along the line between Invoker and the target.
	--This ensures that Invoker is not placed on the opposite side of the target.
	local target_point = target:GetAbsOrigin()
	local point_difference_normalized = (caster:GetAbsOrigin() - target_point):Normalized()
	local point_to_place_caster = GetGroundPosition(target_point + (point_difference_normalized * 64), nil)
	
	FindClearSpaceForUnit(caster, point_to_place_caster, false)

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ability:GetLevelSpecialValueFor("damage", wex_ability:GetLevel()-1),
		damage_type = ability:GetAbilityDamageType()
	}
	ApplyDamage(damageTable)
end


--[[ ============================================================================================================
	Author: wFX
	Date: March 05, 2015
	Called when Telelightning's cast point begins.  Starts the particle effect.
================================================================================================================= ]]
function invoker_retro_telelightning_on_ability_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	local wex_ability = caster:FindAbilityByName("invoker_retro_wex")
	local target = event.target
	
	--Play the particle effects after a short delay.
	Timers:CreateTimer({
		endTime = .2,
		callback = function()
			local particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf",PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particle, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z))
			ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z))
		end
	})
end