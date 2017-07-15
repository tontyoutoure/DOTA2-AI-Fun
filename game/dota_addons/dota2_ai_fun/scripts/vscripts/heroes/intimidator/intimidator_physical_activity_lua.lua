LinkLuaModifier("modifier_intimidator_physical_activity_dislocate_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_intimidator_physical_activity_speed_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_intimidator_physical_activity_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
intimidator_physical_activity_lua = class({})

function intimidator_physical_activity_lua:GetIntrinsicModifierName() 
	return "modifier_intimidator_physical_activity_lua"
end