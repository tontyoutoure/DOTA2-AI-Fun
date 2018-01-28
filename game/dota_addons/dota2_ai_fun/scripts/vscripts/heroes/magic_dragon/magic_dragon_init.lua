local tNewAbilities = {
	"magic_dragon_green_dragon_roar",
	"magic_dragon_green_dragon_hide",
	"magic_dragon_green_dragon_breath",
	"generic_hidden",
	"generic_hidden",
	"magic_dragon_dragon_magic_lua",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_magic_dragon_1"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackRange = 500,
	AttackDamageMin = 32,
	AttackDamageMax = 38,
	DisableWearables = true,
	AttributeBaseStrength = 23,
	AttributeBaseAgility = 16,
	AttributeBaseIntelligence = 18,
	AttributeStrenthGain = 3,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 1.8,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackAnimationPoint = 0.5,
	Model = "models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl",
	ModelScale = 1
}
CustomNetTables:SetTableValue("fun_hero_abilities", "magic_dragon", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "magic_dragon", tHeroBaseStats)

function MagicDragonInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_magic_dragon", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	hHero:SetBaseMagicalResistanceValue(25)
	if hHero:IsIllusion() then
		MagicDragonTransform[hHero:GetOwner():GetAssignedHero().iDragonForm](hHero)
	elseif not hHero.bSpawned then
		require("heroes/magic_dragon/magic_dragon_transform")	
		MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](hHero)		
	end
end