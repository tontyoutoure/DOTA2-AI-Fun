--[[ ============================================================================================================
	Author: tontyoutoure
	Date: March 11, 2018
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_quas_instance", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_wex_instance", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_exort_instance", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_talent_tracker", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)


INVOKER_RETRO_WEARABLE_MAGUS_APEX = 2
INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE = 4
INVOKER_RETRO_WEARABLE_MAGUS_APEX_EXTRA = 8
INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE_EXTRA = 16

modifier_invoker_retro_cosmetic_manager = class({})
function modifier_invoker_retro_cosmetic_manager:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_cosmetic_manager:IsHidden() return true end
function modifier_invoker_retro_cosmetic_manager:RemoveOnDeath() return false end
function modifier_invoker_retro_cosmetic_manager:IsPurgable() return false end

function SetAllManagerStackCounts(self)
	local hParent = self:GetParent()
	local hPlayer = hParent:GetPlayerOwner()
	local tChildren = hParent:GetChildren()
	local bDAC = false
	local bMA = false
	for k,child in pairs(tChildren) do
	   if child:GetClassname() == "dota_item_wearable" then
		   if child:GetModelName() == 'models/items/invoker/dark_artistry/dark_artistry_cape_model.vmdl' then
			bDAC = true
		   end
		   if child:GetModelName() == 'models/items/invoker/magus_apex/magus_apex.vmdl' then
			bMA = true
		   end
	   end
	end
	if (hPlayer.tInvokerWearable) then
		if hPlayer.tInvokerWearable.back.id == '7979' then
			bDAC = true
		else
			bDAC = false
		end
		if (hPlayer.tInvokerWearable.head.id == '7986' and hPlayer.tInvokerWearable.head.style == '1') or hPlayer.tInvokerWearable.head.id == '8746' then
			bMA = true
		else
			bMA = false
		end
	end
	if bDAC then 
		self:SetStackCount(bit.bor(self:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE))
	else
		self:SetStackCount(bit.band(self:GetStackCount(), bit.bnot(INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE)))
	end
	if bMA then 
		self:SetStackCount(bit.bor(self:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX))
	else
		self:SetStackCount(bit.band(self:GetStackCount(), bit.bnot(INVOKER_RETRO_WEARABLE_MAGUS_APEX)))
	end
end


function modifier_invoker_retro_cosmetic_manager:OnCreated() 
	if not self:GetAbility() then return end
	self:GetAbility().hModifier = self
	if IsServer() then 
		SetAllManagerStackCounts(self)
	end
	self:StartIntervalThink(0.4)
end
function modifier_invoker_retro_cosmetic_manager:OnIntervalThink() 
	if IsServer() then 
		SetAllManagerStackCounts(self)
	end
end

local tInvokerRetroInvokeList = {
	q = {
		q = {q = "invoker_retro_icy_path", w = "invoker_retro_portal", e = "invoker_retro_frost_nova"},
		w = {q = "invoker_retro_betrayal", w = "invoker_retro_tornado_blast", e = "invoker_retro_levitation"},
		e = {q = "invoker_retro_power_word", w = "invoker_retro_invisibility_aura", e = "invoker_retro_shroud_of_flames"}
	},
	w = {
		q = {q = "invoker_retro_mana_burn", w = "invoker_retro_emp", e = "invoker_retro_soul_blast"},
		w = {q = "invoker_retro_telelightning", w = "invoker_retro_shock", e = "invoker_retro_arcane_arts"},
		e = {q = "invoker_retro_scout", w = "invoker_retro_energy_ball", e = "invoker_retro_lightning_shield"}
	},
	e = {
		q = {q = "invoker_retro_chaos_meteor", w = "invoker_retro_confuse", e = "invoker_retro_disarm"},
		w = {q = "invoker_retro_soul_reaver", w = "invoker_retro_firestorm", e = "invoker_retro_incinerate"},
		e = {q = "invoker_retro_deafening_blast", w = "invoker_retro_inferno", e = "invoker_retro_firebolt"}
	}
}

local tPersistAbilities = {invoker_retro_tornado_blast = true, invoker_retro_firebolt = true, invoker_retro_shroud_of_flames = true} -- should not be removed
local tPassiveABilities = {invoker_retro_invisibility_aura = true, invoker_retro_arcane_arts = true}

local tOrbColors = {invoker_retro_quas =Vector(0, 140, 244), invoker_retro_wex = Vector(212,87,220)*0.95, invoker_retro_exort = Vector(255, 182, 0)}
local tOrbsShort = {invoker_retro_quas = 'q', invoker_retro_wex = 'w', invoker_retro_exort = 'e'}
local tOriginalAbilities = {invoker_retro_quas = true, invoker_retro_wex = true, invoker_retro_exort = true, invoker_retro_empty1 = true, invoker_retro_empty2 = true, invoker_retro_invoke = true}

modifier_invoker_retro_talent_tracker = class({})
function modifier_invoker_retro_talent_tracker:IsPurgable() return false end
function modifier_invoker_retro_talent_tracker:IsHidden() return true end
function modifier_invoker_retro_talent_tracker:RemoveOnDeath() return false end
function modifier_invoker_retro_talent_tracker:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,MODIFIER_EVENT_ON_DEATH
	} 
