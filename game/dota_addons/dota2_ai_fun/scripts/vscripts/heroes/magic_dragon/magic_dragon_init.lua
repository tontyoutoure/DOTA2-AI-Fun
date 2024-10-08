local tNewAbilities = {
	"magic_dragon_green_dragon_roar",
	"magic_dragon_green_dragon_hide",
	"magic_dragon_green_dragon_breath",
	"generic_hidden",
	"generic_hidden",
	"magic_dragon_dragon_magic_lua",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_unique_magic_dragon_1"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackRange = 500,
	AttackDamageMin = 32,
	AttackDamageMax = 38,
	DisableWearables = true,
	AttributeBaseStrength = 23,
	AttributeBaseAgility = 16,
	AttributeBaseIntelligence = 18,
	AttributeStrengthGain = 3,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 1.8,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackAnimationPoint = 0.17,
	Model = "models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl",
	ModelScale = 0.6,
}
CustomNetTables:SetTableValue("fun_hero_stats", "magic_dragon_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "magic_dragon", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("magic_dragon", tNewAbilities)

function MagicDragonInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_magic_dragon", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	hHero:SetBaseMagicalResistanceValue(25)
	if hHero:IsIllusion()  then -- for siglos
		MagicDragonTransform[hHero:GetPlayerOwner():GetAssignedHero().iDragonForm](hHero)
	elseif hHero.hFormToGo then
		require("heroes/magic_dragon/magic_dragon_transform")	
		MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](hHero)		
		MagicDragonTransform[hHero.hFormToGo.iDragonForm](hHero)		
	elseif not hHero.bSpawned then
		require("heroes/magic_dragon/magic_dragon_transform")	
		MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](hHero)		
	end
end