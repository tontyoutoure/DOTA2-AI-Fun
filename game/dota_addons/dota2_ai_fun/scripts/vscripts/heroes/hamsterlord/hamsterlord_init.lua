LinkLuaModifier("modifier_special_bonus_hamsterlord_5", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

local tNewAbilities = {
	"hamsterlord_pizza_house_delivery",
	"hamsterlord_take_nap",
	"hamsterlord_injure_knees",
	"generic_hidden",
	"generic_hidden",
	"hamsterlord_call_of_hamster",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_hamsterlord_3",
	"special_bonus_hamsterlord_1",
	"special_bonus_hamsterlord_2",
	"special_bonus_hamsterlord_0",
	"special_bonus_hamsterlord_4",
	"special_bonus_hamsterlord_5"
}

local tHeroBaseStats = {
	MovementSpeed = 295,
	AttackAnimationPoint = 0.3,
	AttackRate = 1.7,
	AttackDamageMin = 29,
	AttackDamageMax = 35,
	AttributeBaseStrength = 19,
	AttributeBaseAgility = 22,
	AttributeBaseIntelligence = 14,
	AttributeStrenthGain = 2.4,
	AttributeAgilityGain = 2.6,
	AttributeIntelligenceGain = 1.6,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
}

CustomNetTables:SetTableValue("fun_hero_stats", "hamsterlord_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "hamsterlord", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("hamsterlord", tNewAbilities)
local function HamsterlordTalentManager(keys)
	if keys.abilityname == "special_bonus_hamsterlord_2" then	
		local hPlayer = PlayerResource:GetPlayer(keys.PlayerID)
		local hBoy = Entities:First()	
		while hBoy do
			if hBoy.GetUnitName and hBoy:GetUnitName() == "hamsterlord_pizza_house_deliver_boy" and keys.player-1 == hBoy:GetOwner():GetPlayerID() then	
				hBoy:RemoveAbility("hamsterlord_pizza_house_deliver_boy_gather_tips")
				hBoy:RemoveModifierByName("modifier_hamsterlord_pizza_house_deliver_boy_gather_tips")
				hBoy:AddAbility("hamsterlord_pizza_house_deliver_boy_gather_tips_upgraded"):SetLevel(1)				
			end			
			hBoy = Entities:Next(hBoy)
		end		
	end
end

function HampsterLordInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_hamsterlord", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	if not GameMode.bHamsterlordTalentManagerSet then
		ListenToGameEvent( "dota_player_learned_ability", HamsterlordTalentManager, nil )
		GameMode.bHamsterlordTalentManagerSet = true
	end
end