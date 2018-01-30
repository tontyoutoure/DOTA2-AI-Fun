RAMZA_MENU_STATE_NORMAL = 0
RAMZA_MENU_STATE_UPGRADE = 1
RAMZA_MENU_STATE_PRIMARY = 2
RAMZA_MENU_STATE_SECONDARY = 3
RAMZA_MENU_STATE_SELECT_JOB = 4
RAMZA_MENU_STATE_SELECT_SECONDARY = 5

local tTimeMageAbilities = {
	ramza_time_mage_time_magicks_haste = true,
	ramza_time_mage_time_magicks_slow = true,
	ramza_time_mage_time_magicks_immobilize = true,
	ramza_time_mage_time_magicks_gravity = true,
	ramza_time_mage_time_magicks_quick = true,
	ramza_time_mage_time_magicks_stop = true,
	ramza_time_mage_time_magicks_meteor = true,
	ramza_time_mage_teleport = true
}


ramza_open_stats_lua = class({})
local function PrintAbilities(hHero)
	local iCount = 0
	local sNames = ""
	for i = 0, 23 do
		if hHero:GetAbilityByIndex(i) then 
			iCount = iCount+1
			sNames = sNames .. " " .. hHero:GetAbilityByIndex(i):GetName()
		end
	end
	print(iCount, sNames)
end
function ramza_open_stats_lua:ProcsMagicStick() return false end
function ramza_open_stats_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	CustomGameEventManager:Send_ServerToPlayer( hCaster:GetOwner(), "ramza_close_selection", {iHeroEntityIndex=self:GetCaster():entindex()} )
	hCaster.iBraveryLevel = hCaster.iBraveryLevel or 0
	hCaster.iSpeedLevel = hCaster.iSpeedLevel or 0
	hCaster.iFaithLevel = hCaster.iFaithLevel or 0
	
	hCaster.iMenuState = RAMZA_MENU_STATE_UPGRADE
	hCaster.tNormalMenuState = hCaster.tNormalMenuState or {}
	for i = 1, 5 do
		hCaster.tNormalMenuState[i] = hCaster:GetAbilityByIndex(i-1):GetName()
	end
	
	--first ability is always hide
	hCaster:AddAbility('ramza_select_job_lua'):SetLevel(1);	
	hCaster:SwapAbilities(hCaster.tNormalMenuState[1], "ramza_select_job_lua", false, true)	
--	hCaster:FindAbilityByName(hCaster.tNormalMenuState[1]):SetHidden(true)	
	
	if hCaster.tNormalMenuState[2] ~= "ramza_select_secondary_skill_lua" then
		hCaster:AddAbility("ramza_select_secondary_skill_lua"):SetLevel(1);	
		hCaster:SwapAbilities(hCaster.tNormalMenuState[2], "ramza_select_secondary_skill_lua", false, true)
--		hCaster:FindAbilityByName(hCaster.tNormalMenuState[2]):SetHidden(true)		
	end
	
	local hAbility = hCaster:AddAbility("ramza_bravery")
	if hAbility then 
		hAbility:SetLevel(hCaster.iBraveryLevel)
	else
		PrintAbilities(hCaster)
	end
	hAbility = hCaster:AddAbility("ramza_speed")
	if hAbility then 
		hAbility:SetLevel(hCaster.iSpeedLevel)
	else
		PrintAbilities(hCaster)
	end
	hAbility = hCaster:AddAbility("ramza_faith")
	if hAbility then 
		hAbility:SetLevel(hCaster.iFaithLevel)
	else
		PrintAbilities(hCaster)
	end
	
	hCaster:SwapAbilities(hCaster.tNormalMenuState[3], "ramza_bravery", false, true)
	hCaster:SwapAbilities(hCaster.tNormalMenuState[4], "ramza_speed", false, true)
	hCaster:SwapAbilities(hCaster.tNormalMenuState[5], "ramza_faith", false, true)
	hCaster:SwapAbilities("ramza_open_stats_lua", "ramza_go_back_lua", false, true)
	
