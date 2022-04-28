function GameMode:OnFunHeroSelected(eventSourceIndex, args)
	self.tFunHeroSelection = self.tFunHeroSelection or {}
	self.tFunHeroSelection[args.PlayerID] = args.hero_name
	local hPlayer = PlayerResource:GetPlayer(args.PlayerID)
	hPlayer.bIsPlayingFunHero = true
	if args.language == "schinese" then
		hPlayer.bIsChinese = true
	end
	CreateHeroForPlayer(args.hero_name, hPlayer):RemoveSelf()
	if args.random then
		hPlayer.bRandom = true
	end
	CustomNetTables:SetTableValue('fun_hero_stats', 'fun_hero_selection_player'..tostring(args.PlayerID), {hero = args.hero_name})
end

function GameMode:OnFunHeroUnselected(eventSourceIndex, args)
	self.tFunHeroSelection = self.tFunHeroSelection or {}
	self.tFunHeroSelection[args.PlayerID] = nil
	PlayerResource:GetPlayer(args.PlayerID).bIsPlayingFunHero = nil
	CustomNetTables:SetTableValue('fun_hero_stats', 'fun_hero_selection_player'..tostring(args.PlayerID), {})
end

function GameMode:OnEnableWearablesChange(eventSourceIndex, args)
	self.tWearablesChange = self.tWearablesChange or {}
	self.tWearablesChange[args.PlayerID]=true
	CustomNetTables:SetTableValue('fun_hero_stats', 'wearables_change_'..tostring(args.PlayerID), {bWearablesChange=true})
end

function GameMode:OnDisableWearablesChange(eventSourceIndex, args)
	self.tWearablesChange = self.tWearablesChange or {}
	self.tWearablesChange[args.PlayerID]=false
	CustomNetTables:SetTableValue('fun_hero_stats', 'wearables_change_'..tostring(args.PlayerID), {})
end

function GameMode:OnGameStateChanged( keys )
    local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if not self.PreGameOptionsSet then
			self:PreGameOptions()
		end
		self.tHumanPlayerList = {}
		if self.tFunHeroSelection then
			for k, v in pairs(self.tFunHeroSelection) do
				self.tHumanPlayerList[k] = true
			end
		end
	end
	
    if state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        local num = 0
		local iPlayerNumRadiant = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		local iPlayerNumDire = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
        local used_hero_name = "npc_dota_hero_luna"
       
        for i=0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayer(i) then
                
                -- Random heroes for people who have not picked
   --[[             if PlayerResource:HasSelectedHero(i) == false then
                    print("Randoming hero for:", i)
                    
                    local player = PlayerResource:GetPlayer(i)
                    player:MakeRandomHeroSelection()
                    
                    local hero_name = PlayerResource:GetSelectedHeroName(i)
                    
                    print("Randomed:", hero_name)
                end]]--
                if PlayerResource:GetSelectedHeroName(i) then 
					used_hero_name = PlayerResource:GetSelectedHeroName(i)
					self.tHumanPlayerList[i] = true
					num = num + 1
				end
            end
        end
        
        self.numPlayers = num
--		if IsInToolsMode() then return end

--		if IsInToolsMode() and GetMapName() ~= "dota" then return end
       GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
	   
        -- Eanble bots and fill empty slots
        if IsServer() == true then
            
			if self.iDesiredRadiant > iPlayerNumRadiant then	
				for i = 1, self.iDesiredRadiant - iPlayerNumRadiant do
					Tutorial:AddBot(used_hero_name, "", "", true)
				end
			end
			
			if self.iDesiredDire > iPlayerNumDire then
				for i = 1, self.iDesiredDire - iPlayerNumDire do
					Tutorial:AddBot(used_hero_name, "", "", false)
				end
            end
            GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
            --SendToServerConsole("dota_bot_set_difficulty 2")
            --SendToServerConsole("dota_bot_set_difficulty 2")
        end
    elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		Tutorial:StartTutorialMode()
		local tTowers = Entities:FindAllByClassname("npc_dota_tower")
		_DeepPrintTable(tTowers)
		local tBarracks = Entities:FindAllByClassname("npc_dota_barracks")
