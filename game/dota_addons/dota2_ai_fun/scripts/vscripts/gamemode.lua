DOTA2_AI_FUN_VERSION = "3.2"
DOTA2_AI_FUN_DEBUG_SPEW = false 

if GameMode == nil then
	GameMode = class({})
end

require('libraries/timers')
require('libraries/PseudoRNG')
require('libraries/notifications')
require('libraries/Playertables')
require('libraries/lua_console')
require('libraries/attachments')
require('libraries/json')
if IsInToolsMode() then
	require('libraries/modmaker')
end
require('internal/util')
require('settings')
require('hero_initiation')
require('events')
require('libraries/wearable_manager')
require('libraries/animations')
require('modifier_attribute_indicators')
require('donation')
require('lottery')
require('server')
 
function GameMode:InitGameMode()
	
	GameMode:InitGameOptions()
	GameMode:InitEvents()	
--	Tutorial:StartTutorialMode()
	GameMode:LinkLuaModifiers()
	print("DOTA 2 AI Fun initialized!")
end


function GameMode:LinkLuaModifiers()
	LinkLuaModifier("modifier_item_fun_sprint_shoes_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_magic_hammer_mana_break", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_void_demon_quake_slow_lua", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_void_demon_quake_aura_lua", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_sniper_assassinate_thinker", "heroes/sniper/sniper_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_global_hero_respawn_time", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imbalanced_economizer", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bot_attack_tower_pick_rune", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_tower_power", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_tower_endure", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bot_get_fun_items", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bot_use_items", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_point_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_time_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_range_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_projectile_speed_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_turn_rate_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_axe_thinker", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_backdoor_healing", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_ban_fun_items", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)	
	LinkLuaModifier("modifier_item_assemble_fix", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_plant_tree", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_fast_courier", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_test", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_mutation_killstreak_power", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_ability_layout_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_attack_speed_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_ti9_attack_modifier", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_dynamic_exp_gold", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_anti_diving", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_bot_protection", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
	LinkLuaModifier("modifier_lottery_manager", "lottery.lua", LUA_MODIFIER_MOTION_NONE);
	
	
	
	
end

function GameMode:TestFilter(filterTable)
			PrintTable(filterTable)
	return true
end

function GameMode:InitGameOptions()
--	GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)	
	GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
	GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
	GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME )
	GameRules:SetPostGameTime( POST_GAME_TIME )
	if IsInToolsMode() then 
--		GameRules:SetPreGameTime( 0 )
	end
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, RADIANT_MAX_PLAYER_COUNT)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, DIRE_MAX_PLAYER_COUNT)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetStrategyTime(STRATEGY_TIME)
	GameRules:SetShowcaseTime(0)
    GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(true)
--	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'TestFilter'), self)
--	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'LotteryExecuteOrderFilter'), self)
end


function GameMode:PreGameOptions()
	self.iDesiredRadiant = self.iDesiredRadiant or RADIANT_PLAYER_COUNT
	self.iDesiredDire = self.iDesiredDire or DIRE_PLAYER_COUNT	
	self.fRadiantGoldMultiplier = self.fRadiantGoldMultiplier or RADIANT_GOLD_MULTIPLIER
	self.fRadiantXPMultiplier = self.fRadiantXPMultiplier or RADIANT_XP_MULTIPLIER
	self.fDireXPMultiplier = self.fDireXPMultiplier or DIRE_XP_MULTIPLIER
	self.fDireGoldMultiplier = self.fDireGoldMultiplier or DIRE_GOLD_MULTIPLIER	
	self.iGoldPerTick = self.iGoldPerTick or GOLD_PER_TICK
	self.iGoldTickTime = self.iGoldTickTime or GOLD_TICK_TIME
	self.iRespawnTimePercentage = self.iRespawnTimePercentage or RESPAWN_TIME_PERCENTAGE
	self.iMaxLevel = self.iMaxLevel or MAX_LEVEL
	self.iImbalancedEconomizer = self.iImbalancedEconomizer or 0
	self.iUniversalShop = self.iUniversalShop or 0
	self.iBotHasFunItem = self.iBotHasFunItem or 1
	self.iFastCourier = self.iFastCourier or 1
	self.iBanFunItems = self.iBanFunItems or 0
	self.iEnableLottery = self.iEnableLottery or 1
	self.fGameStartTime = 0
	GameRules:SetGoldPerTick(self.iGoldPerTick)
	GameRules:SetGoldTickTime(self.iGoldTickTime)
    GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( GameMode, "FilterGold" ), self )	
    GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( GameMode, "FilterXP" ), self )
    GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( GameMode, "FilterInventory" ), self )	
	
