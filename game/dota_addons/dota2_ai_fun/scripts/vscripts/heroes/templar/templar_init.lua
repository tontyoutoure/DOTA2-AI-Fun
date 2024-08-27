local tNewAbilities = {
	"templar_drain",
	"templar_chicken",
	"templar_faith",
	"generic_hidden",
	"generic_hidden",
	"templar_vengeance",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_templar_1",
	"special_bonus_unique_templar_2",
	"special_bonus_unique_templar_3",
	"special_bonus_attack_speed_250",
	"special_bonus_cleave_100",
	"special_bonus_unique_templar_4"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.6,
	AttackAnimationPoint = 0.433,
	AttackDamageMin = 28,
	AttackDamageMax = 31,
	AttributeBaseStrength = 18,
	AttributeBaseAgility = 13,
	AttributeBaseIntelligence = 24,
	AttributeStrengthGain = 2.3,
	AttributeAgilityGain = 1.3,
	AttributeIntelligenceGain = 3,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackCapabilities = DOTA_UNIT_CAP_MELEE_ATTACK
}

CustomNetTables:SetTableValue("fun_hero_stats", "templar_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "templar", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("templar", tNewAbilities)
function TemplarInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_templar", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end