local tNewAbilities = {
	"bastion_power_flux",
	"bastion_speed_flux",
	"bastion_mind_flux",
	"bastion_transference_str",
	"bastion_transference_agi",
	"bastion_transference_int",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_movement_speed_25",
	"special_bonus_cooldown_reduction_20",
	"special_bonus_hp_600",
	"special_bonus_attack_range_400",
	"special_bonus_bastion_1"
}


local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 20,
	AttackDamageMax = 23,
	AttributeBaseStrength = 17,
	AttributeBaseAgility = 17,
	AttributeBaseIntelligence = 17,
	AttributeStrengthGain = 2.3,
	AttributeAgilityGain = 2.3,
	AttributeIntelligenceGain = 2.3,
	AttackAnimationPoint = 0.7,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	ProjectileModel = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf"
}

CustomNetTables:SetTableValue("fun_hero_stats", "bastion_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "bastion", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("bastion", tNewAbilities)
function BastionInit(hHero)	
	WearableManager:RemoveOriginalWearables(hHero)
	hHero:SetModel("models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl")
	hHero:SetOriginalModel("models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl")
	hHero:SetModelScale(1)
	
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_bastion", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
end