end

local tInvokerUtilAbilities = {invoker_retro_invoke = true, invoker_retro_quas = true, invoker_retro_wex = true, invoker_retro_exort = true}
function modifier_invoker_retro_talent_tracker:OnDeath(keys)
	if keys.attacker == self:GetParent() and keys.attacker:FindAbilityByName('special_bonus_unique_invoker_retro_6'):GetLevel() > 0 and keys.unit:IsRealHero() and not keys.reincarnate and keys.attacker.tInvokerRetroReadyTime then
		for k, v in pairs(keys.attacker.tInvokerRetroReadyTime) do
			keys.attacker.tInvokerRetroReadyTime[k] = -100;
		end
		for i = 0,23 do 
			if keys.attacker:GetAbilityByIndex(i) then
				keys.attacker:GetAbilityByIndex(i):EndCooldown()
			end
		end
		keys.attacker:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker), 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
	end
end
function modifier_invoker_retro_talent_tracker:OnAbilityExecuted(keys) 
	if keys.unit ~= self:GetParent() then return end
	if string.find(keys.ability:GetName(), 'invoker_retro') and not tInvokerUtilAbilities[keys.ability:GetName()] then
		local iIndex = keys.ability:entindex()
		Timers:CreateTimer(0.03, function ()
			keys.unit.tInvokerRetroReadyTime[EntIndexToHScript(iIndex):GetName()] = GameRules:GetGameTime()+EntIndexToHScript(iIndex):GetCooldownTimeRemaining()
		end)
	end
	if keys.ability:GetName() == 'item_refresher' or keys.ability:GetName() == 'item_refresher_shard' and keys.unit.tInvokerRetroReadyTime then

		for k, v in pairs(keys.unit.tInvokerRetroReadyTime) do
			keys.unit.tInvokerRetroReadyTime[k] = -100
		end
	end
	
	
	if bit.band(keys.ability:GetBehavior(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) > 0 and RandomFloat(0,100) < keys.unit:FindAbilityByName('special_bonus_unique_invoker_retro_5'):GetSpecialValueFor('value') then
		local fRange = keys.ability:GetCastRange(Vector(0,0,0),nil)+keys.unit:GetCastRangeBonus()
		local tTargets = FindUnitsInRadius(keys.unit:GetTeam(), keys.unit:GetOrigin(), nil, fRange, keys.ability:GetAbilityTargetTeam(), keys.ability:GetAbilityTargetType(), keys.ability:GetAbilityTargetFlags()+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		local hTarget
		local iRandom = RandomInt(1, #tTargets)
		if tTargets[iRandom] == keys.target then
			table.remove(tTargets,iRandom)
			if #tTargets > 0 then
				hTarget=tTargets[RandomInt(1, #tTargets)]
			else
				return 
			end
		else
			hTarget=tTargets[iRandom]
		end
		if hTarget then
			local multUnit = CreateUnitByName('npc_multicast', keys.unit:GetOrigin(), false, keys.unit, keys.unit, keys.unit:GetTeamNumber())
			multUnit.iQuasLevel = keys.unit.iQuasLevel
			multUnit.iWexLevel = keys.unit.iWexLevel
			multUnit.iExortLevel = keys.unit.iExortLevel
			multUnit.hDummyMaster = keys.unit
			if keys.unit:HasScepter() then multUnit:AddNewModifier(multUnit, nil, 'modifier_item_ultimate_scepter_consumed', {}) end
			local hAbilityMulti = multUnit:AddAbility(keys.ability:GetName())
			hAbilityMulti:SetLevel(1)
			multUnit:SetControllableByPlayer(keys.unit:GetPlayerOwnerID(), true)
			local iParticle=ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, keys.unit)
			ParticleManager:SetParticleControl(iParticle, 1, Vector(2,1,0))
			keys.unit:EmitSound('Hero_OgreMagi.Fireblast.x2')
			Timers:CreateTimer(0.04, function()
				multUnit:CastAbilityOnTarget(hTarget, hAbilityMulti, keys.unit:GetPlayerOwnerID())
			end)
			
			Timers:CreateTimer(15, function() 
				multUnit:RemoveSelf() 
			end)
		end
	end
end
function modifier_invoker_retro_talent_tracker:OnCreated()
	self:GetAbility().hModifier = self
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_talent_tracker:OnIntervalThink()
	if IsClient() then return end
	self:SetStackCount(self:GetParent():FindAbilityByName('special_bonus_unique_invoker_retro_1'):GetSpecialValueFor('value'))
end


invoker_retro_invoke = class({})
function invoker_retro_invoke:GetIntrinsicModifierName() return 'modifier_invoker_retro_talent_tracker' end
function invoker_retro_invoke:OnHeroLevelUp()
	local hCaster = self:GetCaster()
	if hCaster:GetLevel() == 6 then
		self:SetLevel(1)
	end
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+self.AttributeStrengthGain-hCaster:GetStrengthGain())
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+self.AttributeAgilityGain-hCaster:GetAgilityGain())
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+self.AttributeIntelligenceGain-hCaster:GetIntellectGain())	
end

function invoker_retro_invoke:GetCooldown(num)
	local iTalentReduction = 0
	if self.hModifier and not self.hModifier:IsNull() then iTalentReduction = self.hModifier:GetStackCount() end
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 2-iTalentReduction
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)-iTalentReduction
		end
	end
	
	return self.BaseClass.GetCooldown(self, num)-iTalentReduction
