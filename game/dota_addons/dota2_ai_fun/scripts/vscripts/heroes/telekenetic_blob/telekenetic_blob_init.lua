local tNewAbilities = {
	"telekenetic_blob_throw",
	"telekenetic_blob_catapult",
	"telekenetic_blob_sling",
	"telekenetic_blob_mark_target",
	"generic_hidden",
	"telekenetic_blob_expel",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_hp_600",
	"special_bonus_movement_speed_50",
	"special_bonus_cast_range_400"
}

local tHeroBaseStats = {
	MovementSpeed = 290,
	AttackRate = 1.7,
	AttackDamageMin = 15,
	AttackDamageMax = 20,
	AttributeBaseStrength = 19,
	AttributeBaseAgility = 3,
	AttributeBaseIntelligence = 33,
	AttributeStrengthGain = 2.6,
	AttributeAgilityGain = 0.2,
	AttributeIntelligenceGain = 3.5,
	ArmorPhysical = 4,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
--	AttackCapabilities = DOTA_UNIT_CAP_NO_ATTACK
}
if IsServer() then
	CustomNetTables:SetTableValue("fun_hero_stats", "telekenetic_blob_abilities", tNewAbilities)
	CustomNetTables:SetTableValue("fun_hero_stats", "telekenetic_blob", tHeroBaseStats)
	GameMode:FunHeroScepterUpgradeInfo("telekenetic_blob", tNewAbilities)
end

function GameMode:TelekeneticBlobOrderFilter(filterTable)
--	PrintTable(filterTable)
	if filterTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or filterTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then 
		for k, v in pairs(filterTable.units) do
			if EntIndexToHScript(v):HasAbility('telekenetic_blob_mark_target') then
				ExecuteOrderFromTable({
					UnitIndex = v,
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = filterTable.entindex_target,
					AbilityIndex = EntIndexToHScript(v):FindAbilityByName('telekenetic_blob_mark_target'):entindex(),
					position = nil
				})
				filterTable.units[k] = nil
			end
		end
	end
	return true
end

LinkLuaModifier('modifier_telekenetic_blob', 'heroes/telekenetic_blob/telekenetic_blob_util.lua', LUA_MODIFIER_MOTION_NONE)

function TelekeneticBlobInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_telekenetic_blob", {})	
	hHero:AddNewModifier(hHero, nil, "modifier_telekenetic_blob", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	
	if not GameMode.bTelekeneticBlobOrderFilterSet then
		GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'TelekeneticBlobOrderFilter'), context)
		GameMode.bTelekeneticBlobOrderFilterSet = true
	end
	hHero:FindAbilityByName("telekenetic_blob_mark_target"):SetLevel(1)
end