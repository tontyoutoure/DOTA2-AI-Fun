local tNewAbilities = {
	"kahmeka_ignite",
	"kahmeka_fly",
	"kahmeka_fly_down_divebomb",
	"kahmeka_wounding_spear",
	"generic_hidden",
	"kahmeka_fungwarb",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_kahmeka_1",
	"special_bonus_hp_250",
	"special_bonus_unique_kahmeka_2",
	"special_bonus_unique_kahmeka_3",
	"special_bonus_unique_kahmeka_4",
	"special_bonus_unique_kahmeka_5"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 19,
	AttackDamageMax = 41,
	AttackRange = 600,
	AttributeBaseStrength = 14,
	AttributeBaseAgility = 24,
	AttributeBaseIntelligence = 15,
	AttributeStrengthGain = 1.4,
	AttributeAgilityGain = 2.5,
	AttributeIntelligenceGain = 2,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
	AttackAnimationPoint = 0.6,
	VisionDaytimeRange=1800,
	VisionNighttimeRange=800,
	ProjectileModel = "particles/units/heroes/hero_huskar/huskar_base_attack.vpcf"
}

CustomNetTables:SetTableValue("fun_hero_stats", "kahmeka_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "kahmeka", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("kahmeka", tNewAbilities)


function KahmekaInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_kahmeka", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end