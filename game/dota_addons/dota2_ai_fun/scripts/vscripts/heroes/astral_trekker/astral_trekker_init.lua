local tNewAbilities = {
	"astral_trekker_entrapment",
	"astral_trekker_war_stomp",
	"astral_trekker_pulverize",
	"generic_hidden",
	"generic_hidden",
	"astral_trekker_giant_growth",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_attack_speed_30",
	"special_bonus_astral_trekker_1",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_astral_trekker_2",
}

	

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackDamageMin = 34,
	AttackDamageMax = 34,
	AttributeBaseStrength = 25,
	AttributeBaseAgility = 18,
	AttributeBaseIntelligence = 16,
	AttributeStrenthGain = 3.3,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 1.6,
	AttackAnimationPoint = 0.4,
	ArmorPhysical = 3,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH
}
CustomNetTables:SetTableValue("fun_hero_abilities", "astral_trekker", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "astral_trekker", tHeroBaseStats)

function AstralTrekkerInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_astral_trekker", {})		
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end