end
function invoker_retro_invoke:IsStealable() return false end
function invoker_retro_invoke:IsHiddenWhenStolen() return true end
-- Update orb level for all abilities
local function UpdateInvokerRetroOrbScepter(hInvoker)
	if not hInvoker:FindAbilityByName("invoker_retro_quas") or not hInvoker:FindAbilityByName("invoker_retro_wex") or not hInvoker:FindAbilityByName("invoker_retro_exort") then return end
	local iQuasLevel = hInvoker:FindAbilityByName("invoker_retro_quas"):GetLevel()
	local iWexLevel = hInvoker:FindAbilityByName("invoker_retro_wex"):GetLevel()
	local iExortLevel = hInvoker:FindAbilityByName("invoker_retro_exort"):GetLevel()
	if hInvoker:HasScepter() then
		hInvoker:GetAbilityByIndex(4):SetHidden(false)
	else		
		hInvoker:GetAbilityByIndex(4):SetHidden(true)
	end
	local iTalentValue = hInvoker:FindAbilityByName('special_bonus_unique_invoker_retro_2'):GetSpecialValueFor('value')
	hInvoker.iQuasLevel = iQuasLevel+iTalentValue
	hInvoker.iWexLevel = iWexLevel+iTalentValue
	hInvoker.iExortLevel = iExortLevel+iTalentValue
	hInvoker.iTalentValue = iTalentValue
	CustomNetTables:SetTableValue("invoker_retro", "orb_level_"..tostring(hInvoker:entindex()), {iQuasLevel = iQuasLevel, iWexLevel = iWexLevel, iExortLevel = iExortLevel, iTalentValue = iTalentValue})
	Timers:CreateTimer(0.04, function () CustomGameEventManager:Send_ServerToAllClients( "invoker_scepter_state_change", {entindex = hInvoker:entindex()}) end)
