local tNewAbilities = {
	"void_demon_time_void",
	"void_demon_quake",
	"void_demon_degen_aura",
	"generic_hidden",
	"generic_hidden",
	"void_demon_mass_haste",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_void_demon_1",
	"special_bonus_cast_range_400",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_void_demon_2"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackAnimationPoint = 0.55,
	AttackRate = 1.6,
	AttackDamageMin = 25,
	AttackDamageMax = 29,
	AttributeBaseStrength = 20,
	AttributeBaseAgility = 16,
	AttributeBaseIntelligence = 18,
	AttributeStrengthGain = 3.2,
	AttributeAgilityGain = 1,
	AttributeIntelligenceGain = 1.25,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	VisionDaytimeRange = 1800,
	VisionNighttimeRange = 800
}

CustomNetTables:SetTableValue("fun_hero_stats", "void_demon_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "void_demon", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("void_demon", tNewAbilities)
function VoidDemonInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_void_demon", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end