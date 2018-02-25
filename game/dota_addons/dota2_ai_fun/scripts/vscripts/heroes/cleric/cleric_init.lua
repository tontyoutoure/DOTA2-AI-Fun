LinkLuaModifier("modifier_cleric_magic_mirror", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

local tNewAbilities = {
	"cleric_meteor_shower",
	"cleric_berserk",
	"cleric_magic_mirror",
	"generic_hidden",
	"generic_hidden",
	"cleric_prayer",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_cleric_4",
	"special_bonus_cleric_1",
	"special_bonus_cleric_2",
	"special_bonus_cleric_5",
	"special_bonus_cleric_6",
	"special_bonus_cleric_3"
}

local tHeroBaseStats = {
	MovementSpeed = 290,
	AttackRate = 1.7,
	AttackDamageMin = 29,
	AttackDamageMax = 35,
	AttackRange = 600,
	AttributeBaseStrength = 16,
	AttributeBaseAgility = 14,
	AttributeBaseIntelligence = 25,
	AttributeStrenthGain = 2,
	AttributeAgilityGain = 1.7,
	AttributeIntelligenceGain = 2.8,
	ArmorPhysical = 1,
	PrimaryAttribute = DOTA_ATTRIBUTE_INTELLECT,
	AttackAnimationPoint = 0.2,
}
CustomNetTables:SetTableValue("fun_hero_abilities", "cleric", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "cleric", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("cleric", tNewAbilities)

function ClericTalentManager(keys)
	if PlayerResource:GetPlayer(keys.player-1):GetAssignedHero():GetName() ~= "npc_dota_hero_rubick" then return end
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
	if keys.abilityname == "special_bonus_cleric_5" then
		local iLevel = hHero:FindAbilityByName("cleric_berserk"):GetLevel()
		hHero:RemoveAbility("cleric_berserk")
		hHero:AddAbility("cleric_berserk_aoe"):SetLevel(iLevel)
	end
end


function ClericInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_cleric", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	if not GameMode.bClericTalentManagerSet then
		ListenToGameEvent( "dota_player_learned_ability", ClericTalentManager, nil )
		GameMode.bClericTalentManagerSet = true
	end
 	if hHero:IsRealHero() then
 		local hMagicMirror = hHero:FindAbilityByName("cleric_magic_mirror")
 		hHero:AddNewModifier(hHero, hMagicMirror, "modifier_cleric_magic_mirror", {})
 	end	
end