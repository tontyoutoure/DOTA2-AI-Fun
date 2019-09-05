LinkLuaModifier('modifier_old_butcher_necrogenesis_ghoul', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_necrogenesis_huntress', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_necrogenesis_tauren', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_necrogenesis_rifleman', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_necrogenesis', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_stitch', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_stitch_visual', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_beetle', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_beetle_burrow', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_rifleman_long_rifles', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_ghoul_ghoul_frenzy', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_tauren_pulverize', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_necrogenesis_talent_manager', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_beetle_burrow_attack', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_autocast_manager', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_fly_evade', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_fly_scepter', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_fly_errosion', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_fly_errosion_debuff', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_butcher_carrion_flies_autocast_manager', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier('modifier_old_butcher_avatar', 'heroes/old_butcher/old_butcher_modifiers.lua', LUA_MODIFIER_MOTION_NONE)


local tClassNotProcNotStealable = {ProcsMagicStick = function (self) return false end, IsStealable = function(self) return false end}
local tClassNotStealable = {IsStealable = function(self) return false end}
local tCorpseType= {'ghoul', 'rifleman', 'tauren', 'huntress'}
local tCorpseTypeReverse= {ghoul = 1, rifleman = 2, tauren = 3, huntress = 4}
local OLD_BUTCHER_LAYOUT_SELECT = 1
local OLD_BUTCHER_LAYOUT_DROP = 2
local tOldButcherUnits = LoadKeyValues('scripts/npc/units/old_butcher.txt')


local tNecrogenesisTextureName = {'old_butcher_ghoul', 'old_butcher_rifleman', 'old_butcher_tauren', 'old_butcher_huntress'}
local tOriginalABilityList = {"old_butcher_stitch", "old_butcher_carrion_beetle", "old_butcher_necrogenesis", "old_butcher_select_corpse", "old_butcher_drop_corpse", "old_butcher_carrion_flies",}

local tClassSummonFromCorpse = {
	CastFilterResult = function (self)
		if IsClient() then return UF_SUCCESS end
		local hCaster = self:GetCaster()
		local fRadius = self:GetSpecialValueFor('radius')
		local tCorpses = Entities:FindAllByNameWithin('npc_dota_thinker', hCaster:GetOrigin(), fRadius)
		for i = #tCorpses, 1, -1 do
			if not tCorpses[i].sCorpseUnitName then
				table.remove(tCorpses, i)
			end
		end
		if hCaster:GetUnitName() == 'npc_dota_old_butcher_carrion_fly' then
			local hMaster = hCaster:GetPlayerOwner():GetAssignedHero()
			if #tCorpses > 0 or ((hCaster:GetOrigin()-hMaster:GetOrigin()):Length2D() < fRadius and hMaster:HasModifier('modifier_old_butcher_necrogenesis_huntress') and (hMaster:FindModifierByName('modifier_old_butcher_necrogenesis_huntress'):GetStackCount() > 0 or hMaster:FindModifierByName('modifier_old_butcher_necrogenesis_ghoul'):GetStackCount() > 0 or hMaster:FindModifierByName('modifier_old_butcher_necrogenesis_rifleman'):GetStackCount() > 0 or hMaster:FindModifierByName('modifier_old_butcher_necrogenesis_tauren'):GetStackCount() > 0))
		then return UF_SUCCESS else return UF_FAIL_CUSTOM end
		else
			if #tCorpses > 0 or (hCaster:HasModifier('modifier_old_butcher_necrogenesis_huntress') and (hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_huntress'):GetStackCount() > 0 or hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_ghoul'):GetStackCount() > 0 or hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_rifleman'):GetStackCount() > 0 or hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_tauren'):GetStackCount() > 0))
		then return UF_SUCCESS else return UF_FAIL_CUSTOM end
		end
	end,
	GetCustomCastError = function (self)
		return 'error_old_butcher_no_corpse'
	end
}

old_butcher_stitch = class(tClassSummonFromCorpse)
function old_butcher_stitch:OnSpellStart()
	local hCaster = self:GetCaster()
	local iCount = self:GetSpecialValueFor('count')
	local tCorpses = Entities:FindAllByNameWithin('npc_dota_thinker', hCaster:GetOrigin(), self:GetSpecialValueFor('radius'))
	if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5') > 0 then
		iCount = iCount*CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5')
	end

	for i = #tCorpses, 1, -1 do
		if not tCorpses[i].sCorpseUnitName then
			table.remove(tCorpses, i)
		end
	end
	table.sort(tCorpses, function (a, b) if a.iMaxHealth > b.iMaxHealth then return true else return false end end)
	
	while iCount > 0 and #tCorpses > 0 do
		local hUnit = CreateUnitByName(tCorpses[1].sCorpseUnitName, tCorpses[1]:GetAbsOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetMaxHealth(tCorpses[1].iMaxHealth)
		hUnit:SetHealth(tCorpses[1].iMaxHealth)
		hUnit:SetBaseDamageMax(tCorpses[1].iBaseDamageMax)
		hUnit:SetBaseDamageMin(tCorpses[1].iBaseDamageMin)
		hUnit:SetPhysicalArmorBaseValue(tCorpses[1].iArmor)
		hUnit:SetMaximumGoldBounty(tCorpses[1].iMaximumGoldBounty)
		hUnit:SetMinimumGoldBounty(tCorpses[1].iMinimumGoldBounty)
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(hCaster:GetForwardVector())
		hUnit:AddNewModifier(hCaster, self, "modifier_old_butcher_stitch", {Duration = self:GetSpecialValueFor("duration")})
		hUnit:AddNewModifier(hCaster, self, "modifier_old_butcher_stitch_visual", {})

		iCount = iCount-1
		UTIL_Remove(tCorpses[1])
		table.remove(tCorpses,1)
		hCaster:EmitSound('DOTA_Item.Necronomicon.Activate')
	end
	if not hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_huntress') then return end
	for i = 4,1,-1 do
		while hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 and iCount > 0 do
			local sUnitName = 'npc_dota_old_butcher_'..tCorpseType[i]
			if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_1') > 0 then
				sUnitName = sUnitName..'2'
			end
			local hUnit = CreateUnitByName(sUnitName, hCaster:GetAbsOrigin()+Vector(RandomFloat(-150,150),RandomFloat(-150,150),0), true, hCaster, hCaster, hCaster:GetTeamNumber())			
			hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
			FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
			hUnit:SetForwardVector(hCaster:GetForwardVector())
			hUnit:AddNewModifier(hCaster, self, "modifier_old_butcher_stitch", {Duration = self:GetSpecialValueFor("duration")})
			hUnit:AddNewModifier(hCaster, self, "modifier_old_butcher_stitch_visual", {})
			hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):DecrementStackCount()
			

			iCount = iCount-1
			hCaster:EmitSound('DOTA_Item.Necronomicon.Activate')
		end
	end
end

old_butcher_carrion_beetle = class(tClassSummonFromCorpse)
function old_butcher_carrion_beetle:GetIntrinsicModifierName()
	return 'modifier_old_butcher_autocast_manager'
end
local RemoveWeakestBeetle = function (hUnit, hAbility)
	local hCaster = hAbility:GetCaster()
	if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_4') > 0 then
		local hAbilityNew = hUnit:AddAbility('old_butcher_carrion_beetle_burrow_attack')
		hAbilityNew:SetLevel(1)
		hAbilityNew:SetHidden(true)
	end
	local iMaxCount = hAbility:GetSpecialValueFor('max_count')
	if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5') > 0 then
		iMaxCount = iMaxCount*CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5')
	end
	hUnit:AddNewModifier(hCaster, hAbility, 'modifier_old_butcher_carrion_beetle', nil)
	hCaster.tBeetles = hCaster.tBeetles or {}
	table.insert(hCaster.tBeetles, hUnit)
	while #(hCaster.tBeetles) > iMaxCount do		
		local hWeakestBeetle = hCaster.tBeetles[1]
		table.remove(hCaster.tBeetles, 1)
		hWeakestBeetle:Kill(hAbility, hCaster)
	end
end

function old_butcher_carrion_beetle:OnSpellStart()
	local hCaster = self:GetCaster()
	local sUnitName = 'npc_dota_old_butcher_carrion_beetle_'..tostring(self:GetLevel())
	local iCount = self:GetSpecialValueFor('count')
	if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5') > 0 then
		iCount = iCount*CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5')
	end
	local tCorpses = Entities:FindAllByNameWithin('npc_dota_thinker', hCaster:GetOrigin(), self:GetSpecialValueFor('radius'))
	for i = #tCorpses, 1, -1 do
		if not tCorpses[i].sCorpseUnitName then
			table.remove(tCorpses, i)
		end
	end
	while iCount > 0 and #tCorpses > 0 do
		local iCorpse = RandomInt(1,#tCorpses)
		local hUnit = CreateUnitByName(sUnitName, tCorpses[iCorpse]:GetOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber())			
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(hCaster:GetForwardVector())
		RemoveWeakestBeetle(hUnit, self)
		UTIL_Remove(tCorpses[iCorpse])
		table.remove(tCorpses, iCorpse)
		hUnit:EmitSound('Hero_NyxAssassin.Vendetta')
		iCount = iCount-1
	end
	for i = 1, 4 do
		while iCount > 0 and hCaster:HasModifier('modifier_old_butcher_necrogenesis_'..tCorpseType[i]) and hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 do			
			local hUnit = CreateUnitByName(sUnitName, hCaster:GetAbsOrigin()+Vector(RandomFloat(-150,150),RandomFloat(-150,150),0), true, hCaster, hCaster, hCaster:GetTeamNumber())			
			hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
			FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
			hUnit:SetForwardVector(hCaster:GetForwardVector())
			hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):DecrementStackCount()
			RemoveWeakestBeetle(hUnit, self)
		hUnit:EmitSound('Hero_NyxAssassin.Vendetta')
			iCount = iCount-1
		end
	end
end

old_butcher_necrogenesis = class({})
function old_butcher_necrogenesis:IsStealable() return false end
function old_butcher_necrogenesis:GetCooldown(iLevel)
	if self.hModifierTalent and not self.hModifierTalent:IsNull() then
		return self.BaseClass.GetCooldown(self, iLevel)/(100+self.hModifierTalent:GetStackCount())*100
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end
function old_butcher_necrogenesis:GetIntrinsicModifierName()
	return 'modifier_old_butcher_necrogenesis'
end

function old_butcher_necrogenesis:GetAbilityTextureName()
	if not self.hModifier or self.hModifier:IsNull() or self.hModifier:GetStackCount() == 0 then
		return 'life_stealer_infest'
	else
		return tNecrogenesisTextureName[self.hModifier:GetStackCount()]
	end
end

function old_butcher_necrogenesis:OnUpgrade()
	if self:GetLevel() == 1 then
		self:GetCaster():FindAbilityByName('old_butcher_select_corpse'):SetLevel(1)
		self:GetCaster():FindAbilityByName('old_butcher_drop_corpse'):SetLevel(1)
	end
end


old_butcher_select_corpse = class(tClassNotProcNotStealable)
function old_butcher_select_corpse:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility('old_butcher_select_ghoul'):SetLevel(1)
	hCaster:SwapAbilities('old_butcher_select_ghoul', 'old_butcher_stitch', true, false)
	
	if hCaster:FindAbilityByName('old_butcher_necrogenesis'):GetLevel() > 1 then
		hCaster:AddAbility('old_butcher_select_rifleman'):SetLevel(1)
		hCaster:SwapAbilities('old_butcher_select_rifleman', 'old_butcher_carrion_beetle', true, false)
	else
		hCaster:AddAbility('old_butcher_empty1'):SetLevel(1)
		hCaster:SwapAbilities('old_butcher_empty1', 'old_butcher_carrion_beetle', true, false)
	end
	
	if hCaster:FindAbilityByName('old_butcher_necrogenesis'):GetLevel() > 2 then
		hCaster:AddAbility('old_butcher_select_tauren'):SetLevel(1)
		hCaster:SwapAbilities('old_butcher_select_tauren', 'old_butcher_necrogenesis', true, false)
	else
		hCaster:AddAbility('old_butcher_empty2'):SetLevel(1)
		hCaster:SwapAbilities('old_butcher_empty2', 'old_butcher_necrogenesis', true, false)
	end
	
	if hCaster:FindAbilityByName('old_butcher_necrogenesis'):GetLevel() > 3 then
	hCaster:AddAbility('old_butcher_select_huntress'):SetLevel(1)
	hCaster:SwapAbilities('old_butcher_select_huntress', 'old_butcher_carrion_flies', true, false)
	else
		hCaster:AddAbility('old_butcher_empty3'):SetLevel(1)
		hCaster:SwapAbilities('old_butcher_empty3', 'old_butcher_carrion_flies', true, false)
	end
	
	hCaster:AddAbility('old_butcher_empty4')
	hCaster:SwapAbilities('old_butcher_empty4', 'old_butcher_drop_corpse', true, false)
	
	hCaster:AddAbility('old_butcher_go_back'):SetLevel(1)
	hCaster:SwapAbilities('old_butcher_go_back', 'old_butcher_select_corpse', true, false)
	hCaster.iLayoutState = OLD_BUTCHER_LAYOUT_SELECT
end

local function GoBack(hHero) 
	local tAbilityName = {}
	for i = 0, 5 do
		tAbilityName[i+1] = hHero:GetAbilityByIndex(i):GetAbilityName()
		hHero:SwapAbilities(tOriginalABilityList[i+1], tAbilityName[i+1], true, false)
		hHero:RemoveAbility(tAbilityName[i+1])
	end
	hHero.iLayoutState = nil
end

old_butcher_select_ghoul = class(tClassNotProcNotStealable)
function old_butcher_select_ghoul:OnSpellStart()
	self:GetCaster():FindModifierByName('modifier_old_butcher_necrogenesis'):SetStackCount(1)
	GoBack(self:GetCaster())
end

old_butcher_select_rifleman = class(tClassNotProcNotStealable)
function old_butcher_select_rifleman:OnSpellStart()
	self:GetCaster():FindModifierByName('modifier_old_butcher_necrogenesis'):SetStackCount(2)
	GoBack(self:GetCaster())
end

old_butcher_select_tauren = class(tClassNotProcNotStealable)
function old_butcher_select_tauren:OnSpellStart()
	self:GetCaster():FindModifierByName('modifier_old_butcher_necrogenesis'):SetStackCount(3)
	GoBack(self:GetCaster())
end

old_butcher_select_huntress = class(tClassNotProcNotStealable)
function old_butcher_select_huntress:OnSpellStart()
	self:GetCaster():FindModifierByName('modifier_old_butcher_necrogenesis'):SetStackCount(4)
	GoBack(self:GetCaster())
end

old_butcher_go_back = class(tClassNotProcNotStealable)
function old_butcher_go_back:OnSpellStart()
	GoBack(self:GetCaster())
end
old_butcher_drop_corpse = class(tClassNotProcNotStealable)

function old_butcher_drop_corpse:CastFilterResult()
	if IsClient() then return UF_SUCCESS end
	local hCaster = self:GetCaster()
	for i = 1, 4 do
		if hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 then
			return UF_SUCCESS
		end
	end
	return UF_FAIL_CUSTOM
end
function old_butcher_drop_corpse:GetCustomCastError()
	return "error_old_butcher_no_corpse"
end

function old_butcher_drop_corpse:OnSpellStart()
	local hCaster = self:GetCaster()
	for i = 1, 4 do
		if hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 then
			hCaster:AddAbility('old_butcher_drop_'..tCorpseType[i]):SetLevel(1)
			hCaster:SwapAbilities('old_butcher_drop_'..tCorpseType[i], tOriginalABilityList[i], true, false)
		else
			hCaster:AddAbility('old_butcher_empty'..tostring(i)):SetLevel(1)
			hCaster:SwapAbilities('old_butcher_empty'..tostring(i), tOriginalABilityList[i], true, false)
		end
	end
	hCaster:AddAbility('old_butcher_go_back'):SetLevel(1)
	hCaster:SwapAbilities('old_butcher_go_back', tOriginalABilityList[5], true, false)
	
	hCaster:AddAbility('old_butcher_drop_all_corpse'):SetLevel(1)
	hCaster:SwapAbilities('old_butcher_drop_all_corpse', tOriginalABilityList[6], true, false)
	hCaster.iLayoutState = OLD_BUTCHER_LAYOUT_DROP
end

local function DropCorpseAt(vPlace, iType, bTalented)	
	local hThinker = CreateModifierThinker(hThinker,nil,'modifier_phased', {Duration = 15},  vPlace,DOTA_TEAM_NEUTRALS, false)
	hThinker.sCorpseUnitName = 'npc_dota_old_butcher_'..tCorpseType[iType]
	if bTalented then hThinker.sCorpseUnitName = hThinker.sCorpseUnitName..'2' end
	hThinker.iMaxHealth = tOldButcherUnits[hThinker.sCorpseUnitName].StatusHealth
	hThinker.iBaseDamageMax = tOldButcherUnits[hThinker.sCorpseUnitName].AttackDamageMax
	hThinker.iBaseDamageMin = tOldButcherUnits[hThinker.sCorpseUnitName].AttackDamageMin
	hThinker.iArmor = tOldButcherUnits[hThinker.sCorpseUnitName].ArmorPhysical
	hThinker.iMaximumGoldBounty = tOldButcherUnits[hThinker.sCorpseUnitName].BountyGoldMax
	hThinker.iMinimumGoldBounty = tOldButcherUnits[hThinker.sCorpseUnitName].BountyGoldMin
	hThinker:SetModel('models/props_bones/bones_tintable_003.vmdl')
	hThinker:SetModelScale(0.5)
end

old_butcher_drop_all_corpse = class(tClassNotStealable)
function old_butcher_drop_all_corpse:OnSpellStart()
	local hCaster = self:GetCaster()
	local tCorpseCount = {}
	local bTalented = (CheckTalent(hCaster, 'special_bonus_unique_old_butcher_1') > 0)
	for i = 1, 4 do
		for j = 1, hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() do
			DropCorpseAt(Vector(RandomFloat(-150, 150), RandomFloat(-150, 150), 0)+hCaster:GetOrigin(), i, bTalented)
		end
		hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):SetStackCount(0)
	end	
	GoBack(self:GetCaster())
