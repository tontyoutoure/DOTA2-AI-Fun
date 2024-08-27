LinkLuaModifier("modifier_felguard_color", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

local tNewAbilities = {
	"felguard_fireblade_strike",
	"felguard_felguard_wrath",
	"felguard_strength_and_honor",
	"generic_hidden",
	"generic_hidden",
	"felguard_overflow",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_cast_range_150",
	"special_bonus_unique_felguard_1",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_unique_felguard_2"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackAnimationPoint = 0.3,
	AttackDamageMin = 15,
	AttackDamageMax = 20,
	AttributeBaseStrength = 24,
	AttributeBaseAgility = 15,
	AttributeBaseIntelligence = 16,
	AttributeStrengthGain = 3.3,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 1.75,
	ArmorPhysical = 3,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH
}
CustomNetTables:SetTableValue("fun_hero_stats", "felguard_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "felguard", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("felguard", tNewAbilities)

function FelguardInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_felguard_color", {})
	hHero:SetModelScale(1.1)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_felguard", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end