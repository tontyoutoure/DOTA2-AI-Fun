function TelekeneticBlobGetMarkedTarget(caster)
	local ability = caster:FindAbilityByName("telekenetic_blob_mark_target")
	if ability ~= nil then
		return ability.lastCastTaget
	end
	return nil
end

function TelekeneticBlobUpdateHorizontal(me, dt, modifier)
	if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + modifier.vDirection * modifier.flHorizontalSpeed * dt
        vNewPos.z          = 0
        me:SetOrigin(vNewPos)
    end
end

function TelekeneticBlobUpdateFlyHorizontal(me, dt, modifier)
	if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + modifier.vDirection * modifier.flHorizontalSpeed * dt
        vNewPos.z          = 0
        me:SetOrigin(vNewPos)
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

--function TelekeneticBlobUpdateVertical(me, dt, modifier, landingcallback)
--	if IsServer() then
--        local vOldPosition = me:GetOrigin()
--        local vNewPos      = vOldPosition + modifier.vDirection * modifier.flHorizontalSpeed * dt
--        vNewPos.z          = 0
--        me:SetOrigin(vNewPos)
--    end
--end