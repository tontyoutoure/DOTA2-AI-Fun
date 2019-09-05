
INVOKER_RETRO_WEARABLE_MAGUS_APEX = 2
INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE = 4
INVOKER_RETRO_WEARABLE_MAGUS_APEX_EXTRA = 8
INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE_EXTRA = 16


local tNewAbilities = {
	"invoker_retro_quas",
	"invoker_retro_wex",
	"invoker_retro_exort",
	"invoker_retro_empty1",
	"invoker_retro_empty2",
	"invoker_retro_invoke",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_invoker_retro_5",
	"special_bonus_unique_invoker_retro_4",
	"special_bonus_unique_invoker_retro_3",
	"special_bonus_unique_invoker_retro_2",
	"special_bonus_unique_invoker_retro_6",
	"special_bonus_unique_invoker_retro_1",
}
local tShowedAbilities = {
	"invoker_retro_quas",
	"invoker_retro_wex",
	"invoker_retro_exort",
	"invoker_retro_empty1",
	"invoker_retro_invoke",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_invoker_retro_5",
	"special_bonus_unique_invoker_retro_4",
	"special_bonus_unique_invoker_retro_3",
	"special_bonus_unique_invoker_retro_2",
	"special_bonus_unique_invoker_retro_6",
	"special_bonus_unique_invoker_retro_1",
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackAnimationPoint = 0.3,
	AttackRate = 1.7,
	AttackDamageMin = 3,
	AttackDamageMax = 19,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 15,
	AttributeBaseIntelligence = 22,
	AttributeStrengthGain = 1.8,
	AttributeAgilityGain = 1.45,
	AttributeIntelligenceGain = 3.6,
	AttackRange = 600,
	ArmorPhysical = -1,
	bNoAttributeManager = true,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
}

