LinkLuaModifier("modifier_test_ability1", "test_ability_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_test_ability2", "test_ability_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_add_health_test", "test_ability_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_add_health_test_2", "test_ability_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
test_ability1 = class({})

function test_ability1:GetIntrinsicModifierName()
	return "modifier_test_ability1"
end



ability_add_health_test = class({})

function ability_add_health_test:GetIntrinsicModifierName()
	return 'modifier_ability_add_health_test'
end