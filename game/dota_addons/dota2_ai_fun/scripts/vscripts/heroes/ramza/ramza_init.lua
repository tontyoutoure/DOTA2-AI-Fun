LinkLuaModifier("modifier_ramza_quote_manager", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_growth_str", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_growth_agi", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_growth_int", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_manager", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_level", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_mastered", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_point", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_black_mage_black_magicks_firaga", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_samurai_run_animation_manager", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_white_mage_animation_manager", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_bravery", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_speed", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_faith", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)




-- for Archer's Bane of Ramza
function GameMode:RamzaProjecileFilter(filterTable)
	local hTarget = EntIndexToHScript(filterTable.entindex_target_const)
	local hSource = EntIndexToHScript(filterTable.entindex_source_const)
	if not hTarget.FindAbilityByName then return true end
	local hAbility = hTarget:FindAbilityByName('ramza_archer_archers_bane')
	if hTarget:FindModifierByName("modifier_ramza_archer_archers_bane") and not hTarget:PassivesDisabled() and RandomInt(1, 100) < 50 then
		local tInfo ={
			Target = hTarget,
			Source = hSource,
			Ability = hAbility,
			flExpireTime = GameRules:GetGameTime() + 10, 
			EffectName = hSource:GetRangedProjectileName(),
			iMoveSpeed = hSource:GetProjectileSpeed()
		}		
		
		
		ProjectileManager:CreateTrackingProjectile(tInfo)		
		return false
	end
	return true
end

-- for Defend of Ramza
function GameMode:RamzaDamageFilter(filterTable)
	if not filterTable.entindex_victim_const or not filterTable.entindex_attacker_const then return true end
	local hVictim = EntIndexToHScript(filterTable.entindex_victim_const)
	local hAttacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	if hVictim:HasModifier('modifier_ramza_squire_defend') and not hAttacker:IsBuilding() and not hAttacker:IsHero() then 
		filterTable.damage = filterTable.damage*(1-hVictim:FindAbilityByName('ramza_squire_defend'):GetSpecialValueFor("damage_block")/100)
	end
	return true
end

function RamzaTalentManager(keys)
	if keys.abilityname == "special_bonus_ramza_2" then
		PlayerResource:GetPlayer(keys.player-1):GetAssignedHero().hRamzaJob:RamzaLevelMax()
	end
	if keys.abilityname == "special_bonus_ramza_3" and PlayerResource:GetPlayer(keys.player-1):GetAssignedHero().hRamzaJob.iSecondarySkill > 0 then
		local self = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero().hRamzaJob
		if self.tJobLevels[self.iSecondarySkill] >= 3 then
			self.hParent:AddAbility(self.tOtherAbilities[self.iSecondarySkill][3][1]):SetLevel(1)
			self.hParent:RemoveAbility(self.tOtherAbilities[self.iSecondarySkill][3][1])
		end
		if self.tJobLevels[self.iSecondarySkill] >= 5 then
			self.hParent:AddAbility(self.tOtherAbilities[self.iSecondarySkill][5][1]):SetLevel(1)
			self.hParent:RemoveAbility(self.tOtherAbilities[self.iSecondarySkill][5][1])
		end
		if self.tJobLevels[self.iSecondarySkill] >= 7 then
			self.hParent:AddAbility(self.tOtherAbilities[self.iSecondarySkill][7][1]):SetLevel(1)
			self.hParent:RemoveAbility(self.tOtherAbilities[self.iSecondarySkill][7][1])
		end
	end
end
ListenToGameEvent( "dota_player_learned_ability", RamzaTalentManager, nil )
local tNewAbilities = {
	"ramza_job_squire_JC",
	"ramza_select_secondary_skill_lua",
	"ramza_squire_counter_tackle",
	"ramza_squire_defend",
	"ramza_squire_move1"	,
	"ramza_open_stats_lua",
	"ramza_go_back_lua",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_ramza_1",
	"special_bonus_ramza_2",
	"special_bonus_ramza_3",
}

local tShowedAbilities = {
	"ramza_select_job_lua",
	"ramza_select_secondary_skill_lua",
	"ramza_bravery",
	"ramza_speed",
	"ramza_faith"	,
	"ramza_open_stats_lua",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_armor_10",
	"special_bonus_spell_lifesteal_20",
	"special_bonus_spell_amplify_20",
	"special_bonus_ramza_1",
	"special_bonus_ramza_2",
	"special_bonus_ramza_3",
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	ModelScale = 0.84,
	Model = "models/heroes/dragon_knight/dragon_knight.vmdl",
	DisableWearables = true,
	AttackDamageMin = 21,
	AttackDamageMax = 24,
	AttributeBaseStrength = 19,
	AttributeBaseAgility = 19,
	AttributeBaseIntelligence = 19,
	AttributeStrenthGain = 0,
	AttributeAgilityGain = 0,
	AttributeIntelligenceGain = 0,
	ArmorPhysical = 1,
	bNoAttributeManager = true,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackAnimationPoint = 0.5
}


CustomNetTables:SetTableValue("fun_hero_abilities", "ramza", tShowedAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "ramza", {})

function RamzaInit(hHero, context)
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	if hHero:IsIllusion() then return end
	WearableManager:AddNewWearable(hHero, {ID = "66", style = "0", model = "models/heroes/dragon_knight/weapon.vmdl", particle_systems = {}})
	WearableManager:AddNewWearable(hHero, {ID = "67", style = "0", model = "models/heroes/dragon_knight/shield.vmdl", particle_systems = {}})
	hHero:AddNewModifier(hHero, nil, "modifier_wearable_hider_while_model_changes", {}).sOriginalModel = "models/heroes/dragon_knight/dragon_knight.vmdl"
	require("heroes/ramza/ramza_job")
	hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_manager", {}):SetStackCount(1)
	hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_level", {}):SetStackCount(1)
	hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_point", {})
	hHero:AddNewModifier(hHero, nil, "modifier_ramza_quote_manager", {})
	hHero:FindAbilityByName("ramza_open_stats_lua"):SetLevel(1)
	hHero:FindAbilityByName("ramza_go_back_lua"):SetLevel(1)
	hHero:FindAbilityByName("ramza_job_squire_JC"):SetLevel(1)
	hHero:FindAbilityByName("ramza_select_secondary_skill_lua"):SetLevel(1)
	hHero:AddAbility("ramza_squire_fundamental_stone")
	hHero:FindAbilityByName("ramza_squire_fundamental_stone"):SetLevel(1)
	hHero:FindAbilityByName("ramza_squire_fundamental_stone"):SetHidden(true)
	if not GameMode.bRamzaArchersBaneFileterSet then
		GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(GameMode, 'RamzaProjecileFilter'), context)
		GameMode.bRamzaArchersBaneFileterSet = true
	end
	if not GameMode.bRamzaSquireDenfendFilterSet then
		GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, 'RamzaDamageFilter'), context)
		GameMode.bRamzaSquireDenfendFilterSet = true
	end
end