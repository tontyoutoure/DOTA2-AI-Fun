persuasive_swindle_lua =class({})
persuasive_change_item_slot_0_lua =class({})
persuasive_change_item_slot_1_lua =class({})
persuasive_change_item_slot_2_lua =class({})
persuasive_change_item_slot_3_lua =class({})
persuasive_change_item_slot_4_lua =class({})
persuasive_change_item_slot_5_lua =class({})
persuasive_change_item_slot_6_lua =class({})
persuasive_change_item_slot_7_lua =class({})
persuasive_change_item_slot_8_lua =class({})
persuasive_raise_lua = class({})

function persuasive_swindle_lua:IsStealable() return false end
function persuasive_raise_lua:IsStealable() return false end
function persuasive_change_item_slot_0_lua:IsStealable() return false end
function persuasive_change_item_slot_1_lua:IsStealable() return false end
function persuasive_change_item_slot_2_lua:IsStealable() return false end
function persuasive_change_item_slot_3_lua:IsStealable() return false end
function persuasive_change_item_slot_4_lua:IsStealable() return false end
function persuasive_change_item_slot_5_lua:IsStealable() return false end
function persuasive_change_item_slot_6_lua:IsStealable() return false end
function persuasive_change_item_slot_7_lua:IsStealable() return false end
function persuasive_change_item_slot_8_lua:IsStealable() return false end

function persuasive_swindle_lua:OnUpgrade()
	if self:GetLevel() ~= 1 then return end
	local hCaster = self:GetCaster()
--	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_0_lua"))	
	hCaster:FindAbilityByName("persuasive_raise_lua"):SetLevel(1)
	hCaster:FindAbilityByName("persuasive_empty_for_reflect"):SetLevel(1)
--	hCaster.iItemSlot = 0
end

function persuasive_swindle_lua:CastFilterResultTarget(hTarget)
	if IsClient () then 
		return UF_SUCCESS
	end
	local hCaster = self:GetCaster()
	local fRaise = hCaster:FindAbilityByName("persuasive_raise_lua").Raise
	
	local iCasterValue
	local iHPCost
	local iTargetValue	
	iCasterValue, iTargetValue, iHPCost  = fRaise(hCaster, hTarget)
	if type(iCasterValue) == "string" or iHPCost >= hCaster:GetHealth() then 
		return UF_FAIL_CUSTOM
	else 
		return UF_SUCCESS
	end
end

function persuasive_swindle_lua:GetCustomCastErrorTarget(hTarget)
	local hCaster = self:GetCaster()
	local fRaise = hCaster:FindAbilityByName("persuasive_raise_lua").Raise
	local ReturnValue
	ReturnValue = fRaise(hCaster, hTarget)
	if type(ReturnValue) == 'string' then 
		return ReturnValue
	else 
		return "error_not_enough_hp_to_swindle"
	end
end


function persuasive_swindle_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self:GetCaster():FindAbilityByName("persuasive_empty_for_reflect") ) then return end
	local hCaster = self:GetCaster()
	local hAbilityRaise = hCaster:FindAbilityByName("persuasive_raise_lua")
	local hTarget = self:GetCursorTarget()
	local hCasterItem = hCaster:GetItemInSlot(hCaster.iItemSlot)
	local hTargetItem = hTarget:GetItemInSlot(hCaster.iItemSlot)
	local fRaise = hAbilityRaise.Raise
	local iCasterValue
	local iHPCost
	local iTargetValue	
	local iCasterItemCharges
	local iTargetItemCharges
	
	iCasterValue, iTargetValue, iHPCost = fRaise(hCaster, hTarget)
	
	if hCasterItem:RequiresCharges() then
		iCasterItemCharges = hCasterItem:GetCurrentCharges()
	end
	if hTargetItem:RequiresCharges() then
		iTargetItemCharges = hTargetItem:GetCurrentCharges()
	end
	
	local sTargetItemName = hTargetItem:GetName()
	local sCasterItemName = hCasterItem:GetName()
	
	hTarget:RemoveItem(hTargetItem)
	hCaster:RemoveItem(hCasterItem)
	
	hCasterItem = hCaster:AddItemByName(sTargetItemName)
	hTargetItem = hTarget:AddItemByName(sCasterItemName)
	
	if iCasterItemCharges then
		hTargetItem:SetCurrentCharges(iCasterItemCharges)
	end
	
	if iTargetItemCharges then
		hCasterItem:SetCurrentCharges(iTargetItemCharges)
	end
	
	local particle = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(particle, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, hCaster:GetAbsOrigin())
	hCaster:EmitSound("General.CoinsBig")
	local fCurrentHealth = hCaster:GetHealth()
	if iHPCost >= fCurrentHealth then
		hCaster:DropItemAtPositionImmediate(hCasterItem, hCaster:GetAbsOrigin())
		hCaster:Kill(self, hCaster)
	elseif iHPCost > 0 then
		hCaster:SetHealth(fCurrentHealth-iHPCost)
	end

	
