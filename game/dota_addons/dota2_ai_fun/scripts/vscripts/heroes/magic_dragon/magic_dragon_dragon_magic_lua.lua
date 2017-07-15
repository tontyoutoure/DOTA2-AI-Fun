magic_dragon_dragon_magic_lua = class({})

function magic_dragon_dragon_magic_lua:OnSpellStart()
	local hCaster = self:GetCaster();
	local hModifier = hCaster:FindModifierByName("modifier_magic_dragon_magic_form") or hCaster:FindModifierByName("modifier_magic_dragon_undead_form") or hCaster:FindModifierByName("modifier_magic_dragon_ice_form") or hCaster:FindModifierByName("modifier_magic_dragon_fire_form") or hCaster:FindModifierByName("modifier_magic_dragon_lightning_form") or hCaster:FindModifierByName("modifier_magic_dragon_anti_magic_form")
	
	local sModifierName = hModifier:GetName()
	
	if sModifierName == "modifier_magic_dragon_magic_form" then
		MagicDragonTransform.modifier_magic_dragon_undead_form(hCaster)
	elseif sModifierName == "modifier_magic_dragon_undead_form" then
		MagicDragonTransform.modifier_magic_dragon_ice_form(hCaster)
	elseif sModifierName == "modifier_magic_dragon_ice_form" then
		MagicDragonTransform.modifier_magic_dragon_fire_form(hCaster)
	elseif sModifierName == "modifier_magic_dragon_fire_form" then
		MagicDragonTransform.modifier_magic_dragon_lightning_form(hCaster)
	elseif sModifierName == "modifier_magic_dragon_lightning_form" then
		MagicDragonTransform.modifier_magic_dragon_anti_magic_form(hCaster)
	elseif sModifierName == "modifier_magic_dragon_anti_magic_form" then
		MagicDragonTransform.modifier_magic_dragon_magic_form(hCaster)
	end
	
	
end