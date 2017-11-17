local tNewAbilities = {
	"fluid_engineer_brainstorm_str_lua",
	"fluid_engineer_brainstorm_agi_lua",
	"fluid_engineer_brainstorm_int_lua",
	"fluid_engineer_malicious_tampering_lua",
	"fluid_engineer_salad_lunch_lua",
	"fluid_engineer_bowel_hydraulics_lua",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_spell_amplify_15",
	"special_bonus_hp_600",
	"special_bonus_fluid_engineer_1",
	"special_bonus_fluid_engineer_2",
	"special_bonus_cast_range_400"
}

local tHeroBaseStats = {
	MovementSpeed = 290,
	AttackRate = 1.7,
	AttackDamageMin = 27,
	AttackDamageMax = 36,
	AttributeBaseStrength = 13,
	AttributeBaseAgility = 12,
	AttributeBaseIntelligence = 30,
	AttributeStrenthGain = 2,
	AttributeAgilityGain = 1.6,
	AttributeIntelligenceGain = 3,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.4,
}


function FluidEngineerInit (hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_fluid_engineer", {}) 
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	 
end