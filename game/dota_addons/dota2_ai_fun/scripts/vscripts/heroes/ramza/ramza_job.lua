CRamzaJob = {}

require("heroes/ramza/ramza_job_data")

function CRamzaJob:GainJobPoint(iJobPoint)
	local iPlayerID = self.hParent:GetOwner():GetPlayerID()
	self.tJobPoints[self.iCurrentJob] = self.tJobPoints[self.iCurrentJob] + iJobPoint
	local bHasLeveled = false
	while self.tJobLevels[self.iCurrentJob] < 9 and self.tRamzaJobReqirement[self.tJobLevels[self.iCurrentJob]+1] <= self.tJobPoints[self.iCurrentJob] do --Gain job level
		self.tJobLevels[self.iCurrentJob] = self.tJobLevels[self.iCurrentJob]+1
		if self.tJobLevelUnlocks[self.iCurrentJob] and self.tJobLevelUnlocks[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]] then -- Update unmet job requirements
			for _, v in pairs(self.tJobLevelUnlocks[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]]) do
				self.tChangeJobRequirements[v][self.iCurrentJob] = true						
				local bIsReachRequirement = true				
				for __, u in pairs(self.tChangeJobRequirements[v]) do
					bIsReachRequirement = bIsReachRequirement and u
				end
				if bIsReachRequirement then --New job acquired!
					self.tJobLevels[v] = 1
--					print(self.tJobNames[v].." is acquired!") 
				end
			end
		end
		bHasLeveled = true
--		print(self.tJobNames[self.iCurrentJob].." has leveled up to "..tostring(self.tJobLevels[self.iCurrentJob]))		
		
	end
	if bHasLeveled then		
		self:LevelUpSkills()
		CustomNetTables:SetTableValue("ramza", "job_requirement_"..tostring(iPlayerID), self.tChangeJobRequirements)
		CustomNetTables:SetTableValue("ramza", "job_level_"..tostring(iPlayerID), self.tJobLevels)
		if (self.tJobLevels[self.iCurrentJob] < 9) then
			self.hParent:FindModifierByName("modifier_ramza_job_level"):SetStackCount(self.tJobLevels[self.iCurrentJob])
		else
			self.hParent:RemoveModifierByName("modifier_ramza_job_point")
			self.hParent:RemoveModifierByName("modifier_ramza_job_level")
			self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_mastered", {})
		end
	end
	if (self.tJobLevels[self.iCurrentJob] < 9) then
		self.hParent:FindModifierByName("modifier_ramza_job_point"):SetStackCount(self.tJobPoints[self.iCurrentJob])
	end
end