CustomNetTables:SetTableValue("fun_hero_stats", "invoker_retro_abilities", tShowedAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "invoker_retro", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("invoker_retro", tShowedAbilities)
function InvokerRetroEntityKillListener( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity

	if keys.entindex_attacker then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	if killedUnit ~= nil and killedUnit:IsRealHero() then
		--In version 1.0.0, the Betrayal spell was occasionally erroring out, causing heroes to be stuck on a custom team by themselves.
		--Then, when they attempted to respawn, the game would crash because there was no spawn point for that team.  As a backup,
		--here we make sure a hero is moved back to its original team on death.
		if killedUnit:HasModifier("modifier_invoker_retro_betrayal") then
			killedUnit:RemoveModifierByName("modifier_invoker_retro_betrayal")
		end
		local killed_unit_pid = killedUnit:GetPlayerID()
		if killed_unit_pid ~= nil and PlayerResource:IsValidPlayerID(killed_unit_pid) and PlayerResource:IsValidPlayer(killed_unit_pid) then
			local killed_unit_player = PlayerResource:GetPlayer(killed_unit_pid)
			local killed_unit_current_team = killedUnit:GetTeam()
			if killed_unit_player ~= nil and killed_unit_player.invoker_retro_betrayal_original_team ~= nil and killed_unit_current_team ~= "DOTA_TEAM_GOODGUYS" and killed_unit_current_team ~= "DOTA_TEAM_BADGUYS" then  --If the invoker_retro_betrayal_original_team was not stored, we're in trouble.
				PlayerResource:SetCustomTeamAssignment(killed_unit_pid, killedUnit.invoker_retro_betrayal_original_team)
				killedUnit:SetTeam(killed_unit_player.invoker_retro_betrayal_original_team)
				killedUnit.invoker_retro_betrayal_original_team = nil
			end
		end
	end
end


local function InvokerRetroInitOnce()
	firestorm_fireballs = {}
	for i=0, 79, 1 do
		local fireball_unit = CreateUnitByName("npc_dota_invoker_retro_firestorm_unit", Vector(7000, 7000, 128), false, nil, nil, DOTA_TEAM_GOODGUYS)
		local fireball_unit_ability = fireball_unit:FindAbilityByName("invoker_retro_firestorm_fireball")
		if fireball_unit_ability ~= nil then
			fireball_unit_ability:SetLevel(1)
			fireball_unit_ability:ApplyDataDrivenModifier(fireball_unit, fireball_unit, "dummy_modifier_no_health_bar", nil)
		end
		
		firestorm_fireballs[i] = fireball_unit
	end
	
	ListenToGameEvent( "entity_killed", InvokerRetroEntityKillListener, nil )
	
	
	tInvokerItemsGameFromKV = LoadKeyValues("scripts/vscripts/heroes/hero_invoker/invoker_wearables.kv")
	local iItemIndex = 1
	local iItemTransferIndex = 1
	local iItemTransferCount = 5
	local tItemTransfer = {}
	for k, v in pairs(tInvokerItemsGameFromKV.items) do
		tItemTransfer[k] = v
		iItemIndex = iItemIndex+1
		if iItemIndex > iItemTransferCount then
			iItemIndex = 1
			CustomNetTables:SetTableValue('invoker_retro', 'InvokerWearableTable_'..tostring(iItemTransferIndex), tItemTransfer)
			tItemTransfer = {}
			iItemTransferIndex = iItemTransferIndex+1
		end
	end
	CustomNetTables:SetTableValue('invoker_retro', 'InvokerWearableTable_'..tostring(iItemTransferIndex), tItemTransfer)
	if IsInToolsMode() then
		local tInvokerHeadsFromKV=LoadKeyValues("scripts/vscripts/heroes/hero_invoker/invoker_heads.kv")
		local tPariticles = {}
		local tItems = {}
		local tItemsGame = {items = tItems, attribute_controlled_attached_particles = tPariticles}
		local bNewItems = false
		for k, v in pairs(GameItems.items) do
			if type(v.used_by_heroes) == 'table' and v.used_by_heroes.npc_dota_hero_invoker and (v.prefab == "wearable" or v.prefab == "default_item") then
				if not tInvokerItemsGameFromKV.items[k] then
					bNewItems = true
				end
				if v.item_slot == 'head' and not tInvokerHeadsFromKV[k] then
					print('New Invoker head, id is '..k..', name is '..v.name)
				end
				local tItem = {
					name = v.name, 
					image_inventory = v.image_inventory, 
					item_name = v.item_name, 
					item_rarity = v.item_rarity, 
					item_slot = v.item_slot,
					model_player = v.model_player}
				if v.visuals then
					tItem.visuals = {}
					tItem.visuals.styles = v.visuals.styles
					tItem.visuals.alternate_icons = v.visuals.alternate_icons
					for k1, v1 in pairs(v.visuals) do
						if type(v1) == 'table' and v1.type and (v1.type == "particle_create" or v1.type == "entity_model") then
							tItem.visuals[k1] = v1
							tPariticles[v1.modifier] = true
						end
					end
				end
				tItems[k] = tItem
			end
		end

		for k,v in pairs(GameItems.attribute_controlled_attached_particles) do
			if tPariticles[v.system] then
				tPariticles[v.system] = nil
				tPariticles[k] = v
			end
		end
		-- for ti 7 bracer's particle
		tItems['7821'].visuals.asset_modifier0 = {type="particle_create", style='0', modifier = "particles/econ/items/invoker/invoker_ti7/invoker_ti7_bracer_ambient.vpcf"}
		
		tPariticles['15498'] = {system = "particles/econ/items/invoker/invoker_ti7/invoker_ti7_bracer_ambient.vpcf", attach_type = 'customorigin', attach_entity = "self", control_points={["0"] = {control_point_index = "0", attach_type = "point_follow", attachment = "attach_hand_l"}, ["1"] = {control_point_index = "1", attach_type = "point_follow", attachment = "attach_hand_r"}}}
		


		if bNewItems then
			fi = io.open('c:/Program Files (x86)/Steam/SteamApps/common/dota 2 beta/game/dota_addons/dota2_ai_fun/scripts/vscripts/heroes/hero_invoker/invoker_wearables.kv', 'w')
			WriteKV(fi, 'items_game', tItemsGame)
			fi:close()
		end
	end
end


local INVOKER_RETRO_WEARABLE_MAGUS_APEX = 2
local INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE = 4

if IsServer() then
	LinkLuaModifier("modifier_invoker_retro_cosmetic_manager", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_invoker_retro_manager", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE) 
end


-- tNewWearable is used to record the wearables by body part for a hero, so it could be removed in the future.
function ChangeInvokerWearable(hHero, tInvokerWearable)
--	PrintTable(tInvokerWearable)
	if hHero:HasModifier('modifier_wearable_hider_while_model_changes') then
		local sOriginalModel = hHero:FindModifierByName('modifier_wearable_hider_while_model_changes').sOriginalModel
		if hHero:GetModelName() ~= sOriginalModel then
			return
		end
	end
	
	hHero.tNewWearable = hHero.tNewWearable or {}
	
	if hHero.tNewWearable.head then
		WearableManager:RemoveWearableByIndex(hHero, hHero.tNewWearable.head)
		hHero.tNewWearable.head = nil
	end
	hHero.tNewWearable.head = tInvokerWearable.head.id
	WearableManager:AddNewWearable(hHero, {ID=tInvokerWearable.head.id, style=tInvokerWearable.head.style}, tInvokerItemsGameFromKV)


	if hHero.tNewWearable.shoulder then
		WearableManager:RemoveWearableByIndex(hHero, hHero.tNewWearable.shoulder)
		hHero.tNewWearable.shoulder = nil
	end
	hHero.tNewWearable.shoulder = tInvokerWearable.shoulder.id
	WearableManager:AddNewWearable(hHero, {ID=tInvokerWearable.shoulder.id, style=tInvokerWearable.shoulder.style}, tInvokerItemsGameFromKV)


	if hHero.tNewWearable.back then
		WearableManager:RemoveWearableByIndex(hHero, hHero.tNewWearable.back)
		hHero.tNewWearable.back = nil
	end
	hHero.tNewWearable.back = tInvokerWearable.back.id
	WearableManager:AddNewWearable(hHero, {ID=tInvokerWearable.back.id, style=tInvokerWearable.back.style}, tInvokerItemsGameFromKV)


	if hHero.tNewWearable.arms then
		WearableManager:RemoveWearableByIndex(hHero, hHero.tNewWearable.arms)
		hHero.tNewWearable.arms = nil
	end
	hHero.tNewWearable.arms = tInvokerWearable.arms.id
	WearableManager:AddNewWearable(hHero, {ID=tInvokerWearable.arms.id, style=tInvokerWearable.arms.style}, tInvokerItemsGameFromKV)


	if hHero.tNewWearable.belt then
		WearableManager:RemoveWearableByIndex(hHero, hHero.tNewWearable.belt)
		hHero.tNewWearable.belt = nil
	end
	hHero.tNewWearable.belt = tInvokerWearable.belt.id
	WearableManager:AddNewWearable(hHero, {ID=tInvokerWearable.belt.id, style=tInvokerWearable.belt.style}, tInvokerItemsGameFromKV)
	
	CustomNetTables:SetTableValue('invoker_retro', 'wearables_for_player_'..tostring(hHero:GetPlayerOwnerID()), tInvokerWearable)
end

function InvokerRetroChangeWearableListener(eventSourceIndex, keys)
	local hPlayer = PlayerResource:GetPlayer(keys.PlayerID)
	local hHero = hPlayer:GetAssignedHero()
	hPlayer.tInvokerWearable = keys
	ChangeInvokerWearable(hHero, keys)
end


function InvokerRetroInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_invoker_retro", {})		
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	hHero:FindAbilityByName("invoker_retro_invoke").AttributeStrengthGain = tHeroBaseStats.AttributeStrengthGain
	hHero:FindAbilityByName("invoker_retro_invoke").AttributeAgilityGain = tHeroBaseStats.AttributeAgilityGain
	hHero:FindAbilityByName("invoker_retro_invoke").AttributeIntelligenceGain = tHeroBaseStats.AttributeIntelligenceGain
	hHero:AddNewModifier(hHero, nil, "modifier_invoker_retro_manager", {})
	if not GameMode.bInvokerRetroFirstInited then
		InvokerRetroInitOnce()
		CustomGameEventManager:RegisterListener("invoker_retro_change_wearables", InvokerRetroChangeWearableListener)
		GameMode.bInvokerRetroFirstInited = true
	end
	if GameMode.tWearablesChange and GameMode.tWearablesChange[hHero:GetPlayerOwnerID()] then
		for i, v in pairs(hHero:GetChildren()) do
			if v:GetClassname() == 'dota_item_wearable' and v:GetModelName() ~= 'models/heroes/invoker/invoker_head.vmdl' then
				v:RemoveSelf()
			end
		end
		hHero:GetPlayerOwner().tInvokerWearable =  hHero:GetPlayerOwner().tInvokerWearable or {
			head = {id = '99'},
			shoulder = {id = '89'},
			back = {id = '48'},
			arms = {id = '100'},
			belt = {id = '305'},
		}
		ChangeInvokerWearable(hHero, hHero:GetPlayerOwner().tInvokerWearable)
		hHero:AddNewModifier(hHero, nil, 'modifier_wearable_hider_while_model_changes', {}).sOriginalModel = hHero:GetModelName()
	end
end