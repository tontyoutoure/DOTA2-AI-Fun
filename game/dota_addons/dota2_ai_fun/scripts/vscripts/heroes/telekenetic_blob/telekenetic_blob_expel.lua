function telekenetic_blob_expel(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetPosition = ability:GetCursorPosition()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)

	if markedTarget == nil or CalcDistanceBetweenEntityOBB(markedTarget, caster) > ability:GetSpecialValueFor("marked_target_max_distance") then
		ability:EndCooldown()
		ability:RefundManaCost()
		return
	end
	
	markedTarget:Interrupt()
	GridNav:DestroyTreesAroundPoint(targetPosition, 300, false )
	markedTarget:SetOrigin(targetPosition )
	FindClearSpaceForUnit(markedTarget, targetPosition, true )
end