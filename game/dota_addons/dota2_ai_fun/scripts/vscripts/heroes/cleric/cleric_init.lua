LinkLuaModifier("modifier_cleric_magic_mirror", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function ClericInit(hHero, context)
	if hHero:IsRealHero() then
		local hMagicMirror = hHero:FindAbilityByName("cleric_magic_mirror")
		hHero:AddNewModifier(hHero, hMagicMirror, "modifier_cleric_magic_mirror", {})
	end	
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_cleric", {})	
end