--	hCaster:FindAbilityByName(hCaster.tNormalMenuState[3]):SetHidden(true)
--	hCaster:FindAbilityByName(hCaster.tNormalMenuState[4]):SetHidden(true)
--	hCaster:FindAbilityByName(hCaster.tNormalMenuState[5]):SetHidden(true)
--	hCaster:FindAbilityByName("ramza_open_stats_lua"):SetHidden(true)
	
--	hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(false)
end


ramza_go_back_lua = class({})
function ramza_go_back_lua:ProcsMagicStick() return false end

function ramza_go_back_lua:OnHeroLevelUp()	
	local hCaster = self:GetCaster()
	local iLevel = hCaster:GetLevel()
	if iLevel == 17 or iLevel == 19 or iLevel == 21 or iLevel == 22 or iLevel == 23 or iLevel ==24 then
		hCaster:SetAbilityPoints(hCaster:GetAbilityPoints()+1)
	end
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+hCaster:FindModifierByName("modifier_ramza_job_manager").fStrGrowth-hCaster:GetStrengthGain())
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+hCaster:FindModifierByName("modifier_ramza_job_manager").fAgiGrowth-hCaster:GetAgilityGain())
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+hCaster:FindModifierByName("modifier_ramza_job_manager").fIntGrowth-hCaster:GetIntellectGain())
--	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+hCaster:FindModifierByName("modifier_ramza_job_manager").fStrGrowth)
--	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+hCaster:FindModifierByName("modifier_ramza_job_manager").fAgiGrowth)
--	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+hCaster:FindModifierByName("modifier_ramza_job_manager").fIntGrowth)
end


function ramza_go_back_lua:OnSpellStart()	
	local hCaster = self:GetCaster()
	local sName
	CustomGameEventManager:Send_ServerToPlayer( hCaster:GetOwner(), "ramza_close_selection", {iHeroEntityIndex=self:GetCaster():entindex()} )
	
	if hCaster.iMenuState == RAMZA_MENU_STATE_UPGRADE then
		hCaster:FindAbilityByName(hCaster.tNormalMenuState[1]):SetHidden(false)	
		hCaster:SwapAbilities('ramza_select_job_lua', hCaster.tNormalMenuState[1], false, true)
		hCaster:RemoveAbility('ramza_select_job_lua')
		
		if hCaster.tNormalMenuState[2] ~= "ramza_select_secondary_skill_lua" then
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[2]):SetHidden(false)	
			hCaster:SwapAbilities(hCaster.tNormalMenuState[2], "ramza_select_secondary_skill_lua", true, false)
			hCaster:RemoveAbility('ramza_select_secondary_skill_lua')
		end
		
		
			hCaster:SwapAbilities("ramza_bravery", hCaster.tNormalMenuState[3], false, true)
			hCaster.iBraveryLevel = hCaster:FindAbilityByName("ramza_bravery"):GetLevel()
			hCaster:RemoveAbility("ramza_bravery")
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[3]):SetHidden(false)
			
			hCaster:SwapAbilities("ramza_speed", hCaster.tNormalMenuState[4], false, true)
			hCaster.iSpeedLevel = hCaster:FindAbilityByName("ramza_speed"):GetLevel()
			hCaster:RemoveAbility("ramza_speed")
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[4]):SetHidden(false)
			
			hCaster:SwapAbilities("ramza_faith", hCaster.tNormalMenuState[5], false, true)
			hCaster.iFaithLevel = hCaster:FindAbilityByName("ramza_faith"):GetLevel()
			hCaster:RemoveAbility("ramza_faith")
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[5]):SetHidden(false)
		
		
		
		
		for i = 3, 5 do
			sName = hCaster:GetAbilityByIndex(i-1):GetName()
			hCaster:SwapAbilities(sName, hCaster.tNormalMenuState[i], false, true)
--			hCaster:FindAbilityByName(sName):SetHidden(true)
--			hCaster:FindAbilityByName(hCaster.tNormalMenuState[i]):SetHidden(false)
		end
		
		
		
		hCaster:SwapAbilities("ramza_go_back_lua", "ramza_open_stats_lua", false, true)
