LinkLuaModifier("modifier_felguard_color", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function FelguardInit(hHero, context)
	if not hHero.bSpawned then
		hHero:AddNewModifier(hHero, nil, "modifier_felguard_color", {})
	end	
end