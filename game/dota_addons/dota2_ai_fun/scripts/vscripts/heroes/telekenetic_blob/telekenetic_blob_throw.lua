LinkLuaModifier("telekenetic_blob_throw_modifier", "heroes/telekenetic_blob/telekenetic_blob_throw_modifier.lua", LUA_MODIFIER_MOTION_BOTH )

telekenetic_blob_throw = class({})

function telekenetic_blob_throw:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local markedTarget = GetMarkedTarget(caster)

	if markedTarget == nil or markedTarget:IsAncient() or markedTarget:IsHero() or markedTarget == target or CalcDistanceBetweenEntityOBB(target, markedTarget) > self:GetSpecialValueFor("distance") then
		self:EndCooldown()
		self:RefundManaCost()
		return
	end
	
    if target:TriggerSpellAbsorb(self) then
		return
	end

	self.throw_target = target	

	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_throw_modifier", {})
end

function GetMarkedTarget(caster)
	local ability = caster:FindAbilityByName("telekenetic_blob_mark_target")
	if ability ~= nil then
		return ability.lastCastTaget
	end
	return nil
end