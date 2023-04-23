local tNeutralItems = {
	{
		--"item_keen_optic",
		"item_trusty_shovel",
		"item_arcane_ring",			
		--"item_possessed_mask",
		"item_mysterious_hat",
		"item_unstable_wand",
		"item_pogo_stick",							
		"item_seeds_of_serenity",
		"item_lance_of_pursuit",
		"item_occult_bracelet",
		"item_duelist_gloves",

		--"item_ocean_heart",
		"item_broom_handle",
		--"item_chipped_vest",

		--"item_royal_jelly",
		"item_faded_broach",
		--"item_ironwood_tree",
		"item_spark_of_courage",
	}, 

	{
		"item_ring_of_aquila",
		--"item_imp_claw",
		--"item_nether_shawl",
		"item_dragon_scale",
		"item_pupils_gift",
		"item_vambrace",
		--"item_misericorde",
		"item_grove_bow",
		"item_philosophers_stone",
		--"item_essence_ring",
		--"item_paintball",
		"item_bullwhip",
		--"item_quicksilver_amulet",
		--"item_dagger_of_ristul",
		"item_orb_of_destruction",
		"item_specialists_array",
		"item_eye_of_the_vizier",
		"item_vampire_fangs",
		--"item_blighted_spirit",
		"item_gossamer_cape",
	},

	{
		"item_quickening_charm",
		"item_defiant_shell",
		--"item_black_powder_bag",
		--"item_spider_legs",
		--"item_icarus_wings",
		"item_paladin_sword",
		"item_vindicators_axe",
		"item_dandelion_amulet",
		--"item_orb_of_destruction",
		"item_titan_sliver",
		"item_enchanted_quiver",
		"item_elven_tunic"				  ,
		"item_cloak_of_flames",
		"item_ceremonial_robe",
		"item_psychic_headband",
		--"item_slime_vial",
		"item_ogre_seal_totem",
		--"item_quicksilver_amulet",
		--"item_essence_ring",
	},

	{
		"item_timeless_relic",
		"item_spell_prism",
		"item_ascetic_cap",
		--"item_heavy_blade",
		--"item_flicker",
		"item_ninja_gear",
		--"item_illusionsts_cape",
		--"item_fortitude_ring",
		--"item_the_leveller",
		--"item_minotaur_horn",
		"item_spy_gadget",
		"item_trickster_cloak",
		"item_stormcrafter",
		"item_penta_edged_sword",
		"item_havoc_hammer",
		
		--"item_princes_knife",
		--"item_harpoon",
		--"item_barricade"			  ,
		
		--"item_horizons_equilibrium",
		"item_mind_breaker",
		"item_martyrs_plate",
	},

	{
		"item_force_boots",
		"item_desolator_2",
		"item_seer_stone",
		"item_mirror_shield"			  ,
		"item_apex",
		--"item_ballista",
		"item_demonicon",
		"item_fallen_sky"		  ,
		"item_force_field",
		"item_pirate_hat",
		"item_ex_machina",
		"item_giants_ring",
		--"item_vengeances_shadow",
		"item_book_of_shadows",
		--"item_manacles_of_power",
		--"item_bottomless_chalice",
		--"item_wand_of_sanctitude",
	},
}
local tNeutralItemsReverse = {}
for i, v in ipairs(tNeutralItems) do
	for j, u in ipairs(v) do
		tNeutralItemsReverse[u] = i
		if string.find(u,'_recipe_') then
			local a, b = string.find(u,'_recipe_')
--			print(u,string.sub(1,a-1)..string.sub(b+1,-1))
			tNeutralItemsReverse[string.sub(u,1,a-1)..string.sub(u,b,-1)] = i
		end
	end
end
--PrintTable(tNeutralItemsReverse)
local tReturnAmount = {}