end

local tClassDropCorpse = {
OnSpellStart = function (self)
	local hCaster = self:GetCaster()
	local sSelfName = self:GetAbilityName()
	local sCorpseName = string.sub(sSelfName, 18)
	local bTalented = (CheckTalent(hCaster, 'special_bonus_unique_old_butcher_1') > 0)
	local hModifier = hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..sCorpseName)
	hModifier:DecrementStackCount()
	DropCorpseAt(Vector(RandomFloat(-150, 150), RandomFloat(-150, 150), 0)+hCaster:GetOrigin(), tCorpseTypeReverse[sCorpseName], bTalented)
	if hModifier:GetStackCount() == 0 then
		local bNoCorpse = true
		for i = 1, 4 do
			if hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 then
				bNoCorpse = false
			end
		end
		if bNoCorpse then
			GoBack(hCaster)
			return
		end
		hCaster:AddAbility('old_butcher_empty'..tostring(tCorpseTypeReverse[sCorpseName]))
		hCaster:SwapAbilities(sSelfName, 'old_butcher_empty'..tostring(tCorpseTypeReverse[sCorpseName]), false, true)
		hCaster:RemoveAbility(sSelfName)
	end
end, 
IsStealable = function (self) return false end
}

old_butcher_drop_ghoul = class(tClassDropCorpse)
old_butcher_drop_rifleman = class(tClassDropCorpse)
old_butcher_drop_tauren = class(tClassDropCorpse)
old_butcher_drop_huntress = class(tClassDropCorpse)


