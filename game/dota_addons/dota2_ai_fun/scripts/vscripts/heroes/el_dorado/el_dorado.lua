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
	"item_stout_shield",
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
	"item_gem",
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
	PrintTable(tItemListLv[1])
	PrintTable(tItemListLv[2])
	PrintTable(tItemListLv[3])
	PrintTable(tItemListLv[4])
	if iItem <= #tItemListLv[1] then sColor = "white"
	elseif iItem <= #tItemListLv[2] then sColor = "blue"
	elseif iItem <= #tItemListLv[3] then sColor = "purple"
	elseif iItem <= #tItemListLv[4] then sColor = "gold" end
	local sItemName = tItemListLv[self:GetLevel()][iItem]
	print(iItem, sItemName, sColor)
	if hCaster:HasModifier("modifier_item_master_piracy_method") and ((hCaster:HasScepter() and RandomFloat(0, 1) < hCaster:FindModifierByName("modifier_item_master_piracy_method"):GetAbility():GetSpecialValueFor("bonus_chance_scepter")) or (not hCaster:HasScepter() and RandomFloat(0, 1) < hCaster:FindModifierByName("modifier_item_master_piracy_method"):GetAbility():GetSpecialValueFor("bonus_chance"))) then
		local hItem = CreateItem(sItemName, hCaster, hCaster)
		CreateItemOnPositionSync(vLocation, hItem)
		FindClearSpaceForUnit(hItem, vLocation, false)
		hItem = CreateItem(sItemName, hCaster, hCaster)
		CreateItemOnPositionSync(vLocation, hItem)
		FindClearSpaceForUnit(hItem, vLocation, false)
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge1", style = {color = sColor}})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#DOTA_Tooltip_Ability_"..sItemName, style = {color = sColor}, continue = true})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge2", style = {color = sColor}, continue = true})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge3", style = {color = sColor}, continue = true})
	else
		local hItem = CreateItem(sItemName, hCaster, hCaster)
		CreateItemOnPositionSync(vLocation, hItem)
		FindClearSpaceForUnit(hItem, vLocation, false)
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge1", style = {color = sColor}})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#DOTA_Tooltip_Ability_"..sItemName, style = {color = sColor}, continue = true})
		Notifications:Bottom(hCaster:GetPlayerOwnerID(), {text="#item_forge3", style = {color = sColor}, continue = true})
	end
end

el_dorado_artificial_frog = class({})

function el_dorado_artificial_frog:OnSpellStart()
end

function el_dorado_artificial_frog:CastFilterResultTarget(hTarget)
	print(hTarget:GetName())
	return UF_SUCCESS
end