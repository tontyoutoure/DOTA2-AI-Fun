local tNewAbilities = {
	"old_stealth_assassin_permanent_invisibility",
	"old_stealth_assassin_blink",
	"old_stealth_assassin_critical_strike",
	"generic_hidden",
	"generic_hidden",
	"old_stealth_assassin_death_ward",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_old_stealth_assassin_1",
	"special_bonus_unique_old_stealth_assassin_2",
	"special_bonus_unique_old_stealth_assassin_3",
	"special_bonus_unique_old_stealth_assassin_4",
	"special_bonus_unique_old_stealth_assassin_5",
	"special_bonus_unique_old_stealth_assassin_6"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackRate = 1.7,
	AttackDamageMin = 24,
	AttackDamageMax = 28,
	AttackRange = 150,
	AttributeBaseStrength = 17,
	AttributeStrengthGain = 2.3,
	AttributeBaseAgility = 22,
	AttributeAgilityGain = 2.9,
	AttributeBaseIntelligence = 14,
	AttributeIntelligenceGain = 1.3,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
	AttackAnimationPoint = 0.433,-- cast point 0.5
}

CustomNetTables:SetTableValue("fun_hero_stats", "old_stealth_assassin_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_stealth_assassin", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("old_stealth_assassin", tNewAbilities)


function GameMode:OldStealthAssassinOrderFilter(filterTable)
	local hTarget = EntIndexToHScript(filterTable.entindex_target)
	if filterTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and not ( hTarget.IsHero and hTarget:IsHero() ) then
		for k, v in pairs(filterTable.units) do
			if EntIndexToHScript(v):HasModifier("modifier_old_stealth_assassin_death_ward") then
				filterTable.units[k] = nil
			end
		end
	end
	return true
end

function OldStealthAssassinInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_stealth_assassin", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	if not GameMode.bOldStealthAssassinOrderFilterSet then
		GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'OldStealthAssassinOrderFilter'), context)
		GameMode.bOldStealthAssassinOrderFilterSet = true
	end
end