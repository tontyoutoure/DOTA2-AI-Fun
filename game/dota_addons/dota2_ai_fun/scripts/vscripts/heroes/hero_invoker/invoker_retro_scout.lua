--[[
	Author: wFX with help of Rook and Noya
	Date: 18.01.2015.
	Gets the summoning location for the new unit
]]

function invoker_retro_scout_on_spell_start(keys)
    local caster = keys.caster
    local ability = keys.ability
	local iWexLevel = keys.caster.iWexLevel
	if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end
	
	-- Gets the vector facing 200 units away from the caster origin    
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local front_position = origin + fv * 200
	local owl = CreateUnitByName("npc_dota_invoker_retro_scout_unit", front_position, true, nil, nil, caster:GetTeam())
	owl:SetForwardVector(fv)
	local owl_ability = owl:FindAbilityByName("invoker_retro_scout_unit_ability")
	
	owl_ability:SetLevel(1)
	
	owl_ability:ApplyDataDrivenModifier(caster, owl, "modifier_invoker_retro_scout_unit_ability", {})
	
	local vision_range = ability:GetSpecialValueFor("owl_vision_base")+ability:GetSpecialValueFor("owl_vision_level_wex")*iWexLevel  --Vision radius increases per level of Wex.
	owl:SetDayTimeVisionRange(vision_range)
	owl:SetNightTimeVisionRange(vision_range)
	
	for i = 1, iWexLevel do
		owl_ability:ApplyDataDrivenModifier(caster, owl, 'modifier_invoker_retro_scout_unit_movespeed_bonus', {})
	end
	owl.vOwner = caster:GetOwner()
	owl:SetControllableByPlayer(caster:GetOwner():GetPlayerID(), true)
	owl:AddNewModifier(owl, nil, "modifier_kill", {duration = ability:GetSpecialValueFor("owl_duration_base")+iWexLevel*ability:GetSpecialValueFor("owl_duration_level_wex") })  --Add the green duration circle, and kill it after the duration ends.
	--owl:AddNewModifier(owl, nil, "modifier_invisible", {duration = .1})  --Make the owl have the translucent texture.
	if iWexLevel >= 8 then
		owl:AddNewModifier(owl, owl_ability, 'modifier_invisible', {})
	end
end


--[[
	Author: wFX with help of Rook and Noya
	Date: 18.01.2015.
	Removes invisibility from nearby units, and maintains a translucent texture on the unit.
]]
function modifier_invoker_retro_scout_unit_ability_on_interval_think(keys)
	--keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_invisible", {duration = .1})

	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, keys.caster:GetCurrentVisionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for i, individual_unit in ipairs(nearby_enemy_units) do
		individual_unit:RemoveModifierByName("modifier_truesight")
		individual_unit:AddNewModifier(keys.caster, keys.ability, "modifier_truesight", {duration = .5})
	end
end