--		hCaster:FindAbilityByName("ramza_open_stats_lua"):SetHidden(false)	
--		hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(true)
	else
		for i = 1, 4 do
			sName = hCaster:GetAbilityByIndex(i-1):GetName()
			hCaster:SwapAbilities(sName, hCaster.tNormalMenuState[i], false, true)
--			hCaster:FindAbilityByName(hCaster.tNormalMenuState[i]):SetHidden(false)
			if sName == "ramza_squire_fundamental_stone" then
				hCaster:FindAbilityByName(sName):SetHidden(true)
			else
				hCaster:RemoveAbility(sName)
			end
		end
		
		hCaster:SwapAbilities('ramza_next_page_lua', hCaster.tNormalMenuState[5], false, true)
--		hCaster:FindAbilityByName(hCaster.tNormalMenuState[5]):SetHidden(false)
		hCaster:RemoveAbility('ramza_next_page_lua')
		
		hCaster:AddAbility("ramza_open_stats_lua"):SetLevel(1)	
		hCaster:SwapAbilities("ramza_go_back_lua", "ramza_open_stats_lua", false, true)
--		hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(true)
		hCaster.iPrimaryPointer = 0
		hCaster.iSecondaryPointer = 0
	end
		
	
	hCaster.iMenuState = RAMZA_MENU_STATE_NORMAL 
end

ramza_select_job_lua = class({})
function ramza_select_job_lua:ProcsMagicStick() return false end
	
function ramza_select_job_lua:OnSpellStart()
	CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetOwner(), "ramza_select_job", {iHeroEntityIndex=self:GetCaster():entindex()})
end

ramza_select_secondary_skill_lua = class({})
function ramza_select_secondary_skill_lua:ProcsMagicStick() return false end

function ramza_select_secondary_skill_lua:OnSpellStart()
	CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetOwner(), "ramza_select_secondary_skill", {iHeroEntityIndex=self:GetCaster():entindex()})
end


local RamzaFetchAbilities = function(hCaster, bFromMain, tJobCommandBus, tJobCommandBusRequirement, iPointer)
	local sName1
	local sName2
	local iLevel 
	local iIndex1
	local iIndex2
	if (hCaster.iMenuState == RAMZA_MENU_STATE_PRIMARY) then
		iLevel = hCaster.hRamzaJob.tJobLevels[hCaster.hRamzaJob.iCurrentJob] 
	else
		iLevel = hCaster.hRamzaJob.tJobLevels[hCaster.hRamzaJob.iSecondarySkill]
	end
	for i = 1, 4 do
		sName1 = hCaster:GetAbilityByIndex(i-1):GetName()
		if tJobCommandBus[i+iPointer] then
			sName2 = tJobCommandBus[i+iPointer]
			if hCaster:HasAbility(sName2) then
				hCaster:FindAbilityByName(sName2):SetHidden(false)
			else
				hCaster:AddAbility(sName2)		
			end
			iIndex1 = hCaster:FindAbilityByName(sName1):GetAbilityIndex()
			iIndex2 = hCaster:FindAbilityByName(sName2):GetAbilityIndex()
			hCaster:SwapAbilities(sName1, sName2, false, true)
		else
			sName2 = 'ramza_empty_'..tostring(i)
			hCaster:AddAbility(sName2)
			hCaster:SwapAbilities(sName1, sName2, false, true)
		end
		if bFromMain or sName1 == "ramza_squire_fundamental_stone" then
			hCaster:FindAbilityByName(sName1):SetHidden(true)
		else
			hCaster:RemoveAbility(sName1)
		end
		if not tJobCommandBusRequirement[i+iPointer] or tJobCommandBusRequirement[i+iPointer] <= iLevel then 
			if tJobCommandBusRequirement[i+iPointer] then
				hCaster:FindAbilityByName(sName2):SetLevel(1)
				if tTimeMageAbilities[sName2] and hCaster:HasModifier("modifier_ramza_time_mage_swiftness") then
					hCaster:FindAbilityByName(sName2):SetLevel(2)
				end
			end
			hCaster:FindAbilityByName(sName2):SetHidden(false)
		end
	end
	if bFromMain then 
		sName1 = hCaster:GetAbilityByIndex(4):GetName()
		hCaster:AddAbility('ramza_next_page_lua'):SetLevel(1)
		hCaster:SwapAbilities(sName1, 'ramza_next_page_lua', false, true)		
