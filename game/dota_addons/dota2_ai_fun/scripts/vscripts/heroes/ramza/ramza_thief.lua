LinkLuaModifier("modifier_ramza_thief_gil_snapper", "heroes/ramza/ramza_thief_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function RamzaThiefGilSnapperApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_thief_gil_snapper", {})
end

function RamzaThiefStealArmor(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.caster:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_thief_steal_armor_bonus", {})
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_thief_steal_armor_reduction", {})
end

function RamzaThiefStealWeapon(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound("Hero_Bane.Enfeeble") 
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_thief_steal_weapon_damage_bonus", {})
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_thief_steal_weapon_damage_reduction", {})
end

function RamzaThiefStealGil(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	if keys.target:IsIllusion() then return end
	
	local iGold = keys.caster:GetLevel()*keys.ability:GetSpecialValueFor("level_gold")
	
	PlayerResource:ModifyGold(keys.target:GetOwner():GetPlayerID(), -iGold, false, DOTA_ModifyGold_Unspecified)
	PlayerResource:ModifyGold(keys.caster:GetOwner():GetPlayerID(), iGold, false, DOTA_ModifyGold_Unspecified)
	
	keys.caster:EmitSound("General.CoinsBig")
		
	local iParticle2 = ParticleManager:CreateParticle("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle2, 0, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticle2, 1, keys.caster:GetAbsOrigin())	
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGold))+2, 100))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
end

function RamzaThiefStealEXP(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	if keys.target:IsIllusion() then return end
	local iEXP = keys.caster:GetLevel()*keys.ability:GetSpecialValueFor("level_xp")
	keys.caster:EmitSound("Item.TomeOfKnowledge")
	keys.caster:AddExperience(iEXP, DOTA_ModifyXP_Unspecified, false, true)	
	keys.target:AddExperience(-iEXP, DOTA_ModifyXP_Unspecified, false, true)
end

function RamzaThiefStealHeart(keys)
	keys.target:SetTeam(keys.caster:GetTeamNumber())
	keys.target:SetOwner(keys.caster)
	keys.target:SetControllableByPlayer(keys.caster:GetOwner():GetPlayerID(), true)
	keys.target:EmitSound("Hero_Enchantress.EnchantCreep")
	ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
end

ramza_thief_steal_accessory = class({})

function ramza_thief_steal_accessory:CastFilterResultTarget(hTarget)
	if IsClient() then return UF_SUCCESS end	
	local hCaster = self:GetCaster()
	local bFull = true
	local bNoValid = true
	for i = 0, 8 do
		if not hCaster:GetItemInSlot(i) then bFull = false end
		local hItem = hTarget:GetItemInSlot(i)
		if hItem and not hItem:IsRecipe() and hItem:GetName() ~= "item_aegis" and hItem:IsPermanent() then bNoValid = false end
	end
	if bFull or bNoValid then return UF_FAIL_CUSTOM end	
	return UF_SUCCESS
end

function ramza_thief_steal_accessory:GetCustomCastErrorTarget(hTarget)
	if IsClient() then return end		
	local hCaster = self:GetCaster()
	local bFull = true
	local bNoValid = true
	for i = 0, 8 do
		if not hCaster:GetItemInSlot(i) then bFull = false end
		local hItem = hTarget:GetItemInSlot(i)
		if hItem and not hItem:IsRecipe() and hItem:GetName() ~= "item_aegis" and hItem:IsPermanent() then bNoValid = false end
	end
	if bFull then return "error_ramza_thief_steal_accessory_inventory_full" end
	if bNoValid then return "error_ramza_thief_steal_accessory_no_valid_item" end
end

function ramza_thief_steal_accessory:OnSpellStart()	
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local tItems = {}
	for i = 0, 8 do		
		local hItem = hTarget:GetItemInSlot(i)
		if hItem and not hItem:IsRecipe() and hItem:GetName() ~= "item_aegis" and hItem:IsPermanent() then table.insert(tItems, hItem) end		
	end
	local hItemToGo = tItems[RandomInt(1, #tItems)]
	local sName = hItemToGo:GetName()
	local iCharge = hItemToGo:GetCurrentCharges()
	hTarget:RemoveItem(hItemToGo)
	local hItemNew = hCaster:AddItemByName(sName)
	hItemNew:SetCurrentCharges(iCharge)
end