function CRamzaJob:LevelUpSkills()
	--Level up passives
	if self.iCurrentJob ~= RAMZA_JOB_MIME and self.iCurrentJob ~= RAMZA_JOB_ONION_KNIGHT then
		for i = 1, 3 do
			if self.tJobLevels[self.iCurrentJob] >= self.tJobAbilityBuses.tOtherAbilityBusRequirements[self.iCurrentJob][i] then
				self.hParent:FindAbilityByName(self.tJobAbilityBuses.tOtherAbilityBuses[self.iCurrentJob][i]):SetLevel(1)
				if self.hParent:HasModifier("modifier_ramza_time_mage_swiftness") and self.tTimeMageAbilities[self.tJobAbilityBuses.tOtherAbilityBuses[self.iCurrentJob][i]] then
					self.hParent:FindAbilityByName(self.tJobAbilityBuses.tOtherAbilityBuses[self.iCurrentJob][i]):SetLevel(2)
				end
			end
		end
		
		if self.hParent.iMenuState == RAMZA_MENU_STATE_PRIMARY then
			for i = 1, 4 do
				if i+self.hParent.iPrimaryPointer <= #self.tJobAbilityBuses.tJobCommandBusRequirements[self.iCurrentJob] and self.tJobLevels[self.iCurrentJob] >= self.tJobAbilityBuses.tJobCommandBusRequirements[self.iCurrentJob][i+self.hParent.iPrimaryPointer] then
					local hAbility = self.hParent:FindAbilityByName(self.tJobAbilityBuses.tJobCommandBuses[self.iCurrentJob][i+self.hParent.iPrimaryPointer])
					if self.hParent:HasModifier("modifier_ramza_time_mage_swiftness") and self.tTimeMageAbilities[self.tJobAbilityBuses.tJobCommandBuses[self.iCurrentJob][i+self.hParent.iPrimaryPointer]] then
						hAbility:SetLevel(2)
					else
						hAbility:SetLevel(1)
					end
				end
			end
		end		
	end
	
	--Level up job command for archer, dragoon, ninja, arithmetician, mime, onion knight
	for i = 1, 9 do
		if (
				self.iCurrentJob == RAMZA_JOB_ARCHER or 
				self.iCurrentJob == RAMZA_JOB_ARITHMETICIAN or 
				self.iCurrentJob == RAMZA_JOB_DRAGOON or 
				self.iCurrentJob == RAMZA_JOB_NINJA or 
				self.iCurrentJob == RAMZA_JOB_MIME or 
				self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT) and 
			self.hParent:HasAbility(self.tJobCommands[self.iCurrentJob][i][1]) and 
			i < self.tJobLevels[self.iCurrentJob] and 
				(i < self.tJobLevels[self.iCurrentJob]-1 or 
				self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]][1]) then
			local sName = self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]][1] or self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]-1][1]
			
			self.hParent:RemoveAbility(self.tJobCommands[self.iCurrentJob][i][1])
			if self.iCurrentJob == 20 or self.iCurrentJob == 18 then 
				self.hParent:RemoveModifierByName("modifier_"..self.tJobCommands[self.iCurrentJob][i][1])
			end
			self.hParent:AddAbility(sName):SetLevel(1)		
			if self.hParent.iMenuState == RAMZA_MENU_STATE_NORMAL then
				self.hParent:FindAbilityByName(sName):SetHidden(false)
			else	
				self.hParent:FindAbilityByName(sName):SetHidden(true)
				self.hParent.tNormalMenuState[1] = sName
			end
			break
		end
	end	
end

function CRamzaJob:New(tNewObject)
if GameRules:IsCheatMode() then
	tNewObject.tJobPoints = {4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000}
	tNewObject.tJobLevels = {9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9}