--		hCaster:FindAbilityByName(sName1):SetHidden(true)
		
		hCaster:SwapAbilities('ramza_open_stats_lua', 'ramza_go_back_lua', false, true)		
		hCaster:RemoveAbility('ramza_open_stats_lua')
--		hCaster:FindAbilityByName('ramza_go_back_lua'):SetHidden(false)
	end
end

ramza_next_page_lua = class({})
function ramza_next_page_lua:ProcsMagicStick() return false end

function ramza_next_page_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local tJobCommandBus
	local iPointer
	local tJobCommandBusRequirement
	if hCaster.iMenuState == RAMZA_MENU_STATE_PRIMARY then
		if hCaster.iPrimaryPointer+4 < #hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBuses[hCaster.hRamzaJob.iCurrentJob] then
			hCaster.iPrimaryPointer = hCaster.iPrimaryPointer+4
		else
			hCaster.iPrimaryPointer = 0
		end
		tJobCommandBus = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBuses[hCaster.hRamzaJob.iCurrentJob]
		tJobCommandBusRequirement = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBusRequirements[hCaster.hRamzaJob.iCurrentJob]
		iPointer = hCaster.iPrimaryPointer
	else
		if hCaster.iSecondaryPointer+4 < #hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBuses[hCaster.hRamzaJob.iSecondarySkill] then
			hCaster.iSecondaryPointer = hCaster.iSecondaryPointer+4
		else
			hCaster.iSecondaryPointer = 0
		end
		tJobCommandBus = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBuses[hCaster.hRamzaJob.iSecondarySkill]
		tJobCommandBusRequirement = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBusRequirements[hCaster.hRamzaJob.iSecondarySkill]
		iPointer = hCaster.iSecondaryPointer
	end
	RamzaFetchAbilities(hCaster, false, tJobCommandBus, tJobCommandBusRequirement, iPointer)
end

local RamzaJCOnSpellStart = function (self)
	local hCaster = self:GetCaster()
	CustomGameEventManager:Send_ServerToPlayer( hCaster:GetOwner(), "ramza_close_selection", {iHeroEntityIndex=self:GetCaster():entindex()} )
	local tJobCommandBus
	local iPointer
	local tJobCommandBusRequirement
	hCaster.iPrimaryPointer = hCaster.iPrimaryPointer or 0
	hCaster.iSecondaryPointer = hCaster.iSecondaryPointer or 0
	if self:GetAbilityIndex() == 0 then
		hCaster.iMenuState = RAMZA_MENU_STATE_PRIMARY
		tJobCommandBus = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBuses[hCaster.hRamzaJob.iCurrentJob]
		tJobCommandBusRequirement = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBusRequirements[hCaster.hRamzaJob.iCurrentJob]
		iPointer = hCaster.iPrimaryPointer
	else
		hCaster.iMenuState = RRAMZA_MENU_STATE_SECONDARY
		tJobCommandBus = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBuses[hCaster.hRamzaJob.iSecondarySkill]
		tJobCommandBusRequirement = hCaster.hRamzaJob.tJobAbilityBuses.tJobCommandBusRequirements[hCaster.hRamzaJob.iSecondarySkill]
		iPointer = hCaster.iSecondaryPointer
	end
	
	hCaster.tNormalMenuState = hCaster.tNormalMenuState or {}
	for i = 1, 5 do
		hCaster.tNormalMenuState[i] = hCaster:GetAbilityByIndex(i-1):GetName()
	end
	RamzaFetchAbilities(hCaster, true, tJobCommandBus, tJobCommandBusRequirement, iPointer)
end

RamzaChangeJCSS = function(self)
end

RamzaChangeJCSSCastFilterResult = function(self)
end

