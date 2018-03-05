local tNewAbilities = {
	"persuasive_lagmonster_lua",
	"persuasive_kill_steal",
	"persuasive_swindle_lua",
	"persuasive_raise_lua",
	"persuasive_change_item_slot_0_lua",
	"persuasive_high_stakes",
	"persuasive_empty_for_reflect",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_attack_speed_30",
	"special_bonus_persuasive_1",
	"special_bonus_persuasive_2",
	"special_bonus_hp_600",
	"special_bonus_persuasive_3",
	"special_bonus_cast_range_400"
}

local tHeroBaseStats = {
	MovementSpeed = 290,
	AttackRate = 1.7,
	AttackDamageMin = 16,
	AttackDamageMax = 22,
	AttributeBaseStrength = 30,
	AttributeBaseAgility = 15,
	AttributeBaseIntelligence = 18,
	AttributeStrenthGain = 3.4,
	AttributeAgilityGain = 1.6,
	AttributeIntelligenceGain = 1.6,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackRange = 625,
	AttackAnimationPoint = 0.3
}
CustomNetTables:SetTableValue("fun_hero_stats", "persuasive_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "persuasive", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("persuasive", tNewAbilities)

function PersuasiveInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_persuasive", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end