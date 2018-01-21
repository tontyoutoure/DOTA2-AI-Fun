LinkLuaModifier("modifier_special_bonus_hamsterlord_5", "heroes/hamsterlord/hamsterlord_init.lua", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_hamsterlord_5 = class({})
function modifier_special_bonus_hamsterlord_5:IsHidden() return true end
function modifier_special_bonus_hamsterlord_5:IsPurgable() return false end
function modifier_special_bonus_hamsterlord_5:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE]=true} end
function modifier_special_bonus_hamsterlord_5:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_special_bonus_hamsterlord_5:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

local tNewAbilities = {
	"hamsterlord_pizza_house_delivery",
	"hamsterlord_take_nap",
	"hamsterlord_injure_knees",
	"generic_hidden",
	"generic_hidden",
	"hamsterlord_call_of_hamster",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_hamsterlord_0",
	"special_bonus_hamsterlord_1",
	"special_bonus_hamsterlord_2",
	"special_bonus_hamsterlord_3",
	"special_bonus_hamsterlord_4",
	"special_bonus_hamsterlord_5"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
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
	AttackAnimationPoint = 0.36,
}

local function HamsterlordTalentManager(keys)
	if keys.abilityname == "special_bonus_hamsterlord_2" then	
		local hPlayer = PlayerResource:GetPlayer(keys.player-1)
		local hBoy = Entities:First()	
		while hBoy do
			if hBoy.GetUnitName and hBoy:GetUnitName() == "hamsterlord_pizza_house_deliver_boy" and keys.player-1 == hBoy:GetOwner():GetPlayerID() then	
				print("haha", hPlayer:GetPlayerID(), hBoy:GetOwner():GetPlayerID(), keys.player)
				hBoy:RemoveAbility("hamsterlord_pizza_house_deliver_boy_gather_tips")
				hBoy:RemoveModifierByName("modifier_hamsterlord_pizza_house_deliver_boy_gather_tips")
				hBoy:AddAbility("hamsterlord_pizza_house_deliver_boy_gather_tips_upgraded"):SetLevel(1)				
			end			
			hBoy = Entities:Next(hBoy)
		end		
	end
	if keys.abilityname == "special_bonus_hamsterlord_5" then	
		local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
		if hHero.hHamster1 and not hHero.hHamster1:IsNull() and hHero.hHamster1:IsAlive() then			
			hHero.hHamster1:AddNewModifier(hHero, nil, "modifier_special_bonus_hamsterlord_5", {})
		end
		if hHero.hHamster2 and not hHero.hHamster2:IsNull() and hHero.hHamster2:IsAlive() then			
			hHero.hHamster2:AddNewModifier(hHero, nil, "modifier_special_bonus_hamsterlord_5", {})
		end
		if hHero.hHamster3 and not hHero.hHamster3:IsNull() and hHero.hHamster3:IsAlive() then			
			hHero.hHamster3:AddNewModifier(hHero, nil, "modifier_special_bonus_hamsterlord_5", {})
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