old_butcher_carrion_beetle_burrow = class({})
function old_butcher_carrion_beetle_burrow:OnAbilityPhaseStart()
	CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "old_butcher_burrow_unburrow", {iEntIndex = self:GetCaster():entindex(), bBurrow = true, iPlayerID = self:GetCaster():GetPlayerOwnerID()} )
	return true
end

function old_butcher_carrion_beetle_burrow:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:SwapAbilities('old_butcher_carrion_beetle_burrow','old_butcher_carrion_beetle_unburrow', false, true)
	hCaster:NotifyWearablesOfModelChange(false)
	
	hCaster:EmitSound('Hero_NyxAssassin.Burrow.In')
	hCaster:AddNewModifier(hCaster, self, 'modifier_old_butcher_carrion_beetle_burrow', nil)
	if hCaster:HasAbility('old_butcher_carrion_beetle_burrow_attack') then
		hCaster:FindAbilityByName('old_butcher_carrion_beetle_burrow_attack'):SetHidden(false)
	end
end

old_butcher_carrion_beetle_unburrow = class({})
function old_butcher_carrion_beetle_unburrow:OnAbilityPhaseStart()
	CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "old_butcher_burrow_unburrow", {iEntIndex = self:GetCaster():entindex(), bBurrow = false, iPlayerID = self:GetCaster():GetPlayerOwnerID()} )
	return true
