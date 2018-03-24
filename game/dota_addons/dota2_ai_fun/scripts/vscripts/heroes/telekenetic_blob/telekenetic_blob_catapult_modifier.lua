telekenetic_blob_catapult_modifier = class({})

function telekenetic_blob_catapult_modifier:IsStunDebuff()
    return true
end

function telekenetic_blob_catapult_modifier:IsHidden()
    return true
end

function telekenetic_blob_catapult_modifier:IsPurgable()
    return false
end

function telekenetic_blob_catapult_modifier:RemoveOnDeath()
    return false
end

function telekenetic_blob_catapult_modifier:OnCreated(kv)
    if IsServer() then TelekeneticBlobFlySetup(self, false) end
end

function telekenetic_blob_catapult_modifier:OnDestroy()
	if IsClient() then return end
	TelekeneticBlobFlyTearDown(self)
	local modifier = self
	local damageTable = {
		attacker = modifier:GetCaster(),
		damage_type = modifier:GetAbility():GetAbilityDamageType(),
		damage = modifier:GetAbility():GetSpecialValueFor("damage"),
		ability = modifier:GetAbility()
	}
	local stunDuration = modifier:GetAbility():GetSpecialValueFor("stun_duration")
	local units = FindUnitsInRadius(modifier:GetParent():GetTeamNumber(), modifier:GetParent():GetOrigin(), nil, modifier:GetAbility():GetSpecialValueFor("AOE_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i,v in ipairs(units) do
		if v ~= modifier:GetCaster() then
			damageTable.victim = v
			ApplyDamage(damageTable)
			v:AddNewModifier(modifier:GetCaster(), modifier:GetAbility(), "modifier_stunned", {Duration = stunDuration*CalculateStatusResist(v)})
		end
	end
end

function telekenetic_blob_catapult_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function telekenetic_blob_catapult_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function telekenetic_blob_catapult_modifier:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function telekenetic_blob_catapult_modifier:UpdateHorizontalMotion(me, dt)
    TelekeneticBlobFlyUpdateHorizontal(me, dt, self)
end

function telekenetic_blob_catapult_modifier:UpdateVerticalMotion(me, dt)
	TelekeneticBlobFlyUpdateVertical(me, dt, self, nil)
end

function telekenetic_blob_catapult_modifier:OnHorizontalMotionInterrupted()
	self:Destroy()
end