if IsServer() then
	local tItems = LoadKeyValues('scripts/npc/npc_items_custom.txt')
	GameMode.iLotteryCost = tItems.item_lottery.ItemCost
	GameMode.iLottery10Cost = tItems.item_lottery_10.ItemCost
	for i = 1,5 do
		tReturnAmount[i] = tItems.item_lottery.AbilitySpecial[string.format('%02d',i+5)]['return_lv'..tostring(i)]
	end
	tItems = nil
	--[[
	function GameMode:LotteryExecuteOrderFilter(filterTable)
		if filterTable.order_type == DOTA_UNIT_ORDER_SELL_ITEM then
			PrintTable(filterTable)
			local hHero = EntIndexToHScript(filterTable.units["0"])
			local hItem = EntIndexToHScript(filterTable.entindex_ability)
			print(hItem:GetPurchaser():GetName())
		end
		return true
	end
	--]]
	
	local function FindItemInAllSlotsAndCourier(hHero, sName)
		local hPlayer = hHero:GetPlayerOwner()
		for i = 0, DOTA_ITEM_MAX do
			if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == sName then return hHero:GetItemInSlot(i) end
			if hPlayer.hCourier:GetItemInSlot(i) and hPlayer.hCourier:GetItemInSlot(i):GetName() == sName then return hPlayer.hCourier:GetItemInSlot(i) end
		end
		return nil
	end
	
	function GameMode:OnLotteryPurchased(keys)
		if self.iEnableLottery == 0 and keys.itemname == 'item_lottery' then
			while true do
				local hItem = FindItemInAllSlotsAndCourier(PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero(), 'item_lottery') 
				if not hItem then break end 
				PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero():RemoveItem(hItem)
				PlayerResource:ModifyGold(keys.PlayerID, self.iLotteryCost,false, DOTA_ModifyGold_SellItem)
			end
		end
		if self.iEnableLottery == 0 and keys.itemname == 'item_lottery_10' then
			while true do
				local hItem = FindItemInAllSlotsAndCourier(PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero(), 'item_lottery_10') 
				
				if not hItem then break end 
				PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero():RemoveItem(hItem)
				PlayerResource:ModifyGold(keys.PlayerID, self.iLottery10Cost,false, DOTA_ModifyGold_SellItem)
			end
		end
		if keys.itemname == 'item_sell_neutral_items' then
			local hPlayer = PlayerResource:GetPlayer(keys.PlayerID)
			local hHero = hPlayer:GetAssignedHero()
			for i = 0,DOTA_ITEM_MAX do
				if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == 'item_sell_neutral_items' then
					hHero:GetItemInSlot(i):RemoveSelf()
				end
				if hPlayer.hCourier:GetItemInSlot(i) and hPlayer.hCourier:GetItemInSlot(i):GetName() == 'item_sell_neutral_items' then
					hPlayer.hCourier:GetItemInSlot(i):RemoveSelf()
				end
				if hPlayer.tItemsFromLottery then
					local hCount = #hPlayer.tItemsFromLottery
					print(hCount)
					for i = 1, hCount do
						local hItem = EntIndexToHScript(hPlayer.tItemsFromLottery[hCount+1-i])
						if hItem:GetContainer() then
							local iReturn = tReturnAmount[tNeutralItemsReverse[hItem:GetName()]]
							if hItem:GetCurrentCharges() > 0 then
								iReturn = math.ceil(iReturn*hItem:GetCurrentCharges()/hItem:GetInitialCharges())
							end
							hItem:GetContainer():RemoveSelf()
							hItem:RemoveSelf()
							local hLottery = hHero:FindItemInInventory('item_lottery')
							if not hLottery then 
								hLottery = hHero:AddItemByName('item_lottery')
								iReturn = iReturn-1
							end
							hLottery:SetCurrentCharges(hLottery:GetCurrentCharges()+iReturn)
							table.remove(hPlayer.tItemsFromLottery, hCount+1-i)
						end
					end
				end
			end
			
			
		end
	end
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnLotteryPurchased'), GameMode)
end


