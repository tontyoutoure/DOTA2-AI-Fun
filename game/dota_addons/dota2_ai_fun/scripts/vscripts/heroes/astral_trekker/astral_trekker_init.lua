local tNewAbilities = {
	"astral_trekker_entrapment",
	"astral_trekker_war_stomp",
	"astral_trekker_pulverize",
	"generic_hidden",
	"generic_hidden",
	"astral_trekker_giant_growth",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_attack_speed_40",
	"special_bonus_astral_trekker_1",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_astral_trekker_2",
}

	

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackAnimationPoint = 0.36,
	AttackRate = 1.6,
	AttackDamageMin = 34,
	AttackDamageMax = 34,
	AttributeBaseStrength = 25,
	AttributeBaseAgility = 18,
	AttributeBaseIntelligence = 16,
	AttributeStrengthGain = 3.3,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 1.6,
	AttackAnimationPoint = 0.4,
	ArmorPhysical = 3,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH
}
CustomNetTables:SetTableValue("fun_hero_stats", "astral_trekker_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "astral_trekker", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("astral_trekker", tNewAbilities)

function AstralTrekkerInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_astral_trekker", {})		
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end