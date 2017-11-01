function PersuasiveInit(hHero)
	Timers:CreateTimer(1, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)  hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_persuasive", {}) end)
	Timers:CreateTimer(2, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH) end)	
end