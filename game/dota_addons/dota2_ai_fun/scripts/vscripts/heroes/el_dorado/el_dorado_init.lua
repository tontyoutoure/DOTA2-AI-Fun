function GameMode:ElDoradoDamageFilter(filterTable)
	if not filterTable.entindex_victim_const or not filterTable.entindex_attacker_const then return true end
	local hVictim = EntIndexToHScript(filterTable.entindex_victim_const)
	local hAttacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	if hAttacker:HasModifier('modifier_el_dorado_artificial_frog_demolish') and hVictim:IsBuilding() then 
		filterTable.damage = filterTable.damage*(1+hAttacker:FindAbilityByName('el_dorado_artificial_frog_demolish'):GetSpecialValueFor("bonus_building_damage")/100)
	end
	return true
end

function ElDoradoInit(hHero, context)
	WearableManager:RemoveOriginalWearables(hHero)
	if not GameMode.bEledoradoDemolishFilterSet then
		GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, 'ElDoradoDamageFilter'), context)
		GameMode.bEledoradoDemolishFilterSet = true
	end
end