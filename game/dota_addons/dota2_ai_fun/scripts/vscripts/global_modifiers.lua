require('bot_item_data')



local tClassFTF = {
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return true end,
	RemoveOnDeath = function(self) return false end,
}
local tClassFFF = {
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return false end,
	RemoveOnDeath = function(self) return false end,
}

modifier_global_hero_respawn_time = class(tClassFTF)
function modifier_global_hero_respawn_time:OnCreated()
	self.fBuyBackExtraRespawnTime = 0
	self:StartIntervalThink(0.04)
	if IsClient() then return end
	if self:GetParent():IsIllusion() then self:Destroy() end
end
function modifier_global_hero_respawn_time:OnIntervalThink()
	if self:GetParent():IsIllusion() then self:Destroy() end
	if IsClient() then return end
	if self.bBB then
		self.bBB = false
		self:GetParent():SetBuybackCooldownTime(GameMode.iBuybackCooldown)
	end
	if self:GetParent():IsAlive() then return end
	self.fRespawnTime = self:GetParent():GetTimeUntilRespawn()

end

function modifier_global_hero_respawn_time:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH, MODIFIER_EVENT_ON_RESPAWN}
end

function modifier_global_hero_respawn_time:OnRespawn(keys)
	if keys.unit ~= self:GetParent() then return end 
	if self.fRespawnTime > 0.04 then
		self.fBuyBackExtraRespawnTime = 25
		self.bBB = true
	end
	self.bRespawnTimeReset = false
end

local CalculateLevelRespawnTime = function (iLevel)
	local tDOTARespawnTime = {12, 15, 18, 21, 24, 26, 28, 30, 32, 34, 36, 44, 46, 48, 50, 52, 54, 65, 70, 75, 80, 85, 90, 95, 100}
	if iLevel <= 25 then return tDOTARespawnTime[iLevel] end
	return iLevel*4
end

function modifier_global_hero_respawn_time:OnDeath(keys)
	if (keys.unit ~= self:GetParent() and keys.unit:GetCloneSource() ~= self:GetParent()) or keys.reincarnate then return end

	local iRespawnTime = CalculateLevelRespawnTime(self:GetParent():GetLevel())
	
	if keys.unit:FindModifierByName('modifier_necrolyte_reapers_scythe') then
		iRespawnTime = iRespawnTime+keys.unit:FindModifierByName('modifier_necrolyte_reapers_scythe'):GetAbility():GetSpecialValueFor("respawn_constant")
	end
	
	self:GetParent():SetTimeUntilRespawn(GameMode.iRespawnTimePercentage/100*(iRespawnTime+self.fBuyBackExtraRespawnTime))
end

modifier_imbalanced_economizer = class(tClassFTF)

modifier_bot_attack_tower_pick_rune = class(tClassFTF)

function modifier_bot_attack_tower_pick_rune:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end

function modifier_bot_attack_tower_pick_rune:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local tTowers = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

-- has enough health and has tower/watch tower nearby and no enemy nearby
	if hParent:GetHealth()/hParent:GetMaxHealth() > 0.3 and tTowers[1] and not FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)[1] then
		if self.hTarget == tTowers[1] or hParent:IsCommandRestricted() then return end
		self.hTarget = tTowers[1]
		if string.find(self.hTarget:GetName(), 'watch_tower') then
			local tOrder = 
				{
					UnitIndex = hParent:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = hParent:FindAbilityByName('ability_capture'):entindex(),
					TargetIndex = self.hTarget:entindex()
				}
			ExecuteOrderFromTable(tOrder)
			self.bSentCommand = true
		elseif FindUnitsInRadius(tTowers[1]:GetTeam(), tTowers[1]:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)[1]  then
			local tOrder = 
				{
					UnitIndex = hParent:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = self.hTarget:entindex()
				}
			hParent:SetForceAttackTarget(nil)
			ExecuteOrderFromTable(tOrder)
			self.bSentCommand = true
			hParent:SetForceAttackTarget(self.hTarget)
		end
	elseif Entities:FindAllByClassnameWithin("dota_item_rune", hParent:GetOrigin(), 500)[1] then
		local hRune = Entities:FindAllByClassnameWithin("dota_item_rune", hParent:GetOrigin(), 500)[1]
		local tOrder = 
		{
			UnitIndex = hParent:entindex(),
			OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
			TargetIndex = hRune:entindex()
		}
		ExecuteOrderFromTable(tOrder)		
	elseif self.bSentCommand then	
		hParent:SetForceAttackTarget(nil)
		self.bSentCommand = false
		self.hTarget = nil
	end
end
function modifier_bot_attack_tower_pick_rune:CheckState()
	return {[MODIFIER_STATE_COMMAND_RESTRICTED] = self.bSentCommand}
