local tNewAbilities = {
	"telekenetic_blob_throw",
	"telekenetic_blob_catapult",
	"telekenetic_blob_sling",
	"telekenetic_blob_mark_target",
	"generic_hidden",
	"telekenetic_blob_expel",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_hp_600",
	"special_bonus_movement_speed_50",
	"special_bonus_cast_range_400"
}

local tHeroBaseStats = {
	MovementSpeed = 290,
	AttackRate = 1.7,
	AttackDamageMin = 15,
	AttackDamageMax = 20,
	AttributeBaseStrength = 19,
	AttributeBaseAgility = 3,
	AttributeBaseIntelligence = 33,
	AttributeStrenthGain = 2.6,
	AttributeAgilityGain = 0.2,
	AttributeIntelligenceGain = 3.5,
	ArmorPhysical = 4,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackCapabilities = DOTA_UNIT_CAP_NO_ATTACK
}

function TelekeneticBlobInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_telekenetic_blob", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	hHero:FindAbilityByName("telekenetic_blob_mark_target"):SetLevel(1)
end