else	
	tNewObject.tJobPoints = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	tNewObject.tJobLevels = {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
end
	tNewObject.tChangeJobRequirements = {}
	tNewObject.tPassiveCooldownReadyTime = {}
	for i = 1, 20 do
		tNewObject.tChangeJobRequirements[i] = {}
		for k, v in pairs(self.tRamzaChangeJobRequirements[i]) do
			tNewObject.tChangeJobRequirements[i][k] = false
		end
	end	
	tNewObject.iCurrentJob = RAMZA_JOB_SQUIRE
	tNewObject.iSecondarySkill = 0
	table.insert(self.tAllRamzas, tNewObject.hParent)
	
	setmetatable(tNewObject, {__index = self})
	return tNewObject
end

function CRamzaJob:InitNetTable()	
	local iPlayerID = self.hParent:GetOwner():GetPlayerID()
	if self.hParent:IsIllusion() or GameMode.tFunHeroSelection[self.hParent:GetPlayerOwnerID()] ~= self.hParent:GetName() then return end
	if not GameMode.bRamzaNetTableInitiated then
		CustomNetTables:SetTableValue("ramza", "init_job_requirement", self.tRamzaChangeJobRequirements)
		CustomNetTables:SetTableValue("ramza", "job_names", self.tJobNames)
		CustomNetTables:SetTableValue("ramza", "job_abilities", self.tJobAbilities)
		CustomNetTables:SetTableValue("ramza", "job_stats", self.tJobStats)
		GameMode.bRamzaNetTableInitiated = true
	end
	
	
	CustomNetTables:SetTableValue("ramza", "job_level_"..tostring(iPlayerID), self.tJobLevels)
	CustomNetTables:SetTableValue("ramza", "job_requirement_"..tostring(iPlayerID), self.tChangeJobRequirements)
	CustomNetTables:SetTableValue("ramza", "current_job_"..tostring(iPlayerID), {self.iCurrentJob})
	CustomNetTables:SetTableValue("ramza", "current_secondary_skill_"..tostring(iPlayerID), {self.iSecondarySkill})
end


function CRamzaJob:PrintCurrent()
	print("Current job is"..self.tJobNames[self.iCurrentJob].."(level "..tostring(self.tJobLevels[self.iCurrentJob]).."), job point is "..tostring(self.tJobPoints[self.iCurrentJob]))
end


-- hJob = CRamzaJob:New()

function CRamzaJob:Initialize()
	self.tJobAbilityBuses = {}
	self.tJobAbilities = {}
	self.tJobLevelUnlocks = {}
	self.tJobAbilityBuses.tJobCommandBuses = {}
	self.tJobAbilityBuses.tJobCommandBusRequirements = {}
	self.tJobAbilityBuses.tOtherAbilityBuses = {}
	self.tJobAbilityBuses.tOtherAbilityBusRequirements = {}
	for i = 1, 20 do
		for k, v in pairs(self.tRamzaChangeJobRequirements[i]) do
			self.tJobLevelUnlocks[k] = self.tJobLevelUnlocks[k] or {}
			self.tJobLevelUnlocks[k][v] = self.tJobLevelUnlocks[k][v] or {}
			table.insert(self.tJobLevelUnlocks[k][v], i)
		end
		
		self.tJobAbilities[i] = {}
		self.tJobAbilityBuses.tJobCommandBuses[i] = {}
		self.tJobAbilityBuses.tJobCommandBusRequirements[i] = {}
		self.tJobAbilityBuses.tOtherAbilityBuses[i] = {}
		self.tJobAbilityBuses.tOtherAbilityBusRequirements[i] = {}
		for j = 1,9 do
			self.tJobAbilities[i][j] ={}
			if #self.tJobCommands[i][j] > 0 then
				for k = 1, #self.tJobCommands[i][j] do
					table.insert(self.tJobAbilities[i][j], self.tJobCommands[i][j][k])
					table.insert(self.tJobAbilityBuses.tJobCommandBuses[i], self.tJobCommands[i][j][k])
					table.insert(self.tJobAbilityBuses.tJobCommandBusRequirements[i], j)
				end
			elseif #self.tOtherAbilities[i][j] > 0 then
				for k = 1, #self.tOtherAbilities[i][j] do
					table.insert(self.tJobAbilities[i][j], self.tOtherAbilities[i][j][k])
				end
				table.insert(self.tJobAbilityBuses.tOtherAbilityBuses[i], self.tOtherAbilities[i][j][1])				
				table.insert(self.tJobAbilityBuses.tOtherAbilityBusRequirements[i], j)
			end
		end
	end
	self.tJobAbilityBuses.tOtherAbilityBuses[18] = {"ramza_empty_2", "ramza_empty_3", "ramza_empty_4"}
	self.tJobAbilityBuses.tJobCommandBusRequirements[18] = {10, 10, 10}
	self.tJobAbilityBuses.tOtherAbilityBuses[20] = {"ramza_empty_2", "ramza_empty_3", "ramza_empty_4"}
	self.tJobAbilityBuses.tJobCommandBusRequirements[20] = {10, 10, 10}
	
	self.tAllRamzas = {}
	Convars:RegisterCommand( "ramza_max_level", Dynamic_Wrap(CRamzaJob, 'RamzaLevelMax'), "Give Ramza all job and levels", FCVAR_CHEAT )
end

function CRamzaJob:RamzaLevelMax()
	for i = 1, #self.tAllRamzas do		
		for j = 1, 20 do
			self.tAllRamzas[i].hRamzaJob.tJobPoints[j] = 4000
			self.tAllRamzas[i].hRamzaJob.tJobLevels[j] = 9			
			for k, v in pairs(self.tRamzaChangeJobRequirements[j]) do
				self.tAllRamzas[i].hRamzaJob.tChangeJobRequirements[j][k] = true
			end
			self.tAllRamzas[i].hRamzaJob:LevelUpSkills()
		end
		CustomNetTables:SetTableValue("ramza", "job_level_"..tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), self.tAllRamzas[i].hRamzaJob.tJobLevels)
		CustomNetTables:SetTableValue("ramza", "job_requirement_"..tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), self.tAllRamzas[i].hRamzaJob.tChangeJobRequirements)
		CustomNetTables:SetTableValue("ramza", "current_job_"..tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), {self.tAllRamzas[i].hRamzaJob.iCurrentJob})
		CustomNetTables:SetTableValue("ramza", "current_secondary_skill_"..tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), {self.tAllRamzas[i].hRamzaJob.iSecondarySkill})
	end
