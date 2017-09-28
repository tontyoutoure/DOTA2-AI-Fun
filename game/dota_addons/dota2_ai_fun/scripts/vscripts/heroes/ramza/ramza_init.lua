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
-- for Archer's Bane of Ramza
function GameMode:RamzaProjecileFilter(filterTable)
	local hTarget = EntIndexToHScript(filterTable.entindex_target_const)
	local hSource = EntIndexToHScript(filterTable.entindex_source_const)
	if not hTarget.FindAbilityByName then return true end
	local hAbility = hTarget:FindAbilityByName('ramza_archer_archers_bane')
	if hTarget:FindModifierByName("modifier_ramza_archer_archers_bane") and RandomInt(1, 100) < hAbility:GetSpecialValueFor("evasion") then
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
	local hVictim = EntIndexToHScript(filterTable.entindex_victim_const)
	local hAttacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	if hVictim:HasModifier('modifier_ramza_squire_defend') and not hAttacker:IsBuilding() and not hAttacker:IsHero() then 
		filterTable.damage = filterTable.damage*(1-hVictim:FindAbilityByName('ramza_squire_defend'):GetSpecialValueFor("damage_block")/100)
		PrintTable(filterTable);
	end
	return true
end

function RamzaInit(hHero, context)
	if hHero:IsRealHero() and not hHero.bSpawned then
--		WearableManager:RemoveOriginalWearables(hHero)
		WearableManager:AddNewWearable(hHero, {ID = "66", style = "0", model = "models/heroes/dragon_knight/weapon.vmdl", particle_systems = {}})
		WearableManager:AddNewWearable(hHero, {ID = "67", style = "0", model = "models/heroes/dragon_knight/shield.vmdl", particle_systems = {}})
		hHero:AddNewModifier(hHero, nil, "modifier_wearable_hider_while_model_changes", {}).sOriginalModel = "models/heroes/dragon_knight/dragon_knight.vmdl"
		require("heroes/ramza/ramza_job")
		local hModifier = hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_manager", {})
		hModifier.iBonusAttackRange = 0;
		hModifier:SetStackCount(1)
		hModifier = hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_level", {})
		hModifier:SetStackCount(1)
		hHero:AddNewModifier(hHero, nil, "modifier_ramza_job_point", {})
		hHero:AddNewModifier(hHero, nil, "modifier_ramza_quote_manager", {})
		hHero:FindAbilityByName("ramza_open_stats_lua"):SetLevel(1)
		hHero:FindAbilityByName("ramza_go_back_lua"):SetLevel(1)
		hHero:FindAbilityByName("ramza_job_squire_JC"):SetLevel(1)
		hHero:FindAbilityByName("ramza_select_secondary_skill_lua"):SetLevel(1)
		hHero:AddAbility("ramza_empty_1"):SetLevel(1)
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
end