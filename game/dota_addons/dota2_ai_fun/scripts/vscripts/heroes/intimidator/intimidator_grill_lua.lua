LinkLuaModifier("modifier_intimidator_grill_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

intimidator_grill_lua = class({})

function intimidator_grill_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local hModifier = target:AddNewModifier(caster, self, "modifier_intimidator_grill_lua", {Duration = self:GetSpecialValueFor("duration")})

end