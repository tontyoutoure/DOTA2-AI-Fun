RAMZA_MENU_STATE_NORMAL = 0
RAMZA_MENU_STATE_UPGRADE = 1
RAMZA_MENU_STATE_PRIMARY = 2
RAMZA_MENU_STATE_SECONDARY = 3



ramza_open_stats_lua = class({})

function ramza_open_stats_lua:OnSpellStart()
	local hCaster = self:GetCaster()
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
	hCaster:SwapAbilities(hCaster.tNormalMenuState[1], "ramza_select_job_lua", true, true)	
	hCaster:FindAbilityByName(hCaster.tNormalMenuState[1]):SetHidden(true)	
	
	if hCaster.tNormalMenuState[2] ~= "ramza_select_secondary_skill_lua" then
		hCaster:AddAbility("ramza_select_secondary_skill_lua"):SetLevel(1);	
		hCaster:SwapAbilities(hCaster.tNormalMenuState[2], "ramza_select_secondary_skill_lua", true, true)
		hCaster:FindAbilityByName(hCaster.tNormalMenuState[2]):SetHidden(true)		
	end
		
	hCaster:AddAbility("ramza_bravery"):SetLevel(hCaster.iBraveryLevel)
	hCaster:AddAbility("ramza_speed"):SetLevel(hCaster.iSpeedLevel)
	hCaster:AddAbility("ramza_faith"):SetLevel(hCaster.iFaithLevel)
	
	hCaster:SwapAbilities(hCaster.tNormalMenuState[3], "ramza_bravery", true, true)
	hCaster:SwapAbilities(hCaster.tNormalMenuState[4], "ramza_speed", true, true)
	hCaster:SwapAbilities(hCaster.tNormalMenuState[5], "ramza_faith", true, true)
	hCaster:SwapAbilities("ramza_open_stats_lua", "ramza_go_back_lua", true, true)
	
	hCaster:FindAbilityByName(hCaster.tNormalMenuState[3]):SetHidden(true)
	hCaster:FindAbilityByName(hCaster.tNormalMenuState[4]):SetHidden(true)
	hCaster:FindAbilityByName(hCaster.tNormalMenuState[5]):SetHidden(true)
	hCaster:FindAbilityByName("ramza_open_stats_lua"):SetHidden(true)
	
	hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(false)
end

function ramza_open_stats_lua:OnHeroLevelUp()	
	local hCaster = self:GetCaster()
	local iLevel = hCaster:GetLevel()
	if iLevel == 17 or iLevel == 19 or iLevel == 21 or iLevel == 22 or iLevel == 23 or iLevel ==24 then
		hCaster:SetAbilityPoints(hCaster:GetAbilityPoints()+1)
	end
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+hCaster:FindModifierByName("modifier_ramza_job_manager").fStrGrowth)
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+hCaster:FindModifierByName("modifier_ramza_job_manager").fAgiGrowth)
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+hCaster:FindModifierByName("modifier_ramza_job_manager").fIntGrowth)
end

ramza_go_back_lua = class({})

function ramza_go_back_lua:OnHeroLevelUp()	
	local hCaster = self:GetCaster()
	local iLevel = hCaster:GetLevel()
	if iLevel == 17 or iLevel == 19 or iLevel == 21 or iLevel == 22 or iLevel == 23 or iLevel ==24 then
		hCaster:SetAbilityPoints(hCaster:GetAbilityPoints()+1)
	end
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+hCaster:FindModifierByName("modifier_ramza_job_manager").fStrGrowth)
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+hCaster:FindModifierByName("modifier_ramza_job_manager").fAgiGrowth)
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+hCaster:FindModifierByName("modifier_ramza_job_manager").fIntGrowth)
end