end

function invoker_retro_invoke:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster.tInvokerRetroReadyTime = hCaster.tInvokerRetroReadyTime or {}
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_invoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	hCaster:EmitSound("Hero_Invoker.Invoke")
	if hCaster.invoked_orbs and hCaster.invoked_orbs[1] and hCaster.invoked_orbs[2] and hCaster.invoked_orbs[3] then
		ParticleManager:SetParticleControl(iParticle, 2, (tOrbColors[hCaster.invoked_orbs[1]:GetAbilityName()]+tOrbColors[hCaster.invoked_orbs[2]:GetAbilityName()]+tOrbColors[hCaster.invoked_orbs[3]:GetAbilityName()])/3)
	else
		return
	end
	local sAbilityToInvoke = tInvokerRetroInvokeList[tOrbsShort[hCaster.invoked_orbs[1]:GetAbilityName()]][tOrbsShort[hCaster.invoked_orbs[2]:GetAbilityName()]][tOrbsShort[hCaster.invoked_orbs[3]:GetAbilityName()]]
	local hAbility
	if not hCaster:HasAbility(sAbilityToInvoke) then
		hAbility = hCaster:AddAbility(sAbilityToInvoke)
		hAbility:SetLevel(1)
		
--		if hCaster.tInvokerRetroReadyTime then	print(hAbility:GetName(),  GameRules:GetGameTime(), hCaster.tInvokerRetroReadyTime[sAbilityToInvoke]) end
		if hCaster.tInvokerRetroReadyTime[sAbilityToInvoke] and GameRules:GetGameTime() > hCaster.tInvokerRetroReadyTime[sAbilityToInvoke] then
			hAbility:EndCooldown()
		end
		UpdateInvokerRetroOrbScepter(hCaster)
	else
		hAbility = hCaster:FindAbilityByName(sAbilityToInvoke)
	end
	local sAbility3Name = hCaster:GetAbilityByIndex(3):GetName()
	local sAbility4Name = hCaster:GetAbilityByIndex(4):GetName()
	
	if sAbilityToInvoke == sAbility3Name then
		self:EndCooldown()
		return
	elseif sAbilityToInvoke == sAbility4Name then
		if hCaster:HasScepter() then
			self:EndCooldown()
			hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, true)
			return
		else
			hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, false)
			return
		end
	end
	
	hCaster:SwapAbilities(sAbilityToInvoke, sAbility4Name, true, false)
	if not tPersistAbilities[sAbility4Name] then
		hCaster:RemoveAbility(sAbility4Name)
		if tPassiveABilities[sAbility4Name] then
			for i, v in ipairs(hCaster:FindAllModifiers()) do
				if string.match(v:GetName(), sAbility4Name) then
					v:Destroy()
				end
			end
		end
	end
	if hCaster:HasScepter() then		
		hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, true)	
	else
		hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, false)	
	end	
end

modifier_invoker_retro_manager = class({})
function modifier_invoker_retro_manager:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_EXECUTED} end
function modifier_invoker_retro_manager:OnAbilityExecuted(keys)
	if keys.target == self:GetParent() and (keys.ability:GetName() == "rubick_spell_steal" or keys.ability:GetName() == "morphling_replicate") then

		if keys.target:GetName() == 'npc_dota_hero_invoker' then
			keys.unit.iQuasLevel = keys.target.iQuasLevel-keys.target.iTalentValue
			keys.unit.iWexLevel = keys.target.iWexLevel-keys.target.iTalentValue
			keys.unit.iExortLevel = keys.target.iExortLevel-keys.target.iTalentValue
		else
			keys.unit.iQuasLevel = keys.target.iQuasLevel
			keys.unit.iWexLevel = keys.target.iWexLevel
			keys.unit.iExortLevel = keys.target.iExortLevel
		end
		keys.unit:AddNewModifier(keys.unit, nil, 'modifier_invoker_retro_manager', {})
	end
