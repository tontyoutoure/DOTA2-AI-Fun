--|n|n|c000042ffStrength|r - 14 + 1.85 |n|c00ff0303Agility|r - 20 + 2.5|n|c000042ffIntelligence|r - 19 + 1.85|n|nLearns Purge, Chain Lightning, Split Shot, and |c00ff8000Mana Shield|r.|n|nAttack range of 600.|nMovement speed of 300.
--castpt	castbsw
--0.4	0.5

LinkLuaModifier('modifier_old_gorgon_ability_manager', "heroes/old_gorgon/old_gorgon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


local tNewAbilities = {
	"old_gorgon_purge",
	"old_gorgon_chain_lightning",
	"old_gorgon_split_shot",
	"generic_hidden",
	"generic_hidden",
	"old_gorgon_mana_shield",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_old_gorgon_1",
	"special_bonus_attack_damage_40",
	"special_bonus_mp_800",
	"special_bonus_unique_old_gorgon_3",
	"special_bonus_unique_old_gorgon_2",
	"special_bonus_unique_old_gorgon_splitshot_uam"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 19,
	AttackDamageMax = 25,
	AttackRange = 600,
	AttributeBaseStrength = 14,
	AttributeStrengthGain = 2.15,
	AttributeBaseAgility = 20,
	AttributeAgilityGain = 2.5,
	AttributeBaseIntelligence =19,
	AttributeIntelligenceGain = 1.85,
	ArmorPhysical = -1,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
	AttackAnimationPoint = 0.46,
}

CustomNetTables:SetTableValue("fun_hero_stats", "old_gorgon_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_gorgon", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("old_gorgon", tNewAbilities)

function OldGorgonInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_gorgon", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end