function ramza_go_back_lua:OnSpellStart()	
	local hCaster = self:GetCaster()
	local sName
	
	if hCaster.iMenuState == RAMZA_MENU_STATE_UPGRADE then
		hCaster:FindAbilityByName(hCaster.tNormalMenuState[1]):SetHidden(false)	
		hCaster:SwapAbilities('ramza_select_job_lua', hCaster.tNormalMenuState[1], true, true)
		hCaster:RemoveAbility('ramza_select_job_lua')
		
		if hCaster.tNormalMenuState[2] ~= "ramza_select_secondary_skill_lua" then
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[2]):SetHidden(false)	
			hCaster:SwapAbilities(hCaster.tNormalMenuState[2], "ramza_select_secondary_skill_lua", true, true)
			hCaster:RemoveAbility('ramza_select_secondary_skill_lua')
		end
		
		
			hCaster:SwapAbilities("ramza_bravery", hCaster.tNormalMenuState[3], true, true)
			hCaster.iBraveryLevel = hCaster:FindAbilityByName("ramza_bravery"):GetLevel()
			hCaster:RemoveAbility("ramza_bravery")
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[3]):SetHidden(false)
			
			hCaster:SwapAbilities("ramza_speed", hCaster.tNormalMenuState[4], true, true)
			hCaster.iSpeedLevel = hCaster:FindAbilityByName("ramza_speed"):GetLevel()
			hCaster:RemoveAbility("ramza_speed")
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[4]):SetHidden(false)
			
			hCaster:SwapAbilities("ramza_faith", hCaster.tNormalMenuState[5], true, true)
			hCaster.iFaithLevel = hCaster:FindAbilityByName("ramza_faith"):GetLevel()
			hCaster:RemoveAbility("ramza_faith")
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[5]):SetHidden(false)
		
		
		
		
		for i = 3, 5 do
			sName = hCaster:GetAbilityByIndex(i-1):GetName()
			hCaster:SwapAbilities(sName, hCaster.tNormalMenuState[i], true, true)
			hCaster:FindAbilityByName(sName):SetHidden(true)
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[i]):SetHidden(false)
		end
		
		
		
		hCaster:SwapAbilities("ramza_go_back_lua", "ramza_open_stats_lua", true, true)
		hCaster:FindAbilityByName("ramza_open_stats_lua"):SetHidden(false)	
		hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(true)
	else
		for i = 1, 4 do
			sName = hCaster:GetAbilityByIndex(i-1):GetName()
			hCaster:SwapAbilities(sName, hCaster.tNormalMenuState[i], true, true)
			hCaster:FindAbilityByName(hCaster.tNormalMenuState[i]):SetHidden(false)
			if sName == "ramza_squire_fundamental_stone" then
				hCaster:FindAbilityByName(sName):SetHidden(true)
			else
				hCaster:RemoveAbility(sName)
			end
		end
		
		hCaster:SwapAbilities('ramza_next_page_lua', hCaster.tNormalMenuState[5], true, true)
		hCaster:FindAbilityByName(hCaster.tNormalMenuState[5]):SetHidden(false)
		hCaster:FindAbilityByName('ramza_next_page_lua'):SetHidden(true)
		
		hCaster:AddAbility("ramza_open_stats_lua"):SetLevel(1)	
		hCaster:SwapAbilities("ramza_go_back_lua", "ramza_open_stats_lua", true, true)
		hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(true)
	end
		
	
	hCaster.iMenuState = RAMZA_MENU_STATE_NORMAL 
end

ramza_select_job_lua = class({})
	
function ramza_select_job_lua:OnSpellStart()
	CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetOwner(), "ramza_select_job", nil )
end

ramza_select_secondary_skill_lua = class({})

function ramza_select_secondary_skill_lua:OnSpellStart()
	CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetOwner(), "ramza_select_secondary_skill", nil )
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
			hCaster:SwapAbilities(sName1, sName2, true, true)
		else
			sName2 = 'ramza_empty_'..tostring(i)
			hCaster:AddAbility(sName2)
			hCaster:SwapAbilities(sName1, sName2, true, true)
		end
		if bFromMain or sName1 == "ramza_squire_fundamental_stone" then
			hCaster:FindAbilityByName(sName1):SetHidden(true)
		else
			hCaster:RemoveAbility(sName1)
		end
		
		if not tJobCommandBusRequirement[i+iPointer] or tJobCommandBusRequirement[i+iPointer] <= iLevel then 
			if tJobCommandBusRequirement[i+iPointer] then
				hCaster:FindAbilityByName(sName2):SetLevel(1)
			end
			hCaster:FindAbilityByName(sName2):SetHidden(false)
		end
	end
	if bFromMain then 
		sName1 = hCaster:GetAbilityByIndex(4):GetName()
		hCaster:SwapAbilities(sName1, 'ramza_next_page_lua', true, true)		
		hCaster:FindAbilityByName(sName1):SetHidden(true)
		hCaster:FindAbilityByName('ramza_next_page_lua'):SetHidden(false)
		
		hCaster:SwapAbilities('ramza_open_stats_lua', 'ramza_go_back_lua', true, true)		
		hCaster:RemoveAbility('ramza_open_stats_lua')
		hCaster:FindAbilityByName('ramza_go_back_lua'):SetHidden(false)
	end
end

ramza_next_page_lua = class({})

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






















