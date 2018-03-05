local tNewAbilities = {
	"siglos_disadvantage",
	"siglos_reflect",
	"siglos_disruption_aura",
	"generic_hidden",
	"generic_hidden",
	"siglos_mind_control",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_7",
	"special_bonus_unique_siglos_1",
	"special_bonus_cast_range_300",
	"special_bonus_unique_siglos_2",
	"special_bonus_unique_siglos_3",
	"special_bonus_unique_siglos_4"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 23,
	AttackDamageMax = 32,
	AttackRange = 600,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 16,
	AttributeBaseIntelligence = 23,
	AttributeStrenthGain = 1.8,
	AttributeAgilityGain = 1.5,
	AttributeIntelligenceGain = 2.9,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
}

CustomNetTables:SetTableValue("fun_hero_stats", "siglos_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "siglos", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("siglos", tNewAbilities)
function GameMode:SiglosOrderFilter(filterTable)
	if filterTable.order_type ~= DOTA_UNIT_ORDER_CAST_TARGET or not EntIndexToHScript(filterTable.units["0"]):HasModifier("modifier_siglos_disruption_aura_target") then return true end
	local hModifier = EntIndexToHScript(filterTable.units["0"]):FindModifierByName("modifier_siglos_disruption_aura_target")
	local iRadius = hModifier:GetAbility():GetSpecialValueFor("disruption_range")
	if hModifier:GetCaster():HasAbility("special_bonus_unique_siglos_1") then
		iRadius = iRadius+hModifier:GetCaster():FindAbilityByName("special_bonus_unique_siglos_1"):GetSpecialValueFor("value")
	end
	local hTarget = EntIndexToHScript(filterTable.entindex_target)
	local hAbility = EntIndexToHScript(filterTable.entindex_ability)
	local tTargets = FindUnitsInRadius(EntIndexToHScript(filterTable.units["0"]):GetTeam(), hTarget:GetOrigin(), nil, iRadius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	if #tTargets <= 1 then
		return true
	else
		local hDisruptedTarget = tTargets[RandomInt(1, #tTargets)]
		while hDisruptedTarget == hTarget do
			hDisruptedTarget = tTargets[RandomInt(1, #tTargets)]
		end
		filterTable.entindex_target = hDisruptedTarget:entindex()
		return true
	end
end

function SiglosInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_siglos", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	if not GameMode.bSiglosOrderFilterSet then
		GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'SiglosOrderFilter'), context)
		GameMode.bSiglosOrderFilterSet = true
	end
end