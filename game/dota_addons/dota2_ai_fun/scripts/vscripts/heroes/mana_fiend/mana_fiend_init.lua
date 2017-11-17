local tNewAbilities = {
	"mana_fiend_equilibrium",
	"mana_field_mana_rift",
	"mana_fiend_osmose",
	"generic_hidden",
	"generic_hidden",
	"mana_fiend_abandon",
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
	MovementSpeed = 310,
	AttackRate = 1.5,
	AttackDamageMin = 22,
	AttackDamageMax = 26,
	AttackRange = 600,
	AttributeBaseStrength = 18,
	AttributeBaseAgility = 15,
	AttributeBaseIntelligence = 22,
	AttributeStrenthGain = 1.7,
	AttributeAgilityGain = 1.4,
	AttributeIntelligenceGain = 2.8,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.4
}

function ManaFiendInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_mana_fiend", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end