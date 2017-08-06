LinkLuaModifier("modifier_ramza_ninja_reflexes", "heroes/ramza/ramza_ninja_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


RmazaNinjaReflexesApply = function (keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_ninja_reflexes", {})
end

RamzaNinjaVanishApply = function (keys)
	keys.unit:AddNewModifier(keys.unit, keys.ability, 'modifier_invisible', {Duration = keys.ability:GetSpecialValueFor("duration")})
end


RamzaNinjaVanishToggle = function(keys)
	if keys.caster:HasModifier('modifier_ramza_ninja_vanish') then
		keys.caster:RemoveModifierByName('modifier_ramza_ninja_vanish')
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, 'modifier_ramza_ninja_vanish', {})
	end
end