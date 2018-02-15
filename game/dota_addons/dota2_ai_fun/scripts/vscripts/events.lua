function GameMode:_OnConnectFull(keys)
	if GameMode._reentrantCheck then
		return
	end

--	GameMode:_CaptureGameMode()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	local userID = keys.userid
	self.vUserIds = self.vUserIds or {}
	self.vUserIds[userID] = ply
	GameMode._reentrantCheck = true
	GameMode:OnConnectFull( keys )
	GameMode._reentrantCheck = false
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)


	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()--GameMode:AddBotPlayers()
	
	
end

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
		if IsInToolsMode() then return end
--		if IsInToolsMode() and GetMapName() ~= "dota" then return end
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
		local iTowerPower = self.iTowerPower or 1
		local iTowerEndure = self.iTowerEndure or 1
		for k, v in pairs(tTowers) do
			v:AddNewModifier(v, nil, "modifier_tower_power", {}):SetStackCount(iTowerPower)
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
		end
		local tTowers = Entities:FindAllByClassname("npc_dota_barracks")
		for k, v in pairs(tTowers) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
		end
		local tTowers = Entities:FindAllByClassname("npc_dota_healer")
		for k, v in pairs(tTowers) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
		end
		local tTowers = Entities:FindAllByClassname("npc_dota_fort")
		for k, v in pairs(tTowers) do
			v:AddNewModifier(v, nil, "modifier_tower_endure", {}):SetStackCount(iTowerEndure)
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
    end
end

function GameMode:OnPlayerSpawn(keys)

end

local CalculateLevelRespawnTimeWithDiscount = function (iLevel)
	local tDOTARespawnTime = {8, 10, 12, 14, 16, 26, 28, 30, 32, 34, 36, 48,52,54,56,58,60,70,74,76, 78, 82, 86, 90, 100}
	if iLevel <= 25 then return tDOTARespawnTime[iLevel]*GameMode.iRespawnTimePercentage/100 end
	return (100+4*(iLevel-25))*GameMode.iRespawnTimePercentage/100
end

function GameMode:OnEntityKilled(keys)
	local hHero = EntIndexToHScript(keys.entindex_killed)
	if not hHero:IsHero() or hHero:IsIllusion() then return end

	Timers:CreateTimer(0.04, function ()
		local fRespawnTime = CalculateLevelRespawnTimeWithDiscount(hHero:GetLevel())
		--print("Normal Respawn Time: ", fRespawnTime, "Reincarnate Time: ", hHero.fReincarnateTime, "Buy back extra time: ", hHero.fBuyBackExtraRespawnTime, "Scythe Extra time: ", hHero.fScytheTime, "BloodStone Time", hHero.fBloodstoneRespawnTimeReduce)
		if hHero.fReincarnateTime then
			hHero:SetTimeUntilRespawn(hHero.fReincarnateTime)
			hHero.fScytheTime = nil
			hHero.fReincarnateTime = nil
			hHero.fBloodstoneRespawnTimeReduce = nil	
		else
			if hHero.fScytheTime then 
				fRespawnTime = fRespawnTime+hHero.fScytheTime
				hHero.fScytheTime = nil
			end
			if hHero.fBuyBackExtraRespawnTime then
				fRespawnTime = fRespawnTime+hHero.fBuyBackExtraRespawnTime
				hHero.fBuyBackExtraRespawnTime = nil
			end
			if hHero.fBloodstoneRespawnTimeReduce then
				fRespawnTime = fRespawnTime-hHero.fBloodstoneRespawnTimeReduce
				hHero.fBloodstoneRespawnTimeReduce = nil				
			end
			if fRespawnTime < 0 then fRespawnTime = 0 end
			hHero:SetTimeUntilRespawn(fRespawnTime)
		end
		--[[
		local fTimeTillRespawn = hHero:GetTimeUntilRespawn()*self.iRespawnTimePercentage/100
		if hHero:GetLevel()>25 then fTimeTillRespawn = (hHero:GetLevel()*4+hHero.fBuyBackExtraRespawnTime)*self.iRespawnTimePercentage/100 end
		if hHero:IsReincarnating() then fTimeTillRespawn = hHero.fReincarnateTime or 3 end
		print("TTR:", fTimeTillRespawn, hHero.fBuyBackExtraRespawnTime, hHero:GetLevel()*4, hHero:GetTimeUntilRespawn(), self.iRespawnTimePercentage/100)
		hHero:SetTimeUntilRespawn(fTimeTillRespawn)
		]]--
	end)
