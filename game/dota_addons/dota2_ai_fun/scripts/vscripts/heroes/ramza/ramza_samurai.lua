LinkLuaModifier("modifier_ramza_samurai_bonecrusher", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


RamzaSamuraiBoneCrusherApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_bonecrusher", {})
end