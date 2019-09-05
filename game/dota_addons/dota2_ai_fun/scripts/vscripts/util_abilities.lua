function BackdoorProtectionTest (keys)
--	PrintTable(keys)
	keys.ability.fTimeToAdd = keys.ability.fTimeToAdd or 0
	local tUnits = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetOrigin(), nil, keys.ability:GetSpecialValueFor("radius"),DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local iLength = #tUnits
	for i = 1, iLength do
		if tUnits[iLength+1-i]:GetPlayerOwnerID() > 0 or (tUnits[iLength+1-i]:GetClassname() ~= "npc_dota_creep_lane" and tUnits[iLength+1-i]:GetClassname() ~= "npc_dota_creep_siege") then
			table.remove(tUnits, iLength+1-i)
		end
	end
	if #tUnits > 0 then
		keys.caster:RemoveModifierByName("modifier_backdoor_protection_active")
		keys.ability.fTimeToAdd = GameRules:GetGameTime() + keys.ability:GetSpecialValueFor("activation_time")
	end
	if GameRules:GetGameTime() > keys.ability.fTimeToAdd then
		keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_backdoor_protection_active", {})
	end
end