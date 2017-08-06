-- This file records functions about transformation of magic dragon

MagicDragonTransform = {}

MAGIC_DRAGON_GREEN_DRAGON_FORM = 1
MAGIC_DRAGON_GHOST_DRAGON_FORM = 2
MAGIC_DRAGON_BLUE_DRAGON_FORM = 3
MAGIC_DRAGON_RED_DRAGON_FORM = 4
MAGIC_DRAGON_GOLD_DRAGON_FORM = 5
MAGIC_DRAGON_BLACK_DRAGON_FORM = 6



--Green Dragon, Magic Form
MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM] = function(hCaster)

	hCaster:RemoveModifierByName("modifier_magic_dragon_lightning_form")
	
	hCaster:SetModel("models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl")
	hCaster:SetOriginalModel("models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl")
	Timers:CreateTimer(0.03, function () hCaster:SetMaterialGroup("0") end)
	hCaster:SetRenderColor(255, 255, 255)
	hCaster:SetModelScale(1)
	hCaster:SetRangedProjectileName("particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf")
	
	local hHide = hCaster:GetAbilityByIndex(1)
	local iHideLevel = hHide:GetLevel()
	hCaster:RemoveAbility(hHide:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_hide")	
	local hHideNew = hCaster:AddAbility("magic_dragon_green_dragon_hide")
	hHideNew:SetLevel(iHideLevel)
	
	local hBreath = hCaster:GetAbilityByIndex(2)
	local iBreathLevel = hBreath:GetLevel()
	hCaster:RemoveAbility(hBreath:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_breath")	
	local hBreathNew = hCaster:AddAbility("magic_dragon_green_dragon_breath")
	hBreathNew:SetLevel(iBreathLevel)
	
	local hRoar = hCaster:GetAbilityByIndex(0)
	local iRoarLevel = hRoar:GetLevel()
	hCaster:RemoveAbility(hRoar:GetName())
	local hRoarNew = hCaster:AddAbility("magic_dragon_green_dragon_roar")
	hRoarNew:SetLevel(iRoarLevel)
	hCaster.iDragonForm = MAGIC_DRAGON_GREEN_DRAGON_FORM
end

--Ghost Dragon, Undead Form
MagicDragonTransform[MAGIC_DRAGON_GHOST_DRAGON_FORM] = function(hCaster)

	hCaster:RemoveModifierByName("modifier_magic_dragon_lightning_form")
	
	hCaster:SetModel("models/heroes/visage/visage.vmdl")
	hCaster:SetOriginalModel("models/heroes/visage/visage.vmdl")
	hCaster:SetRenderColor(255, 255, 255)
	hCaster:SetModelScale(1.2)
	hCaster:SetRangedProjectileName("particles/units/heroes/hero_visage/visage_base_attack.vpcf")
	local hHide = hCaster:GetAbilityByIndex(1)
	local iHideLevel = hHide:GetLevel()
	hCaster:RemoveAbility(hHide:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_hide")	
	local hHideNew = hCaster:AddAbility("magic_dragon_ghost_dragon_hide")
	hHideNew:SetLevel(iHideLevel)
	
	local hBreath = hCaster:GetAbilityByIndex(2)
	local iBreathLevel = hBreath:GetLevel()
	hCaster:RemoveAbility(hBreath:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_breath")	
	local hBreathNew = hCaster:AddAbility("magic_dragon_ghost_dragon_breath")
	hBreathNew:SetLevel(iBreathLevel)
	
	local hRoar = hCaster:GetAbilityByIndex(0)
	local iRoarLevel = hRoar:GetLevel()
	hCaster:RemoveAbility(hRoar:GetName())
	local hRoarNew = hCaster:AddAbility("magic_dragon_ghost_dragon_roar")
	hRoarNew:SetLevel(iRoarLevel)
	hCaster.iDragonForm = MAGIC_DRAGON_GHOST_DRAGON_FORM
end


--Blue Dragon, Ice Form

MagicDragonTransform[MAGIC_DRAGON_BLUE_DRAGON_FORM] = function(hCaster)

	hCaster:RemoveModifierByName("modifier_magic_dragon_lightning_form")

	hCaster:SetModel("models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl")
	hCaster:SetOriginalModel("models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl")
	Timers:CreateTimer(0.03, function () hCaster:SetMaterialGroup("2") end)
	hCaster:SetRenderColor(255, 255, 255)
	hCaster:SetModelScale(1)
	hCaster:SetRangedProjectileName("particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf")
	
	local hHide = hCaster:GetAbilityByIndex(1)
	local iHideLevel = hHide:GetLevel()
	hCaster:RemoveAbility(hHide:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_hide")	
	local hHideNew = hCaster:AddAbility("magic_dragon_blue_dragon_hide")
	hHideNew:SetLevel(iHideLevel)
	
	local hBreath = hCaster:GetAbilityByIndex(2)
	local iBreathLevel = hBreath:GetLevel()
	hCaster:RemoveAbility(hBreath:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_breath")	
	local hBreathNew = hCaster:AddAbility("magic_dragon_blue_dragon_breath")
	hBreathNew:SetLevel(iBreathLevel)
	
	local hRoar = hCaster:GetAbilityByIndex(0)
	local iRoarLevel = hRoar:GetLevel()
	hCaster:RemoveAbility(hRoar:GetName())
	local hRoarNew = hCaster:AddAbility("magic_dragon_blue_dragon_roar")
	hRoarNew:SetLevel(iRoarLevel)
	hCaster.iDragonForm = MAGIC_DRAGON_BLUE_DRAGON_FORM
end

-- Red Dragon, Fire Form

MagicDragonTransform[MAGIC_DRAGON_RED_DRAGON_FORM] = function(hCaster)

	hCaster:RemoveModifierByName("modifier_magic_dragon_lightning_form")

	hCaster:SetModel("models/items/dragon_knight/fireborn_dragon/fireborn_dragon.vmdl")
	hCaster:SetOriginalModel("models/items/dragon_knight/fireborn_dragon/fireborn_dragon.vmdl")
	Timers:CreateTimer(0.03, function () hCaster:SetMaterialGroup("1") end)
	hCaster:SetRenderColor(255, 255, 255)
	hCaster:SetModelScale(1)
	hCaster:SetRangedProjectileName("particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf")
	
	local hHide = hCaster:GetAbilityByIndex(1)
	local iHideLevel = hHide:GetLevel()
	hCaster:RemoveAbility(hHide:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_hide")	
	local hHideNew = hCaster:AddAbility("magic_dragon_red_dragon_hide")
	hHideNew:SetLevel(iHideLevel)
	
	local hBreath = hCaster:GetAbilityByIndex(2)
	local iBreathLevel = hBreath:GetLevel()
	hCaster:RemoveAbility(hBreath:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_breath")	
	local hBreathNew = hCaster:AddAbility("magic_dragon_red_dragon_breath")
	hBreathNew:SetLevel(iBreathLevel)
	
	local hRoar = hCaster:GetAbilityByIndex(0)
	local iRoarLevel = hRoar:GetLevel()
	hCaster:RemoveAbility(hRoar:GetName())
	local hRoarNew = hCaster:AddAbility("magic_dragon_red_dragon_roar")
	hRoarNew:SetLevel(iRoarLevel)
	hCaster.iDragonForm = MAGIC_DRAGON_RED_DRAGON_FORM
end

--Gold Dragon, Lightning Form

MagicDragonTransform[MAGIC_DRAGON_GOLD_DRAGON_FORM] = function(hCaster)
	hCaster:AddNewModifier(hCaster, nil, "modifier_magic_dragon_lightning_form", {})

	hCaster:SetModel("models/items/dragon_knight/dragon_immortal_1/dragon_immortal_1.vmdl")
	hCaster:SetOriginalModel("models/items/dragon_knight/dragon_immortal_1/dragon_immortal_1.vmdl")
	hCaster:SetRenderColor(185, 110, 255)
	Timers:CreateTimer(0.03, function () hCaster:SetMaterialGroup("0") end)
	hCaster:SetModelScale(1)
	hCaster:SetRangedProjectileName("particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf")
	
	local hHide = hCaster:GetAbilityByIndex(1)
	local iHideLevel = hHide:GetLevel()
	hCaster:RemoveAbility(hHide:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_hide")	
	local hHideNew = hCaster:AddAbility("magic_dragon_gold_dragon_hide")
	hHideNew:SetLevel(iHideLevel)
	
	local hBreath = hCaster:GetAbilityByIndex(2)
	local iBreathLevel = hBreath:GetLevel()
	hCaster:RemoveAbility(hBreath:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_breath")	
	local hBreathNew = hCaster:AddAbility("magic_dragon_gold_dragon_breath")
	hBreathNew:SetLevel(iBreathLevel)
	
	local hRoar = hCaster:GetAbilityByIndex(0)
	local iRoarLevel = hRoar:GetLevel()
	hCaster:RemoveAbility(hRoar:GetName())
	local hRoarNew = hCaster:AddAbility("magic_dragon_gold_dragon_roar")
	hRoarNew:SetLevel(iRoarLevel)
	hCaster.iDragonForm = MAGIC_DRAGON_GOLD_DRAGON_FORM
end

-- Black Dragon, Anti Magic Form

MagicDragonTransform[MAGIC_DRAGON_BLACK_DRAGON_FORM] = function(hCaster)

	hCaster:RemoveModifierByName("modifier_magic_dragon_lightning_form")
	
	hCaster:SetModel("models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl")
	hCaster:SetOriginalModel("models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl")
	Timers:CreateTimer(0.03, function () hCaster:SetMaterialGroup("0") end)
	hCaster:SetRenderColor(0, 0, 0)
	hCaster:SetModelScale(1)
	hCaster:SetRangedProjectileName("particles/neutral_fx/black_dragon_attack.vpcf")
	
	local hHide = hCaster:GetAbilityByIndex(1)
	local iHideLevel = hHide:GetLevel()
	hCaster:RemoveAbility(hHide:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_hide")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_hide")	
	local hHideNew = hCaster:AddAbility("magic_dragon_black_dragon_hide")
	hHideNew:SetLevel(iHideLevel)
	
	local hBreath = hCaster:GetAbilityByIndex(2)
	local iBreathLevel = hBreath:GetLevel()
	hCaster:RemoveAbility(hBreath:GetName())
	hCaster:RemoveModifierByName("modifier_magic_dragon_green_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_ghost_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_red_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_blue_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_black_dragon_breath")
	hCaster:RemoveModifierByName("modifier_magic_dragon_gold_dragon_breath")	
	local hBreathNew = hCaster:AddAbility("magic_dragon_black_dragon_breath")
	hBreathNew:SetLevel(iBreathLevel)
	
	local hRoar = hCaster:GetAbilityByIndex(0)
	local iRoarLevel = hRoar:GetLevel()
	hCaster:RemoveAbility(hRoar:GetName())
	local hRoarNew = hCaster:AddAbility("magic_dragon_black_dragon_roar")
	hRoarNew:SetLevel(iRoarLevel)
	hCaster.iDragonForm = MAGIC_DRAGON_BLACK_DRAGON_FORM
end


print("Magic Dragon initialized")