local function LotteryOnSpellStart(self)
	local hCaster = self:GetCaster()
	EmitSoundOnClient('Item.TomeOfKnowledge', hCaster:GetPlayerOwner())
	local fRoll = RandomFloat(0,100)
	local tAccumulatedChance = {}
	tAccumulatedChance[1] = self:GetSpecialValueFor('chance_lv1')
	for i = 2, 5 do
		tAccumulatedChance[i] = self:GetSpecialValueFor('chance_lv'..tostring(i))+tAccumulatedChance[i-1]
	end
	-- print(fRoll)
	-- _DeepPrintTable(tAccumulatedChance)
	local sName
	if fRoll < tAccumulatedChance[1] then
		sName = tNeutralItems[1][RandomInt(1,#tNeutralItems[1])]
	elseif fRoll < tAccumulatedChance[2] then
		sName = tNeutralItems[2][RandomInt(1,#tNeutralItems[2])]
	elseif fRoll < tAccumulatedChance[3] then
		sName = tNeutralItems[3][RandomInt(1,#tNeutralItems[3])]
	elseif fRoll < tAccumulatedChance[4] then
		sName = tNeutralItems[4][RandomInt(1,#tNeutralItems[4])]
	elseif fRoll < tAccumulatedChance[5] then
		sName = tNeutralItems[5][RandomInt(1,#tNeutralItems[5])]
	end
	if sName then
		local tMessageTables = {
			{
				duration = 4,
				item = 'item_lottery',
			},
			{
				duration = 4,
				text = "#lottery1",
				continue = true
			},
			{
				duration = 4,
				hero = self:GetCaster():GetName(),
				continue = true
			},
			{
				duration = 4,
				text = "#lottery2",
				continue = true
			},
			{
				duration = 4,
				item = sName,
				continue = true
			},
			{
				duration = 4,
				text = "#lottery3",
				continue = true
			},
		}
		if fRoll > tAccumulatedChance[3] then
			
			for i = 1, #tMessageTables do
				Notifications:BottomToAll(tMessageTables[i])
			end
		else
			for i = 1, #tMessageTables do
				Notifications:Bottom(self:GetCaster():GetPlayerOwnerID(), tMessageTables[i])
			end
		end
		local hItem = CreateItem(sName, hCaster, hCaster)
		hCaster:GetPlayerOwner().tItemsFromLottery = hCaster:GetPlayerOwner().tItemsFromLottery or {}
		
		
		table.insert(hCaster:GetPlayerOwner().tItemsFromLottery, 1, hItem:entindex())
		local hLootBox = CreateItemOnPositionSync(hCaster:GetOrigin()+RandomVector(100),hItem)
		ParticleManager:CreateParticle('particles/neutral_fx/neutral_item_drop.vpcf', PATTACH_ABSORIGIN, hLootBox)
	end
	if self:GetName() == 'item_lottery' then
		self:SetCurrentCharges(self:GetCurrentCharges()-1)
		if self:GetCurrentCharges() <= 0 then
			self:RemoveSelf()
		elseif self:GetCurrentCharges() % 10 == 0 and self:IsCombinable() then
			local iCharge = self:GetCurrentCharges()/10
			local hLottery10 = self:GetCaster():FindItemInInventory('item_lottery_10')
			self:RemoveSelf()
			if hLottery10 then
				hLottery10:SetCurrentCharges(hLottery10:GetCurrentCharges()+iCharge)
			else
				hCaster:AddItemByName('item_lottery_10'):SetCurrentCharges(iCharge)
			end
		end
	end
end

item_lottery = class({})
item_lottery.OnSpellStart = LotteryOnSpellStart
item_lottery_10 = class({})
function item_lottery_10:OnSpellStart()
	for i = 1, 11 do
		LotteryOnSpellStart(self)
	end
	self:SetCurrentCharges(self:GetCurrentCharges()-1)
	if self:GetCurrentCharges() <= 0 then
		self:RemoveSelf()
	end
end

modifier_lottery_manager = class({})
function modifier_lottery_manager:IsHidden() return true end
function modifier_lottery_manager:RemoveOnDeath() return false end
function modifier_lottery_manager:IsPurgable() return false end

sell_neutral_items = class({})
function sell_neutral_items:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound('General.CoinsBig')
--	PrintTable(tReturnAmount)
	for i = 0,DOTA_ITEM_MAX do
--		if hCaster:GetItemInSlot(i) then print('selling', hCaster:GetItemInSlot(i):GetName(),tReturnAmount[tNeutralItemsReverse[hCaster:GetItemInSlot(i):GetName()]],hCaster:GetItemInSlot(i).hNeutralItemOwner == hCaster:GetPlayerOwner()) end
		if hCaster:GetItemInSlot(i) and tNeutralItemsReverse[hCaster:GetItemInSlot(i):GetName()] and hCaster:GetItemInSlot(i).hNeutralItemOwner == hCaster:GetPlayerOwner() then
			local hItem = hCaster:GetItemInSlot(i)
			local iReturn = tReturnAmount[tNeutralItemsReverse[hItem:GetName()]]
			if hItem:GetCurrentCharges() > 0 then
				iReturn = math.ceil(iReturn*hItem:GetCurrentCharges()/hItem:GetInitialCharges())
			end
			hCaster:RemoveItem(hItem)
			local hLottery = hCaster:FindItemInInventory('item_lottery')
			if not hLottery then 
				hLottery = hCaster:AddItemByName('item_lottery')
				iReturn = iReturn-1
			end
			hLottery:SetCurrentCharges(hLottery:GetCurrentCharges()+iReturn)
		end
	end
end

local function IsInventoryFull(hUnit)
	for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_SLOT_9 do
		if not hUnit:GetItemInSlot(i) then return false end
	end
	return true
end

retrieve_neutral_items = class({})
function retrieve_neutral_items:OnSpellStart()
	local hCaster = self:GetCaster()
	local tItems = Entities:FindAllByClassnameWithin('dota_item_drop', hCaster:GetOrigin(), self:GetSpecialValueFor('range'))
	
	for i = 1, #tItems do
		if tItems[#tItems+1-i]:GetContainedItem().hNeutralItemOwner == hCaster:GetPlayerOwner() and not IsInventoryFull(hCaster) then
			hCaster:AddItem(tItems[#tItems+1-i]:GetContainedItem())
			tItems[#tItems+1-i]:RemoveSelf()
		end
	end
end

















