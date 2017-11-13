LinkLuaModifier("modifier_sniper_assassinate_thinker", "heroes/sniper/sniper_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function SniperInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_sniper_assassinate_thinker", {})
end