--[[ ============================================================================================================
	Author: Noya
	Date: March 10, 2015
	Called when the unit under the Shroud of Flames buff is attacked. Damages the target enemy unit by Exort level
================================================================================================================= ]]
function invoker_retro_shroud_of_flames(keys)
	local hero = keys.caster:GetOwner()
	if keys.caster.shroud_of_flames_exort_level ~= nil then
		local damage_exort = keys.ability:GetLevelSpecialValueFor("damage_exort", keys.caster.shroud_of_flames_exort_level - 1)  --Damage dealt increases per level of Exort.
		
		ApplyDamage({victim = keys.target, attacker = hero, damage = damage_exort, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

--[[ ============================================================================================================
	Author: Noya
	Date: March 10, 2015
	Create a dummy to apply the modifier on the desired unit. 
	This is needed because once the old rank of the ability is removed, the OnProjectileHitUnit trigger and 
	magic_resistance are lost, making the buff malfunction if Quas/Exort are leveled up during the buff.
================================================================================================================= ]]
function invoker_retro_shroud_of_flames_dummy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local exort_ability = caster:FindAbilityByName("invoker_retro_exort")
	local quas_ability = caster:FindAbilityByName("invoker_retro_quas")

	local pos = caster:GetAbsOrigin()
	local shroud_of_flames_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_shroud_of_flames_unit", pos, false, caster, caster, caster:GetTeam())

	-- Teach the ability and set its level
	local ability_name = ability:GetAbilityName()
	shroud_of_flames_dummy_unit:AddAbility(ability_name)
	local dummy_ability = shroud_of_flames_dummy_unit:FindAbilityByName(ability_name)
	dummy_ability:SetLevel(quas_ability:GetLevel())
	
	shroud_of_flames_dummy_unit.shroud_of_flames_exort_level = exort_ability:GetLevel()
	
	-- Apply this modifier rank on the target
	target:RemoveModifierByName("modifier_shroud_of_flames")
	dummy_ability:ApplyDataDrivenModifier(shroud_of_flames_dummy_unit, target, "modifier_shroud_of_flames", {duration = dummy_ability:GetDuration()})

	-- Kill the dummy after the duration
	Timers:CreateTimer(dummy_ability:GetDuration(), function()
		shroud_of_flames_dummy_unit:RemoveSelf()
	end)
end