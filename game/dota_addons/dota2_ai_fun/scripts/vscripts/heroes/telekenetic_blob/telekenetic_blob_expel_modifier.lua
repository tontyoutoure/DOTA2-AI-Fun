telekenetic_blob_expel_modifier = class({})

function telekenetic_blob_expel_modifier:IsStunDebuff()
    return true
end

function telekenetic_blob_expel_modifier:IsHidden()
    return true
end

function telekenetic_blob_expel_modifier:IsPurgable()
    return false
end

function telekenetic_blob_expel_modifier:RemoveOnDeath()
    return false
end

function telekenetic_blob_expel_modifier:OnCreated(kv)
    if IsServer() then TelekeneticBlobFlySetup(self, true) end
end

function telekenetic_blob_expel_modifier:OnDestroy()
    if IsServer() then TelekeneticBlobFlyTearDown(self) end
end

function telekenetic_blob_expel_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function telekenetic_blob_expel_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function telekenetic_blob_expel_modifier:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function telekenetic_blob_expel_modifier:UpdateHorizontalMotion(me, dt)
    TelekeneticBlobFlyUpdateHorizontal(me, dt, self)
end

function telekenetic_blob_expel_modifier:UpdateVerticalMotion(me, dt)
	TelekeneticBlobFlyUpdateVertical(me, dt, self, nil)
end