end


function RamzaJobChangeListener(eventSourceIndex, args)
	local hRamza = PlayerResource:GetPlayer(tonumber(args.PlayerID)):GetAssignedHero()
	local iChangeJobState = tonumber(args.iState)
	local iJobToGo = tonumber(args.iJob)
	if (hRamza:HasScepter() or GameRules:IsCheatMode() or hRamza:GetHealthPercent() == 100 and hRamza:GetManaPercent() == 100) and not hRamza:HasModifier("modifier_ramza_dragoon_jump") then
		hRamza.hRamzaJob:ChangeJob(iJobToGo, iChangeJobState)
	elseif hRamza:HasModifier("modifier_ramza_dragoon_jump") then
		if tonumber(args.iState) == SELECT_JOB then
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_job_jump", duration = 2, style = {color = "red"}})
		else
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_secondary_skill_jump", duration = 2, style = {color = "red"}})
		end
	else
		if tonumber(args.iState) == SELECT_JOB then
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_job_full", duration = 2, style = {color = "red"}})
		else
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_secondary_skill_full", duration = 2, style = {color = "red"}})
		end
		
	end
end

function CRamzaJob:ChangeJob(iJobToGo, iChangeJobState)
	local iPlayerID = self.hParent:GetOwner():GetPlayerID()	
	if iChangeJobState == SELECT_JOB then
		
		if self.hParent:GetAbilityByIndex(5):GetName() == 'ramza_go_back_lua' then
			self.hParent:FindAbilityByName('ramza_go_back_lua'):CastAbility()
		end
		
		self.hParent:GetAbilityByIndex(1):SetActivated(true)
		self.hParent:FindModifierByName("modifier_ramza_job_manager"):SetStackCount(iJobToGo)
		self:ChangeStat(iJobToGo)
		self:ChangeModel(iJobToGo)		
		self.iCurrentJob = iJobToGo
		
		--remove secondary skill if it's job command of current job or current job can have no secondary skill
		if self.iCurrentJob == self.iSecondarySkill or self.iCurrentJob == RAMZA_JOB_MIME or self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT then 
			if self.hParent:FindAbilityByName("special_bonus_ramza_3"):GetLevel() == 1 and self.iSecondarySkill > 0 then
				self.hParent:RemoveModifierByName("modifier_" .. self.tOtherAbilities[self.iSecondarySkill][3][1])
				self.hParent:RemoveModifierByName("modifier_" .. self.tOtherAbilities[self.iSecondarySkill][5][1])
				self.hParent:RemoveModifierByName("modifier_" .. self.tOtherAbilities[self.iSecondarySkill][7][1])
			end
			self.iSecondarySkill = 0
			CustomNetTables:SetTableValue("ramza", "current_secondary_skill_"..tostring(iPlayerID), {self.iSecondarySkill})
			local sName = self.hParent:GetAbilityByIndex(1):GetName()
			local bHasAdded = false
			if string.sub(sName, 1, 16) == "ramza_archer_aim" or string.sub(sName, 1, 17) == "ramza_ninja_throw" then
				self.hParent:AddAbility("ramza_select_secondary_skill_lua"):SetLevel(1)
				self.hParent:SwapAbilities(sName, "ramza_select_secondary_skill_lua", true, true)
				self.hParent:FindAbilityByName(sName):SetHidden(true)
				bHasAdded = true
			else
				self.hParent:RemoveAbility(sName)
			end 			
			
			if not bHasAdded then
				self.hParent:AddAbility("ramza_select_secondary_skill_lua"):SetLevel(1)
			end
			
			if self.iCurrentJob == RAMZA_JOB_MIME or self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT then
				self.hParent:FindAbilityByName("ramza_select_secondary_skill_lua"):SetActivated(false)
			end
		end
		
		-- change job command
		local sName1
		if 	(self.iCurrentJob == RAMZA_JOB_ARCHER or 
				self.iCurrentJob == RAMZA_JOB_ARITHMETICIAN or 
				self.iCurrentJob == RAMZA_JOB_DRAGOON or 
				self.iCurrentJob == RAMZA_JOB_NINJA or 
				self.iCurrentJob == RAMZA_JOB_MIME or 
				self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT) then
			sName1 = self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]][1] or self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]-1][1] 
		else
			sName1 = self.tJobNames[self.iCurrentJob]..'_JC'
		end
		local sName0 = self.hParent:GetAbilityByIndex(0):GetName()
		
		if (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and  (self.hParent:FindAbilityByName(sName1)) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)			
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and  (not self.hParent:FindAbilityByName(sName1)) then
			self.hParent:AddAbility(sName1):SetLevel(1)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) ~= "ramza_archer_aim" or string.sub(sName0, 1, 17) ~= "ramza_ninja_throw") and  (self.hParent:FindAbilityByName(sName1)) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:RemoveAbility(sName0)
		else		
			self.hParent:RemoveAbility(sName0)
			self.hParent:AddAbility(sName1):SetLevel(1)
		end
		
		if string.sub(sName0, 7, 18) == "onion_knight" then
			self.hParent:RemoveModifierByName("modifier_"..sName0)
		end
		
		if string.sub(sName0, 7, 10) == "mime" then
			self.hParent:RemoveModifierByName("modifier_"..sName0)
		end

		-- change other abilities
		for i = 1, 3 do
			local sName = self.hParent:GetAbilityByIndex(i+1):GetName()
			-- keep cooldown state
			if sName == "ramza_dragoon_dragonheart" or sName == "ramza_monk_critical_recover_hp" or sName == "ramza_summoner_critical_recover_mp" then
				if self.hParent:FindAbilityByName(sName):IsCooldownReady() then
					self.tPassiveCooldownReadyTime[sName] = Time()
				else
					self.tPassiveCooldownReadyTime[sName] = Time()+self.hParent:FindAbilityByName(sName):GetCooldownTimeRemaining()
				end
			end
			self.hParent:RemoveAbility(sName)			
			self.hParent:RemoveModifierByName('modifier_'..sName)	
			local sName1 = self.tJobAbilityBuses.tOtherAbilityBuses[self.iCurrentJob][i]
			self.hParent:AddAbility(sName1)			
			if (sName1 == "ramza_dragoon_dragonheart" or sName1 == "ramza_monk_critical_recover_hp" or sName1 == "ramza_summoner_critical_recover_mp") and self.tPassiveCooldownReadyTime[sName1] and self.tPassiveCooldownReadyTime[sName1] > Time() then
				self.hParent:FindAbilityByName(sName1):StartCooldown(self.tPassiveCooldownReadyTime[sName1] - Time())
			end
		end
		
		self:LevelUpSkills()
		-- renew indicator
		if (self.tJobLevels[self.iCurrentJob] < 9) then
			if self.hParent:FindModifierByName("modifier_ramza_job_mastered") then
				self.hParent:RemoveModifierByName("modifier_ramza_job_mastered")
				self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_level", {})
				self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_point", {})
			end
			self.hParent:FindModifierByName("modifier_ramza_job_level"):SetStackCount(self.tJobLevels[self.iCurrentJob])
			self.hParent:FindModifierByName("modifier_ramza_job_point"):SetStackCount(self.tJobPoints[self.iCurrentJob])
		else
			if not self.hParent:FindModifierByName("modifier_ramza_job_mastered") then
				self.hParent:RemoveModifierByName("modifier_ramza_job_point")
				self.hParent:RemoveModifierByName("modifier_ramza_job_level")
				self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_mastered", {})
			end
		end
		
		-- tell panorama
