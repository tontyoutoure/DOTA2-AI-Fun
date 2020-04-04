function GameMode:ElDoradoDamageFilter(filterTable)
	if not filterTable.entindex_victim_const or not filterTable.entindex_attacker_const then return true end
	local hVictim = EntIndexToHScript(filterTable.entindex_victim_const)
	local hAttacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	if hAttacker:HasModifier('modifier_el_dorado_artificial_frog_demolish') and hVictim:IsBuilding() then 
		filterTable.damage = filterTable.damage*(1+hAttacker:FindAbilityByName('el_dorado_artificial_frog_demolish'):GetSpecialValueFor("bonus_building_damage")/100)
	end
	return true
end

local tNewAbilities = {
	"el_dorado_item_forge",
	"el_dorado_artificial_frog",
	"el_dorado_change_item_slot_0_lua",
	"el_dorado_refine_weapons",
	"generic_hidden",
	"el_dorado_piracy_method",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_intelligence_20",
	"special_bonus_movement_speed_35",
	"special_bonus_el_dorado_1",
	"special_bonus_el_dorado_3",
	"special_bonus_el_dorado_2",
	"special_bonus_cast_range_400"
}

local tHeroBaseStats = {
	MovementSpeed = 315,
	AttackRate = 1.6,
	AttackDamageMin = 24,
	AttackDamageMax = 32,
	AttackRange = 600,
	DisableWearables = true,
	AttributeBaseStrength = 21,
	AttributeBaseAgility = 18,
	AttributeBaseIntelligence = 23,
	AttributeStrengthGain = 2.1,
	AttributeAgilityGain = 2.1,
	AttributeIntelligenceGain = 2.5,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.433,
	Model = "models/courier/frog/frog.vmdl",
	ProjectileModel = "particles/econ/items/puck/puck_alliance_set/puck_base_attack_aproset.vpcf",
}
CustomNetTables:SetTableValue("fun_hero_stats", "el_dorado_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "el_dorado", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("el_dorado", tNewAbilities)

function ElDoradoInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_el_dorado", {})
	if not GameMode.bEledoradoDemolishFilterSet then
		GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, 'ElDoradoDamageFilter'), context)
		GameMode.bEledoradoDemolishFilterSet = true
	end
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	
end