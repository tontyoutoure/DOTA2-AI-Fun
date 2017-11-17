
local tOriginalAbilities = {
	"spirit_breaker_charge_of_darkness",
	"spirit_breaker_empowering_haste",
	"spirit_breaker_greater_bash",
	"generic_hidden",
	"generic_hidden",
	"spirit_breaker_nether_strike",
	"special_bonus_night_vision_400",
	"special_bonus_armor_5",
	"special_bonus_hp_regen_10",
	"special_bonus_attack_damage_30",
	"special_bonus_unique_spirit_breaker_3",
	"special_bonus_unique_spirit_breaker_2",
	"special_bonus_unique_spirit_breaker_1",
	"special_bonus_hp_800"
}

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

function AstralTrekkerInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_astral_trekker", {})		
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end