ramza_job_squire_JC = class({})
ramza_job_chemist_JC = class({})
ramza_job_knight_JC = class({})
ramza_job_archer_JC = class({})
ramza_job_white_mage_JC = class({})
ramza_job_black_mage_JC = class({})
ramza_job_monk_JC = class({})
ramza_job_thief_JC = class({})
ramza_job_mystic_JC = class({})
ramza_job_time_mage_JC = class({})
ramza_job_orator_JC = class({})
ramza_job_summoner_JC = class({})
ramza_job_geomancer_JC = class({})
ramza_job_dragoon_JC = class({})
ramza_job_samurai_JC = class({})
ramza_job_ninja_JC = class({})
ramza_job_arithmetician_JC = class({})
ramza_job_mime_JC = class({})
ramza_job_dark_knight_JC = class({})
ramza_job_onion_knight_JC = class({})
function ramza_job_squire_JC:ProcsMagicStick() return false end
function ramza_job_chemist_JC:ProcsMagicStick() return false end
function ramza_job_knight_JC:ProcsMagicStick() return false end
function ramza_job_archer_JC:ProcsMagicStick() return false end
function ramza_job_white_mage_JC:ProcsMagicStick() return false end
function ramza_job_black_mage_JC:ProcsMagicStick() return false end
function ramza_job_monk_JC:ProcsMagicStick() return false end
function ramza_job_thief_JC:ProcsMagicStick() return false end
function ramza_job_mystic_JC:ProcsMagicStick() return false end
function ramza_job_time_mage_JC:ProcsMagicStick() return false end
function ramza_job_orator_JC:ProcsMagicStick() return false end
function ramza_job_summoner_JC:ProcsMagicStick() return false end
function ramza_job_geomancer_JC:ProcsMagicStick() return false end
function ramza_job_dragoon_JC:ProcsMagicStick() return false end
function ramza_job_samurai_JC:ProcsMagicStick() return false end
function ramza_job_ninja_JC:ProcsMagicStick() return false end
function ramza_job_arithmetician_JC:ProcsMagicStick() return false end
function ramza_job_mime_JC:ProcsMagicStick() return false end
function ramza_job_dark_knight_JC:ProcsMagicStick() return false end
function ramza_job_onion_knight_JC:ProcsMagicStick() return false end

ramza_job_squire_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_chemist_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_knight_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_archer_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_white_mage_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_black_mage_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_monk_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_thief_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_mystic_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_time_mage_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_orator_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_summoner_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_geomancer_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_dragoon_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_samurai_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_ninja_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_arithmetician_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_mime_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_dark_knight_JC.OnSpellStart = RamzaJCOnSpellStart
ramza_job_onion_knight_JC.OnSpellStart = RamzaJCOnSpellStart

ramza_job_squire_change_job = class({})
ramza_job_chemist_change_job = class({})
ramza_job_knight_change_job = class({})
ramza_job_archer_change_job = class({})
ramza_job_white_mage_change_job = class({})
ramza_job_black_mage_change_job = class({})
ramza_job_monk_change_job = class({})
ramza_job_thief_change_job = class({})
ramza_job_mystic_change_job = class({})
ramza_job_time_mage_change_job = class({})
ramza_job_orator_change_job = class({})
ramza_job_summoner_change_job = class({})
ramza_job_geomancer_change_job = class({})
ramza_job_dragoon_change_job = class({})
ramza_job_samurai_change_job = class({})
ramza_job_ninja_change_job = class({})
ramza_job_arithmetician_change_job = class({})
ramza_job_mime_change_job = class({})
ramza_job_dark_knight_change_job = class({})
ramza_job_onion_knight_change_job = class({})
ramza_job_squire_change_secondary_skill = class({})
ramza_job_chemist_change_secondary_skill = class({})
ramza_job_knight_change_secondary_skill = class({})
ramza_job_archer_change_secondary_skill = class({})
ramza_job_white_mage_change_secondary_skill = class({})
ramza_job_black_mage_change_secondary_skill = class({})
ramza_job_monk_change_secondary_skill = class({})
ramza_job_thief_change_secondary_skill = class({})
ramza_job_mystic_change_secondary_skill = class({})
ramza_job_time_mage_change_secondary_skill = class({})
ramza_job_orator_change_secondary_skill = class({})
ramza_job_summoner_change_secondary_skill = class({})
ramza_job_geomancer_change_secondary_skill = class({})
ramza_job_dragoon_change_secondary_skill = class({})
ramza_job_samurai_change_secondary_skill = class({})
ramza_job_ninja_change_secondary_skill = class({})
ramza_job_arithmetician_change_secondary_skill = class({})
ramza_job_mime_change_secondary_skill = class({})
ramza_job_dark_knight_change_secondary_skill = class({})
ramza_job_onion_knight_change_secondary_skill = class({})

