LinkLuaModifier("modifier_felguard_color", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function FelguardInit(hHero, context)
		hHero:AddNewModifier(hHero, nil, "modifier_felguard_color", {})
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_felguard", {})
end