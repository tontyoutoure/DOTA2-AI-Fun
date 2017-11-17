local tNewAbilities = {
	"formless_unus",
	"formless_duos",
	"formless_tertius",
	"generic_hidden",
	"generic_hidden",
	"formless_denique",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_cast_range_400"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackRange = 500,
	AttackDamageMin = 23,
	AttackDamageMax = 30,
	AttributeBaseStrength = 15,
	AttributeBaseAgility = 17,
	AttributeBaseIntelligence = 23,
	AttributeStrenthGain = 1.4,
	AttributeAgilityGain = 2.0,
	AttributeIntelligenceGain = 3.1,
	ArmorPhysical = 3,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.1,
}



function GameMode:OnFormlessForget(eventSourceIndex, args)	
	if not PlayerResource:GetPlayer(eventSourceIndex - 1).bIsPlayingFunHero then return end
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



function FormlessInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_formless", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	if not GameMode.bFormlessForgetListenerSet then 
		GameMode.bFormlessForgetListenerSet = true
		CustomGameEventManager:RegisterListener("formless_forget", function(eventSourceIndex, args) return GameMode:OnFormlessForget(eventSourceIndex, args) end )
	end
end