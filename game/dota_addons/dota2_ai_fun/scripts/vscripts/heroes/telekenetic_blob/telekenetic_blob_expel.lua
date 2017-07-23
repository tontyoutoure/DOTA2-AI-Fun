LinkLuaModifier("telekenetic_blob_expel_modifier", "heroes/telekenetic_blob/telekenetic_blob_expel_modifier.lua", LUA_MODIFIER_MOTION_BOTH )

telekenetic_blob_expel = class({})

function telekenetic_blob_expel:OnSpellStart()
	local caster = self:GetCaster()
	local targetPosition = self:GetCursorPosition()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)

	if markedTarget == nil or CalcDistanceBetweenEntityOBB(markedTarget, caster) > self:GetSpecialValueFor("marked_target_max_distance") then
		self:EndCooldown()
		self:RefundManaCost()
		return
	end

	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_expel_modifier", {})
end