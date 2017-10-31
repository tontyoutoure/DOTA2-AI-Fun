LinkLuaModifier("modifier_ramza_chemist_items_phoenix_down", "heroes/ramza/ramza_chemist_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_chemist_items_phoenix_down_thinker", "heroes/ramza/ramza_chemist_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function RamzaChemistTreasureHunterParticles(keys)
	local iGold = keys.ability:GetSpecialValueFor("gold")
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 4, 100))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
	
	local iParticle2 = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle2, 0, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticle2, 1, keys.caster:GetAbsOrigin())
end


ramza_chemist_items_phoenix_down = class({})

local function RamzaItemsGetCastRange(self, vLocation, hTarget)
	if self:GetCaster():HasModifier("modifier_ramza_chemist_throw_items") then return 99999
	else return 1200
	end
end

ramza_chemist_items_phoenix_down.GetCastRange = RamzaItemsGetCastRange


function ramza_chemist_items_phoenix_down:CastFilterResultTarget(hTarget)
	if IsClient() then return UF_SUCCESS end
	if hTarget:HasModifier("modifier_ramza_chemist_items_phoenix_down") then return UF_FAIL_CUSTOM end
	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then return UF_FAIL_ENEMY end
	return UF_SUCCESS
end

function ramza_chemist_items_phoenix_down:GetCustomCastErrorTarget(hTarget) 
	return "error_ramza_already_have_phoenix_down"
end

function ramza_chemist_items_phoenix_down:OnSpellStart()
	local hModifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ramza_chemist_items_phoenix_down", {})
	self:GetCaster():EmitSound("General.Buy")
end

local function RamzaEtherSpellStart(self)	
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("General.Buy")
	hTarget:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
	
	local iManaRestore = self:GetSpecialValueFor("mana_restore")
	hTarget:ReduceMana(-iManaRestore);
	
	if iManaRestore > 200 then
		local iParticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(iParticle1, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_attack1", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle1, 1, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	else
		ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	end
	
	
	local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, iManaRestore, 0))
	ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 4, 500))
	ParticleManager:SetParticleControl(iParticle2, 3, Vector(100, 100, 255))
end



ramza_chemist_items_ether = class({})
ramza_chemist_items_ether.GetCastRange = RamzaItemsGetCastRange

ramza_chemist_items_ether.OnSpellStart = RamzaEtherSpellStart

ramza_chemist_items_hiether = class({})
ramza_chemist_items_hiether.GetCastRange = RamzaItemsGetCastRange

ramza_chemist_items_hiether.OnSpellStart = RamzaEtherSpellStart

local RamzaPotionSpellStart = function (self)
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("General.Buy")
	hTarget:EmitSound("DOTA_Item.FaerieSpark.Activate")
	local iHealthRestore = self:GetSpecialValueFor("health_restore")
	hTarget:Heal(iHealthRestore, hCaster)	
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iHealthRestore, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 4, 200))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(60, 255, 60))
	
	if iHealthRestore > 250 then
		ParticleManager:CreateParticle("particles/econ/events/ti6/mekanism_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	else
		ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	end
	
end

ramza_chemist_items_potion = class({})
ramza_chemist_items_potion.GetCastRange = RamzaItemsGetCastRange
ramza_chemist_items_potion.OnSpellStart = RamzaPotionSpellStart


ramza_chemist_items_hipotion = class({})
ramza_chemist_items_hipotion.GetCastRange = RamzaItemsGetCastRange
ramza_chemist_items_hipotion.OnSpellStart = RamzaPotionSpellStart

ramza_chemist_items_elixir = class({})
ramza_chemist_items_elixir.GetCastRange = RamzaItemsGetCastRange
function ramza_chemist_items_elixir:OnSpellStart()	
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("General.Buy")
	local fManaRestore = hTarget:GetMaxMana()-hTarget:GetMana()
	local fHealthRestore = hTarget:GetMaxHealth()-hTarget:GetHealth()
	hTarget:Heal(fHealthRestore, hCaster)
	hTarget:ReduceMana(-fManaRestore)
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, math.floor(fManaRestore), 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2+math.floor(math.log10(fManaRestore)), 500))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(20, 20, 100))	
	
	local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fHealthRestore), 0))
	ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fHealthRestore)), 200))
	ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
	
	local iParticle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(iParticle3, 0, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle3, 1, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	hTarget:EmitSound("Hero_Chen.HandOfGodHealHero")
end

ramza_chemist_items_remedy = class({})
ramza_chemist_items_remedy.GetCastRange = RamzaItemsGetCastRange

function ramza_chemist_items_remedy:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("General.Buy")
	local iParticle3 = ParticleManager:CreateParticle("particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf", PATTACH_POINT, hTarget)
	ParticleManager:SetParticleControlEnt(iParticle3, 0, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle3, 1, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle3, 3, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle3, 4, hTarget, PATTACH_POINT, "follow_origin", hTarget:GetAbsOrigin(), true)
	
	
	hTarget:EmitSound("Hero_Slark.DarkPact.Cast")
	hTarget:Purge(false, true, false, true, true)
end


RamzaChemistAutoPotionTakePotion = function (keys)
	PrintTable(keys)
	if keys.caster:GetGold() < 50 then return end
	keys.caster:EmitSound("General.Buy")
	keys.caster:EmitSound("DOTA_Item.FaerieSpark.Activate")
	local iHealthRestore
	if keys.caster:GetMaxHealth() - keys.caster:GetHealth() > 200 then 
		iHealthRestore = 200
	else
		iHealthRestore = keys.caster:GetMaxHealth() - keys.caster:GetHealth()
	end
	keys.caster:Heal(iHealthRestore, keys.caster)	
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iHealthRestore, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 4, 200))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(60, 255, 60))
	
	keys.caster:SpendGold(50, DOTA_ModifyGold_PurchaseItem)
	ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
end

RamzaChemistAutoPotionToggle = function (keys)
	if keys.caster:HasModifier("modifier_ramza_chemist_autopotion") then
		keys.caster:RemoveModifierByName("modifier_ramza_chemist_autopotion")
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_chemist_autopotion", {})
	end
end