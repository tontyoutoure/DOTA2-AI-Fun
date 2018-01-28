local tNewAbilities = {
	"intimidator_glare_lua",
	"intimidator_grill_lua",
	"intimidator_physical_activity_lua",
	"generic_hidden",
	"generic_hidden",
	"intimidator_be_my_friend_lua",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_movement_speed_25",
	"special_bonus_intimidator_1",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_intimidator_2"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 22,
	AttackDamageMax = 28,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 24,
	AttributeBaseIntelligence = 16,
	AttributeStrenthGain = 2.2,
	AttributeAgilityGain = 2.5,
	AttributeIntelligenceGain = 1.9,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
	AttackAnimationPoint = 0.5,
}

CustomNetTables:SetTableValue("fun_hero_abilities", "intimidator", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "intimidator", tHeroBaseStats)


function IntimidatorInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_initimidator", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end