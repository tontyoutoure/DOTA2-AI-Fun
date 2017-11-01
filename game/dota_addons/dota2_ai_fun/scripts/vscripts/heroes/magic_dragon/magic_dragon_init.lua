function MagicDragonInit(hHero)
	if hHero:IsIllusion() then
		MagicDragonTransform[hHero:GetOwner():GetAssignedHero().iDragonForm](hHero)
	elseif not hHero.bSpawned then
		require("heroes/magic_dragon/magic_dragon_transform")	
		MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](hHero)		
		WearableManager:RemoveOriginalWearables(hHero)
		Timers:CreateTimer(1, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)  hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_magic_dragon", {}) end)
		Timers:CreateTimer(2, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH) end)	
	end
end