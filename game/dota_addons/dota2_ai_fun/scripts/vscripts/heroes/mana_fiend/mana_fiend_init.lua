LinkLuaModifier("modifier_mana_fiend_color", "heroes/mana_fiend/mana_fiend_modifiers.lua", LUA_MODIFIER_MOTION_NONE);

local tNewAbilities = {
	"mana_fiend_equilibrium",
	"mana_field_mana_rift",
	"mana_fiend_osmose",
	"generic_hidden",
	"generic_hidden",
	"mana_fiend_abandon",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_mana_fiend_1",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_unique_mana_fiend_2",
	"special_bonus_unique_mana_fiend_3",
	"special_bonus_attack_range_400",
	"special_bonus_unique_mana_fiend_4"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 22,
	AttackDamageMax = 26,
	AttackRange = 600,
	AttributeBaseStrength = 18,
	AttributeBaseAgility = 15,
	AttributeBaseIntelligence = 22,
	AttributeStrengthGain = 1.7,
	AttributeAgilityGain = 1.4,
	AttributeIntelligenceGain = 2.8,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.33,
}
CustomNetTables:SetTableValue("fun_hero_stats", "mana_fiend_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "mana_fiend", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("mana_fiend", tNewAbilities)

function ManaFiendInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_mana_fiend", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	hHero:AddNewModifier(hHero, nil, 'modifier_mana_fiend_color',nil)
	hHero:SetRangedProjectileName('particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_arcane_bolt.vpcf')
end