local tNewAbilities = {
	"old_holy_knight_purge",
	"old_holy_knight_holy_light",
	"old_holy_knight_critical_strike",
	"generic_hidden",
	"generic_hidden",
	"old_holy_knight_holy_persuation",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_old_holy_knight_0",
	"special_bonus_unique_old_holy_knight_1",
	"special_bonus_attack_range_250",
	"special_bonus_unique_old_holy_knight_2",
	"special_bonus_unique_old_holy_knight_3",
	"special_bonus_unique_old_holy_knight_4"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 22,
	AttackDamageMax = 29,
	AttackRange = 550,
	AttributeBaseStrength = 20,
	AttributeStrengthGain = 1.8,
	AttributeBaseAgility = 15,
	AttributeAgilityGain = 2.05,
	AttributeBaseIntelligence = 21,
	AttributeIntelligenceGain = 2.65,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.5,
}

CustomNetTables:SetTableValue("fun_hero_stats", "old_holy_knight_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_holy_knight", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("old_holy_knight", tNewAbilities)

function OldHolyKnightInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_holy_knight", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end