--		print("job change to", self.tJobNames[self.iCurrentJob])
		CustomNetTables:SetTableValue("ramza", "current_job_"..tostring(iPlayerID), {self.iCurrentJob})		
		CustomGameEventManager:Send_ServerToPlayer( self.hParent:GetOwner(), "ramza_close_selection", {iHeroEntityIndex=self.hParent:entindex()})
	else	
		if self.hParent:GetAbilityByIndex(5):GetName() == 'ramza_go_back_lua' then
			self.hParent:FindAbilityByName('ramza_go_back_lua'):CastAbility()
		end
		
		if self.hParent:FindAbilityByName("special_bonus_ramza_3"):GetLevel() == 1 and self.iSecondarySkill > 0 then
			self.hParent:RemoveModifierByName("modifier_" .. self.tOtherAbilities[self.iSecondarySkill][3][1])
			self.hParent:RemoveModifierByName("modifier_" .. self.tOtherAbilities[self.iSecondarySkill][5][1])
			self.hParent:RemoveModifierByName("modifier_" .. self.tOtherAbilities[self.iSecondarySkill][7][1])
		end
		self.iSecondarySkill = iJobToGo
		
		if self.hParent:FindAbilityByName("special_bonus_ramza_3"):GetLevel() == 1 then
			if self.tJobLevels[self.iSecondarySkill] >= 3 then
				self.hParent:AddAbility(self.tOtherAbilities[self.iSecondarySkill][3][1]):SetLevel(1)
				self.hParent:RemoveAbility(self.tOtherAbilities[self.iSecondarySkill][3][1])
			end
			if self.tJobLevels[self.iSecondarySkill] >= 5 then
				self.hParent:AddAbility(self.tOtherAbilities[self.iSecondarySkill][5][1]):SetLevel(1)
				self.hParent:RemoveAbility(self.tOtherAbilities[self.iSecondarySkill][5][1])
			end
			if self.tJobLevels[self.iSecondarySkill] >= 7 then
				self.hParent:AddAbility(self.tOtherAbilities[self.iSecondarySkill][7][1]):SetLevel(1)
				self.hParent:RemoveAbility(self.tOtherAbilities[self.iSecondarySkill][7][1])
			end
		end
		local sName1
		if 	(self.iSecondarySkill == RAMZA_JOB_ARCHER or 
				self.iSecondarySkill == RAMZA_JOB_ARITHMETICIAN or 
				self.iSecondarySkill == RAMZA_JOB_DRAGOON or 
				self.iSecondarySkill == RAMZA_JOB_NINJA) then
			sName1 = self.tJobCommands[self.iSecondarySkill][self.tJobLevels[self.iSecondarySkill]][1] or self.tJobCommands[self.iSecondarySkill][self.tJobLevels[self.iSecondarySkill]-1][1] 
		else
			sName1 = self.tJobNames[self.iSecondarySkill]..'_JC'
		end
		
		local sName0 = self.hParent:GetAbilityByIndex(1):GetName()		
		
		if (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and self.hParent:FindAbilityByName(sName1) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)			
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and not self.hParent:FindAbilityByName(sName1) then
			self.hParent:AddAbility(sName1):SetLevel(1)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) ~= "ramza_archer_aim" or string.sub(sName0, 1, 17) ~= "ramza_ninja_throw") and self.hParent:FindAbilityByName(sName1) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:RemoveAbility(sName0)
		else		
			self.hParent:RemoveAbility(sName0)
			self.hParent:AddAbility(sName1):SetLevel(1)
		end

		CustomNetTables:SetTableValue("ramza", "current_secondary_skill_"..tostring(iPlayerID), {self.iSecondarySkill})
		CustomGameEventManager:Send_ServerToPlayer( self.hParent:GetOwner(), "ramza_close_selection", {iHeroEntityIndex=self.hParent:entindex()} )
	end