end
	
function old_butcher_carrion_beetle_unburrow:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:SwapAbilities('old_butcher_carrion_beetle_burrow','old_butcher_carrion_beetle_unburrow', true, false)
	hCaster:NotifyWearablesOfModelChange(true)
	hCaster:EmitSound('Hero_NyxAssassin.Burrow.Out')
	hCaster:RemoveModifierByName('modifier_old_butcher_carrion_beetle_burrow')
	if hCaster:HasAbility('old_butcher_carrion_beetle_burrow_attack') then
		hCaster:FindAbilityByName('old_butcher_carrion_beetle_burrow_attack'):SetHidden(true)
	end
end

old_butcher_rifleman_long_rifles = class({})
function old_butcher_rifleman_long_rifles:GetIntrinsicModifierName() return 'modifier_old_butcher_rifleman_long_rifles' end

old_butcher_ghoul_ghoul_frenzy = class({})
function old_butcher_ghoul_ghoul_frenzy:GetIntrinsicModifierName() return 'modifier_old_butcher_ghoul_ghoul_frenzy' end

old_butcher_tauren_pulverize = class({})
function old_butcher_tauren_pulverize:GetIntrinsicModifierName() return 'modifier_old_butcher_tauren_pulverize' end

old_butcher_carrion_beetle_burrow_attack = class({})
function old_butcher_carrion_beetle_burrow_attack:GetIntrinsicModifierName()
	return 'modifier_old_butcher_carrion_beetle_burrow_attack'
