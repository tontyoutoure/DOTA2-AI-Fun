local tNewAbilities = {
	"conjurer_conjure_image",
	"conjurer_summon_golem",
	"conjurer_water_elemental",
	"generic_hidden",
	"generic_hidden",
	"conjurer_phoenix",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_conjurer_1",
	"special_bonus_movement_speed_40",
	"special_bonus_unique_conjurer_2",
	"special_bonus_unique_conjurer_3",
	"special_bonus_unique_conjurer_4",
	"special_bonus_unique_conjurer_5"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 16,
	AttackDamageMax = 28,
	AttackRange = 600,
	AttributeBaseStrength = 17,
	AttributeBaseAgility = 17,
	AttributeBaseIntelligence = 20,
	AttributeStrenthGain = 2.1,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 3,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
}
CustomNetTables:SetTableValue("fun_hero_abilities", "conjurer", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "conjurer", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("conjurer", tNewAbilities)

function ConjurerInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_conjurer", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	 
end