modifier_ramza_mime_mimic = class({})

local tBugHeroRamzaMimic = {}
tBugHeroRamzaMimic["npc_dota_hero_rubick"] = true
tBugHeroRamzaMimic["npc_dota_hero_wisp"] = true
tBugHeroRamzaMimic["npc_dota_hero_techies"] = true
tBugHeroRamzaMimic["npc_dota_hero_shadow_demon"] = true --ulti is buggy
tBugHeroRamzaMimic["npc_dota_hero_visage"] = true -- don't transform

local tBugAbilitiesRamzaMinic = {
	fluid_engineer_malicious_tampering = true,
	terran_marine_u247_rifle_lua = true,
	bastion_transference_agi = true,
	bastion_transference_str = true,
	bastion_transference_int = true,
	bloodseeker_rupture = true,
	shredder_chakram_2 = true,
	shredder_return_chakram_2 = true,
	shredder_chakram = true,
	shredder_return_chakram = true,
	morphling_morph_agi = true,
	morphling_morph_str = true,
	morphling_hybrid = true,
	morphling_replicate = true,
	morphling_morph = true,
	morphling_morph_replicate = true,
	troll_warlord_berserkers_rage = true,
	monkey_king_tree_dance = true,
	monkey_king_primal_spring = true,
	monkey_king_primal_spring_early = true,
	monkey_king_mischief = true,
	monkey_king_untransform = true,
	ember_spirit_activate_fire_remnant = true,
	ember_spirit_fire_remnant = true,
	keeper_of_the_light_spirit_form = true,
	invoker_quas = true,
	invoker_wex = true,
	invoker_exort = true,
	invoker_invoke = true,
	death_prophet_exorcism = true,
	doom_bringer_devour = true,
	broodmother_spin_web = true}


RamzaMimicDeclareFunctions = function(self)
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

RamzaMimicGetModifierCooldownReduction_Constant = function(self)
	return 999
end

RamzaMimicGetModifierPercentageManacost = function(self)
	return self:GetAbility():GetSpecialValueFor("mana_cost")-100
end

RamzaMimicOnAbilityExecuted = function(self, keys)
	local hParent = self:GetParent()
	if hParent:GetTeamNumber() ~= keys.unit:GetTeamNumber() or hParent == keys.unit or tBugHeroRamzaMimic[keys.unit:GetName()] or tBugAbilitiesRamzaMinic[keys.ability:GetName()] or keys.ability:IsItem() or hParent.iMenuState == RAMZA_MENU_STATE_UPGRADE then return end

	if hParent:IsChanneling() then hParent:GetAbilityByIndex(2):EndChannel(true) end
	hParent:RemoveAbility(hParent:GetAbilityByIndex(2):GetName())
	hParent:AddAbility(keys.ability:GetName()):SetLevel(keys.ability:GetLevel())
	print("Mimic added", keys.ability:GetName())	
end

RamzaMimicIsHidden = function (self) return true end

modifier_ramza_mime_mimic_100_mana_cost = class({})
modifier_ramza_mime_mimic_90_mana_cost = class({})
modifier_ramza_mime_mimic_80_mana_cost = class({})
modifier_ramza_mime_mimic_70_mana_cost = class({})
modifier_ramza_mime_mimic_60_mana_cost = class({})
modifier_ramza_mime_mimic_50_mana_cost = class({})
modifier_ramza_mime_mimic_40_mana_cost = class({})
modifier_ramza_mime_mimic_20_mana_cost = class({})
modifier_ramza_mime_mimic_0_mana_cost = class({})

modifier_ramza_mime_mimic_100_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_90_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_80_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_70_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_60_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_50_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_40_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_20_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions
modifier_ramza_mime_mimic_0_mana_cost.DeclareFunctions = RamzaMimicDeclareFunctions

modifier_ramza_mime_mimic_100_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_90_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_80_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_70_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_60_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_50_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_40_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_20_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost
modifier_ramza_mime_mimic_0_mana_cost.GetModifierPercentageManacost = RamzaMimicGetModifierPercentageManacost

modifier_ramza_mime_mimic_100_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_90_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_80_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_70_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_60_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_50_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_40_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_20_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant
modifier_ramza_mime_mimic_0_mana_cost.GetModifierCooldownReduction_Constant = RamzaMimicGetModifierCooldownReduction_Constant

modifier_ramza_mime_mimic_100_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_90_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_80_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_70_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_60_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_50_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_40_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_20_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted
modifier_ramza_mime_mimic_0_mana_cost.OnAbilityExecuted = RamzaMimicOnAbilityExecuted

modifier_ramza_mime_mimic_100_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_90_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_80_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_70_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_60_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_50_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_40_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_20_mana_cost.IsHidden = RamzaMimicIsHidden
modifier_ramza_mime_mimic_0_mana_cost.IsHidden = RamzaMimicIsHidden











