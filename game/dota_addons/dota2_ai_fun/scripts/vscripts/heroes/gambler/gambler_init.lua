local tNewAbilities = {
	"gambler_ante_up",
	"gambler_chip_stack",
	"gambler_lucky_stars",
	"generic_hidden",
	"generic_hidden",
	"gambler_all_in",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_cast_range_200",
	"special_bonus_unique_gambler_1",
	"special_bonus_unique_gambler_2",
	"special_bonus_unique_gambler_3",
	"special_bonus_unique_gambler_4",
	"special_bonus_unique_gambler_5"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackAnimationPoint = 0.6,
	AttackDamageMin = 22,
	AttackDamageMax = 28,
	AttackRange = 500,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 16,
	AttributeBaseIntelligence = 21,
	AttributeStrengthGain = 2.1,
	AttributeAgilityGain = 1.8,
	AttributeIntelligenceGain = 2.6,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	ProjectileModel="particles/gambler_base_attack.vpcf",
}

CustomNetTables:SetTableValue("fun_hero_stats", "gambler_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "gambler", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("gambler", tNewAbilities)

function GamblerInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_gambler", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end