end


function CRamzaJob:ChangeStat(iJobToGo)
	self.hParent:SetBaseMoveSpeed(self.tJobStats[iJobToGo].move_speed)
	self.hParent:SetPrimaryAttribute(self.tJobStats[iJobToGo].primary_attribute)
	self.hParent:SetAttackCapability(self.tJobStats[iJobToGo].attack_cap)
	self.hParent:FindModifierByName("modifier_attack_point_change"):SetStackCount(self.tJobStats[iJobToGo].attack_point*1000)
	self.hParent:FindModifierByName("modifier_ramza_job_manager").iBonusAttackRange = self.tJobStats[iJobToGo].attack_range-150;
	self.hParent:FindModifierByName("modifier_ramza_job_manager"):ForceRefresh()
	self.hParent:SetAcquisitionRange(self.tJobStats[iJobToGo].attack_range+200)
	self.hParent:SetPhysicalArmorBaseValue(self.tJobStats[iJobToGo].armor)
	local fDiffStr = self.tJobStats[iJobToGo].base_str-self.tJobStats[self.iCurrentJob].base_str+(self.hParent:GetLevel()-1)*(self.tJobStats[iJobToGo].gain_str-self.tJobStats[self.iCurrentJob].gain_str)
	local fDiffAgi = self.tJobStats[iJobToGo].base_agi-self.tJobStats[self.iCurrentJob].base_agi+(self.hParent:GetLevel()-1)*(self.tJobStats[iJobToGo].gain_agi-self.tJobStats[self.iCurrentJob].gain_agi)
	local fDiffInt = self.tJobStats[iJobToGo].base_int-self.tJobStats[self.iCurrentJob].base_int+(self.hParent:GetLevel()-1)*(self.tJobStats[iJobToGo].gain_int-self.tJobStats[self.iCurrentJob].gain_int)
	self.hParent:ModifyStrength(fDiffStr)
	self.hParent:ModifyAgility(fDiffAgi)
	self.hParent:ModifyIntellect(fDiffInt)
	self.hParent:FindModifierByName("modifier_ramza_job_manager").fStrGrowth = self.tJobStats[iJobToGo].gain_str
	self.hParent:FindModifierByName("modifier_ramza_job_manager").fAgiGrowth = self.tJobStats[iJobToGo].gain_agi
	self.hParent:FindModifierByName("modifier_ramza_job_manager").fIntGrowth = self.tJobStats[iJobToGo].gain_int
	self.hParent:CalculateStatBonus()
