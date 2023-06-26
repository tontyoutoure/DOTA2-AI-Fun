LinkLuaModifier("modifier_el_dorado_refine_weapons", "heroes/el_dorado/el_dorado_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_el_dorado_refine_weapons_frog", "heroes/el_dorado/el_dorado_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_el_dorado_piracy_method", "heroes/el_dorado/el_dorado_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_el_dorado_artificial_frog_disable_healing", "heroes/el_dorado/el_dorado_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
local tItemList = {
	"item_branches",
	"item_gauntlets",
	"item_slippers",
	"item_mantle",
	"item_circlet",
	"item_belt_of_strength",
	"item_boots_of_elves",
	"item_robe",
	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_staff_of_wizardry",
	"item_ring_of_protection",
--	"item_stout_shield",
	"item_quelling_blade",
	"item_infused_raindrop",
	"item_blight_stone",
	"item_orb_of_venom",
	"item_blades_of_attack",
	"item_chainmail",
	"item_quarterstaff",
	"item_helm_of_iron_will",
	"item_broadsword",
	"item_claymore",
	"item_javelin",
	"item_mithril_hammer",
	"item_wind_lace",
	"item_magic_stick",
	"item_sobi_mask",
	"item_ring_of_regen",
	"item_boots",
	"item_gloves",
	"item_cloak",
	"item_ring_of_health",
	"item_void_stone",
	"item_lifesteal",
	"item_shadow_amulet",
	"item_ghost",
	"item_blink",
	"item_energy_booster",
	"item_vitality_booster",
	"item_point_booster",
	"item_platemail",
	"item_talisman_of_evasion",
	"item_hyperstone",
	"item_ultimate_orb",
	"item_demon_edge",
	"item_crown",
	"item_ring_of_tarrasque"
}

local tItemListLv = {}
tItemListLv[1] = {}
tItemListLv[2] = {}
tItemListLv[3] = {}
tItemListLv[4] = {}
el_dorado_item_forge = class({})

function el_dorado_item_forge:OnUpgrade()
	if #tItemListLv[1] > 0 then return end
	local iLv1MaxCost = self:GetLevelSpecialValueFor("max_cost", 0)
	local iLv2MaxCost = self:GetLevelSpecialValueFor("max_cost", 1)
	local iLv3MaxCost = self:GetLevelSpecialValueFor("max_cost", 2)
	local iLv4MaxCost = self:GetLevelSpecialValueFor("max_cost", 3)
	local tItemListLv1 = {}
	local tItemListLv2 = {}
	local tItemListLv3 = {}
	local tItemListLv4 = {}
	for k, v in pairs(tItemList) do
		if GetItemCost(v) <= iLv1MaxCost then table.insert(tItemListLv1, v) 
		elseif GetItemCost(v) <= iLv2MaxCost then table.insert(tItemListLv2, v) 
		elseif GetItemCost(v) <= iLv3MaxCost then table.insert(tItemListLv3, v) 
		elseif GetItemCost(v) <= iLv4MaxCost then table.insert(tItemListLv4, v) end
	end
	
	for k, v in pairs(tItemListLv1) do table.insert(tItemListLv[1], v) end
	for k, v in pairs(tItemListLv1) do table.insert(tItemListLv[2], v) end
	for k, v in pairs(tItemListLv1) do table.insert(tItemListLv[3], v) end
	for k, v in pairs(tItemListLv1) do table.insert(tItemListLv[4], v) end
	for k, v in pairs(tItemListLv2) do table.insert(tItemListLv[2], v) end
	for k, v in pairs(tItemListLv2) do table.insert(tItemListLv[3], v) end
	for k, v in pairs(tItemListLv2) do table.insert(tItemListLv[4], v) end
	for k, v in pairs(tItemListLv3) do table.insert(tItemListLv[3], v) end
	for k, v in pairs(tItemListLv3) do table.insert(tItemListLv[4], v) end
	for k, v in pairs(tItemListLv4) do table.insert(tItemListLv[4], v) end
end

function el_dorado_item_forge:OnSpellStart()
	local vLocation = self:GetCursorPosition()
	local hCaster = self:GetCaster()
	local iItem = RandomInt(1, #tItemListLv[self:GetLevel()])
	local sColor
--	PrintTable(tItemListLv[1])
--	PrintTable(tItemListLv[2])
----	PrintTable(tItemListLv[3])
--	PrintTable(tItemListLv[4])
	if iItem <= #tItemListLv[1] then sColor = "white"
	elseif iItem <= #tItemListLv[2] then sColor = "blue"
	elseif iItem <= #tItemListLv[3] then sColor = "purple"
	elseif iItem <= #tItemListLv[4] then sColor = "gold" end
	local sItemName = tItemListLv[self:GetLevel()][iItem]
	if hCaster:HasModifier("modifier_el_dorado_piracy_method") and ((hCaster:HasScepter() and RandomFloat(0, 1) < hCaster:FindModifierByName("modifier_el_dorado_piracy_method"):GetAbility():GetSpecialValueFor("bonus_chance_scepter")/100) or (not hCaster:HasScepter() and RandomFloat(0, 1) < hCaster:FindModifierByName("modifier_el_dorado_piracy_method"):GetAbility():GetSpecialValueFor("bonus_chance")/100)) then
		local hItem = CreateItem(sItemName, hCaster, hCaster)
		local fAngle = RandomFloat(0, 2*3.1415926)
		CreateItemOnPositionSync(vLocation+Vector(50*math.sin(fAngle),50*math.	cos(fAngle),0), hItem)
		FindClearSpaceForUnit(hItem, vLocation, false)
		hItem = CreateItem(sItemName, hCaster, hCaster)
		CreateItemOnPositionSync(vLocation, hItem)
		FindClearSpaceForUnit(hItem, vLocation, false)
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge1", style = {color = sColor}})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {item=sItemName, continue = true})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {item=sItemName, continue = true})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge3", style = {color = sColor}, continue = true})
	else
		local hItem = CreateItem(sItemName, hCaster, hCaster)
		CreateItemOnPositionSync(vLocation, hItem)
		FindClearSpaceForUnit(hItem, vLocation, false)
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge1", style = {color = sColor}})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {item=sItemName, continue = true})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge4", style = {color = sColor}, continue = true})
	end
