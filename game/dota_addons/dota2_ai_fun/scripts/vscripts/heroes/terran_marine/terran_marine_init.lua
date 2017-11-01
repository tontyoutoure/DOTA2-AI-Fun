function TerranMarineInit(hHero)
	Timers:CreateTimer(1, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)  hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_terran_marine", {}) end)
	Timers:CreateTimer(2, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY) end)	
end