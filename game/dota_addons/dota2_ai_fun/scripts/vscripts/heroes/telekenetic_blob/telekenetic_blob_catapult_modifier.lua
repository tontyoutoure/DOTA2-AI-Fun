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
    if IsServer() then TelekeneticBlobFlyTearDown(self) end
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
    local dealDamageAndStunOnLanding= function (modifier)
			local damageTable = {
				attacker = modifier:GetCaster(),
				damage_type = modifier:GetAbility():GetAbilityDamageType(),
				damage = modifier:GetAbility():GetSpecialValueFor("damage"),
				ability = modifier:GetAbility()
			}
			local damage = modifier:GetAbility():GetSpecialValueFor("damage")
			local stunDuration = modifier:GetAbility():GetSpecialValueFor("stun_duration")
			local units = FindUnitsInRadius(modifier:GetParent():GetTeamNumber(), modifier:GetParent():GetOrigin(), nil, modifier:GetAbility():GetSpecialValueFor("AOE_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for i,v in ipairs(units) do
				damageTable.victim = v
				ApplyDamage(damageTable)
				v:AddNewModifier(modifier:GetCaster(), modifier:GetAbility(), "telekenetic_blob_catapult_stun_modifier", {Duration = stunDuration})
			end
	end
	TelekeneticBlobFlyUpdateVertical(me, dt, self, dealDamageAndStunOnLanding)
end

telekenetic_blob_catapult_stun_modifier = class({})

function telekenetic_blob_catapult_stun_modifier:IsDebuff()
	return true
end

function telekenetic_blob_catapult_stun_modifier:IsStunDebuff()
	return true
end

function telekenetic_blob_catapult_stun_modifier:IsHidden()
	return false
end

function telekenetic_blob_catapult_stun_modifier:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function telekenetic_blob_catapult_stun_modifier:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function telekenetic_blob_catapult_stun_modifier:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end