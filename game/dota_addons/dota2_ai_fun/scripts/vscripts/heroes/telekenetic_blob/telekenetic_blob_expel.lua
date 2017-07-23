function telekenetic_blob_expel(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetPosition = ability:GetCursorPosition()
	local markedTarget = GetMarkedTarget(caster)

	if markedTarget == nil or CalcDistanceBetweenEntityOBB(markedTarget, caster) > ability:GetSpecialValueFor("marked_target_max_distance") then
		self:EndCooldown()
		self:RefundManaCost()
		return
	end
	
	markedTarget:Interrupt()
	GridNav:DestroyTreesAroundPoint(targetPosition, 300, false )
	markedTarget:SetOrigin(targetPosition )
	FindClearSpaceForUnit(markedTarget, targetPosition, true )
end