--	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetUseDefaultDOTARuneSpawnLogic(true)
--	GameRules:GetGameModeEntity():SetMaximumAttackSpeed(2000)
--	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled(true)
	--[[
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, true )
	GameRules:GetGameModeEntity():SetRuneSpawnFilter( Dynamic_Wrap( GameMode, "FilterRune" ), self )
	--]]
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( GameMode, "FilterBounty" ), self )
--	if IsInToolsMode() or self.iUniversalShop == 1 then		
	if self.iUniversalShop == 1 then		
		GameRules:SetUseUniversalShopMode(true)
	end
	if self.iMaxLevel ~= 30 then
		local tLevelRequire = {
							0,
							230,
							600,
							1080,
							1660,
							2260,
							2980,
							3730,
							4510,
							5320,
							6160,
							7030,
							7930,
							9155,
							10405,
							11680,
							12980,
							14305,
							15805,
							17395,
							18995,
							20845,
							22945,
							25295,
							27895,
							31395,
							35895,
							41395,
							47895,
							55395,

		} -- value in 7.23
		local iRequireLevel = tLevelRequire[25]
		for i = 26, self.iMaxLevel-5 do
			iRequireLevel = iRequireLevel+i*1000
			table.insert(tLevelRequire, iRequireLevel)
		end
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels ( true )
		GameRules:SetUseCustomHeroXPValues( true )
		print(self.iMaxLevel)
		GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(self.iMaxLevel-5) 		
		GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(tLevelRequire)
	end
	self.PreGameOptionsSet = true
end