end
function old_butcher_carrion_beetle_burrow_attack:GetAbilityTextureName()
	if self:GetCaster():GetUnitName() == 'npc_dota_old_butcher_carrion_beetle_4' then
		return 'nyx_assassin/immortal_gold/nyx_assassin_impale'
	else		
		return 'nyx_assassin/immortal/nyx_assassin_impale'
	end

end
function old_butcher_carrion_beetle_burrow_attack:GetCastRange()
	return self:GetSpecialValueFor('range')
end
function old_butcher_carrion_beetle_burrow_attack:OnProjectileHit(hTarget, vLocation)
	self:GetCaster():PerformAttack(hTarget, false, true, true, true, false, false, true)
end



old_butcher_carrion_flies = class(tClassSummonFromCorpse)
function old_butcher_carrion_flies:GetIntrinsicModifierName()
	return 'modifier_old_butcher_carrion_flies_autocast_manager'
end
function old_butcher_carrion_flies:GetManaCost(iLevel)
	if self:GetCaster():GetUnitName() == 'npc_dota_old_butcher_carrion_fly' then return self:GetSpecialValueFor('mana_cost_fly') else return self.BaseClass.GetManaCost(self, iLevel) end
end

local function InitFly(hUnit, hAbility, hCaster)
	if hCaster:HasScepter() then
		hUnit:SetMaterialGroup("1")
		hUnit:AddNewModifier(hCaster, hAbility, 'modifier_old_butcher_carrion_fly_scepter', {})
		hUnit:AddNewModifier(hCaster, hAbility, 'modifier_kill', {Duration = hAbility:GetSpecialValueFor('duration_scepter')})			
		hUnit:SetBaseDamageMax(hAbility:GetSpecialValueFor('damage_max_scepter'))
		hUnit:SetBaseDamageMin(hAbility:GetSpecialValueFor('damage_min_scepter'))
		hUnit:SetBaseManaRegen(hAbility:GetSpecialValueFor('mana_regen_scepter'))
	else
		hUnit:SetMaterialGroup("0")
		hUnit:AddNewModifier(hCaster, hAbility, 'modifier_kill', {Duration = hAbility:GetSpecialValueFor('duration')})			
		hUnit:SetBaseDamageMax(hAbility:GetSpecialValueFor('damage_max'))
		hUnit:SetBaseDamageMin(hAbility:GetSpecialValueFor('damage_min'))
		hUnit:SetBaseManaRegen(hAbility:GetSpecialValueFor('mana_regen'))
	end
	hUnit:FindAbilityByName(hAbility:GetName()):SetLevel(hAbility:GetLevel())
	if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_3') > 0 or hCaster:HasAbility('old_butcher_carrion_fly_errosion') then
		hUnit:AddAbility('old_butcher_carrion_fly_errosion'):SetLevel(1)
	end
	local hHero = hCaster:GetPlayerOwner():GetAssignedHero()
	if hHero:FindAbilityByName(hAbility:GetName()).bAutoCast then
		hUnit:FindAbilityByName(hAbility:GetName()):ToggleAutoCast()
	end
