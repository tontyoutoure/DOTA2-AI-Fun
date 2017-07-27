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

function GameMode:OnGameStateChanged( keys )
    local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if not self.PreGameOptionsSet then
			self:PreGameOptions()
		end
    elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
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
					print(used_hero_name, "has been picked!")
					num = num + 1
				end
            end
        end
        
        self.numPlayers = num

        -- Eanble bots and fill empty slots
        if IsServer() == true then
            print("Adding bots in empty slots")
            
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
-- TODO: Didn't get Reaper's scythe respawn time penalty right when hero level>25
function GameMode:OnEntityKilled(keys)
	local hHero = EntIndexToHScript(keys.entindex_killed)
	if not hHero:IsHero() or hHero:IsIllusion() then return end
	Timers:CreateTimer(0.06, function ()
		local fTimeTillRespawn = hHero:GetTimeUntilRespawn()*self.iRespawnTimePercentage/100
		if hHero:GetLevel()>25 then fTimeTillRespawn = (hHero:GetLevel()*4+hHero.fBuyBackExtraRespawnTime)*self.iRespawnTimePercentage/100 end
		if hHero:IsReincarnating() then fTimeTillRespawn = 3 end
		print("TTR:", fTimeTillRespawn, hHero.fBuyBackExtraRespawnTime, hHero:GetLevel()*4, hHero:GetTimeUntilRespawn(), self.iRespawnTimePercentage/100)
		hHero:SetTimeUntilRespawn(fTimeTillRespawn)
	end)
end
-- for Archer's Bane of Ramza
function GameMode:RamzaProjecileFilter(filterTable)
	local hTarget = EntIndexToHScript(filterTable.entindex_target_const)
	local hSource = EntIndexToHScript(filterTable.entindex_source_const)
	local hAbility = hTarget:FindAbilityByName('ramza_archer_archers_bane')
	if hTarget:FindModifierByName("modifier_ramza_archer_archers_bane") and math.random(100) < hAbility:GetSpecialValueFor("evasion") then
		local tInfo ={
			Target = hTarget,
			Source = hSource,
			Ability = hAbility,
			flExpireTime = GameRules:GetGameTime() + 10, 
			EffectName = hSource:GetRangedProjectileName(),
			iMoveSpeed = hSource:GetProjectileSpeed()
		}		
		
		
		ProjectileManager:CreateTrackingProjectile(tInfo)		
		return false
	end
	return true
end

-- for Defend of Ramza
function GameMode:RamzaDamageFilter(filterTable)
	local hVictim = EntIndexToHScript(filterTable.entindex_victim_const)
	local hAttacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	if hVictim:HasModifier('modifier_ramza_squire_defend') and not hAttacker:IsBuilding() and not hAttacker:IsHero() then 
		filterTable.damage = filterTable.damage*(1-hVictim:FindAbilityByName('ramza_squire_defend'):GetSpecialValueFor("damage_block")/100)
		PrintTable(filterTable);
	end
	return true
end

function LearnInnateSkillOnSpawn(hero)
	local innateSkillNames = {}
	innateSkillNames[#innateSkillNames+1] = "telekenetic_blob_mark_target"

	for i = 1, #innateSkillNames do
		if hero:HasAbility(innateSkillNames[i]) then
			local ability = hero:FindAbilityByName(innateSkillNames[i])
			ability:SetLevel(1)
		end
	end
end

function GameMode:_OnNPCSpawned(keys)
	local hHero = EntIndexToHScript(keys.entindex)
	
	if hHero:GetName() == "npc_dota_hero_visage" then	
		if hHero:IsIllusion() then
			MagicDragonTransform[hHero:GetOwner():GetAssignedHero().iDragonForm](hHero)
		elseif not hHero.bSpawned then
			require("heroes/magic_dragon/magic_dragon_transform")	
			MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](hHero)
		end
	end
	
	if hHero:GetName() == "npc_dota_hero_brewmaster" then
		if hHero:IsRealHero() and not hHero.bSpawned then
			HideWearables(hHero)
			require("heroes/ramza/ramza_job")
			local hModifier = hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_str", {})
			hModifier.fGrowth = 2.5
			hModifier = hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_agi", {})
			hModifier.fGrowth = 2.5
			hModifier = hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_int", {})
			hModifier.fGrowth = 2.5
			hModifier = hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_manager", {})
			hModifier.iBonusAttackRange = 0;
			hModifier = hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_level", {})
			hModifier:SetStackCount(1)
			hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_point", {})
			hHero:FindAbilityByName("ramza_open_stats_lua"):SetLevel(1)
			hHero:FindAbilityByName("ramza_go_back_lua"):SetLevel(1)
			hHero:FindAbilityByName("ramza_next_page_lua"):SetLevel(1)
			hHero:FindAbilityByName("ramza_select_job_lua"):SetLevel(1)
			hHero:FindAbilityByName("ramza_select_secondary_skill_lua"):SetLevel(1)
			if not GameMode.bRamzaArchersBaneFileterSet then
				GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(GameMode, 'RamzaProjecileFilter'), self)
				GameMode.bRamzaArchersBaneFileterSet = true
			end
			if not GameMode.bRamzaSquireDenfendFilterSet then
				GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, 'RamzaDamageFilter'), self)
				GameMode.bRamzaSquireDenfendFilterSet = true
			end
		end
	end

	LearnInnateSkillOnSpawn(hHero)
	
	for i = 1, #GameMode.tStripperList do
		if not hHero.bSpawned and hHero:GetName() == GameMode.tStripperList[i] then
			HideWearables(hHero)
		end
	end

	if not hHero:IsHero() or hHero:IsIllusion() then return end	
	if IsInToolsMode() then PlayerResource:SetGold(hHero:GetOwner():GetPlayerID(), 99999, true) end
	hHero:SetTimeUntilRespawn(-1)
	Timers:CreateTimer(0.06, function ()  
		
		local hModifierBGP = hHero:FindModifierByName("modifier_buyback_gold_penalty")
		if hModifierBGP then 
			hHero.fBuyBackExtraRespawnTime = hModifierBGP:GetDuration()*0.25
		else
			hHero.fBuyBackExtraRespawnTime = 0
		end
	end)
	hHero.bSpawned = true;
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
	self:PreGameOptions()
end

function GameMode:OnFormlessForget(eventSourceIndex, args)	
	local hero = PlayerResource:GetPlayer(eventSourceIndex - 1):GetAssignedHero()
	local currentAbility = hero:GetAbilityByIndex(tonumber(args.skill_index))
    if currentAbility:GetName() ~= args.skillname_to_forget then
	  if currentAbility:IsChanneling() then
		currentAbility:EndChannel(true)
	  end
      hero:SwapAbilities(currentAbility:GetName(), args.skillname_to_forget, false, true)
      hero:FindAbilityByName(args.skillname_to_forget):SetLevel(currentAbility:GetLevel())
	  local allModifiers = hero:FindAllModifiers()
	  local modifiersToRemove = {}
	  for i = #allModifiers, 1, -1 do
		  if string.find(allModifiers[i]:GetName(), currentAbility:GetName()) then
	  		table.insert(modifiersToRemove, allModifiers[i]:GetName())
		  end
	  end	  
	  hero:RemoveAbility(currentAbility:GetName())
	  for i = 1, #modifiersToRemove do
		hero:RemoveModifierByName(modifiersToRemove[i])
	  end
    end
end