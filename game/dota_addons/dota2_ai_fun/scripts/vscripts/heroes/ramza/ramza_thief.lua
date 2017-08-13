LinkLuaModifier("modifier_ramza_thief_gil_snapper", "heroes/ramza/ramza_thief_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function RamzaThiefGilSnapperApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_thief_gil_snapper", {})
end

