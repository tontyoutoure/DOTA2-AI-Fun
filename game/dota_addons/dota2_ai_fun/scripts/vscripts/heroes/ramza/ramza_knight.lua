RamzaKnightRendSpeed = function(keys)	
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_knight_aow_rend_speed", {})
	keys.target:EmitSound("DOTA_Item.RodOfAtos.Target")
end

RamzaKnightRendMagick = function (keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_knight_aow_rend_magick", {})
	keys.target:EmitSound("DOTA_Item.Orchid.Activate")
end

RanzaKnightRendPower = function (keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_knight_aow_rend_power", {})
	keys.target:EmitSound("Hero_Bane.Enfeeble")
end

RamzaKnightRendMP = function (keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:ReduceMana(keys.ability:GetSpecialValueFor("mana_reduction"))
	keys.target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
end

RamzaKnightRendArmor = function (keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_knight_aow_rend_armor", {})
	keys.target:EmitSound("Hero_Slardar.Amplify_Damage")
end

RamzaKnightRendWeapon = function (keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_knight_aow_rend_weapon", {})
	keys.target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
end

RamzaKnightRendHelm = function (keys)	
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	if math.random(100) <= keys.ability:GetSpecialValueFor("chance") then
		local tItems = {}
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			if keys.target:GetItemInSlot(i) then 
				table.insert(tItems, keys.target:GetItemInSlot(i))
			end
		end
		keys.target:RemoveItem(tItems[math.random(#tItems)])
		keys.target:EmitSound("DOTA_Item.AbyssalBlade.Activate")		
		ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	end
	
	
end