function GameMode:InitEvents()	
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameStateChanged' ), self )
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)	
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, '_OnNPCSpawned'), self)
	

	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnDOTAItemPurchased'), self)
	ListenToGameEvent('item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickUp'), self)
	ListenToGameEvent('dota_inventory_item_changed', Dynamic_Wrap(GameMode, 'LotteryOnItemGifted'), self)	
	

	ListenToGameEvent('dota_player_update_hero_selection',  Dynamic_Wrap(GameMode, 'OnPlayerUpdateSelectUnit1'), self)
	ListenToGameEvent('dota_player_update_selected_unit',  Dynamic_Wrap(GameMode, 'OnPlayerUpdateSelectUnit2'), self)
	ListenToGameEvent('player_connect_full',  Dynamic_Wrap(GameMode, 'OnPlayerConnectFull'), self)
	--JS events
	
	CustomGameEventManager:RegisterListener("confirm_game_options", function (eventSourceIndex, args) return GameMode:OnConfirmGameOptions(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("loading_individual_game_option_vote", function (eventSourceIndex, args) return GameMode:OnGetLoadingIndividualGameOptionVotes(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("loading_game_options", function (eventSourceIndex, args) return GameMode:OnGetLoadingGameOptions(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("loading_set_options", function (eventSourceIndex, args) return GameMode:OnGetLoadingSetOptions(eventSourceIndex, args) end)
	
	CustomGameEventManager:RegisterListener("fun_hero_selection", function (eventSourceIndex, args) return GameMode:OnFunHeroSelected(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("fun_hero_unselection", function (eventSourceIndex, args) return GameMode:OnFunHeroUnselected(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("enable_wearables_change", function (eventSourceIndex, args) return GameMode:OnEnableWearablesChange(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("disable_wearables_change", function (eventSourceIndex, args) return GameMode:OnDisableWearablesChange(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("net_table_change_value", function (eventSourceIndex, args) return GameMode:OnNetTableValueChanged(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("vote_make_choice", function (eventSourceIndex, args) return GameMode:OnVoteMakeChoice(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("vote_confirm", function (eventSourceIndex, args) return GameMode:OnVoteConfirm(eventSourceIndex, args) end)
end

--[==[
function GameMode:AddBotPlayers()
	self.iDesiredRadiant = self.iDesiredRadiant or 10
	self.iDesiredDire = self.iDesiredDire or 10
--	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, self.desiredRadiant)
--	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, self.desiredDire)
	print("tring to add bots!")
	
	require('herolist')
	self.tHeroList = self.tHeroListTest 
	local iRadiantPlayerNum = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	local iDirePlayerNum = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
	math.randomseed(math.floor(Time()*1000000000))
	print("original number is", iDirePlayerNum, iRadiantPlayerNum)
	   if IsInToolsMode() then
        self.brokenBots = {
            npc_dota_hero_tidehunter = true,
            npc_dota_hero_razor = true,

            -- Stoped working around Feburary, 24, 2017
            npc_dota_hero_skywrath_mage = true,
            npc_dota_hero_nevermore = true,
            npc_dota_hero_pudge = true,
            npc_dota_hero_phantom_assassin = true,

            --[[npc_dota_hero_sven = true,
            npc_dota_hero_skeleton_king = true,
            npc_dota_hero_lina = true,
            npc_dota_hero_luna = true,
            npc_dota_hero_dragon_knight = true,
            npc_dota_hero_bloodseeker = true,
            npc_dota_hero_lion = true,
            npc_dota_hero_tiny = true,
            npc_dota_hero_oracle = true,]]
        }
    else
        self.brokenBots = {
            npc_dota_hero_tidehunter = true,
            npc_dota_hero_razor = true,
            npc_dota_hero_pudge = true,

            -- Stoped working around Feburary, 24, 2017
            --[[npc_dota_hero_sven = true,
            npc_dota_hero_skeleton_king = true,
            npc_dota_hero_lina = true,
            npc_dota_hero_luna = true,
            npc_dota_hero_dragon_knight = true,
            npc_dota_hero_bloodseeker = true,
            npc_dota_hero_lion = true,
            npc_dota_hero_tiny = true,
            npc_dota_hero_oracle = true,]]
        }

    end
	while iRadiantPlayerNum < self.iDesiredRadiant do
		local iPlayerID = iDirePlayerNum+iRadiantPlayerNum
		local sHeroName = self:GetRandomHeroName()
		self.tAI = self.tAI or {}
		self.tAI[#self.tAI] = iPlayerID
		while self.brokenBots[sHeroName] do
			sHeroName = self:GetRandomHeroName()
		end
		Tutorial:AddBot(sHeroName, '', '', true)	
--		PlayerResource:SetCustomTeamAssignment(iPlayerID, DOTA_TEAM_GOODGUYS)		
		iRadiantPlayerNum = iRadiantPlayerNum+1
	end
	
	while iDirePlayerNum < self.iDesiredDire do
		local iPlayerID = iRadiantPlayerNum+iDirePlayerNum
		local sHeroName = self:GetRandomHeroName()
		while self.brokenBots[sHeroName] do
			sHeroName = self:GetRandomHeroName()
		end
		Tutorial:AddBot(sHeroName, '', '', false)
		self.tAI[#self.tAI] = iPlayerID
--		PlayerResource:SetCustomTeamAssignment(iPlayerID, DOTA_TEAM_BADGUYS)		
		iDirePlayerNum = iDirePlayerNum+1
	end
	

end


-- give a total random hero from the list, and remove it from the list

function GameMode:GetRandomHeroName()
	local iHeroIndex = math.random(#self.tHeroList)
	local sHeroName = self.tHeroList[iHeroIndex]
	table.remove(self.tHeroList, iHeroIndex)
	return sHeroName
end
]==]--

function GameMode:FilterBounty(tBountyFilter)
	if PlayerResource:GetTeam(tBountyFilter.player_id_const) == DOTA_TEAM_GOODGUYS then
		tBountyFilter.gold_bounty = math.floor(tBountyFilter.gold_bounty*self.fRadiantGoldMultiplier)
		tBountyFilter.xp_bounty = math.floor(tBountyFilter.xp_bounty*self.fRadiantXPMultiplier)
	else
		tBountyFilter.gold_bounty = math.floor(tBountyFilter.gold_bounty*self.fDireGoldMultiplier)
		tBountyFilter.xp_bounty = math.floor(tBountyFilter.xp_bounty*self.fDireXPMultiplier)
	end
--	PrintTable(tBountyFilter)
	return true
end

function GameMode:FilterGold(tGoldFilter)
	local iGold = tGoldFilter["gold"]
	local iPlayerID = tGoldFilter["player_id_const"]
	local iReason = tGoldFilter["reason_const"]
	local bReliable = tGoldFilter["reliable"] == 1
	
	if PlayerResource:GetTeam(iPlayerID) == DOTA_TEAM_GOODGUYS then
		tGoldFilter["gold"] = math.floor(iGold*self.fRadiantGoldMultiplier)
	else
		tGoldFilter["gold"] = math.floor(iGold*self.fDireGoldMultiplier)
	end
	
	return true
end

function GameMode:FilterInventory(tInventoryFilter)
	return true
end

function GameMode:FilterXP(tXPFilter)
	local iXP = tXPFilter["experience"]
	local iPlayerID = tXPFilter["player_id_const"]
	local iReason = tXPFilter["reason_const"]
	if PlayerResource:GetTeam(iPlayerID) == DOTA_TEAM_GOODGUYS then
		tXPFilter["experience"] = math.floor(iXP*self.fRadiantXPMultiplier)
	else
		tXPFilter["experience"] = math.floor(iXP*self.fDireXPMultiplier)
	end
	return true
end

local bFirstRuneShouldSpawned = false
local bFirstRuneActuallySpawned = false
local tPossibleRunes = {
	DOTA_RUNE_ILLUSION,
	DOTA_RUNE_REGENERATION,
	DOTA_RUNE_HASTE,
	DOTA_RUNE_INVISIBILITY,
	DOTA_RUNE_DOUBLEDAMAGE,
	DOTA_RUNE_ARCANE
}

local tLastRunes = {}

function GameMode:FilterRune(tRuneFilter)
	if true then return true end
	if GameRules:GetGameTime() > 2395+self.fGameStartTime then
		tRuneFilter.rune_type = tPossibleRunes[RandomInt(1, 6)]
		while tRuneFilter.rune_type == tLastRunes[tRuneFilter.spawner_entindex_const] do
			tRuneFilter.rune_type = tPossibleRunes[RandomInt(1, 6)]
		end
		tLastRunes[tRuneFilter.spawner_entindex_const] = tRuneFilter.rune_type
		return true
	else
		if bFirstRuneShouldSpawned then
			if bFirstRuneActuallySpawned then
				tLastRunes[tRuneFilter.spawner_entindex_const] = nil
				bFirstRuneShouldSpawned = false
				return false
			else
				tRuneFilter.rune_type = tPossibleRunes[RandomInt(1, 6)]
				while tRuneFilter.rune_type == tLastRunes[tRuneFilter.spawner_entindex_const] do
					tRuneFilter.rune_type = tPossibleRunes[RandomInt(1, 6)]
				end
				tLastRunes[tRuneFilter.spawner_entindex_const] = tRuneFilter.rune_type
				bFirstRuneShouldSpawned = false
				return true
			end
		else
			if RandomInt(0,1) > 0 then
				bFirstRuneActuallySpawned = true
				bFirstRuneShouldSpawned = true
				tRuneFilter.rune_type = tPossibleRunes[RandomInt(1, 6)]
				while tRuneFilter.rune_type == tLastRunes[tRuneFilter.spawner_entindex_const] do
					tRuneFilter.rune_type = tPossibleRunes[RandomInt(1, 6)]
				end
				tLastRunes[tRuneFilter.spawner_entindex_const] = tRuneFilter.rune_type
				return true
			else
				bFirstRuneActuallySpawned = false
				bFirstRuneShouldSpawned = true
				tLastRunes[tRuneFilter.spawner_entindex_const] = nil
				return false
			end
		end
	end
end