end


function GameMode:_OnNPCSpawned(keys)
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME then return end
	local hHero = EntIndexToHScript(keys.entindex)	
--	if hHero:IsHero() and not hHero.bInitialized and (not self.tFunHeroSelection[hHero:GetPlayerOwnerID()] or self.tFunHeroSelection[hHero:GetPlayerOwnerID()]==hHero:GetName()) then self:InitializeFunHero(hHero) end
	if hHero:IsHero() and not hHero.bInitialized and ((hHero:GetPlayerOwner() and hHero:GetPlayerOwner().bIsPlayingFunHero) or hHero.bIsPlayingFunHero ) and self.tFunHeroSelection[hHero:GetPlayerOwnerID()]==hHero:GetName() then self:InitializeFunHero(hHero) end
--	if hHero:IsHero() and not hHero.bInitialized then self:InitializeFunHero(hHero) end
	if hHero:GetName() == "npc_dota_hero_sniper" then
		require('heroes/sniper/sniper_init')
		SniperInit(hHero, self)
	end

	if not hHero:IsHero() or hHero:IsIllusion() then return end	
	
	if not self.tHumanPlayerList[hHero:GetPlayerOwnerID()] and self.iBotHasFunItem == 1 then
		hHero:AddNewModifier(hHero, nil, "modifier_bot_get_fun_items", {})
		hHero:AddNewModifier(hHero, nil, "modifier_bot_use_fun_items", {})
	end
	
	if not self.tHumanPlayerList[hHero:GetPlayerOwnerID()] and self.iBotAttackTowerPickRune == 1 then
		hHero:AddNewModifier(hHero, nil, "modifier_bot_attack_tower_pick_rune", {}).tHumanPlayerList = self.tHumanPlayerList
	end
	
	
	
	if IsInToolsMode() and self.tHumanPlayerList[(hHero:GetPlayerOwnerID())] then PlayerResource:SetGold(hHero:GetOwner():GetPlayerID(), 99999, true) end
	if not hHero.bInitialized then
		hHero:AddNewModifier(hHero, nil, "modifier_global_hero_respawn_time", {})
		if self.iImbalancedEconomizer > 0 then hHero:AddNewModifier(hHero, nil, "modifier_imbalanced_economizer", {}) end
	end

	Timers:CreateTimer(0.04, function ()  
		if hHero:IsNull() then return end
		local hModifierBGP = hHero:FindModifierByName("modifier_buyback_gold_penalty")
		if hModifierBGP then 
			hHero.fBuyBackExtraRespawnTime = hModifierBGP:GetDuration()*0.25
		end
	end)

	hHero.bInitialized = true;
end
--[[
function GameMode:OnPlayerPickHero(keys)	

end
]]--
function GameMode:OnPlayerLevelUp(keys)
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
    local level = hHero:GetLevel()

	if level > 25 then
		hHero:SetCustomDeathXP(330 + 110*(level-8))
	end
end

function GameMode:OnGetLoadingSetOptions(eventSourceIndex, args)	
	if tonumber(args.host_privilege) ~= 1 then return end	
	self.iDesiredRadiant = tonumber(args.game_options.radiant_player_number);
	self.iDesiredDire = tonumber(args.game_options.dire_player_number);
	self.fRadiantGoldMultiplier = tonumber(args.game_options.radiant_gold_multiplier);
	self.fRadiantXPMultiplier = tonumber(args.game_options.radiant_xp_multiplier);
	self.fDireXPMultiplier = tonumber(args.game_options.dire_xp_multiplier);
	self.fDireGoldMultiplier = tonumber(args.game_options.dire_gold_multiplier);
	self.iRespawnTimePercentage = tonumber(args.game_options.respawn_time_percentage)
	self.iMaxLevel = tonumber(args.game_options.max_level)
	self.iTowerPower = tonumber(args.game_options.tower_power)
	self.iTowerEndure = tonumber(args.game_options.tower_endure)
	self.iImbalancedEconomizer = args.game_options.imbalanced_economizer
	self.iBotHasFunItem = args.game_options.bot_has_fun_item
	self.iBotAttackTowerPickRune = args.game_options.bot_attack_tower_pick_rune
	self.iUniversalShop = args.game_options.universal_shop
	self:PreGameOptions()
end

