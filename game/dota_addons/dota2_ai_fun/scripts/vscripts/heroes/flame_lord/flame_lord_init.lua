local tNewAbilities = {
	"flame_lord_flameshot",
	"flame_lord_fire_storm",
	"flame_lord_liquid_fire",
	"generic_hidden",
	"generic_hidden",
	"flame_lord_enflame",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_flame_lord_1",
	"special_bonus_cast_range_150",
	"special_bonus_unique_flame_lord_2",
	"special_bonus_unique_flame_lord_3",
	"special_bonus_unique_flame_lord_4",
	"special_bonus_cooldown_reduction_30"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackDamageMin = 17,
	AttackDamageMax = 26,
	AttackRange = 575,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 18,
	AttributeBaseIntelligence = 22,
	AttributeStrenthGain = 1.8,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 3,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
}

CustomNetTables:SetTableValue("fun_hero_abilities", "flame_lord", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "flame_lord", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("flame_lord", tNewAbilities)

function FlameLordTalentManager(keys)
	if PlayerResource:GetPlayer(keys.player-1):GetAssignedHero():GetName() ~= "npc_dota_hero_warlock" then return end
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
	if keys.abilityname == "special_bonus_unique_flame_lord_4" then
		local iLevel = hHero:FindAbilityByName("flame_lord_enflame"):GetLevel()
		local fCD = hHero:FindAbilityByName("flame_lord_enflame"):GetCooldownTimeRemaining()
		hHero:RemoveAbility("flame_lord_enflame")
		local hAbility = hHero:AddAbility("flame_lord_enflame_talented")
		hAbility:SetLevel(iLevel)
		hAbility:StartCooldown(fCD)
	end
	if keys.abilityname == "special_bonus_unique_flame_lord_2" then
		local iLevel = hHero:FindAbilityByName("flame_lord_fire_storm"):GetLevel()
		local fCD = hHero:FindAbilityByName("flame_lord_fire_storm"):GetCooldownTimeRemaining()
		hHero:RemoveAbility("flame_lord_fire_storm")
		local hAbility = hHero:AddAbility("flame_lord_fire_storm_talented")
		hAbility:SetLevel(iLevel)
		hAbility:StartCooldown(fCD)
	end
end

function FlameLordInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_flame_lord", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	if not GameMode.bFlameLordTalentManagerSet then
		ListenToGameEvent( "dota_player_learned_ability", FlameLordTalentManager, nil )
		GameMode.bFlameLordTalentManagerSet = true
	end
end