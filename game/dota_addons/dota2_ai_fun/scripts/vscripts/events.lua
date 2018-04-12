function GameMode:OnFunHeroSelected(eventSourceIndex, args)
	self.tFunHeroSelection = self.tFunHeroSelection or {}
	self.tFunHeroSelection[args.player_id] = args.hero_name
	PlayerResource:GetPlayer(args.player_id).bIsPlayingFunHero = true
	if args.language == "schinese" then
		self.bIsChinese = true
	end
end

function GameMode:OnFunHeroUnselected(eventSourceIndex, args)
	self.tFunHeroSelection = self.tFunHeroSelection or {}
	self.tFunHeroSelection[args.player_id] = nil
	PlayerResource:GetPlayer(args.player_id).bIsPlayingFunHero = nil
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
				CreateHeroForPlayer(v, PlayerResource:GetPlayer(k)):RemoveSelf()
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
		if IsInToolsMode() and GetMapName() ~= "dota" then return end
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
            --SendToServerConsole("dota_bot_populate")
            --SendToServerConsole("dota_bot_set_difficulty 2")
        end
    elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		Tutorial:StartTutorialMode()
		local tTowers = Entities:FindAllByClassname("npc_dota_tower")
		local tBarracks = Entities:FindAllByClassname("npc_dota_barracks")
		local tHealers = Entities:FindAllByClassname("npc_dota_healer")
		local tForts = Entities:FindAllByClassname("npc_dota_fort")
		local tFillers = Entities:FindAllByClassname("npc_dota_filler")
		self.tBackdoorBuildings = {}
		self.tBackdoorInBaseBuildings = {}
		local iTowerPower = self.iTowerPower or 1
		local iTowerEndure = self.iTowerEndure or 1
		for k, v in pairs(tTowers) do
			v:AddNewModifier(v, nil, "modifier_tower_power", {}):SetStackCount(iTowerPower)
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			if v:HasAbility("backdoor_protection") then table.insert(self.tBackdoorBuildings, v) end
			if v:HasAbility("backdoor_protection_in_base") then table.insert(self.tBackdoorInBaseBuildings, v) end
		end
		for k, v in pairs(tBarracks) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			if v:HasAbility("backdoor_protection") then table.insert(self.tBackdoorBuildings, v) end
			if v:HasAbility("backdoor_protection_in_base") then table.insert(self.tBackdoorInBaseBuildings, v) end
		end
		for k, v in pairs(tHealers) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			if v:HasAbility("backdoor_protection") then table.insert(self.tBackdoorBuildings, v) end
			if v:HasAbility("backdoor_protection_in_base") then table.insert(self.tBackdoorInBaseBuildings, v) end
		end
		for k, v in pairs(tForts) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			if v:HasAbility("backdoor_protection") then table.insert(self.tBackdoorBuildings, v) end
			if v:HasAbility("backdoor_protection_in_base") then table.insert(self.tBackdoorInBaseBuildings, v) end
		end
		for k, v in pairs(tFillers) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
			v:AddNewModifier(v, nil, "modifier_backdoor_healing", {})
			if v:HasAbility("backdoor_protection") then table.insert(self.tBackdoorBuildings, v) end
			if v:HasAbility("backdoor_protection_in_base") then table.insert(self.tBackdoorInBaseBuildings, v) end
		end
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self.fGameStartTime = GameRules:GetGameTime()
		for k, v in ipairs(self.tBackdoorBuildings) do
			if not v:HasAbility("backdoor_protection") then
				v:AddAbility("backdoor_protection"):SetLevel(1)
			end
		end
		for k, v in ipairs(self.tBackdoorInBaseBuildings) do
			if not v:HasAbility("backdoor_protection_in_base") then
				v:AddAbility("backdoor_protection_in_base"):SetLevel(1)
			end
		end
