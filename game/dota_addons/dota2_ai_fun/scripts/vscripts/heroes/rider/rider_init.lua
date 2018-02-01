local tNewAbilities = {
	"rider_run_down",
	"rider_bloodrage",
	"rider_backstab",
	"generic_hidden",
	"generic_hidden",
	"rider_drag",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_lifesteal_20",
	"special_bonus_all_stats_8",
	"special_bonus_unique_rider_1",
	"special_bonus_unique_rider_2",
	"special_bonus_unique_rider_3",
	"special_bonus_unique_rider_4"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 24,
	AttackDamageMax = 28,
	AttackRange = 150,
	AttributeBaseStrength = 19,
	AttributeStrenthGain = 2.7,
	AttributeBaseAgility = 21,
	AttributeAgilityGain = 2.6,
	AttributeBaseIntelligence = 13,
	AttributeIntelligenceGain = 1.2,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
	AttackAnimationPoint = 0.5,
}

CustomNetTables:SetTableValue("fun_hero_abilities", "rider", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "rider", tHeroBaseStats)

function RiderInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_rider", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end