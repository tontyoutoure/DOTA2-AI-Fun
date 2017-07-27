ramza_open_stats_lua = class({})

function ramza_open_stats_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster.tNormalHudState = hCaster.tNormalHudState or {}
	for i = 1, 5 do
		hCaster.tNormalHudState[i] = hCaster:GetAbilityByIndex(i-1):GetName()
	end
	
	
	hCaster:SwapAbilities(hCaster.tNormalHudState[1], "ramza_select_job_lua", true, true)
	hCaster:FindAbilityByName(hCaster.tNormalHudState[1]):SetHidden(true)		
	hCaster:FindAbilityByName("ramza_select_job_lua"):SetHidden(false)
	
	if hCaster.tNormalHudState[2] ~= "ramza_select_secondary_skill_lua" then
		hCaster:SwapAbilities(hCaster.tNormalHudState[2], "ramza_select_secondary_skill_lua", true, true)
		hCaster:FindAbilityByName(hCaster.tNormalHudState[2]):SetHidden(true)		
		hCaster:FindAbilityByName("ramza_select_secondary_skill_lua"):SetHidden(false)
	end
		
	hCaster:SwapAbilities(hCaster.tNormalHudState[3], "ramza_bravery", true, true)
	hCaster:SwapAbilities(hCaster.tNormalHudState[4], "ramza_speed", true, true)
	hCaster:SwapAbilities(hCaster.tNormalHudState[5], "ramza_faith", true, true)
	hCaster:SwapAbilities("ramza_open_stats_lua", "ramza_go_back_lua", true, true)
	
	hCaster:FindAbilityByName(hCaster.tNormalHudState[3]):SetHidden(true)
	hCaster:FindAbilityByName(hCaster.tNormalHudState[4]):SetHidden(true)
	hCaster:FindAbilityByName(hCaster.tNormalHudState[5]):SetHidden(true)
	hCaster:FindAbilityByName("ramza_open_stats_lua"):SetHidden(true)
	
	hCaster:FindAbilityByName("ramza_bravery"):SetHidden(false)
	hCaster:FindAbilityByName("ramza_speed"):SetHidden(false)
	hCaster:FindAbilityByName("ramza_faith"):SetHidden(false)
	hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(false)
end

function ramza_open_stats_lua:OnHeroLevelUp()	
	local hCaster = self:GetCaster()
	local iLevel = hCaster:GetLevel()
	if iLevel == 17 or iLevel == 19 or iLevel == 21 or iLevel == 22 or iLevel == 23 or iLevel ==24 then
		hCaster:SetAbilityPoints(hCaster:GetAbilityPoints()+1)
	end
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+hCaster:FindModifierByName("modifier_attribute_growth_str").fGrowth)
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+hCaster:FindModifierByName("modifier_attribute_growth_agi").fGrowth)
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+hCaster:FindModifierByName("modifier_attribute_growth_int").fGrowth)
end

ramza_go_back_lua = class({})

function ramza_go_back_lua:OnSpellStart()	
	local hCaster = self:GetCaster()
	local tCurrentHudState = {}
	for i = 1, 5 do
		tCurrentHudState[i] = hCaster:GetAbilityByIndex(i-1):GetName()
		if tCurrentHudState[i] ~= hCaster.tNormalHudState[i] then
			hCaster:SwapAbilities(tCurrentHudState[i], hCaster.tNormalHudState[i], true, true)
			hCaster:FindAbilityByName(tCurrentHudState[i]):SetHidden(true)
			hCaster:FindAbilityByName(hCaster.tNormalHudState[i]):SetHidden(false)			
		end
	end
	
	hCaster:SwapAbilities("ramza_go_back_lua", "ramza_open_stats_lua", true, true)
	hCaster:FindAbilityByName("ramza_open_stats_lua"):SetHidden(false)	
	hCaster:FindAbilityByName("ramza_go_back_lua"):SetHidden(true)
end

ramza_select_job_lua = class({})
	
function ramza_select_job_lua:OnSpellStart()
	CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetOwner(), "ramza_select_job", nil )
end

ramza_select_secondary_skill_lua = class({})

function ramza_select_secondary_skill_lua:OnSpellStart()
	CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetOwner(), "ramza_select_secondary_skill", nil )
end



ramza_job_squire_PA = class({})






