end
function modifier_invoker_retro_manager:IsHidden() return true end
function modifier_invoker_retro_manager:IsPurgable() return false end
function modifier_invoker_retro_manager:RemoveOnDeath() return false end
function modifier_invoker_retro_manager:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:GetName() ~= 'npc_dota_hero_invoker' then return end
	self.iCount = 0
	self.bPreviousScepter = hParent:HasScepter()
	UpdateInvokerRetroOrbScepter(hParent)
	self:StartIntervalThink(0.04)
end

function modifier_invoker_retro_manager:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iCount = self.iCount+1
	if hParent:HasScepter() and not self.bPreviousScepter or not hParent:HasScepter() and self.bPreviousScepter or self.iCount == 10 then
		self.bPreviousScepter = hParent:HasScepter()
		UpdateInvokerRetroOrbScepter(hParent)
	end
	self:SetStackCount(hParent.iQuasLevel*64+hParent.iWexLevel*8+hParent.iExortLevel)
end


invoker_retro_quas = class({})
invoker_retro_wex = class({})
invoker_retro_exort = class({})
function invoker_retro_quas:IsStealable() return false end
function invoker_retro_wex:IsStealable() return false end
function invoker_retro_exort:IsStealable() return false end
function invoker_retro_quas:IsHiddenWhenStolen() return false end
function invoker_retro_wex:IsHiddenWhenStolen() return false end
function invoker_retro_exort:IsHiddenWhenStolen() return false end
function invoker_retro_quas:ProcsMagicStick() return false end
function invoker_retro_wex:ProcsMagicStick() return false end
function invoker_retro_exort:ProcsMagicStick() return false end

function invoker_retro_quas:GetIntrinsicModifierName() return "modifier_invoker_retro_cosmetic_manager" end
function invoker_retro_wex:GetIntrinsicModifierName() return "modifier_invoker_retro_cosmetic_manager" end
function invoker_retro_exort:GetIntrinsicModifierName() return "modifier_invoker_retro_cosmetic_manager" end

function invoker_retro_quas:GetAbilityTextureName() 
	if self.hModifier and not self.hModifier:IsNull() and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE+INVOKER_RETRO_WEARABLE_MAGUS_APEX) == INVOKER_RETRO_WEARABLE_MAGUS_APEX then
		return "invoker/magus_apex/invoker_quas"
	else
		return "invoker_quas"
	end
end

function invoker_retro_wex:GetAbilityTextureName() 
	if self.hModifier and not self.hModifier:IsNull() and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE+INVOKER_RETRO_WEARABLE_MAGUS_APEX) == INVOKER_RETRO_WEARABLE_MAGUS_APEX then
		return "invoker/magus_apex/invoker_wex"
	else
		return "invoker_wex"
	end
end

function invoker_retro_exort:GetAbilityTextureName() 
	if self.hModifier and not self.hModifier:IsNull() and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE+INVOKER_RETRO_WEARABLE_MAGUS_APEX) == INVOKER_RETRO_WEARABLE_MAGUS_APEX then
		return "invoker/magus_apex/invoker_exort"
	else
		return "invoker_exort"
	end
end


function invoker_retro_quas:OnSpellStart()
	if self:GetCaster():GetUnitName() ~= "npc_dota_hero_invoker" then return end
	local hCaster = self:GetCaster()
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf")
	elseif self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf")
	else
		invoker_retro_replace_orb(hCaster, self, "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf")
	end
	invoker_retro_orb_replace_modifiers(hCaster)
end

function invoker_retro_wex:OnSpellStart()
	if self:GetCaster():GetUnitName() ~= "npc_dota_hero_invoker" then return end
	local hCaster = self:GetCaster()
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf")
	elseif self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf")
	else
		invoker_retro_replace_orb(hCaster, self, "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf")
	end	
	invoker_retro_orb_replace_modifiers(hCaster) 
end

function invoker_retro_exort:OnSpellStart()
	if self:GetCaster():GetUnitName() ~= "npc_dota_hero_invoker" then return end
	local hCaster = self:GetCaster()
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf")
	elseif self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf")
	else
		invoker_retro_replace_orb(hCaster, self, "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf")
	end	
	invoker_retro_orb_replace_modifiers(hCaster) 