--      for i=0, DOTA_MAX_TEAM_PLAYERS do`
--          print(i)
--          if PlayerResource:IsFakeClient(i) then
--              print(i)
--              PlayerResource:GetPlayer(i):GetAssignedHero():SetBotDifficulty(2)
--          end
--      end
    end
end

function GameMode:_OnNPCSpawned(keys)
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME then return end
	local hHero = EntIndexToHScript(keys.entindex)	
	if hHero.bInitialized or not hHero:IsHero() then return end	 
--	if (not self.tFunHeroSelection[hHero:GetPlayerOwnerID()] or self.tFunHeroSelection[hHero:GetPlayerOwnerID()]==hHero:GetName()) then self:InitializeFunHero(hHero) end
	if ((hHero:GetPlayerOwner() and hHero:GetPlayerOwner().bIsPlayingFunHero) or hHero.bIsPlayingFunHero ) and self.tFunHeroSelection[hHero:GetPlayerOwnerID()]==hHero:GetName() then self:InitializeFunHero(hHero) end
--	self:InitializeFunHero(hHero)
	if hHero:GetName() == "npc_dota_hero_sniper" then
		require('heroes/sniper/sniper_init')
		SniperInit(hHero, self)
	end
	
-- bot initiation	
	if not self.tHumanPlayerList[hHero:GetPlayerOwnerID()] and not IsInToolsMode() then
		if self.iBotHasFunItem == 1 then
			hHero:AddNewModifier(hHero, nil, "modifier_bot_get_fun_items", {})
			hHero:AddNewModifier(hHero, nil, "modifier_bot_use_fun_items", {})
		end
	
		hHero:AddNewModifier(hHero, nil, "modifier_bot_attack_tower_pick_rune", {}).tHumanPlayerList = self.tHumanPlayerList
		if hHero:GetName() == "npc_dota_hero_axe" then
			hHero:AddNewModifier(hHero, nil, "modifier_axe_thinker", {})
		end
	end
	
	if IsInToolsMode() and self.tHumanPlayerList[(hHero:GetPlayerOwnerID())] then PlayerResource:SetGold(hHero:GetOwner():GetPlayerID(), 99999, true) end
	
	if self.iImbalancedEconomizer == 1 then hHero:AddNewModifier(hHero, nil, "modifier_imbalanced_economizer", {}) end
	if self.iBanFunItems == 1 then hHero:AddNewModifier(hHero, nil, "modifier_ban_fun_items", {}) end
	
	Timers:CreateTimer(0.1, function ()
		if hHero:IsRealHero() then
			hHero:AddNewModifier(hHero, nil, "modifier_global_hero_respawn_time", {}) 
		end
	end)
	
	hHero.bInitialized = true;
end

function GameMode:OnPlayerLevelUp(keys)
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
    local level = hHero:GetLevel()

	if level > 25 then
		hHero:SetCustomDeathXP(330 + 110*(level-8))
	end
end

function GameMode:OnGetLoadingSetOptions(eventSourceIndex, args)	
	self.iDesiredRadiant = tonumber(args.radiant_player_number);
	self.iDesiredDire = tonumber(args.dire_player_number);
	self.fRadiantGoldMultiplier = tonumber(args.radiant_gold_multiplier);
	self.fRadiantXPMultiplier = tonumber(args.radiant_xp_multiplier);
	self.fDireXPMultiplier = tonumber(args.dire_xp_multiplier);
	self.fDireGoldMultiplier = tonumber(args.dire_gold_multiplier);
	self.iRespawnTimePercentage = tonumber(args.respawn_time_percentage)
	self.iMaxLevel = tonumber(args.max_level)
	self.iTowerPower = tonumber(args.tower_power)
	self.iTowerEndure = tonumber(args.tower_endure)
	self.iImbalancedEconomizer = args.imbalanced_economizer
	self.iBotHasFunItem = args.bot_has_fun_item
	self.iUniversalShop = args.universal_shop
	self.iBanFunItems = args.ban_fun_items
	self:PreGameOptions()
end

function GameMode:OnNetTableValueChanged(eventSourceIndex, args)
	CustomNetTables:SetTableValue(args.table_name, args.table_key, args.table_value)
end