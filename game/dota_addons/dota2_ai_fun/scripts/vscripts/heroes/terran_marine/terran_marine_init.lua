LinkLuaModifier("modifier_terran_marine_attack_sound", "heroes/terran_marine/modifier_terran_marine.lua", LUA_MODIFIER_MOTION_NONE)
local tNewAbilities = {
	"terran_marine_stim_pack",
	"terran_marine_heavy_artillery",
	"terran_marine_precision_lua",
	"generic_hidden",
	"generic_hidden",
	"terran_marine_u247_rifle_lua",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_movement_speed_25",
	"special_bonus_terran_marine_1",
	"special_bonus_all_stats_12",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_terran_marine_2"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1,
	AttackDamageMin = 3,
	AttackDamageMax = 5,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 27,
	AttributeBaseIntelligence = 12,
	AttributeStrengthGain = 2.1,
	AttributeAgilityGain = 2.6,
	AttributeIntelligenceGain = 1.4,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
	AttackRange = 650,
	AttackAnimationPoint = 0.17,	
	AttackCapabilities = DOTA_UNIT_CAP_MELEE_ATTACK
}

CustomNetTables:SetTableValue("fun_hero_stats", "terran_marine_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "terran_marine", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("terran_marine", tNewAbilities)

function TerranMarineInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_terran_marine", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	hHero:AddNewModifier(hHero, nil, "modifier_terran_marine_attack_sound", {})
end