end

function InvokerRetroOrbOnUpgrade(self)
	local hCaster = self:GetCaster()
	UpdateInvokerRetroOrbScepter(hCaster)
	if hCaster:GetUnitName() ~= "npc_dota_hero_invoker" then return end
	invoker_retro_orb_replace_modifiers(hCaster) 
end

invoker_retro_quas.OnUpgrade = InvokerRetroOrbOnUpgrade
invoker_retro_wex.OnUpgrade = InvokerRetroOrbOnUpgrade
invoker_retro_exort.OnUpgrade = InvokerRetroOrbOnUpgrade

function InvokerRetroOrbOnOwnerSpawned(self)
	local hCaster = self:GetCaster()
	invoker_retro_orb_replace_modifiers(hCaster) 
end

invoker_retro_quas.OnOwnerSpawned = InvokerRetroOrbOnOwnerSpawned
invoker_retro_wex.OnOwnerSpawned = InvokerRetroOrbOnOwnerSpawned
invoker_retro_exort.OnOwnerSpawned = InvokerRetroOrbOnOwnerSpawned

modifier_invoker_retro_quas_instance = class({})
modifier_invoker_retro_wex_instance = class({})
modifier_invoker_retro_exort_instance = class({})
function modifier_invoker_retro_quas_instance:IsPurgable() return false end
function modifier_invoker_retro_quas_instance:RemoveOnDeath() return false end
function modifier_invoker_retro_quas_instance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_quas_instance:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_invoker_retro_quas_instance:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_percent_per_instance") end
function modifier_invoker_retro_wex_instance:IsPurgable() return false end
function modifier_invoker_retro_wex_instance:RemoveOnDeath() return false end
function modifier_invoker_retro_wex_instance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_wex_instance:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_invoker_retro_wex_instance:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("move_speed_percent_per_instance") end
function modifier_invoker_retro_exort_instance:IsPurgable() return false end
function modifier_invoker_retro_exort_instance:RemoveOnDeath() return false end
function modifier_invoker_retro_exort_instance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_exort_instance:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end
function modifier_invoker_retro_exort_instance:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("bonus_health_regen_per_instance") end