end

function persuasive_change_item_slot_0_lua:OnUpgrade()
	self:GetCaster().iItemSlot = 0
end

function persuasive_change_item_slot_0_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_1_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_1_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_0_lua", "persuasive_change_item_slot_1_lua", true, true)
	hCaster.iItemSlot = 1
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_0_lua")
end

function persuasive_change_item_slot_1_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_2_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_2_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_1_lua", "persuasive_change_item_slot_2_lua", true, true)
	hCaster.iItemSlot = 2
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_1_lua")
end

function persuasive_change_item_slot_2_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_3_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_3_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_2_lua", "persuasive_change_item_slot_3_lua", true, true)
	hCaster.iItemSlot = 3
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_2_lua")
end

function persuasive_change_item_slot_3_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_4_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_4_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_3_lua", "persuasive_change_item_slot_4_lua", true, true)
	hCaster.iItemSlot = 4
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_3_lua")
end

function persuasive_change_item_slot_4_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_5_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_5_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_4_lua", "persuasive_change_item_slot_5_lua", true, true)
	hCaster.iItemSlot = 5
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_4_lua")
end

function persuasive_change_item_slot_5_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_6_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_6_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_5_lua", "persuasive_change_item_slot_6_lua", true, true)
	hCaster.iItemSlot = 6
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_5_lua")
end

function persuasive_change_item_slot_6_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_7_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_7_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_6_lua", "persuasive_change_item_slot_7_lua", true, true)
	hCaster.iItemSlot = 7
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_6_lua")
end

function persuasive_change_item_slot_7_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_8_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_8_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_7_lua", "persuasive_change_item_slot_8_lua", true, true)
	hCaster.iItemSlot = 8
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_7_lua")
end

function persuasive_change_item_slot_8_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddAbility("persuasive_change_item_slot_0_lua")
	hCaster:UpgradeAbility(hCaster:FindAbilityByName("persuasive_change_item_slot_0_lua"))
	hCaster:SwapAbilities("persuasive_change_item_slot_8_lua", "persuasive_change_item_slot_0_lua", true, true)
	hCaster.iItemSlot = 0
	iAbilityPoints = hCaster:GetAbilityPoints()
	hCaster:SetAbilityPoints(iAbilityPoints+1)
	hCaster:RemoveAbility("persuasive_change_item_slot_8_lua")
end

function persuasive_raise_lua.Raise(hCaster, hTarget)
	if hCaster == hTarget then return "error_cannot_self_cast" end
	local hTargetItem = CDOTA_BaseNPC.GetItemInSlot(hTarget, hCaster.iItemSlot)
	local hCasterItem = CDOTA_BaseNPC.GetItemInSlot(hCaster, hCaster.iItemSlot)
	if not hCasterItem then
		return "error_caster_no_item"
	end
	if not hTargetItem then
		return "error_target_no_item"
	end
	if not hCasterItem:IsPermanent() or not hTargetItem:IsPermanent() then return "error_cannot_swindle_consumable" end
	if hCasterItem:IsRecipe() or hTargetItem:IsRecipe() then return "error_cannot_swindle_recipe" end
	if hTargetItem:GetName() == "item_aegis" or hCasterItem:GetName() == "item_aegis" then return "error_cannot_swindle_aegis" end
	local iCasterValue = hCasterItem:GetCost()
	local iTargetValue = hTargetItem:GetCost()
	local iHPCost = iTargetValue-hCaster:FindAbilityByName("persuasive_swindle_lua"):GetSpecialValueFor("multiplier")*iCasterValue
	return iCasterValue, iTargetValue, iHPCost
