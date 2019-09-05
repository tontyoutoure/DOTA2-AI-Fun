--Electric Rave, Barrier, Overload, and |c00ff8000Lightning Grapple|r.

local tNewAbilities = {
	"old_storm_spirit_electric_rave",
	"old_storm_spirit_barrier",
	"old_storm_spirit_overload",
	"generic_hidden",
	"generic_hidden",
	"old_storm_spirit_lightning_grapple",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_old_storm_spirit_1",
	"special_bonus_unique_old_storm_spirit_2",
	"special_bonus_unique_old_storm_spirit_3",
	"special_bonus_unique_old_storm_spirit_4",
	"special_bonus_unique_old_storm_spirit_5",
	"special_bonus_unique_old_storm_spirit_6"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 22,
	AttackDamageMax = 32,
	AttackRange = 600,
	AttributeBaseStrength = 22,
	AttributeStrengthGain = 2.8,
	AttributeBaseAgility = 17,
	AttributeAgilityGain = 1.5,
	AttributeBaseIntelligence = 23,
	AttributeIntelligenceGain = 2.6,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.5,
}

CustomNetTables:SetTableValue("fun_hero_stats", "old_storm_spirit_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_storm_spirit", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("old_storm_spirit", tNewAbilities)

function OldStormSpiritInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_storm_spirit", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end