end

el_dorado_change_item_slot_0_lua =class({})
el_dorado_change_item_slot_1_lua =class({})
el_dorado_change_item_slot_2_lua =class({})
el_dorado_change_item_slot_3_lua =class({})
el_dorado_change_item_slot_4_lua =class({})
el_dorado_change_item_slot_5_lua =class({})
el_dorado_change_item_slot_6_lua =class({})
el_dorado_change_item_slot_7_lua =class({})
el_dorado_change_item_slot_8_lua =class({})
el_dorado_change_item_slot_9_lua =class({})


function el_dorado_change_item_slot_0_lua:IsStealable() return false end
function el_dorado_change_item_slot_1_lua:IsStealable() return false end
function el_dorado_change_item_slot_2_lua:IsStealable() return false end
function el_dorado_change_item_slot_3_lua:IsStealable() return false end
function el_dorado_change_item_slot_4_lua:IsStealable() return false end
function el_dorado_change_item_slot_5_lua:IsStealable() return false end
function el_dorado_change_item_slot_6_lua:IsStealable() return false end
function el_dorado_change_item_slot_7_lua:IsStealable() return false end
function el_dorado_change_item_slot_8_lua:IsStealable() return false end
function el_dorado_change_item_slot_9_lua:IsStealable() return false end

function el_dorado_change_item_slot_0_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_1_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_2_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_3_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_4_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_5_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_6_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_7_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_8_lua:ProcsMagicStick() return false end
function el_dorado_change_item_slot_9_lua:ProcsMagicStick() return false end

function el_dorado_change_item_slot_0_lua:OnUpgrade()
	self:GetCaster().iItemSlot = 0
