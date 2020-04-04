local tNewAbilities = {
	"old_silencer_star_storm",
	"old_silencer_healing_wave",
	"old_silencer_rain_of_chaos",
	"generic_hidden",
	"generic_hidden",
	"old_silencer_silencer",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_old_silencer_0",
	"special_bonus_unique_old_silencer_1",
	"special_bonus_attack_range_250",
	"special_bonus_unique_old_silencer_2",
	"special_bonus_unique_old_silencer_3",
	"special_bonus_unique_old_silencer_4"
}

local tHeroBaseStats = {
	MovementSpeed = 290,
	AttackRate = 1.7,
	AttackDamageMin = 28,
	AttackDamageMax = 40,
	AttackRange = 450,
	AttributeBaseStrength = 16,
	AttributeStrengthGain = 2.4,
	AttributeBaseAgility = 14,
	AttributeAgilityGain = 1.4,
	AttributeBaseIntelligence = 23,
	AttributeIntelligenceGain = 2.7,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.5,
	AttackSpeedBonus=-15,
}

CustomNetTables:SetTableValue("fun_hero_stats", "old_silencer_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_silencer", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("old_silencer", tNewAbilities)

if IsServer() then
	LinkLuaModifier("modifier_remove_silencer_int_steal", "heroes/old_silencer/old_silencer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
end

function OldSilencerInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_silencer", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	hHero:AddNewModifier(hHero, nil, "modifier_remove_silencer_int_steal", {})
end