LinkLuaModifier("modifier_terran_marine_precision", "heroes/terran_marine/modifier_terran_marine.lua", LUA_MODIFIER_MOTION_NONE)
terran_marine_precision_lua = class({})

function terran_marine_precision_lua:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_terran_marine_precision", {})
end