end

local function EldoradoChangeItemSlot(self)
	local sName = self:GetName()
	local iSlot = tonumber(string.match(sName, "%d"))
	local hCaster = self:GetCaster()
	if iSlot < 9 then
		hCaster:AddAbility("el_dorado_change_item_slot_"..tostring(iSlot+1).."_lua"):SetLevel(1)
		hCaster:SwapAbilities(sName, "el_dorado_change_item_slot_"..tostring(iSlot+1).."_lua", true, true)
		hCaster.iItemSlot = iSlot+1
		hCaster:RemoveAbility(sName)
	else
		hCaster:AddAbility("el_dorado_change_item_slot_0_lua"):SetLevel(1)
		hCaster:SwapAbilities(sName, "el_dorado_change_item_slot_0_lua", true, true)
		hCaster.iItemSlot = 0
		hCaster:RemoveAbility(sName)
	end
end


el_dorado_change_item_slot_0_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_1_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_2_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_3_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_4_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_5_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_6_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_7_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_8_lua.OnSpellStart = EldoradoChangeItemSlot
el_dorado_change_item_slot_9_lua.OnSpellStart = EldoradoChangeItemSlot

el_dorado_artificial_frog = class({})

function el_dorado_artificial_frog:OnUpgrade()
	if self:GetLevel() == 1 then
		self:GetCaster():FindAbilityByName("el_dorado_change_item_slot_0_lua"):SetLevel(1)
	end
end

function el_dorado_artificial_frog:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Creep_Good_Engine.Move")
	hCaster.tSummons = hCaster.tSummons or {}	
	local vSummonSpot = hCaster:GetOrigin()+hCaster:GetForwardVector():Normalized()*150
	local iSlot = 1
	
	hCaster.iLastFrog = hCaster.iLastFrog or 0
	
	while hCaster.tSummons[iSlot] and not hCaster.tSummons[iSlot]:IsNull() and hCaster.tSummons[iSlot]:IsAlive() do
		iSlot = iSlot+1
	end
	
	if iSlot > hCaster.iLastFrog then
		hCaster.iLastFrog = iSlot
	end
	
	hCaster.tSummons[iSlot] = CreateUnitByName("npc_el_dorado_artificial_frog", vSummonSpot, true, hCaster, hCaster, hCaster:GetTeamNumber())
	hCaster.tSummons[iSlot]:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)	
	FindClearSpaceForUnit(hCaster.tSummons[iSlot], hCaster.tSummons[iSlot]:GetOrigin(), true)	
	hCaster.tSummons[iSlot]:SetForwardVector(hCaster:GetForwardVector())
	if hCaster:GetItemInSlot(hCaster.iItemSlot):GetCost()+1000 < 4000 then
		hCaster.tSummons[iSlot]:SetBaseMaxHealth(hCaster:GetItemInSlot(hCaster.iItemSlot):GetCost()+1000)
		hCaster.tSummons[iSlot]:SetMaxHealth(hCaster:GetItemInSlot(hCaster.iItemSlot):GetCost()+1000)
		hCaster.tSummons[iSlot]:SetHealth(hCaster:GetItemInSlot(hCaster.iItemSlot):GetCost()+1000)
	else
		hCaster.tSummons[iSlot]:SetMaxHealth(4000)
		hCaster.tSummons[iSlot]:SetBaseMaxHealth(4000)
		hCaster.tSummons[iSlot]:SetHealth(4000)
	end
	hCaster.tSummons[iSlot]:AddNewModifier(hCaster, self, "modifier_el_dorado_artificial_frog_disable_healing", {})
	hCaster:RemoveItem(hCaster:GetItemInSlot(hCaster.iItemSlot))
end


