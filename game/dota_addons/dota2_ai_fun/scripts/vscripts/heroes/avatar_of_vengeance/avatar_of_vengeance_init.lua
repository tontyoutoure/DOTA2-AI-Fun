local tNewAbilities = {
	"avatar_of_vengeance_phase",
	"avatar_of_vengeance_haunt",
	"avatar_of_vengeance_reality",
	"avatar_of_vengeance_dispersion",
	"avatar_of_vengeance_direct_vengeance",
	"avatar_of_vengeance_vengeance",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_avatar_of_vengeance_1",
	"special_bonus_unique_avatar_of_vengeance_2",
	"special_bonus_unique_avatar_of_vengeance_3",
	"special_bonus_hp_600",
	"special_bonus_unique_avatar_of_vengeance_4",
	"special_bonus_unique_avatar_of_vengeance_5",
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 18,
	AttackDamageMax = 22,
	AttributeBaseStrength = 17,
	AttributeBaseAgility = 26,
	AttributeBaseIntelligence = 16,
	AttributeStrenthGain = 2.3,
	AttributeAgilityGain = 2.6,
	AttributeIntelligenceGain = 1.3,
	AttackAnimationPoint = 0.3,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY
}
CustomNetTables:SetTableValue("fun_hero_stats", "avatar_of_vengeance_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "avatar_of_vengeance", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("avatar_of_vengeance", tNewAbilities)

function AvatarOfVengeanceInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_avatar_of_vengeance", {})		
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end