--[[ ============================================================================================================
	Author: Rook
	Revised: tontyoutoure
	Date: February 15, 2015
	Removes the third-to-most-recent orb created (if applicable) to make room for the newest orb.
================================================================================================================= ]]
function invoker_retro_replace_orb(hInvoker, hAbility, particle_filepath)
	--Initialization, if not already done.
	if hInvoker.invoked_orbs == nil then
		hInvoker.invoked_orbs = {}
	end
	if hInvoker.invoked_orbs_particle == nil then
		hInvoker.invoked_orbs_particle = {}
	end
	if hInvoker.invoked_orbs_particle_attach == nil then
		hInvoker.invoked_orbs_particle_attach = {}
		hInvoker.invoked_orbs_particle_attach[1] = "attach_orb1"
		hInvoker.invoked_orbs_particle_attach[2] = "attach_orb2"
		hInvoker.invoked_orbs_particle_attach[3] = "attach_orb3"
	end
	
	--Invoker can only have three orbs active at any time.  Each time an orb is activated, its hscript is
	--placed into hInvoker.invoked_orbs[3], the old [3] is moved into [2], and the old [2] is moved into [1].
	--Therefore, the oldest orb is located in [1], and the newest is located in [3].
	--Shift the ordered list of currently summoned orbs down.
	hInvoker.invoked_orbs[1] = hInvoker.invoked_orbs[2]
	hInvoker.invoked_orbs[2] = hInvoker.invoked_orbs[3]
	hInvoker.invoked_orbs[3] = hAbility
	
	--Remove the removed orb's particle effect.
	if hInvoker.invoked_orbs_particle[1] ~= nil then
		ParticleManager:DestroyParticle(hInvoker.invoked_orbs_particle[1], false)
		hInvoker.invoked_orbs_particle[1] = nil
	end
	
	--Shift the ordered list of currently summoned orb particle effects down, and create the new particle.
	hInvoker.invoked_orbs_particle[1] = hInvoker.invoked_orbs_particle[2]
	hInvoker.invoked_orbs_particle[2] = hInvoker.invoked_orbs_particle[3]
	hInvoker.invoked_orbs_particle[3] = ParticleManager:CreateParticle(particle_filepath, PATTACH_CUSTOMORIGIN_FOLLOW, hInvoker)
	ParticleManager:SetParticleControlEnt(hInvoker.invoked_orbs_particle[3], 0, hInvoker, PATTACH_POINT_FOLLOW, "attach_hitloc", hInvoker:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(hInvoker.invoked_orbs_particle[3], 1, hInvoker, PATTACH_POINT_FOLLOW, hInvoker.invoked_orbs_particle_attach[1], hInvoker:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(hInvoker.invoked_orbs_particle[3], 2, hInvoker, PATTACH_POINT_FOLLOW, "attach_hitloc", hInvoker:GetAbsOrigin(), false)
	
	--Shift the ordered list of currently summoned orb particle effect attach locations down.
	local temp_attachment_point = hInvoker.invoked_orbs_particle_attach[1]
	hInvoker.invoked_orbs_particle_attach[1] = hInvoker.invoked_orbs_particle_attach[2]
	hInvoker.invoked_orbs_particle_attach[2] = hInvoker.invoked_orbs_particle_attach[3]
	hInvoker.invoked_orbs_particle_attach[3] = temp_attachment_point
	
	 --Remove and reapply the orb instance modifiers.
	if RandomFloat(0,1)>0.5 then
		StartAnimation(hInvoker, {duration=0.5, activity=ACT_DOTA_OVERRIDE_ABILITY_1})
	else
		StartAnimation(hInvoker, {duration=0.5, activity=ACT_DOTA_OVERRIDE_ABILITY_2})
	end
end


--[[ ============================================================================================================
	Author: Rook
	Revised: tontyoutoure
	Date: February 15, 2015
	Called when Quas, Wex, or Exort is cast or upgraded.  Replaces the modifiers on the caster's modifier bar to
	ensure the correct order, which also has the effect of leveling the effects of any currently existing orbs.
================================================================================================================= ]]
function invoker_retro_orb_replace_modifiers(hInvoker)
	if hInvoker.invoked_orbs == nil then
		hInvoker.invoked_orbs = {}
	end
	--Reapply all the orbs Invoker has out in order to benefit from the upgraded ability's level.  By reapplying all
	--three orb modifiers, they will maintain their order on the modifier bar (so long as all are removed before any
	--are reapplied, since ordering problems arise there are two of the same type of orb otherwise).
	hInvoker:RemoveModifierByName("modifier_invoker_retro_quas_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_quas_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_quas_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_wex_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_wex_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_wex_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_exort_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_exort_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_exort_instance")
	for i=1, 3 do
		if hInvoker.invoked_orbs[i] ~= nil then
			local orb_name = hInvoker.invoked_orbs[i]:GetName()
			if orb_name == "invoker_retro_quas" then
				hInvoker:AddNewModifier(hInvoker, hInvoker:FindAbilityByName("invoker_retro_quas"), "modifier_invoker_retro_quas_instance", {})
			elseif orb_name == "invoker_retro_wex" then
				hInvoker:AddNewModifier(hInvoker, hInvoker:FindAbilityByName("invoker_retro_wex"), "modifier_invoker_retro_wex_instance", {})
			elseif orb_name == "invoker_retro_exort" then
				hInvoker:AddNewModifier(hInvoker, hInvoker:FindAbilityByName("invoker_retro_exort"), "modifier_invoker_retro_exort_instance", {})
			end
		end
	end 
end

if IsServer() then
	InvokerRetroTalentManager = function(keys)
		if PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero():GetName() ~= "npc_dota_hero_invoker" then return end
		if keys.abilityname == "special_bonus_unique_invoker_retro_2" then
			UpdateInvokerRetroOrbScepter(PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero())
		end
	end
	ListenToGameEvent( "dota_player_learned_ability", InvokerRetroTalentManager, nil )
end