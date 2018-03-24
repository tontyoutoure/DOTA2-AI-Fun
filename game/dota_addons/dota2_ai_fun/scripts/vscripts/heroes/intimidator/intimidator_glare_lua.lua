LinkLuaModifier("modifier_intimidator_glare_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

intimidator_glare_lua = class({})

function intimidator_glare_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local target = self:GetCursorTarget()
	target:AddNewModifier(self:GetCaster(), self, "modifier_intimidator_glare_lua", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(target)})	
end
