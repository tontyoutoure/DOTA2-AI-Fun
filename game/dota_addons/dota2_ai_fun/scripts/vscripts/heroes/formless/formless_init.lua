function GameMode:OnFormlessForget(eventSourceIndex, args)	
	local hero = PlayerResource:GetPlayer(eventSourceIndex - 1):GetAssignedHero()
	local currentAbility = hero:GetAbilityByIndex(tonumber(args.skill_index))
    if currentAbility:GetName() ~= args.skillname_to_forget then
	  if currentAbility:IsChanneling() then
		currentAbility:EndChannel(true)
	  end
      hero:SwapAbilities(currentAbility:GetName(), args.skillname_to_forget, false, true)
      hero:FindAbilityByName(args.skillname_to_forget):SetLevel(currentAbility:GetLevel())
	  local allModifiers = hero:FindAllModifiers()
	  local modifiersToRemove = {}
	  for i = #allModifiers, 1, -1 do
		  if string.find(allModifiers[i]:GetName(), currentAbility:GetName()) then
	  		table.insert(modifiersToRemove, allModifiers[i]:GetName())
		  end
	  end	  
	  hero:RemoveAbility(currentAbility:GetName())
	  for i = 1, #modifiersToRemove do
		hero:RemoveModifierByName(modifiersToRemove[i])
	  end
    end
end

CustomGameEventManager:RegisterListener("formless_forget", function(eventSourceIndex, args) return GameMode:OnFormlessForget(eventSourceIndex, args) end )


function FormlessInit(hHero)
	Timers:CreateTimer(1, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)  hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_formless", {}) end)
	Timers:CreateTimer(2, function () hHero:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT) end)	
end