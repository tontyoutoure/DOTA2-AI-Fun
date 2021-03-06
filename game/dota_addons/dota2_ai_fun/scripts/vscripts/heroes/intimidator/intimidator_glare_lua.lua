LinkLuaModifier("modifier_intimidator_glare_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_intimidator_glare_lua_buff", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

intimidator_glare_lua = class({})

function intimidator_glare_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local target = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	target:AddNewModifier(hCaster, self, "modifier_intimidator_glare_lua", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(target)})
	if hCaster:HasScepter() then 
		hCaster:AddNewModifier(hCaster, self, "modifier_intimidator_glare_lua_buff", {Duration = self:GetSpecialValueFor("duration")})
	end
end