function el_dorado_artificial_frog:CastFilterResult()
	local hCaster = self:GetCaster()
	if IsClient() then return UF_SUCCESS end
	
	if not hCaster:GetItemInSlot(hCaster.iItemSlot) or hCaster:GetItemInSlot(hCaster.iItemSlot):GetName() == "item_aegis" then 
		return UF_FAIL_CUSTOM
	end
	
	if hCaster:FindAbilityByName("special_bonus_el_dorado_1"):GetLevel() == 0 then
		local bCanNotSummon = true
		if not hCaster.tSummons then return UF_SUCCESS end
		for i = 1, self:GetSpecialValueFor("max_frogs") do
			bCanNotSummon = bCanNotSummon and hCaster.tSummons[i] and not hCaster.tSummons[i]:IsNull() and hCaster.tSummons[i]:IsAlive()
		end
		if bCanNotSummon then return UF_FAIL_CUSTOM end
	end
	
	return UF_SUCCESS	
end

function el_dorado_artificial_frog:GetCustomCastError()
	local hCaster = self:GetCaster()
	if IsClient() then return UF_SUCCESS end
	if not hCaster:GetItemInSlot(hCaster.iItemSlot) then return "error_el_dorado_artificial_frog_no_item" end
	if hCaster:GetItemInSlot(hCaster.iItemSlot):GetName() == "item_aegis" then return "error_el_dorado_artificial_frog_aegis" end
	return "error_el_dorado_artificial_frog_no_more_frogs"
end

ElDoradoArtificialFrogBlink = function (keys)
	local vOrigin = keys.caster:GetOrigin()
	local vDestnation = keys.target_points[1]
	if (vDestnation - vOrigin):Length2D() > keys.ability:GetSpecialValueFor("blink_range") then
		vDestnation = vOrigin+(vDestnation - vOrigin):Normalized()*keys.ability:GetSpecialValueFor("blink_range_clamp")
	end
	keys.caster:EmitSound("LoneDruid_SpiritBear.ReturnStart")
	ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
	Timers:CreateTimer(0.04, function ()
		ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
		keys.caster:EmitSound("LoneDruid_SpiritBear.Return") 
	end)
	FindClearSpaceForUnit(keys.caster, vDestnation, true)
end
el_dorado_refine_weapons = class({})

function el_dorado_refine_weapons:OnUpgrade() if self:GetLevel() == 1 then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_el_dorado_refine_weapons", {}) end end

el_dorado_piracy_method = class({})

function el_dorado_piracy_method:GetIntrinsicModifierName()
	return "modifier_el_dorado_piracy_method"
end

function el_dorado_piracy_method:OnSpellStart()
	if IsClient() then return end
	self.hTarget = self:GetCursorTarget()
	self:RefundManaCost()
	self:EndCooldown()
end

function el_dorado_piracy_method:GetChannelTime()
	if self:GetCaster():HasScepter() then 
		return self:GetSpecialValueFor("channel_time_scepter")
	else
		return self:GetSpecialValueFor("channel_time")
	end
end

function el_dorado_piracy_method:CastFilterResultTarget(hTarget)
	if IsClient() then return UF_SUCCESS end
	local bHasEmptySlot = false
	for i = 0, 8 do
		if not self:GetCaster():GetItemInSlot(i) then
			bHasEmptySlot = true
			break
		end
	end
	if bHasEmptySlot then return UF_SUCCESS
	else return UF_FAIL_CUSTOM
	end
end

function el_dorado_piracy_method:GetCustomCastErrorTarget(hTarget)
	return "error_el_dorado_piracy_method_inventory_full"
end

function el_dorado_piracy_method:GetChannelAnimation()
	return ACT_DOTA_TELEPORT
end

function el_dorado_piracy_method:OnChannelFinish(bInterrupted)
	if bInterrupted then
	else
		self:UseResources(true, true, true, true)
		local tTargetItems = {}
		local j = 1
		for i = 0, 8 do
			if self.hTarget:GetItemInSlot(i) then
				tTargetItems[j] = i
				j = j+1
			end
		end
		if j > 1 then
			self:GetCaster():AddItemByName(self.hTarget:GetItemInSlot(tTargetItems[RandomInt(1, j-1)]):GetName())
		end
	end
end







