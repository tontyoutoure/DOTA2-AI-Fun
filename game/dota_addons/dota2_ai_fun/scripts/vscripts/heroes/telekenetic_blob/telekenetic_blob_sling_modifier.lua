telekenetic_blob_sling_modifier = class({})

function telekenetic_blob_sling_modifier:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function telekenetic_blob_sling_modifier:IsStunDebuff()
    return true
end

function telekenetic_blob_sling_modifier:IsHidden()
    return true
end

function telekenetic_blob_sling_modifier:IsPurgable()
    return false
end

function telekenetic_blob_sling_modifier:RemoveOnDeath()
    return false
end

function telekenetic_blob_sling_modifier:OnCreated(kv)
    if IsServer() then 
	    if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
		self.vStartPosition = GetGroundPosition(self:GetParent():GetOrigin(), self:GetParent())
		self.vTargetPosition = self:GetAbility():GetCursorPosition()
		self.vDirection = (self.vTargetPosition - self.vStartPosition):Normalized()
		local flTargetDistance = (self.vTargetPosition - self.vStartPosition):Length2D()
		self.flDistance = self:GetAbility():GetSpecialValueFor("sling_distance")
		if flTargetDistance < self.flDistance then
			self.flDistance = flTargetDistance
		end
		self.flHorizontalSpeed = self:GetAbility():GetSpecialValueFor("sling_speed")
	    EmitSoundOnLocationWithCaster(self.vStartPosition, "DOTA_Item.ForceStaff.Activate", self:GetParent())
	end
end

function telekenetic_blob_sling_modifier:OnDestroy()
    if IsServer() then
	    self:GetParent():RemoveHorizontalMotionController(self)
	end
end

function telekenetic_blob_sling_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function telekenetic_blob_sling_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function telekenetic_blob_sling_modifier:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end

function telekenetic_blob_sling_modifier:UpdateHorizontalMotion(me, dt)
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
		KnockbackCollisionUnits(me, self)

		if bArrived == true then
		    self:GetParent():RemoveHorizontalMotionController(self)
            self:SetDuration(0.01, true)
        end
	end
end

function KnockbackCollisionUnits(target, modifier)
    local collisionRadius = modifier:GetAbility():GetSpecialValueFor("sling_knockback_collision_radius")
	local units = FindUnitsInRadius(modifier:GetParent():GetTeamNumber(), target:GetOrigin(), nil, collisionRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = modifier:GetCaster(),
		damage_type = modifier:GetAbility():GetAbilityDamageType(),
		damage = modifier:GetAbility():GetSpecialValueFor("damage"),
		ability = modifier:GetAbility()
	}
	for i,v in ipairs(units) do
		if v ~= target and not v:HasModifier("telekenetic_blob_sling_knockback_modifier") then
			damageTable.victim = v
			ApplyDamage(damageTable)
			local direction = (v:GetOrigin() - target:GetOrigin()):Normalized()
			v:AddNewModifier(modifier:GetCaster(), modifier:GetAbility(), "telekenetic_blob_sling_knockback_modifier", {Duration = modifier:GetAbility():GetSpecialValueFor("sling_knockback_distance")/modifier:GetAbility():GetSpecialValueFor("sling_knockback_speed"), directionX = direction.x, directionY = direction.y, directionZ = 0})
			damageTable.victim = target
			ApplyDamage(damageTable)
		end
	end
end