end

function old_butcher_carrion_flies:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster
	local iCount = self:GetSpecialValueFor('count')
	if hCaster:GetUnitName() == 'npc_dota_old_butcher_carrion_fly' then
		hMaster = hCaster:GetPlayerOwner():GetAssignedHero()
		if CheckTalent(hMaster, 'special_bonus_unique_old_butcher_5') > 0 then
			iCount = iCount*CheckTalent(hMaster, 'special_bonus_unique_old_butcher_5')
		end
	else
		if CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5') > 0 then
			iCount = iCount*CheckTalent(hCaster, 'special_bonus_unique_old_butcher_5')
		end		
	end
	local tCorpses = Entities:FindAllByNameWithin('npc_dota_thinker', hCaster:GetOrigin(), self:GetSpecialValueFor('radius'))
	for i = #tCorpses, 1, -1 do
		if not tCorpses[i].sCorpseUnitName then
			table.remove(tCorpses, i)
		end
	end
	local sUnitName = 'npc_dota_old_butcher_carrion_fly'
	while iCount > 0 and #tCorpses > 0 do
		local iCorpse = RandomInt(1,#tCorpses)
		local hUnit = CreateUnitByName(sUnitName, tCorpses[iCorpse]:GetOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber())			
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(hCaster:GetForwardVector())
		UTIL_Remove(tCorpses[iCorpse])
		table.remove(tCorpses, iCorpse)
		hUnit:EmitSound('Hero_Weaver.Swarm.Cast')
		InitFly(hUnit, self, hCaster)
		iCount = iCount-1
	end
	for i = 1, 4 do
		if hMaster then
			while iCount > 0 and hMaster:HasModifier('modifier_old_butcher_necrogenesis_'..tCorpseType[i]) and hMaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 do			
				local vPos = Vector(RandomFloat(-150,150),RandomFloat(-150,150),0)+hMaster:GetOrigin()
				local hUnit = CreateUnitByName(sUnitName, vPos, true, hMaster, hMaster, hMaster:GetTeamNumber())			
				hUnit:SetControllableByPlayer(hMaster:GetPlayerOwnerID(), true)
				FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
				hUnit:SetForwardVector(hMaster:GetForwardVector())
				hMaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):DecrementStackCount()
				hUnit:EmitSound('Hero_Weaver.Swarm.Cast')
				InitFly(hUnit, self, hCaster)
				iCount = iCount-1
			end
		else
			while iCount > 0 and hCaster:HasModifier('modifier_old_butcher_necrogenesis_'..tCorpseType[i]) and hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):GetStackCount() > 0 do			
				local vPos = Vector(RandomFloat(-150,150),RandomFloat(-150,150),0)+hCaster:GetOrigin()
				local hUnit = CreateUnitByName(sUnitName, vPos, true, hCaster, hCaster, hCaster:GetTeamNumber())			
				hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
				FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
				hUnit:SetForwardVector(hCaster:GetForwardVector())
				hCaster:FindModifierByName('modifier_old_butcher_necrogenesis_'..tCorpseType[i]):DecrementStackCount()
				hUnit:EmitSound('Hero_Weaver.Swarm.Cast')
				InitFly(hUnit, self, hCaster)
				iCount = iCount-1
			end
		end
	end
end

old_butcher_carrion_fly_evade = class({})
function old_butcher_carrion_fly_evade:GetIntrinsicModifierName()
	return 'modifier_old_butcher_carrion_fly_evade'
end

old_butcher_carrion_fly_errosion = class({})
function old_butcher_carrion_fly_errosion:GetIntrinsicModifierName()
	return 'modifier_old_butcher_carrion_fly_errosion'
end