end

function persuasive_raise_lua:CastFilterResultTarget(hTarget)
	if IsClient () then 
		return UF_SUCCESS
	end
	local hCaster = self:GetCaster()
	local sReturn = self.Raise(hCaster, hTarget)
	if type(sReturn) == "string" then 
		return UF_FAIL_CUSTOM
	else 
		return UF_SUCCESS
	end
end

function persuasive_raise_lua:GetCustomCastErrorTarget(hTarget)
	local hCaster = self:GetCaster()
	return self.Raise(hCaster, hTarget)
end

function persuasive_raise_lua:OnUpgrade()
end

function persuasive_raise_lua:OnSpellStart()	
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local sTargetName = hTarget:GetName()
	local sCasterItemName = hCaster:GetItemInSlot(hCaster.iItemSlot):GetName()
	local sTargetItemName = hTarget:GetItemInSlot(hCaster.iItemSlot):GetName()
	local iID = hCaster:GetPlayerOwner():GetPlayerID()
	local iCasterValue
	local iHPCost
	local iTargetValue	
	
	iCasterValue, iTargetValue, iHPCost = self.Raise(hCaster, hTarget)
	
	local tMessageTables 
	if iHPCost > 0 then 
		tMessageTables = 
		{
			{
				duration = 4,
				text = "#persuasive_raise1"
			},
			{
				duration = 4,
				item = sCasterItemName,
				continue = true
			},
			{
				duration = 4,
				text = "(",
				continue = true
			},
			{
				duration = 4,
				style = {color = "#FFDF00"},
				text = tostring(iCasterValue),
				continue = true
			},
			{
				duration = 4,
				image = "file://{images}/custom_game/gold.png",
				continue = true
			},
			{
				duration = 4,
				text = ")",
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise2",
				continue = true
			},
			{
				duration = 4,
				hero = sTargetName,
				herostyle = "portrait",
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise3",
				continue = true
			},
			{
				duration = 4,
				item = sTargetItemName,
				continue = true
			},
			{
				duration = 4,
				text = "(",
				continue = true
			},
			{
				duration = 4,			
				style = {color = "#FFDF00"},
				text = tostring(iTargetValue),
				continue = true
			},
			{
				duration = 4,
				image = "file://{images}/gold.png",
				continue = true
			},
			{
				duration = 4,
				text = ")",
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise4",
				continue = true
			},
			{
				duration = 4,
				style = {color = "red"},
				text = tostring(iHPCost),
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise5",
				continue = true
			},
		}
	else
		tMessageTables = 
		{
			{
				duration = 4,
				text = "#persuasive_raise1"
			},
			{
				duration = 4,
				item = sCasterItemName,
				continue = true
			},
			{
				duration = 4,
				text = "(",
				continue = true
			},
			{
				duration = 4,
				style = {color = "#FFDF00"},
				text = tostring(iCasterValue),
				continue = true
			},
			{
				duration = 4,
				image = "file://{images}/custom_game/gold.png",
				continue = true
			},
			{
				duration = 4,
				text = ")",
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise2",
				continue = true
			},
			{
				duration = 4,
				hero = sTargetName,
				herostyle = "portrait",
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise3",
				continue = true
			},
			{
				duration = 4,
				item = sTargetItemName,
				continue = true
			},
			{
				duration = 4,
				text = "(",
				continue = true
			},
			{
				duration = 4,			
				style = {color = "#FFDF00"},
				text = tostring(iTargetValue),
				continue = true
			},
			{
				duration = 4,
				image = "file://{images}/gold.png",
				continue = true
			},
			{
				duration = 4,
				text = ")",
				continue = true
			},
			{
				duration = 4,
				text = "#persuasive_raise6",
				continue = true
			}
		}
	end
	for i = 1, #tMessageTables do
		Notifications:Bottom(iID, tMessageTables[i])
	end
end

