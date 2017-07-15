LinkLuaModifier("modifier_persuasive_lagmonster_lua", "heroes/persuasive/persuasive_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_persuasive_lagmonster_stun_lua", "heroes/persuasive/persuasive_modifiers.lua",  LUA_MODIFIER_MOTION_NONE)
persuasive_lagmonster_lua = class({})

function persuasive_lagmonster_lua:OnSpellStart()
	local hModifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_persuasive_lagmonster_lua", {Duration = self:GetSpecialValueFor("duration")})
end