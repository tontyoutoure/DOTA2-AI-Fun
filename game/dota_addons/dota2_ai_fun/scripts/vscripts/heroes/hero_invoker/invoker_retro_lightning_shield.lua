--[[ ============================================================================================================
	Author: Rook, based on Noya's code for Shroud of Flames.
	Date: March 11, 2015
	Called when Lightning Shield is cast.
================================================================================================================= ]]
function invoker_retro_lightning_shield_on_spell_start(keys)
	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_wex")
	if wex_ability ~= nil then
		local wex_level = wex_ability:GetLevel()
		local damage_per_second = keys.ability:GetLevelSpecialValueFor("damage_per_second", wex_level - 1)
		local duration = keys.ability:GetLevelSpecialValueFor("duration", wex_level - 1)
		
		keys.target:EmitSound("Hero_Zuus.StaticField")
		
		--Create a dummy to apply the modifier on the desired unit. 
		--This is needed because the buff could malfunction if Wex is leveled up during the buff, or if the ability is de-invoked.
		local lightning_shield_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_lightning_shield_unit", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeam())
		
		--Teach the dummy unit Lightning Shield, and set its level.
		lightning_shield_dummy_unit:AddAbility("invoker_retro_lightning_shield")
		local dummy_unit_ability = lightning_shield_dummy_unit:FindAbilityByName("invoker_retro_lightning_shield")
		dummy_unit_ability:SetLevel(wex_level)
		
		lightning_shield_dummy_unit.lightning_shield_damage_per_second = damage_per_second
		
		--Have the dummy unit apply the buff.  Existing modifiers must be removed first because reapplying the modifier will not refresh the stored caster of the modifier,
		--so when the dummy unit is deleted later, an error will proc.
		keys.target:RemoveModifierByName("modifier_invoker_retro_lightning_shield")
		dummy_unit_ability:ApplyDataDrivenModifier(lightning_shield_dummy_unit, keys.target, "modifier_invoker_retro_lightning_shield", {duration = duration})
	
		--Kill the dummy after the duration.
		Timers:CreateTimer(duration + 1, function()
			lightning_shield_dummy_unit:RemoveSelf()
		end)
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 11, 2015
	Called regularly while the Lightning Shield modifier is on a unit.  Damages nearby enemies.
	Additional parameters: keys.Radius and keys.DamageInterval
================================================================================================================= ]]
function modifier_invoker_retro_lightning_shield_on_interval_think(keys)
	if keys.caster.lightning_shield_damage_per_second ~= nil then
		local damage_to_deal = keys.caster.lightning_shield_damage_per_second * keys.DamageInterval   --This gives us the damage per interval.
		
		local nearby_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_BOTH,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for i, individual_unit in ipairs(nearby_units) do
			if keys.target ~= individual_unit then  --The carrier of Lightning Shield cannot damage itself.
				ApplyDamage({victim = individual_unit, attacker = keys.caster:GetOwner(), damage = damage_to_deal, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
end