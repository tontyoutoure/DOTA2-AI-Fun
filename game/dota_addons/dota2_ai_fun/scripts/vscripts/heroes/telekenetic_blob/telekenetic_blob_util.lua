function TelekeneticBlobGetMarkedTarget(caster)
	local ability = caster:FindAbilityByName("telekenetic_blob_mark_target")
	if ability ~= nil then
		return ability.lastCastTaget
	end
	return nil
end

function TelekeneticBlobFlySetup(modifier, fixedSpeed)
    if modifier:ApplyHorizontalMotionController() == false or modifier:ApplyVerticalMotionController() == false then
        modifier:Destroy()
        return
    end

    modifier.vStartPosition    = GetGroundPosition( modifier:GetParent():GetOrigin(), modifier:GetParent() )
    modifier.vTargetPosition   = modifier:GetAbility():GetCursorPosition()
    modifier.flHeight          = modifier:GetAbility():GetSpecialValueFor("fly_height")
    modifier.vDirection        = (modifier.vTargetPosition - modifier.vStartPosition):Normalized()
    modifier.flDistance        = (modifier.vTargetPosition - modifier.vStartPosition):Length2D()
	if fixedSpeed then
		modifier.flHorizontalSpeed = modifier:GetAbility():GetSpecialValueFor("fly_speed")
		modifier.flDuration = modifier.flDistance / modifier.flHorizontalSpeed
	else
		modifier.flDuration        = modifier:GetAbility():GetSpecialValueFor("fly_duration")
		modifier.flHorizontalSpeed = modifier.flDistance / modifier.flDuration
	end
    EmitSoundOnLocationWithCaster(modifier.vStartPosition, "Ability.TossThrow", modifier:GetParent())
end

function TelekeneticBlobFlyTearDown(modifier)
    if IsServer() then
        modifier:GetParent():RemoveHorizontalMotionController(modifier)
        modifier:GetParent():RemoveVerticalMotionController(modifier)
    end
end

function TelekeneticBlobFlyUpdateHorizontal(me, dt, modifier)
	if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + modifier.vDirection * modifier.flHorizontalSpeed * dt
        vNewPos.z          = 0
        me:SetOrigin(vNewPos)
    end
end

function TelekeneticBlobFlyUpdateVertical(me, dt, modifier, landingCallback)
    if IsServer() then
        local vOrigin        = me:GetOrigin()
        local vDistance      = (vOrigin - modifier.vStartPosition):Length2D()
        local vZ             = - 4 * modifier.flHeight / (modifier.flDistance * modifier.flDistance) * (vDistance * vDistance) + 4 * modifier.flHeight / modifier.flDistance * vDistance
        vOrigin.z            = vZ
        local flGroundHeight = GetGroundHeight( vOrigin, modifier:GetParent() )
        local bLanded        = false

        if ( vOrigin.z < flGroundHeight and vDistance > modifier.flDistance / 2 ) then
            vOrigin.z = flGroundHeight
            bLanded   = true
        end

        me:SetOrigin(vOrigin)
        if bLanded == true then
			if landingCallback ~= nil then
				landingCallback(modifier)
			end
            local pid = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf", PATTACH_WORLDORIGIN, modifier:GetParent())
            ParticleManager:SetParticleControl(pid, 0, me:GetOrigin())
            ParticleManager:ReleaseParticleIndex(pid)
            EmitSoundOnLocationWithCaster(modifier:GetParent():GetOrigin(), "Ability.TossImpact", modifier:GetParent())
            modifier:GetParent():RemoveHorizontalMotionController(modifier)
            modifier:GetParent():RemoveVerticalMotionController(modifier)
            modifier:SetDuration(0.01, true)
        end
    end
end
