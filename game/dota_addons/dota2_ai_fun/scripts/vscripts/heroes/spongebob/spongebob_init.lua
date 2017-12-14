local tNewAbilities = {
	"spongebob_karate_chop",
	"spongebob_spongify",
	"spongebob_jellyfish_net",
	"generic_hidden",
	"generic_hidden",
	"spongebob_krabby_food",
	"hero_attribute_gain_manager",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_movement_speed_25",
	"special_bonus_cooldown_reduction_20",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_bastion_1"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackDamageMin = 26,
	AttackDamageMax = 38,
	AttributeBaseStrength = 10,
	AttributeBaseAgility = 30,
	AttributeBaseIntelligence = 10,
	AttributeStrenthGain = 1.3,
	AttributeAgilityGain = 3.8,
	AttributeIntelligenceGain = 1,
	AttackAnimationPoint = 0.3,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
}

function SpongeBobInit(hHero)		
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_spongebob", {})
--	if GameMode.bIsChinese then
		hHero:SetModel("models/heroes/bob/spongbob.vmdl")
		hHero:SetOriginalModel("models/heroes/bob/spongbob.vmdl")
		WearableManager:RemoveOriginalWearables(hHero)
--	end
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end