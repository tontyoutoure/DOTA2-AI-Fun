telekenetic_blob_throw_modifier = class({})

function telekenetic_blob_throw_modifier:IsStunDebuff()
    return true
end

function telekenetic_blob_throw_modifier:IsHidden()
    return true
end

function telekenetic_blob_throw_modifier:IsPurgable()
    return false
end

function telekenetic_blob_throw_modifier:RemoveOnDeath()
    return false
end

function telekenetic_blob_throw_modifier:OnCreated(kv)
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then
            self:Destroy()
            return
        end

        self.vStartPosition    = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
        self.vTargetPosition   = self:GetAbility():GetCursorPosition()
        self.flDuration        = self:GetAbility():GetSpecialValueFor("throw_duration")
        self.flHeight          = self:GetAbility():GetSpecialValueFor("throw_height")
        self.vDirection        = (self.vTargetPosition - self.vStartPosition):Normalized()
        self.flDistance        = (self.vTargetPosition - self.vStartPosition):Length2D()
        self.flHorizontalSpeed = self.flDistance / self.flDuration
        EmitSoundOnLocationWithCaster(self.vStartPosition, "Ability.TossThrow", self:GetParent())
    end
end

function telekenetic_blob_throw_modifier:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
    end
end

function telekenetic_blob_throw_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function telekenetic_blob_throw_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function telekenetic_blob_throw_modifier:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_ROT
end

function telekenetic_blob_throw_modifier:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
        vNewPos.z          = 0
        me:SetOrigin(vNewPos)
    end
end

function telekenetic_blob_throw_modifier:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local vOrigin        = me:GetOrigin()
        local vDistance      = (vOrigin - self.vStartPosition):Length2D()
        local vZ             = - 4 * self.flHeight / (self.flDistance * self.flDistance) * (vDistance * vDistance) + 4 * self.flHeight / self.flDistance * vDistance
        vOrigin.z            = vZ
        local flGroundHeight = GetGroundHeight( vOrigin, self:GetParent() )
        local bLanded        = false

        if ( vOrigin.z < flGroundHeight and vDistance > self.flDistance / 2 ) then
            vOrigin.z = flGroundHeight
            bLanded   = true
        end

        me:SetOrigin(vOrigin)
        if bLanded == true then
--            local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 275, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
--            for _, unit in pairs(units) do
--                DealDamage(self:GetParent(), unit, 1, self)
--            end
			local casterLevel = self:GetCaster():GetLevel()
			local physicalDamage = self:GetAbility():GetSpecialValueFor("physical_damage")
			local magicalDamage = casterLevel * 5
			local target = self:GetAbility().throw_target
			local damageTable = {
				victim = target,
				attacker = self:GetCaster(),
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage = magicalDamage,
				ability = self:GetAbility()
			}
			ApplyDamage(damageTable)
			damageTable.victim = me
			ApplyDamage(damageTable)
		    damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
			damageTable.damage = physicalDamage
			ApplyDamage(damageTable)
			damageTable.victim = target
			ApplyDamage(damageTable)
            local pid = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
            ParticleManager:SetParticleControl(pid, 0, me:GetOrigin())
            ParticleManager:ReleaseParticleIndex(pid)
            EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "Ability.TossImpact", self:GetParent())
            self:GetParent():RemoveHorizontalMotionController(self)
            self:GetParent():RemoveVerticalMotionController(self)
            self:SetDuration(0.15, true)
        end
    end
end