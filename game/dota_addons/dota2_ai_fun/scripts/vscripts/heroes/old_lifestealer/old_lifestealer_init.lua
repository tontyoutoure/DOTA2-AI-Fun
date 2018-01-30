local tNewAbilities = {
	"old_lifestealer_feast",
	"old_lifestealer_anabolic_frenzy",
	"old_lifestealer_poison_sting",
	"generic_hidden",
	"generic_hidden",
	"old_lifestealer_rage",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_attack_damage_30",
	"special_bonus_strength_12",
	"special_bonus_unique_old_lifestealer_1",
	"special_bonus_unique_old_lifestealer_2",
	"special_bonus_unique_old_lifestealer_3",
	"special_bonus_unique_old_lifestealer_4"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 24,
	AttackDamageMax = 34,
	AttackRange = 150,
	AttributeBaseStrength = 15,
	AttributeStrenthGain = 1.7,
	AttributeBaseAgility = 26,
	AttributeAgilityGain = 4.05,
	AttributeBaseIntelligence = 15,
	AttributeIntelligenceGain = 1.5,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackAnimationPoint = 0.3,
}

CustomNetTables:SetTableValue("fun_hero_abilities", "old_lifestealer", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_lifestealer", tHeroBaseStats)

function OldLifestealerInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_lifestealer", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end