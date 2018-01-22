local tNewAbilities = {
	"formless_unus",
	"formless_duos",
	"formless_tertius",
	"formless_forget_choose",
	"formless_forget_all",
	"formless_denique",
	"formless_unus_forget",
	"formless_duos_forget",
	"formless_tertius_forget",
	"formless_denique_forget",
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

function FormlessInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_formless", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)		
	hHero:AddNewModifier(hHero, nil, "modifier_sniper_assassinate_thinker", {})
end