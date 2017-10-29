LinkLuaModifier("modifier_test_ability1", "test_ability_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_test_ability2", "test_ability_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
test_ability1 = class({})

function test_ability1:GetIntrinsicModifierName()
	return "modifier_test_ability1"
end


function testAttackLanded(keys)
print(keys.ability:IsInAbilityPhase())
	if not keys.ability:IsCooldownReady() or not keys.ability:IsOwnersManaEnough() then return end
	if (keys.ability:GetAutoCastState())then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_test_ability1_2", {Duration = 4})
		keys.ability:UseResources(true, true, true)
	end
end
