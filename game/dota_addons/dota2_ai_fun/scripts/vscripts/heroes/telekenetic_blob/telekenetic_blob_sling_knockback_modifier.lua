telekenetic_blob_sling_knockback_modifier = class({})

function telekenetic_blob_sling_knockback_modifier:IsStunDebuff()
    return true
end

function telekenetic_blob_sling_knockback_modifier:IsHidden()
    return true
end

function telekenetic_blob_sling_knockback_modifier:IsPurgable()
    return false
end

function telekenetic_blob_sling_knockback_modifier:RemoveOnDeath()
    return false
end

function telekenetic_blob_sling_knockback_modifier:OnCreated(kv)
    if IsServer() then 
	    if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
		self.vStartPosition = GetGroundPosition(self:GetParent():GetOrigin(), self:GetParent())
		self.vDirection = Vector(kv.directionX, kv.directionY, kv.directionZ)
		self.flDistance = self:GetAbility():GetSpecialValueFor("sling_knockback_distance")
		self.flHorizontalSpeed = self:GetAbility():GetSpecialValueFor("sling_knockback_speed")
	    EmitSoundOnLocationWithCaster(self.vStartPosition, "DOTA_Item.ForceStaff.Activate", self:GetParent())
	end
end

function telekenetic_blob_sling_knockback_modifier:OnDestroy()
    if IsServer() then
	    self:GetParent():RemoveHorizontalMotionController(self)
	end
end

function telekenetic_blob_sling_knockback_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function telekenetic_blob_sling_knockback_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function telekenetic_blob_sling_knockback_modifier:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end

function telekenetic_blob_sling_knockback_modifier:UpdateHorizontalMotion(me, dt)
    if IsServer() then
		local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
		local vDistance      = (vNewPos - self.vStartPosition):Length2D()
		local bArrived        = false
		if(vDistance > self.flDistance) then
			local flGroundHeight = GetGroundHeight(vNewPos, self:GetParent())
			vNewPos.z = flGroundHeight
			bArrived = true
		end
        me:SetOrigin(vNewPos)

		if bArrived == true then
		    self:GetParent():RemoveHorizontalMotionController(self)
            self:SetDuration(0.01, true)
        end
	end
end
function telekenetic_blob_sling_knockback_modifier:OnHorizontalMotionInterrupted()
	self:Destroy()
end