end
modifier_tower_endure = class({})

function modifier_tower_endure:IsPurgable() return false end
function modifier_tower_endure:IsDebuff() return false end
function modifier_tower_endure:GetTexture() return "tower_endure" end
function modifier_tower_endure:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	local iHealth = hParent:GetMaxHealth()	
	Timers:CreateTimer(0.04, function ()
		hParent:SetMaxHealth(self:GetStackCount()*iHealth)
		hParent:SetBaseMaxHealth(self:GetStackCount()*iHealth)
		hParent:SetHealth(self:GetStackCount()*iHealth)
	end)
end

function modifier_tower_endure:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_tower_endure:GetModifierConstantHealthRegen()
	return 10*(self:GetStackCount()-1)
end

function modifier_tower_endure:GetModifierPhysicalArmorBonus()	
	local sName = self:GetParent():GetName()
	
	if string.match(sName, "healer") then		
		return 17*(self:GetStackCount()-1)/2
	elseif string.match(sName, "fort") then		
		return 13*(self:GetStackCount()-1)/2
	elseif string.match(sName, "range") then		
		return 9*(self:GetStackCount()-1)/2
	elseif string.match(sName, "melee") then		
		return 15*(self:GetStackCount()-1)/2
	elseif string.match(sName, "1") then 
		return 12*(self:GetStackCount()-1)/2
	elseif string.match(sName, "2") then		
		return 16*(self:GetStackCount()-1)/2
	elseif string.match(sName, "3") then		
		return 16*(self:GetStackCount()-1)/2
	elseif string.match(sName, "4") then		
		return 21*(self:GetStackCount()-1)/2
	end
end

function modifier_tower_endure:OnTooltip()
	return (self:GetStackCount()-1)*100
end

modifier_tower_power = class({})


function modifier_tower_power:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_tower_power:IsPurgable() return false end
function modifier_tower_power:IsDebuff() return false end
function modifier_tower_power:GetTexture() return "tower_power" end
function modifier_tower_power:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetOrigin(), nil, (self:GetStackCount()-1)*75, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	for i, v in ipairs(tTargets) do
		if v ~= keys.target then
			ApplyDamage({
				attacker = keys.attacker,
				victim = v,
				damage = keys.damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
			})
		end
	end
end

function modifier_tower_power:OnTooltip()
	return 75*(self:GetStackCount()-1)
end

function modifier_tower_power:GetModifierAttackSpeedBonus_Constant() return 500/9*(self:GetStackCount()-1) end


function modifier_tower_power:GetModifierBaseDamageOutgoing_Percentage()
	return 100*(self:GetStackCount()-1)
end


local function FindItemByNameNotIncludeBackpack(hHero, sName)
	for i = 0, 5 do
		if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == sName then return hHero:GetItemInSlot(i) end
	end
	return nil
end


local function FindItemByName(hHero, sName)
	for i = 0, 8 do
		if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == sName then return hHero:GetItemInSlot(i) end
	end
	return nil
end

local function FindItemByNameIncludeStash(hHero, sName)
	for i = 0, 15 do
		if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == sName then return hHero:GetItemInSlot(i) end
	end
	return nil
end

local function CheckFunItems(hHero, sFunItem)
	hHero.tFunItemList = hHero.tFunItemList or {}
--	print("checking", sFunItem, 'for', hHero:GetName())
	if hHero.tFunItemList[sFunItem] then return end
	
	local tHasComponent = {}
	local tLackComponent = {}
	for j = 1, #tBotItemData.tFunItems[sFunItem] do
		local hItem = FindItemByName(hHero, tBotItemData.tFunItems[sFunItem][j])
--		print(hItem, tBotItemData.tFunItems[sFunItem][j])
		if hItem and not tBotItemData.tNotUpgrade[hItem:GetName()] then 
			table.insert(tHasComponent, hItem)
		else
			table.insert(tLackComponent, tBotItemData.tFunItems[sFunItem][j])
		end
	end
