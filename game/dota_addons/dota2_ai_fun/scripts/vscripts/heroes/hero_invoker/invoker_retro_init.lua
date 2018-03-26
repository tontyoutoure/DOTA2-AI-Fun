local tNewAbilities = {
	"invoker_retro_quas",
	"invoker_retro_wex",
	"invoker_retro_exort",
	"invoker_retro_empty1",
	"invoker_retro_empty2",
	"invoker_retro_invoke",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_attack_speed_30",
	"special_bonus_astral_trekker_1",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_astral_trekker_2",
}
local tShowedAbilities = {
	"invoker_retro_quas",
	"invoker_retro_wex",
	"invoker_retro_exort",
	"invoker_retro_empty1",
	"invoker_retro_invoke",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_armor_10",
	"special_bonus_attack_speed_30",
	"special_bonus_astral_trekker_1",
	"special_bonus_hp_600",
	"special_bonus_lifesteal_30",
	"special_bonus_astral_trekker_2",
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
	AttributeStrenthGain = 1.8,
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
local tInvokerWearables
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
	tInvokerWearables = LoadKeyValues("scripts/vscripts/heroes/hero_invoker/invoker_wearables.txt") 
	if IsInToolsMode() then
		local tInvokerWearableNew = {}
		for k, v in pairs(GameItems.items) do
			if v.model_player then
				if string.match(v.model_player, "invoker") and not tInvokerWearables[v.model_player] then
					tInvokerWearableNew[v.model_player] = v.item_slot
				end
			end
		end
		local bHasNewWearables
		for k, v in pairs(tInvokerWearableNew) do
			bHasNewWearables = true
			tInvokerWearables[k]=v
		end
		PrintTable(tInvokerWearableNew)
		if bHasNewWearables then
		
			local fhInvokerWearable = io.open('c:/Program Files (x86)/Steam/SteamApps/common/dota 2 beta/game/dota_addons/dota2_ai_fun/scripts/vscripts/heroes/hero_invoker/invoker_wearables.txt', 'w')
			fhInvokerWearable:write('"invoker_wearables"\n{\n')
			for k, v in pairs(tInvokerWearables) do
		
				fhInvokerWearable:write('\t"'..k .. '" "'.. v..'"\n')
			end
			fhInvokerWearable:write('}')
			fhInvokerWearable:close()
		end
	end
end

local INVOKER_RETRO_WEARABLE_MAGUS_APEX = 2
local INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE = 4

function InvokerRetroInit(hHero)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_invoker_retro", {})		
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	hHero:FindAbilityByName("invoker_retro_invoke").AttributeStrenthGain = tHeroBaseStats.AttributeStrenthGain
	hHero:FindAbilityByName("invoker_retro_invoke").AttributeAgilityGain = tHeroBaseStats.AttributeAgilityGain
	hHero:FindAbilityByName("invoker_retro_invoke").AttributeIntelligenceGain = tHeroBaseStats.AttributeIntelligenceGain
	if not GameMode.bInvokerRetroFirstInited then
		InvokerRetroInitOnce()
		GameMode.bInvokerRetroFirstInited = true
	end
end