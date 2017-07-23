LinkLuaModifier("telekenetic_blob_catapult_modifier", "heroes/telekenetic_blob/telekenetic_blob_catapult_modifier.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("telekenetic_blob_catapult_stun_modifier", "heroes/telekenetic_blob/telekenetic_blob_catapult_modifier.lua", LUA_MODIFIER_MOTION_NONE)

telekenetic_blob_catapult = class({})

function telekenetic_blob_catapult:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)

	if markedTarget == nil or CalcDistanceBetweenEntityOBB(target, markedTarget) > self:GetSpecialValueFor("distance") then
		self:EndCooldown()
		self:RefundManaCost()
		return
	end

	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_catapult_modifier", {})
end