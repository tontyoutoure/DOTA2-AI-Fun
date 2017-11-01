function BastionInit(hHero)
	WearableManager:RemoveOriginalWearables(hHero)
	Timers:CreateTimer(1, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)  hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_bastion", {}) end)
	Timers:CreateTimer(2, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH) end)
	
end