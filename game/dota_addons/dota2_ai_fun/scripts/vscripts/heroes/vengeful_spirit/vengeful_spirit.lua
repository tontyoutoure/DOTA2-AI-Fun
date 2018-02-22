LinkLuaModifier("modifier_vengefulspirit_command_aura_effect_customed", "heroes/vengeful_spirit/vengeful_spirit_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengefulspirit_command_aura_customed", "heroes/vengeful_spirit/vengeful_spirit_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

VengefulSpiritCommandAuraApply = function (keys)
	print("gaa")
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_vengefulspirit_command_aura_customed", {})
end