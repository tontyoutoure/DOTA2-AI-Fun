--castpt 0.5 
--Learns Tornado Blast, Tornado Barrier, Displace, and |c00ff8000Typhoon|r.
local tNewAbilities = {
	"god_of_wind_tornado_blast",
	"god_of_wind_tornado_barrier",
	"god_of_wind_dispalce",
	"generic_hidden",
	"generic_hidden",
	"god_of_wind_typhoon",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_movement_speed_25",
	"special_bonus_cooldown_reduction_20",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_bastion_1",
}


local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 16,
	AttackDamageMax = 32,
	AttributeBaseStrength = 17,
	AttributeBaseAgility = 13,
	AttributeBaseIntelligence = 22,
	AttributeStrengthGain = 2,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 3,
	AttackAnimationPoint = 0.3,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	ArmorPhysical = -1,
	ProjectileModel = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
	DisableWearables = true,
	Model = "models/creeps/neutral_creeps/n_creep_vulture_b/n_creep_vulture_b.vmdl",
}

CustomNetTables:SetTableValue("fun_hero_stats", "god_of_wind_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "god_of_wind", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("god_of_wind", tNewAbilities)
function GodOfWindInit(hHero)	
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_god_of_wind", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end