end


function CRamzaJob:ChangeModel(iJobToGo)
	if iJobToGo == RAMZA_JOB_SAMURAI then
		Timers:CreateTimer(0.04, function () self.hParent:SetMaterialGroup("1") end)
	else
		Timers:CreateTimer(0.04, function () self.hParent:SetMaterialGroup("0") end)
	end
	
	if self.tJobStats[iJobToGo].attack_cap == DOTA_UNIT_CAP_RANGED_ATTACK then
		self.hParent:SetRangedProjectileName(self.tJobModels[iJobToGo].attack_projectile)	
	end
	self.hParent:SetModel(self.tJobModels[iJobToGo].model)
	self.hParent:SetOriginalModel(self.tJobModels[iJobToGo].model)
	self.hParent:FindModifierByName("modifier_wearable_hider_while_model_changes").sOriginalModel = self.tJobModels[iJobToGo].model
	self.hParent:FindModifierByName("modifier_wearable_hider_while_model_changes"):ForceRefresh()
	if iJobToGo == RAMZA_JOB_SAMURAI then
		self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_samurai_run_animation_manager", {})
	else
		self.hParent:RemoveModifierByName("modifier_ramza_samurai_run_animation_manager")
	end
	
	if iJobToGo == RAMZA_JOB_WHITE_MAGE then
		self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_white_mage_animation_manager", {})
	else
		self.hParent:RemoveModifierByName("modifier_ramza_white_mage_animation_manager")
	end
	
	self.hParent:SetModelScale(self.tJobModels[iJobToGo].model_scale)
	WearableManager:RemoveAllWearable(self.hParent)
	for k, v in pairs(self.tJobModels[iJobToGo].wearables) do
		WearableManager:AddNewWearable(self.hParent, v)
	end
--	WearableManager:PrintAllPrecaches(self.hParent)
end

CRamzaJob:Initialize()


function RamzaDeathEffects(keys)
	local hRamza = EntIndexToHScript(keys.entindex_killed)
	if hRamza.hRamzaJob and hRamza.hRamzaJob.iCurrentJob == RAMZA_JOB_BLACK_MAGE then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, hRamza)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(255, 150, 0))		
		ParticleManager:SetParticleControl(iParticle, 2, Vector(0, 0, 0))
	elseif hRamza.hRamzaJob and hRamza.hRamzaJob.iCurrentJob == RAMZA_JOB_WHITE_MAGE then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, hRamza)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(255, 255, 200))		
		ParticleManager:SetParticleControl(iParticle, 2, Vector(0, 0, 0))
	end
end

ListenToGameEvent("entity_killed", RamzaDeathEffects, nil)
CustomGameEventManager:RegisterListener("ramza_change_job_client_to_server", RamzaJobChangeListener)