function ramza_job_squire_change_job:ProcsMagicStick() return false end
function ramza_job_chemist_change_job:ProcsMagicStick() return false end
function ramza_job_knight_change_job:ProcsMagicStick() return false end
function ramza_job_archer_change_job:ProcsMagicStick() return false end
function ramza_job_white_mage_change_job:ProcsMagicStick() return false end
function ramza_job_black_mage_change_job:ProcsMagicStick() return false end
function ramza_job_monk_change_job:ProcsMagicStick() return false end
function ramza_job_thief_change_job:ProcsMagicStick() return false end
function ramza_job_mystic_change_job:ProcsMagicStick() return false end
function ramza_job_time_mage_change_job:ProcsMagicStick() return false end
function ramza_job_orator_change_job:ProcsMagicStick() return false end
function ramza_job_summoner_change_job:ProcsMagicStick() return false end
function ramza_job_geomancer_change_job:ProcsMagicStick() return false end
function ramza_job_dragoon_change_job:ProcsMagicStick() return false end
function ramza_job_samurai_change_job:ProcsMagicStick() return false end
function ramza_job_ninja_change_job:ProcsMagicStick() return false end
function ramza_job_arithmetician_change_job:ProcsMagicStick() return false end
function ramza_job_mime_change_job:ProcsMagicStick() return false end
function ramza_job_dark_knight_change_job:ProcsMagicStick() return false end
function ramza_job_onion_knight_change_job:ProcsMagicStick() return false end
function ramza_job_squire_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_chemist_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_knight_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_archer_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_white_mage_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_black_mage_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_monk_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_thief_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_mystic_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_time_mage_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_orator_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_summoner_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_geomancer_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_dragoon_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_samurai_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_ninja_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_arithmetician_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_mime_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_dark_knight_change_secondary_skill:ProcsMagicStick() return false end
function ramza_job_onion_knight_change_secondary_skill:ProcsMagicStick() return false end

ramza_job_squire_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_chemist_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_knight_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_archer_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_white_mage_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_black_mage_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_monk_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_thief_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_mystic_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_time_mage_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_orator_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_summoner_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_geomancer_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_dragoon_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_samurai_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_ninja_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_arithmetician_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_mime_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_dark_knight_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_onion_knight_change_job.OnSpellStart = RamzaChangeJCSS
ramza_job_squire_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_chemist_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_knight_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_archer_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_white_mage_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_black_mage_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_monk_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_thief_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_mystic_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_time_mage_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_orator_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_summoner_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_geomancer_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_dragoon_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_samurai_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_ninja_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_arithmetician_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_mime_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_dark_knight_change_secondary_skill.OnSpellStart = RamzaChangeJCSS
ramza_job_onion_knight_change_secondary_skill.OnSpellStart = RamzaChangeJCSS

ramza_job_squire_change_job.CastFilterResult = RamzaChangeJCSSCastFilterResult
ramza_job_chemist_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_knight_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_archer_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_white_mage_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_black_mage_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_monk_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_thief_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_mystic_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_time_mage_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_orator_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_summoner_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_geomancer_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_dragoon_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_samurai_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_ninja_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_arithmetician_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_mime_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_dark_knight_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_onion_knight_change_job.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_squire_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_chemist_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_knight_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_archer_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_white_mage_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_black_mage_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_monk_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_thief_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_mystic_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_time_mage_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_orator_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_summoner_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_geomancer_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_dragoon_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_samurai_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_ninja_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_arithmetician_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_mime_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_dark_knight_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult
ramza_job_onion_knight_change_secondary_skill.OnSpellStart = RamzaChangeJCSSCastFilterResult