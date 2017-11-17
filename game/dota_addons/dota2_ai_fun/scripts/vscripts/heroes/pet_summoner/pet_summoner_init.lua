local tNewAbilities = {
	"pet_summoner_pets",
	"pet_summoner_fix_boo_boo",
	"pet_summoner_mittens_meow",
	"generic_hidden",
	"generic_hidden",
	"pet_summoner_critters",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_attack_speed_30",
	"special_bonus_pet_summoner_1",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_pet_summoner_2"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 19,
	AttackDamageMax = 27,
	AttackRange = 550,
	AttributeBaseStrength = 19,
	AttributeBaseAgility = 16,
	AttributeBaseIntelligence = 28,
	AttributeStrenthGain = 2,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 3.1,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
}


function PetSummonerInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_pet_summoner", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end