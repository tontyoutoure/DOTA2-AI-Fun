local OLD_BUTCHER_CORPSE_DURATION = 15
local tNewAbilities = {
	"old_butcher_stitch",
	"old_butcher_carrion_beetle",
	"old_butcher_necrogenesis",
	"old_butcher_select_corpse",
	"old_butcher_drop_corpse",
	"old_butcher_carrion_flies",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_old_butcher_1",
	"special_bonus_unique_old_butcher_2",
	"special_bonus_unique_old_butcher_3",
	"special_bonus_unique_old_butcher_4",
	"special_bonus_unique_old_butcher_5",
	"special_bonus_unique_old_butcher_6"
}

local tHeroBaseStats = {
	AttackAnimationPoint = 0.5,
	AttackRate = 1.7,
	AttackDamageMin = 31,
	AttackDamageMax = 39,	
	MovementSpeed = 280,
	AttributeBaseStrength = 26,
	AttributeBaseAgility = 10,
	AttributeBaseIntelligence = 15,
	AttributeStrengthGain = 4.05,
	AttributeAgilityGain = 1,
	AttributeIntelligenceGain = 2.25,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
}


CustomNetTables:SetTableValue("fun_hero_stats", "old_butcher_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "old_butcher", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("old_butcher", tNewAbilities)
local function OldButcherSummonChecker(keys)
	if (EntIndexToHScript(keys.entindex):GetUnitName() == 'npc_dota_thinker') then return end
	EntIndexToHScript(keys.entindex):AddNewModifier(EntIndexToHScript(keys.entindex), nil, 'modifier_old_butcher_summon_check', {Duration = 0.1})
end
local function OldButcherCorpseManager(keys)
	local hUnit = EntIndexToHScript(keys.entindex_killed)	
	if hUnit:IsHero() or hUnit:IsAncient() or hUnit:IsBuilding() or hUnit:IsConsideredHero() or hUnit.bSummon or hUnit:HasModifier('modifier_kill') or hUnit:HasModifier('modifier_old_butcher_carrion_beetle') then return end
	local hThinker = CreateModifierThinker(hThinker,nil,'modifier_phased', {Duration = 15},  hUnit:GetOrigin(),DOTA_TEAM_NEUTRALS, false)
	hThinker.sCorpseUnitName = hUnit:GetUnitName()
	hThinker.iMaxHealth = hUnit:GetMaxHealth()
	hThinker.iBaseDamageMax = hUnit:GetBaseDamageMax()
	hThinker.iBaseDamageMin = hUnit:GetBaseDamageMin()
	hThinker.iArmor = hUnit:GetPhysicalArmorValue(false)
	hThinker.iMaximumGoldBounty = hUnit:GetMaximumGoldBounty()
	hThinker.iMinimumGoldBounty = hUnit:GetMinimumGoldBounty()
	hThinker.hOriginalUnit = hUnit
--	hThinker:SetModel('models/props_bones/bones_tintable_003.vmdl')
end

function OldButcherBurrowListener(eventSourceIndex, keys)
	for k, v in pairs(keys.tSelectedUnits) do
		if EntIndexToHScript(v):HasAbility('old_butcher_carrion_beetle_burrow') and v ~= keys.entindex then
			local hUnit = EntIndexToHScript(v)
			if keys.bBurrow > 0 then
				if not hUnit:FindAbilityByName('old_butcher_carrion_beetle_burrow'):IsHidden() and not hUnit:FindAbilityByName('old_butcher_carrion_beetle_burrow'):IsInAbilityPhase() then

					hUnit:CastAbilityNoTarget(hUnit:FindAbilityByName('old_butcher_carrion_beetle_burrow'), keys.iPlayerID)
				end
			else
				if not hUnit:FindAbilityByName('old_butcher_carrion_beetle_unburrow'):IsHidden() and not hUnit:FindAbilityByName('old_butcher_carrion_beetle_unburrow'):IsInAbilityPhase() then
					hUnit:CastAbilityNoTarget(hUnit:FindAbilityByName('old_butcher_carrion_beetle_unburrow'), keys.iPlayerID)
				end
			end
		end
	end
end
function OldButcherTalentManager(keys)
	if keys.abilityname == "special_bonus_unique_old_butcher_4" and PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero().tBeetles then
		for k, v in pairs(PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero().tBeetles) do
			local hAbility = v:AddAbility('old_butcher_carrion_beetle_burrow_attack')
			hAbility:SetLevel(1)
			if not v:HasModifier('modifier_old_butcher_carrion_beetle_burrow') then
				hAbility:SetHidden(true)
			end
		end
	end
	if keys.abilityname == "special_bonus_unique_old_butcher_3" and PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero().tFlies then
		for k, v in pairs(PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero().tFlies) do
			v:AddAbility('old_butcher_carrion_fly_errosion'):SetLevel(1)
		end
	end
	if keys.abilityname == "special_bonus_unique_old_butcher_6" then
		print('talent')
		local hCaster = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
		tUnits=FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetOrigin(), nil, 99999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k, v in pairs(tUnits) do
			if v:GetPlayerOwnerID() == keys.PlayerID and (v:HasModifier('modifier_old_butcher_carrion_fly_evade') or v:HasModifier('modifier_old_butcher_stitch') or v:HasModifier('modifier_old_butcher_carrion_beetle')) then
				v:AddNewModifier(hCaster, nil, "modifier_old_butcher_avatar", {})
			end
		end
	end
end

function OldButcherFlyToggleListener(eventSourceIndex, keys)
	for k, v in pairs(keys.tSelectedUnits) do
		if v ~= keys.entindex and EntIndexToHScript(v):GetUnitName() == 'npc_dota_old_butcher_carrion_fly' then
			if EntIndexToHScript(v):FindAbilityByName('old_butcher_carrion_flies'):GetAutoCastState() == (keys.bAutoCast == 1) then
				EntIndexToHScript(v):FindAbilityByName('old_butcher_carrion_flies'):ToggleAutoCast()
			end
		end
	end
end

function GameMode:OldButcherOrderFilter(filterTable)
-- PrintTable(filterTable)
	if filterTable.issuer_player_id_const<0 then return true end
	if filterTable.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO and EntIndexToHScript(filterTable.entindex_ability):GetName() == 'old_butcher_carrion_flies' and EntIndexToHScript(filterTable.units['0']):GetUnitName() == 'npc_dota_old_butcher_carrion_fly' then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(filterTable.issuer_player_id_const), "old_butcher_carrion_fly_toggle", {iEntIndex = filterTable.units['0'], bAutoCast = EntIndexToHScript(filterTable.entindex_ability):GetAutoCastState(), iPlayerID = filterTable.issuer_player_id_const} )
	end
	return true
end

function OldButcherInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_old_butcher", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	if not GameMode.bOldButcherInited then				
		LinkLuaModifier('modifier_old_butcher_summon_check', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
		ListenToGameEvent("entity_killed", OldButcherCorpseManager, nil)
		ListenToGameEvent("npc_spawned", OldButcherSummonChecker, nil)
		ListenToGameEvent( "dota_player_learned_ability", OldButcherTalentManager, nil )
		GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'OldButcherOrderFilter'), context)
		CustomGameEventManager:RegisterListener('old_butcher_selected_units_for_burrow', OldButcherBurrowListener)
		CustomGameEventManager:RegisterListener('old_butcher_selected_units_for_fly_toggle', OldButcherFlyToggleListener)
		GameMode.bOldButcherInited = true
	end
end