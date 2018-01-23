DOTA2_AI_FUN_VERSION = "1.2"
DOTA2_AI_FUN_DEBUG_SPEW = false 

if GameMode == nil then
	GameMode = class({})
end

require('libraries/timers')
require('libraries/notifications')
require('libraries/Playertables')
require('libraries/lua_console')
if IsInToolsMode() then
	require('libraries/modmaker')
	require('libraries/attachments')
end
require('internal/util')
require('settings')
require('hero_initiation')
require('events')
require('libraries/wearable_manager')
require('libraries/animations')
require('modifier_attribute_indicators')
require('donation')


-- Heroes need to be stripped
GameMode.tStripperList = {"npc_dota_hero_shadow_demon"}

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
	LinkLuaModifier("modifier_bot_use_fun_items", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_point_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_time_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_range_change", "global_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
end

function GameMode:InitGameOptions()
--	GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)	
	GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
	GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
	GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME )
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, RADIANT_PLAYER_COUNT)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, DIRE_PLAYER_COUNT)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)
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
	self.fGameStartTime = 0
	GameRules:SetGoldPerTick(self.iGoldPerTick)
	GameRules:SetGoldTickTime(self.iGoldTickTime)
    GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( GameMode, "FilterGold" ), self )	
    GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( GameMode, "FilterXP" ), self )
	GameRules:GetGameModeEntity():SetRuneSpawnFilter( Dynamic_Wrap( GameMode, "FilterRune" ), self )
	if IsInToolsMode() or self.iUniversalShop == 1 then		
		GameRules:SetUseUniversalShopMode(true)
	end
	if self.iMaxLevel ~= 25 then
		local tLevelRequire = {
			0,
			240,
			600,
			1080,
			1680,
			2300,
			2940,
			3600,
			4280,
			5080,
			5900,
			6740,
			7640,
			8865,
			10115,
			11390,
			12690,
			14015,
			15415,
			16905,
			18405,
			20155,
			22155,
			24405,
			26905
		}
		local iRequireLevel = tLevelRequire[25]
		for i = 26, self.iMaxLevel do
			iRequireLevel = iRequireLevel+i*100
			table.insert(tLevelRequire, iRequireLevel)
		end
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels ( true )
		GameRules:SetUseCustomHeroXPValues( true )
		GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(self.iMaxLevel) 		
		GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(tLevelRequire)
	end
	self.PreGameOptionsSet = true
end

function GameMode:InitEvents()	
--	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, '_OnConnectFull'), self)
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameStateChanged' ), self )
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)	
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, '_OnNPCSpawned'), self)
	
--	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_update_hero_selection',  Dynamic_Wrap(GameMode, 'OnPlayerUpdateSelectUnit1'), self)
	ListenToGameEvent('dota_player_update_selected_unit',  Dynamic_Wrap(GameMode, 'OnPlayerUpdateSelectUnit2'), self)
	--JS events
	CustomGameEventManager:RegisterListener("loading_set_options", function (eventSourceIndex, args) return GameMode:OnGetLoadingSetOptions(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("fun_hero_selection", function (eventSourceIndex, args) return GameMode:OnFunHeroSelected(eventSourceIndex, args) end)
	CustomGameEventManager:RegisterListener("fun_hero_unselection", function (eventSourceIndex, args) return GameMode:OnFunHeroUnselected(eventSourceIndex, args) end)
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


function GameMode:FilterGold(tGoldFilter)
	local iGold = tGoldFilter["gold"]
	local iPlayerID = tGoldFilter["player_id_const"]
	local iReason = tGoldFilter["reason_const"]
	local bReliable = tGoldFilter["reliable"] == 1
	
	if PlayerResource:GetTeam(iPlayerID) == DOTA_TEAM_GOODGUYS then
		tGoldFilter["gold"] = math.floor(iGold*self.fRadiantGoldMultiplier)
	else
		tGoldFilter["gold"] = math.floor(iGold*self.fDireGoldMultiplier)
--		print("Dire Gold", tGoldFilter["gold"], iGold)
	end
	
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
--		print("Dire XP", tXPFilter["experience"], iXP)
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