--		local tHealers = Entities:FindAllByClassname("npc_dota_healer")
		local tForts = Entities:FindAllByClassname("npc_dota_fort")
		local tFillers = Entities:FindAllByClassname("npc_dota_filler")

		self.tBackdoorBuildings = {}
		self.tBackdoorInBaseBuildings = {}
		local iTowerPower = self.iTowerPower or 1
		local iTowerEndure = self.iTowerEndure or 1
		for k, v in pairs(tTowers) do
			v:AddNewModifier(v, nil, "modifier_tower_power", {}):SetStackCount(iTowerPower)
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			--v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
		end
		for k, v in pairs(tBarracks) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			--v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
		end
		for k, v in pairs(tForts) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			--v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			end
		for k, v in pairs(tFillers) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			--v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			end
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self.fGameStartTime = GameRules:GetGameTime()
--      for i=0, DOTA_MAX_TEAM_PLAYERS do`
--          print(i)
--          if PlayerResource:IsFakeClient(i) then
--              print(i)
--              PlayerResource:GetPlayer(i):GetAssignedHero():SetBotDifficulty(2)
--          end
--      end
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
		local tPlayerPostGameInfo = {}
		for i = 0,23 do
			if PlayerResource:GetPlayer(i) then
				tPlayerPostGameInfo[i] = {}
				tPlayerPostGameInfo[i].fGPM = PlayerResource:GetGoldPerMin(i)
				tPlayerPostGameInfo[i].fXPM = PlayerResource:GetXPPerMin(i)
				local fDamageAll = 0
				for j = 0, 23 do
					fDamageAll = fDamageAll+PlayerResource:GetDamageDoneToHero(i,j)
				end
				tPlayerPostGameInfo[i].fDamage = fDamageAll
			end
		end
		CustomNetTables:SetTableValue('game_options', 'player_post_game_info', tPlayerPostGameInfo)
    end
end
bAllFunHeroes = false
function GameMode:_OnNPCSpawned(keys)
	if EntIndexToHScript(keys.entindex):IsCourier() then
		local hCourier = EntIndexToHScript(keys.entindex)
		if self.iFastCourier > 0 then
			hCourier:AddNewModifier(hCourier, nil, 'modifier_fast_courier', nil)
		end
		hCourier:GetOwner().hCourier = hCourier
	end
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME then return end
	local hHero = EntIndexToHScript(keys.entindex)	
	if hHero.bInitialized or not hHero:IsHero() then return end	 
	
-- Init heroes
--	if (not self.tFunHeroSelection[hHero:GetPlayerOwnerID()] or self.tFunHeroSelection[hHero:GetPlayerOwnerID()]==hHero:GetName()) then self:InitializeFunHero(hHero) end
	if (((hHero:GetPlayerOwner() and hHero:GetPlayerOwner().bIsPlayingFunHero) or hHero.bIsPlayingFunHero ) and self.tFunHeroSelection[hHero:GetPlayerOwnerID()]==hHero:GetName()) or (IsInToolsMode() and bAllFunHeroes) then self:InitializeFunHero(hHero) end
--	self:InitializeFunHero(hHero)
--[[
	if hHero:GetName() == "npc_dota_hero_sniper" then
		require('heroes/sniper/sniper_init')
		SniperInit(hHero, self)
	end
]]	
-- bot initiation	
	if not self.tHumanPlayerList[hHero:GetPlayerOwnerID()] then
--	if not self.tHumanPlayerList[hHero:GetPlayerOwnerID()] and not IsInToolsMode() then
		if hHero:IsRealHero() and not hHero:IsTempestDouble() and not hHero:IsClone() then
			hHero:AddNewModifier(hHero, nil, "modifier_bot_use_items", {})
			hHero:AddNewModifier(hHero, nil, 'modifier_item_assemble_fix', {})
		end
		if self.iBotProtection > 0 then
			hHero:AddNewModifier(hHero, nil, 'modifier_bot_protection', {})
		end
		hHero:AddNewModifier(hHero, nil, "modifier_bot_attack_tower_pick_rune", {}).tHumanPlayerList = self.tHumanPlayerList
		if hHero:GetName() == "npc_dota_hero_axe" and not hHero:IsIllusion() then
			hHero:AddNewModifier(hHero, nil, "modifier_axe_thinker", {})
		end
	end
	
	--if IsInToolsMode() and self.tHumanPlayerList[(hHero:GetPlayerOwnerID())] then PlayerResource:SetGold(hHero:GetOwner():GetPlayerID(), 99999, true) end
	
	if self.iImbalancedEconomizer == 1 then hHero:AddNewModifier(hHero, nil, "modifier_imbalanced_economizer", {}) end
	hHero:AddNewModifier(hHero, nil, "modifier_ban_fun_items", {})
	if self.iAntiDiving == 1 then hHero:AddNewModifier(hHero, nil, "modifier_anti_diving", {}) end
	hHero:AddNewModifier(hHero, nil, "modifier_lottery_manager", {})

	if hHero:IsRealHero() and not hHero:IsTempestDouble() and not hHero:IsClone() then
		if PlayerResource:GetTeam(hHero:GetPlayerOwnerID()) == DOTA_TEAM_GOODGUYS then
			hHero:SetGold(self.iRadiantGoldStart, false)
			for i=1,self.iRadiantLvlStart-1 do
				hHero:HeroLevelUp(false)
			end
		else
			for i=1,self.iDireLvlStart-1 do
				hHero:HeroLevelUp(false)
			end
		end
	end

	Timers:CreateTimer(0.1, function ()
		if hHero:IsRealHero() and not hHero:IsTempestDouble() and not hHero:IsClone() then
			hHero:AddNewModifier(hHero, nil, "modifier_global_hero_respawn_time", {}) 
			


--			hHero:AddNewModifier(hHero, nil, "modifier_plant_tree", {}) 
		end
	end)
	
	--[[
	if hHero:IsIllusion() then
		hHero:AddNewModifier(hHero, nil, "modifier_plant_tree", {}):SetStackCount(hHero:GetPlayerOwner():GetAssignedHero():FindModifierByName('modifier_plant_tree'):GetStackCount())
	
	end
	]]
	
	hHero.bInitialized = true;
end

function GameMode:OnPlayerLevelUp(keys)
	local iEntIndex=keys.hero_entindex
	Timers:CreateTimer(0.5, function () 
		EntIndexToHScript(iEntIndex):SetCustomDeathXP(40 + EntIndexToHScript(iEntIndex):GetCurrentXP()*0.13)
	end)
end

-- Start Voting For Game Option
function GameMode:OnGetLoadingGameOptions(eventSourceIndex, args)
	if not args.bFromServer then
		GameMode.tGameOption = args
		GameMode.tGameOption .PlayerID = nil
	end
	if args.btoVote then
		CustomGameEventManager:Send_ServerToAllClients("start_loading_game_option_vote", {})
		GameMode.tGameOption.btoVote = nil
	end
	CustomNetTables:SetTableValue('game_options', 'loading_game_options', GameMode.tGameOption)
end


function GameMode:OnGetLoadingIndividualGameOptionVotes(eventSourceIndex, args)
	GameMode.tPreGameVote = GameMode.tPreGameVote or {}
	GameMode.tPreGameVote.iYay = GameMode.tPreGameVote.iYay or 0
	GameMode.tPreGameVote.iNay = GameMode.tPreGameVote.iNay or 0
	GameMode.tPreGameVoteIndividual = GameMode.tPreGameVoteIndividual or {}
	if not GameMode.tPreGameVoteIndividual[args.PlayerID] then
		GameMode.tPreGameVoteIndividual[args.PlayerID] = args.vote
		if args.vote == "1" then
			GameMode.tPreGameVote.iYay = GameMode.tPreGameVote.iYay+1
		else
			GameMode.tPreGameVote.iNay = GameMode.tPreGameVote.iNay+1
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("set_loading_game_option_vote", GameMode.tPreGameVote)
end


function GameMode:OnConfirmGameOptions(eventSourceIndex, args)

	GameMode.bGameOptionsConfirmed = true
	self.iDesiredRadiant = tonumber(GameMode.tGameOption.radiant_player_number);
	self.iDesiredDire = tonumber(GameMode.tGameOption.dire_player_number);
	self.fRadiantGoldMultiplier = tonumber(GameMode.tGameOption.radiant_gold_multiplier);
	self.fRadiantXPMultiplier = tonumber(GameMode.tGameOption.radiant_xp_multiplier);
	self.fDireXPMultiplier = tonumber(GameMode.tGameOption.dire_xp_multiplier);
	self.fDireGoldMultiplier = tonumber(GameMode.tGameOption.dire_gold_multiplier);
	self.iRespawnTimePercentage = tonumber(GameMode.tGameOption.respawn_time_percentage)
	self.iBuybackCooldown = tonumber(GameMode.tGameOption.buyback_cooldown)
	self.iMaxLevel = tonumber(GameMode.tGameOption.max_level)
	self.iTowerPower = tonumber(GameMode.tGameOption.tower_power)
	self.iTowerEndure = tonumber(GameMode.tGameOption.tower_endure)
	self.iImbalancedEconomizer = GameMode.tGameOption.imbalanced_economizer
	self.iBotHasFunItem = GameMode.tGameOption.bot_has_fun_item
	self.iUniversalShop = GameMode.tGameOption.universal_shop
	self.iFastCourier = GameMode.tGameOption.fast_courier
	self.iDynamicExpGold = GameMode.tGameOption.dynamic_exp_gold
	self.iBotProtection = GameMode.tGameOption.bot_protection
	self.iAntiDiving = GameMode.tGameOption.anti_diving
	self.iEnableLottery = GameMode.tGameOption.enable_lottery
	self.iRadiantFunItemTotalPriceThreshold = tonumber(GameMode.tGameOption.radiant_fun_item_total_price_thresold)
	self.iDireFunItemTotalPriceThreshold = tonumber(GameMode.tGameOption.dire_fun_item_total_price_thresold)
	self.iRadiantGoldStart = tonumber(GameMode.tGameOption.radiant_gold_start)
	self.iDireGoldStart = tonumber(GameMode.tGameOption.dire_gold_start)
	self.iRadiantLvlStart = tonumber(GameMode.tGameOption.radiant_lvl_start)
	self.iDireLvlStart = tonumber(GameMode.tGameOption.dire_lvl_start)
	self.iExtraTower = tonumber(GameMode.tGameOption.extra_tower)


	--_DeepPrintTable(GameMode.tGameOption)
	self:PreGameOptions()
	
	
	
end

function GameMode:OnNetTableValueChanged(eventSourceIndex, args)
	CustomNetTables:SetTableValue(args.table_name, args.table_key, args.table_value)
end

local function FindFirstBranch(hHero)
	for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
		if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == 'item_branches' then
			return hHero:GetItemInSlot(i)
		end
	end
	local hCourier = PlayerResource:GetNthCourierForTeam(0,hHero:GetTeamNumber())
	if hCourier then
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			if hCourier:GetItemInSlot(i) and hCourier:GetItemInSlot(i):GetName() == 'item_branches' and hHero == hCourier:GetItemInSlot(i):GetPurchaser() then
				return hCourier:GetItemInSlot(i)
			end	
		end
	end
	return false
end

function GameMode:OnDOTAItemPurchased(keys)
--[[
	if keys.itemname == 'item_branches' then
		local hPlayer = PlayerResource:GetPlayer(keys.PlayerID)
		local hHero = hPlayer:GetAssignedHero()
		while hHero:HasAnyAvailableInventorySpace() do
			if FindFirstBranch(hHero) then
				hHero:AddItemByName(FindFirstBranch(hHero):GetName()):SetPurchaseTime(FindFirstBranch(hHero):GetPurchaseTime())
				FindFirstBranch(hHero):RemoveSelf()
			else
				break
			end
		end
	end
	]]
	if string.find(keys.itemname, 'item_fun') then
		PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero():FindModifierByName('modifier_plant_tree').bHasFunItem = true
	end
end
function GameMode:OnHeroInventoryItemChange(keys)
	-- print('OnHeroInventoryItemChange:')
	-- _DeepPrintTable(keys)
	-- print(EntIndexToHScript(keys.item_entindex):GetName())

end
function GameMode:OnItemPickUp(keys)
	-- print('OnItemPickUp')
end

function GameMode:OnVoteConfirm(eventSourceIndex, args)
	self.tVoteResult = self.tVoteResult or {}
	self.tVoteContent = self.tVoteContent or {"iActivateFunHeroes", "iActivateImbaFunHeroes", "iBanFunItems"}
	self.tVotedPlayers = self.tVotedPlayers or {}
	if self.tVotedPlayers[args.PlayerID] then return end
	self.tVotedPlayers[args.PlayerID] = true
	for k, v in pairs(args.aVoteResult) do
		self.tVoteResult[tostring(k)+1] = self.tVoteResult[tostring(k)+1] or {}
		self.tVoteResult[tostring(k)+1][v] = self.tVoteResult[tostring(k)+1][v] or 0
		self.tVoteResult[tostring(k)+1][v] = self.tVoteResult[tostring(k)+1][v]+1
	end
	GameMode.iVotePlayerCount=args.iPlayerCount
	GameMode.iConfirmedVotePlayerCount = GameMode.iConfirmedVotePlayerCount or 0
	GameMode.iConfirmedVotePlayerCount = GameMode.iConfirmedVotePlayerCount+1
	CustomGameEventManager:Send_ServerToAllClients("update_vote_confirmed_players", {iConfirmedPlayerCount=GameMode.iConfirmedVotePlayerCount, iPlayerCount=GameMode.iVotePlayerCount})
	CustomGameEventManager:Send_ServerToAllClients("update_vote_result", self.tVoteResult)
--	if GameMode.iConfirmedVotePlayerCount >= GameMode.iVotePlayerCount then
	if GameMode.iConfirmedVotePlayerCount >= 1 then
		GameMode:OnVoteEnd()
	end
end

function GameMode:OnVoteEnd()
	if self.bVoteEnded then return end
	self.bVoteEnded = true
	CustomGameEventManager:Send_ServerToAllClients("vote_end", {})
	local tSend = {}
--	GameMode.iBanFunItems = 1
	if not self.tVoteResult then
		self.iActivateFunHeroes = 1
		self.iActivateImbaFunHeroes = 1
		self.iBanFunItems = 0
		CustomNetTables:SetTableValue('game_options', 'vote_options_result', {iActivateFunHeroes = 1, iActivateImbaFunHeroes = 1, iBanFunItems = 0})
		return
	end
	for k, v in pairs(self.tVoteResult) do
		local mOption = 0
		local nOption
		for k1, v1 in pairs(v) do
			if v1 > mOption then
				nOption = k1
				mOption = v1
			end
		end
		tSend[GameMode.tVoteContent[k]] = nOption
		GameMode[GameMode.tVoteContent[k]] = nOption
	end
	CustomNetTables:SetTableValue('game_options', 'vote_options_result', tSend)
--	GameMode.iGameOptionSetTime = GAME_OPTION_SET_TIME
--	CustomGameEventManager:Send_ServerToAllClients("update_game_option_set_time", {iTime=GameMode.iGameOptionSetTime})
--	GameRules:GetGameModeEntity():SetContextThink('GameOptionSetTimer', OnGameOptionSetTimerChange, 1)
end

local function OnVoteTimerChange()
	GameMode.iVoteTime = GameMode.iVoteTime-1
	CustomGameEventManager:Send_ServerToAllClients("update_vote_time", {iTime=GameMode.iVoteTime})
	if GameMode.iVoteTime > 0 then
		return 1
	else
		GameMode:OnVoteEnd()
	end
end

function GameMode:OnPlayerConnectFull(keys)
--	print("All Players Connected!")
	GameMode.iVoteTime = VOTE_TIME
	CustomGameEventManager:Send_ServerToAllClients("update_vote_time", {iTime=GameMode.iVoteTime})
	GameRules:GetGameModeEntity():SetContextThink('VoteTimer', OnVoteTimerChange, 1)
end


local function OnGameOptionSetTimerChange()
	if GameMode.bGameOptionsConfirmed then return end
	GameMode.iGameOptionSetTime = GameMode.iGameOptionSetTime-1
	CustomGameEventManager:Send_ServerToAllClients("update_game_option_set_time", {iTime=GameMode.iGameOptionSetTime})
	if GameMode.iGameOptionSetTime > 0 then
		return 1
	else
		GameMode:OnGetLoadingGameOptions(-1, {bFromServer = true, btoVote = true})
	end
end
