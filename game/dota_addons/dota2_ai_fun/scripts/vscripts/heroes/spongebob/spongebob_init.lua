local tNewAbilities = {
	"spongebob_karate_chop",
	"spongebob_spongify",
	"spongebob_jellyfish_net",
	"generic_hidden",
	"generic_hidden",
	"spongebob_krabby_food",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_magic_resistance_20",
	"special_bonus_unique_spongebob_1",
	"special_bonus_unique_spongebob_2",
	"special_bonus_hp_600",
	"special_bonus_unique_spongebob_3",
	"special_bonus_unique_spongebob_4"
}

local tHeroBaseStats = {
	MovementSpeed = 305,
	AttackRate = 1.7,
	AttackDamageMin = 26,
	AttackDamageMax = 38,
	AttributeBaseStrength = 10,
	AttributeBaseAgility = 30,
	AttributeBaseIntelligence = 10,
	AttributeStrengthGain = 1.3,
	AttributeAgilityGain = 3.8,
	AttributeIntelligenceGain = 1,
	AttackAnimationPoint = 0.6,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
}

CustomNetTables:SetTableValue("fun_hero_stats", "spongebob_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "spongebob", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("spongebob", tNewAbilities)
function SpongeBobInit(hHero)		
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_spongebob", {})
	--[[
	if GameMode.bIsChinese then
		hHero:SetModel("models/heroes/bob/spongbob.vmdl")
		hHero:SetOriginalModel("models/heroes/bob/spongbob.vmdl")
		WearableManager:RemoveOriginalWearables(hHero)
	end
	--]]
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	

end