--	print(#tLackComponent, #tHasComponent, #tBotItemData.tFunItems[sFunItem])
	local iGoldRemaining = 0
	for k, v in ipairs(tLackComponent) do
		iGoldRemaining = iGoldRemaining+GetItemCost(v)
	end
	if hHero:GetGold() > iGoldRemaining then
--		print(hHero:GetUnitName(), hHero:GetGold(), iGoldRemaining)
--		PrintTable(tLackComponent)
		for i, v in ipairs(tHasComponent) do
			hHero:RemoveItem(v)
		end
		hHero:AddItemByName(sFunItem)
		hHero.tFunItemList[sFunItem] = true
		PlayerResource:SpendGold(hHero:GetPlayerOwnerID(), iGoldRemaining, DOTA_ModifyGold_PurchaseItem)
	end
end


modifier_bot_use_items = class(tClassFTF)
function modifier_bot_use_items:OnCreated()
	self:StartIntervalThink(0.04)
end
function modifier_bot_use_items:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end
function modifier_bot_use_items:OnOrder(keys)
	if keys.unit~= self:GetParent() then return end
	--[[
	if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION  then
		for i, v in pairs(keys.unit.tPapyrusScarabMinions) do
			ExecuteOrderFromTable({
				OrderType = keys.order_type,
				UnitIndex  = v:entindex(),
				Position = keys.new_pos,
			})
		end
	end
	--]]
	if  keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.unit.tPapyrusScarabMinions then
		for i, v in pairs(keys.unit.tPapyrusScarabMinions) do
			ExecuteOrderFromTable({
				OrderType = keys.order_type,
				UnitIndex  = v:entindex(),
				TargetIndex = keys.target:entindex(),
			})
		end
	end
end

function modifier_bot_use_items:OnIntervalThink()
	if IsClient() then return end
	
	local hParent = self:GetParent()
	if hParent:IsIllusion() or hParent:HasModifier("modifier_ban_fun_items") then self:Destroy() end
	if hParent:IsStunned() or hParent:IsMuted() or hParent:IsCommandRestricted() then return end
	

	if GameMode.iBotHasFunItem == 1 then
	
		--Pick up AA
		for k, v in pairs(Entities:FindAllByClassnameWithin("dota_item_drop", hParent:GetOrigin(), 800)) do
			if v:GetContainedItem():GetAbilityName() == "item_fun_angelic_alliance" then
				if (hParent:GetOrigin()-v:GetOrigin()):Length2D() < 140 then
					local iMinimumCost = 99999
					local hMinimumCostItem
					local bHasEmpty = false
					for i = 0, 8 do
						if not hParent:GetItemInSlot(i) then
							bHasEmpty = true
							break
						else						
							if iMinimumCost > hParent:GetItemInSlot(i):GetCost() then
								iMinimumCost = hParent:GetItemInSlot(i):GetCost()
								hMinimumCostItem = hParent:GetItemInSlot(i)
							end
						end
					end
	--				print(bHasEmpty, iMinimumCost, hMinimumCostItem:GetName())
					if bHasEmpty then
						hParent:PickupDroppedItem(v)
					else
						hParent:DropItemAtPositionImmediate(hMinimumCostItem, hParent:GetOrigin())
						hParent:PickupDroppedItem(v)
					end
				else
					hParent:MoveToPosition(v:GetOrigin())
				end
			end
		end
	
		local hItem = FindItemByNameNotIncludeBackpack(hParent, "item_fun_blood_sword")
		if hItem and hItem:IsCooldownReady() then
			local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			if #tTargets > 0 then
				hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
			end
		end
		
		hItem = FindItemByNameNotIncludeBackpack(hParent, "item_fun_magic_hammer")
		if hItem and hItem:IsCooldownReady() then
			local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			if #tTargets > 0 then
				hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
			end
		end
		
		hItem = FindItemByNameNotIncludeBackpack(hParent, "item_fun_heros_bow")
		if hItem and hItem:IsCooldownReady() then
			local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			if #tTargets > 0 then
				hParent:CastAbilityOnTarget(tTargets[1], hItem, hParent:GetPlayerOwnerID())
			end
		end
		hItem = FindItemByNameNotIncludeBackpack(hParent, "item_fun_papyrus_scarab")
		if hItem and hItem:IsCooldownReady() then
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, hItem:GetSpecialValueFor("transform_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
			local tAllyHeroes = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, hItem:GetSpecialValueFor("transform_range"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
			local bAllyHurt = false
			for i, v in pairs(tAllyHeroes) do
				if v:GetHealth()/v:GetMaxHealth() < 0.5 then bAllyHurt = true end
			end
			if (bAllyHurt and hParent.tPapyrusScarabMinions and #hParent.tPapyrusScarabMinions > 0) or #tTargets > 1 then
				hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
			end
		end
		-- use AA to escape
		hItem = FindItemByNameNotIncludeBackpack(hParent, "item_fun_angelic_alliance")
		if hItem and hItem:IsFullyCastable() and hParent:GetHealth()/hParent:GetMaxHealth() < 0.15 then
			local hFountain
			if hParent:GetTeam() == DOTA_TEAM_GOODGUYS then
				hFountain = Entities:FindByName(nil, "ent_dota_fountain_good")
			else
				hFountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
			end
			hParent:CastAbilityOnPosition(hFountain:GetOrigin(), hItem, hParent:GetPlayerOwnerID()) 
		end
		hItem = FindItemByNameNotIncludeBackpack(hParent, "item_fun_bs")
		if hItem and hItem:IsCooldownReady() then
			local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			for i, v in pairs(tTargets) do
				if v:GetHealthPercent() < 50 then
					hParent:CastAbilityOnTarget(v, hItem, hParent:GetPlayerOwnerID())
					break
				end
			end
		end
	end
	
	-- Normal Items

	local hItem = FindItemByNameNotIncludeBackpack(hParent, "item_guardian_greaves")
	if hItem and hItem:IsFullyCastable() then
		local bAllyHurt = false
		local tAllyHeroes = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, hItem:GetSpecialValueFor("transform_range"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
		for i, v in pairs(tAllyHeroes) do
			if v:GetHealth()/v:GetMaxHealth() < 0.5 then bAllyHurt = true end
		end
		if bAllyHurt then
			hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
		end
	end
	
	hItem = FindItemByNameNotIncludeBackpack(hParent, "item_bloodthorn")
	if hItem and hItem:IsFullyCastable() and not hParent:IsInvisible() then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, hItem:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i, v in ipairs(tTargets) do
			if not v:IsSilenced() then
				hParent:CastAbilityOnTarget(v, hItem, hParent:GetPlayerOwnerID())
				break
			end
		end
	end
	
	hItem = FindItemByNameNotIncludeBackpack(hParent, "item_refresher")
	if hItem and hItem:IsFullyCastable() then
		local fFullCooldown = 0
		local iMaxCooldownAbility
		for i = 0, 23 do
			if hParent:GetAbilityByIndex(i) then
				local fCooldown = hParent:GetAbilityByIndex(i):GetCooldown(hParent:GetAbilityByIndex(i):GetLevel())
				if fFullCooldown < fCooldown then
					fFullCooldown = fCooldown
					iMaxCooldownAbility = i
				end
			end
		end
		if hParent:GetAbilityByIndex(iMaxCooldownAbility):GetCooldownTimeRemaining() > 0 then
			hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
		end
	end
	
	hItem = FindItemByNameNotIncludeBackpack(hParent, "item_solar_crest")
	if hItem and not hItem:IsInBackpack() and hItem:IsFullyCastable() and not hParent:IsInvisible() then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, hItem:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i, v in ipairs(tTargets) do
			if not v:HasModifier('modifier_item_solar_crest_armor_reduction') then
				hParent:CastAbilityOnTarget(v, hItem, hParent:GetPlayerOwnerID())
				break
			end
		end
	end
end

modifier_attack_point_change = class(tClassFTF)
function modifier_attack_point_change:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT} end
function modifier_attack_point_change:GetModifierAttackPointConstant() 
	return self:GetStackCount()/1000
end

modifier_attack_time_change = class(tClassFTF)
function modifier_attack_time_change:DeclareFunctions() return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_attack_time_change:GetModifierBaseAttackTimeConstant() 
	return self:GetStackCount()/100
end


modifier_attack_range_change = class(tClassFTF)
function modifier_attack_range_change:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end
function modifier_attack_range_change:GetModifierAttackRangeBonus() return self:GetStackCount() end

modifier_projectile_speed_change = class(tClassFTF)
function modifier_projectile_speed_change:DeclareFunctions() return {MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS} end
function modifier_projectile_speed_change:GetModifierProjectileSpeedBonus() return self:GetStackCount() end

modifier_turn_rate_change = class(tClassFTF)
function modifier_turn_rate_change:DeclareFunctions() return {MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE} end
function modifier_turn_rate_change:GetModifierProjectileSpeedBonus() return self:GetStackCount() end

modifier_axe_thinker = class(tClassFTF)
function modifier_axe_thinker:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end

function modifier_axe_thinker:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_EXECUTED} end

local function ThinkForAxeAbilities(hAxe)
	local hAbility1 = hAxe:GetAbilityByIndex(0)
	local hAbility2 = hAxe:GetAbilityByIndex(1)
	local hAbility6 = hAxe:GetAbilityByIndex(5)
	if hAxe:IsSilenced() or hAxe:IsStunned() or hAbility1:IsInAbilityPhase() or hAbility2:IsInAbilityPhase() or hAbility6:IsInAbilityPhase() then return end
	local iRange2 = hAbility2:GetCastRange()
	local iThreshold = hAbility6:GetSpecialValueFor("kill_threshold")
	if hAbility6:IsFullyCastable() then
		local tAllHeroes = FindUnitsInRadius(hAxe:GetTeam(), hAxe:GetOrigin(), nil, hAbility6:GetCastRange()+150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		
		for i, v in ipairs(tAllHeroes) do
			if v:GetHealth() < iThreshold then
				hAxe:CastAbilityOnTarget(v, hAbility6, hAxe:GetPlayerOwnerID())
				hAxe.IsCasting = true
				return
			end
		end
	end
	if hAbility1:IsFullyCastable() then

		local tAllHeroes = FindUnitsInRadius(hAxe:GetTeam(), hAxe:GetOrigin(), nil, hAbility1:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		local iCount = #tAllHeroes
		for i = 1, iCount do
			if tAllHeroes[iCount+1-i]:IsStunned() or tAllHeroes[iCount+1-i]:IsHexed() then table.remove(tAllHeroes, iCount+1-i) end
		end
		
		if #tAllHeroes > 0 then
			hAxe:CastAbilityNoTarget(hAbility1, hAxe:GetPlayerOwnerID())
			return
		end
	end
	if hAbility2:IsFullyCastable() then
		local tAllHeroes = FindUnitsInRadius(hAxe:GetTeam(), hAxe:GetOrigin(), nil, hAbility2:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, v in ipairs(tAllHeroes) do
			hAxe:CastAbilityOnTarget(v, hAbility2, hAxe:GetPlayerOwnerID())
			return
		end
	end
end

function modifier_axe_thinker:OnIntervalThink()
	if IsClient() then return end
	ThinkForAxeAbilities(self:GetParent())
end

modifier_backdoor_healing = class(tClassFTF)
function modifier_backdoor_healing:OnCreated()
	self:StartIntervalThink(FrameTime())
	self.bWasProtected = false
	self.fFormerHealth = 0
end
function modifier_backdoor_healing:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:HasModifier("modifier_backdoor_protection_active") then
		if not self.bWasProtected then
			self.bWasProtected = true
		end
		if hParent:GetHealth() > self.fFormerHealth then
			self.fFormerHealth = hParent:GetHealth()
		end
	else
		if self.bWasProtected then
			self.bWasProtected = false
			self.fFormerHealth = 0
		end
	end
	if hParent:GetHealth() < self.fFormerHealth then
		self:SetStackCount(hParent:FindModifierByName("modifier_backdoor_protection_active"):GetAbility():GetSpecialValueFor("regen_rate"))
	else
		self:SetStackCount(0)
	end
end

function modifier_backdoor_healing:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_backdoor_healing:GetModifierConstantHealthRegen()
	return self:GetStackCount()
end

function modifier_backdoor_healing:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	if keys.attacker:GetTeam() == keys.unit:GetTeam() then 
		self.fFormerHealth = keys.unit:GetHealth()
	elseif keys.unit:HasAbility("backdoor_protection") and keys.unit:HasModifier("modifier_backdoor_protection_active") then
		
		local iParticle = ParticleManager:CreateParticle("particles/items_fx/backdoor_protection.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(200,0,0))
		ParticleManager:SetParticleControlForward(iParticle, 2, keys.unit:GetOrigin()-keys.attacker:GetOrigin())
	end	
end

tFunExpensiveMode = {
	item_fun_economizer = {'item_apex', 'item_spell_prism'},
	item_fun_genji_gloves = {'item_apex', 'item_pirate_hat'},
	item_fun_ragnarok = {'item_apex', 'item_witless_shako'},
	item_fun_escutcheon = {'item_mirror_shield','item_panic_button'},
	item_fun_blood_sword = {'item_desolator_2','item_havoc_hammer'},
	item_fun_heros_bow = {'item_ballista','item_force_boots'},
	item_fun_magic_hammer = {'item_seer_stone','item_woodland_striders'},
	item_fun_papyrus_scarab = {'item_demonicon','item_illusionsts_cape'},
	item_fun_orb_of_omnipotence = {'item_apex','item_princes_knife'},
	item_fun_sprint_shoes = {'item_fallen_sky', 'item_flicker'},
	item_fun_terra_blade = {'item_apex', 'item_trident'},
	item_fun_angelic_alliance = {'item_apex', 'item_titan_sliver','item_timeless_relic'},
	
}
modifier_ban_fun_items = class(tClassFTF)

function modifier_ban_fun_items:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_ban_fun_items:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	for i = 0, 14 do
		if hParent:GetItemInSlot(i) and tBotItemData.tFunItems[hParent:GetItemInSlot(i):GetAbilityName()] then
			hParent:DisassembleItem(hParent:GetItemInSlot(i))
		end
	end
end


modifier_test = class({});
function modifier_test:IsPurgable() return false end
function modifier_test:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_SUPPRESS_TELEPORT	
	}
end
function modifier_test:GetSuppressTeleport(keys)
	PrintTable(keys)
end

local function GetItemCount(hHero, sName)
	local iCount = 0
	local hItem
	for i = 0,14 do
		if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == sName then
			iCount = iCount+1
			hItem = hHero:GetItemInSlot(i)
		end
	end
	return iCount, hItem
end

modifier_item_assemble_fix = class(tClassFTF)
function modifier_item_assemble_fix:OnCreated() 
	if IsClient() then return end
	self:StartIntervalThink(0.5)
end


local function CheckItemAfter(hHero, sItemBefore, sItemAfter)
	if FindItemByNameIncludeStash(hHero, sItemBefore) and (not hHero.tItemHistory or not hHero.tItemHistory[sItemAfter] ) then
		if tBotItemData.tItemParts[sItemAfter] then
		
			local iComponentsCost = 0
			for i, v in pairs(tBotItemData.tItemParts[sItemAfter]) do
				iComponentsCost = iComponentsCost + GetItemCost(v)
			end
			if hHero:GetGold() > GetItemCost(sItemAfter)-iComponentsCost  then
				for i, v in pairs(tBotItemData.tItemParts[sItemAfter]) do
					local _, hItem = GetItemCount(hHero, v)
					hHero:RemoveItem(hItem)
				end			
				hHero:SpendGold(GetItemCost(sItemAfter)-iComponentsCost, DOTA_ModifyGold_PurchaseItem)
				hHero:AddItemByName(sItemAfter)
				hHero.tItemHistory = hHero.tItemHistory or {}
				hHero.tItemHistory[sItemAfter] = true
			end
			
			
		else		
			if hHero:GetGold() > GetItemCost(sItemAfter)then
				hHero:SpendGold(GetItemCost(sItemAfter), DOTA_ModifyGold_PurchaseItem)
				hHero:AddItemByName(sItemAfter)
				hHero.tItemHistory = hHero.tItemHistory or {}
				hHero.tItemHistory[sItemAfter] = true
			end
		end
	end
end






local function SellLowCostItems(hHero)
	if (hHero:HasModifier('modifier_fountain_aura_buff') or GameMode.iUniversalShop == 1) then
		iTotalCost = 0
		for i = 0,14 do
			if hHero:GetItemInSlot(i) then
				iTotalCost = iTotalCost+hHero:GetItemInSlot(i):GetCost()
			end
		end
		if iTotalCost > 20000 then
			for i = 0,14 do
				if hHero:GetItemInSlot(i) and tBotItemData.tLowCostItems[hHero:GetItemInSlot(i):GetName()] then
					hHero:SellItem(hHero:GetItemInSlot(i))
				end
			end		
		end
	end
end



function modifier_item_assemble_fix:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if not IsInToolsMode() and not hParent:HasModifier('modifier_fountain_aura_buff') then return end
	iEntIndex = hParent:entindex()

	if self:GetStackCount() > 0 and hParent:GetGold() > 0 then
		if hParent:GetGold() > self:GetStackCount() then
			hParent:SpendGold(self:GetStackCount(), DOTA_ModifyGold_PurchaseItem)
			self:SetStackCount(0)
		else
			self:SetStackCount(self:GetStackCount() - hParent:GetGold())
			hParent:SpendGold(hParent:GetGold(), DOTA_ModifyGold_PurchaseItem)
		end
	end
	for k,v in ipairs(tBotItemData.tWrongItems) do
		local bHasAllComponents = true
		for k1, v1 in pairs(v.components) do
			if GetItemCount(hParent, k1) < v1 then
				bHasAllComponents = false
			end
		end
		if bHasAllComponents and hParent:GetName() ~= v.disable_hero then
			for k1, v1 in pairs(v.components) do
				for j = 1,v1 do
					local _, hItem = GetItemCount(hParent, k1)
					hParent:RemoveItem(hItem)
				end
			end
			for i2, v2 in pairs(v.tRightItems) do
				hParent:AddItemByName(v2)
			end
			if v.deficit > 0 then
				self:SetStackCount(v.deficit)
			else
				hParent:ModifyGold(-v.deficit, false, DOTA_ModifyGold_SellItem)
			end
		end
	end
	if not hParent.bHasEndItem then
		local tHeroLuxuryItemList = tBotItemData.tLuxuryItemList[hParent:GetName()]
		local iOmit = 0
		local bHasE2toBuild = false
		for i, v in ipairs(tBotItemData.tBotBuildFunItems[hParent:GetName()].tWantedFunItems) do
			if v == "item_fun_economizer_2" then
				bHasE2toBuild = true
			end
		end
		
		if bHasE2toBuild and GameMode.iBotHasFunItem == 1 and GameMode.iBanFunItems == 0 then
			iOmit = 1
		end
		for i = 1, (#tHeroLuxuryItemList-1-iOmit) do
			CheckItemAfter(hParent, tHeroLuxuryItemList[i], tHeroLuxuryItemList[i+1])
		end
		if (hParent:GetName() == 'npc_dota_hero_chaos_knight' and hParent:HasItemInInventory(tBotItemData.tLuxuryItemList[hParent:GetName()][#tBotItemData.tLuxuryItemList[hParent:GetName()]])) or (iOmit == 1 and hParent:HasItemInInventory(tBotItemData.tLuxuryItemList[hParent:GetName()][#tBotItemData.tLuxuryItemList[hParent:GetName()]-1])) or hParent:HasModifier('modifier_item_ultimate_scepter_consumed') then
			hParent.bHasEndItem = true
		end
	end 
--	SellLowCostItems(hParent)
	
	if not hParent.bHasEndFunItem and GameMode.iBotHasFunItem > 0 and not hParent:HasModifier('modifier_ban_fun_items') and hParent.bHasEndItem then
		for i, v in ipairs(tBotItemData.tBotBuildFunItems[hParent:GetName()].tWantedFunItems) do
	
			CheckFunItems(hParent, v)
		end
		if hParent:HasItemInInventory(tBotItemData.tBotBuildFunItems[hParent:GetName()].tWantedFunItems[#tBotItemData.tBotBuildFunItems[hParent:GetName()].tWantedFunItems]) then 
			hParent.bHasEndFunItem = true
		end
	end
end

modifier_plant_tree = class({})

function modifier_plant_tree:IsPurgable() return false end
function modifier_plant_tree:RemoveOnDeath() return false end
function modifier_plant_tree:IsDebuff() return false end
function modifier_plant_tree:IsHidden() return self:GetStackCount() == 0 end
function modifier_plant_tree:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_MODIFIER_ADDED
	}
end
function modifier_plant_tree:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end
function modifier_plant_tree:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end
function modifier_plant_tree:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end
function modifier_plant_tree:OnAbilityExecuted(keys)
	if keys.unit == self:GetParent() and keys.ability:GetName()=='item_tango' and keys.target.bPlanted then
		self.iFrameCount = GetFrameCount()
	end
	if keys.unit == self:GetParent() and (keys.ability:GetName() == 'item_branches' or keys.ability:GetName() == 'item_tree_planting_suite') then
		self.vTreePos = keys.ability:GetCursorPosition()
		self.iTreesPlanted = self.iTreesPlanted or 0
		self.iTreesPlanted = self.iTreesPlanted+1
		if self.bHasFunItem then
			if self.iTreesPlanted >= keys.ability:GetSpecialValueFor('count_tree_plant_fun') then
				self.iTreesPlanted = 0
				self:IncrementStackCount()
			end
		else
			if self.iTreesPlanted >= keys.ability:GetSpecialValueFor('count_tree_plant') then
				self.iTreesPlanted = 0
				self:IncrementStackCount()
			end
		end
	end
end
function modifier_plant_tree:GetTexture()
	return "item_branches"
end

function modifier_plant_tree:OnModifierAdded(keys)
	if keys.unit == self:GetParent() then
		for i = 0, 14 do
			if keys.unit:GetItemInSlot(i) and tBotItemData.tFunItems[keys.unit:GetItemInSlot(i):GetAbilityName()] then
				self.bHasFunItem = true
			end
		end
		if self.iFrameCount then
			local hModifier = keys.unit:FindModifierByName('modifier_tango_heal')
			hModifier:SetDuration(hModifier:GetDuration()*2, true)
			self.iFrameCount = nil
		end
	end
end
modifier_fast_courier = class({})
function modifier_fast_courier:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_MAX,
			MODIFIER_PROPERTY_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,}
end


function modifier_fast_courier:GetModifierMoveSpeed_Max()
	return 2000
end

function modifier_fast_courier:GetModifierMoveSpeed_Limit()
	return 2000
end

function modifier_fast_courier:GetModifierMoveSpeed_Absolute()
	return 2000
end


function modifier_fast_courier:GetTexture() return 'void_demon_mass_haste' end

modifier_mutation_killstreak_power = class({
	IsPurgable = function(self) return false end,
	RemoveOnDeath = function(self) return false end,
})

function modifier_mutation_killstreak_power:IsHidden()
	if self:GetStackCount() > 0 then return false else return true end
end

function modifier_mutation_killstreak_power:DeclareFunctions() 
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE}
end

function modifier_mutation_killstreak_power:GetModifierIncomingDamage_Percentage()
	return 20*self:GetStackCount()
end

function modifier_mutation_killstreak_power:GetModifierTotalDamageOutgoing_Percentage()
	return 20*self:GetStackCount()
end

modifier_ability_layout_change = class(tClassFTF)
function modifier_ability_layout_change:DeclareFunctions() return {MODIFIER_PROPERTY_ABILITY_LAYOUT} end
function modifier_ability_layout_change:GetModifierAbilityLayout( params ) return self:GetStackCount() end


modifier_attack_speed_change = class(tClassFTF)
function modifier_attack_speed_change:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_attack_speed_change:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount() end

modifier_ti9_attack_modifier = class(tClassFTF)

function modifier_ti9_attack_modifier:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_ti9_attack_modifier:OnAttack(keys)
	if keys.attacker == self:GetParent() and keys.attacker:IsRangedAttacker() then
		local vStart
		if string.find(keys.attacker:GetSequence(),'2') then
			vStart = keys.attacker:GetAttachmentOrigin(keys.attacker:ScriptLookupAttachment('attach_attack1')) 
		else
			vStart = keys.attacker:GetAttachmentOrigin(keys.attacker:ScriptLookupAttachment('attach_attack2')) 
		end
		ProjectileManager:CreateTrackingProjectile({
			Target = keys.target,
--			Source = keys.attacker,
			vSourceLoc = vStart,
			Ability = nil,	
			EffectName = 'particles/econ/attack/attack_modifier_ti9.vpcf',
			iMoveSpeed = keys.attacker:GetProjectileSpeed(),
			vSourceLoc= keys.attacker:GetAbsOrigin(),                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
			bDodgeable = true,                                -- Optional
			bIsAttack = false,                                -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bReplaceExisting = false,                         -- Optional
			bProvidesVision = false,                           -- Optional
		})
	end
end

modifier_dynamic_exp_gold = class(tClassFFF)
modifier_anti_diving=class({})
function modifier_anti_diving:IsPurgable() return false end
function modifier_anti_diving:RemoveOnDeath() return false end
function modifier_anti_diving:IsHidden() 
	if self:GetStackCount() <= 0 then return true else return false end
end
function modifier_anti_diving:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, MODIFIER_EVENT_ON_TAKEDAMAGE}
end
function modifier_anti_diving:GetModifierTotalDamageOutgoing_Percentage()
	return -10*self:GetStackCount()
end

function modifier_anti_diving:OnCreated()
	self:StartIntervalThink(0.1)
	self.fTime = 0
end
function modifier_anti_diving:GetTexture()
	return "anti_diving"
end
function modifier_anti_diving:OnIntervalThink()
	if IsClient() or not Entities:FindByName(nil, "ent_dota_fountain_bad") then return end
	local fDistance
	if self:GetParent():GetTeam() == DOTA_TEAM_BADGUYS then
		fDistance = CalcDistanceBetweenEntityOBB(self:GetParent(), Entities:FindByName(nil, "ent_dota_fountain_good"))
	else
		fDistance = CalcDistanceBetweenEntityOBB(self:GetParent(), Entities:FindByName(nil, "ent_dota_fountain_bad"))
	
	end
	if fDistance < 1200 then
		self.fTime = self.fTime + 0.1
	else
		self.fTime = self.fTime - 0.05
	end
	if self.fTime < 0 then self.fTime = 0 end
	if self.fTime  > 15 then self.fTime  = 15 end
	local iStackCount = math.floor(self.fTime)-5
	if iStackCount < 0 then
		iStackCount = 0
	end
	self:SetStackCount(iStackCount)
end

modifier_bot_protection = class({})
function modifier_bot_protection:IsPurgable() return false end
function modifier_bot_protection:RemoveOnDeath() return false end
function modifier_bot_protection:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_EVENT_ON_DEATH}
end
function modifier_bot_protection:GetTexture() return "Bot_hard_icon" end
function modifier_bot_protection:OnDeath(keys)
	if keys.unit:IsRealHero() then
		local iPlayerID = self:GetParent():GetPlayerOwnerID()
		self:SetStackCount(PlayerResource:GetDeaths(iPlayerID)-PlayerResource:GetKills(iPlayerID)-5)
	end
end

function modifier_bot_protection:IsHidden()
	if self:GetStackCount() <= 0 then return true else return false end
end

function modifier_bot_protection:GetModifierIncomingDamage_Percentage()
	local iPercentage = -self:GetStackCount()*5
	if iPercentage < -50 then iPercentage = -50 end
	return iPercentage
end

function modifier_bot_protection:GetModifierTotalDamageOutgoing_Percentage()
	local iPercentage = self:GetStackCount()*10
	if iPercentage > 100 then iPercentage = 100 end
	return iPercentage
end




