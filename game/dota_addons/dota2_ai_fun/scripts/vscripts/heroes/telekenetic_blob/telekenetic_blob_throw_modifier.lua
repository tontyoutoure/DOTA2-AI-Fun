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
    if IsServer() then TelekeneticBlobFlySetup(self, false) end
end

function telekenetic_blob_throw_modifier:OnDestroy()
    if IsServer() then TelekeneticBlobFlyTearDown(self) end
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
    return ACT_DOTA_FLAIL
end

function telekenetic_blob_throw_modifier:UpdateHorizontalMotion(me, dt)
    TelekeneticBlobFlyUpdateHorizontal(me, dt, self)
end

function telekenetic_blob_throw_modifier:UpdateVerticalMotion(me, dt)
    local dealDamageOnLanding= function (modifier)
			local casterLevel = modifier:GetCaster():GetLevel()
			local physicalDamage = modifier:GetAbility():GetSpecialValueFor("physical_damage")
			local magicalDamage = casterLevel * 5
			local target = modifier:GetAbility().throw_target
			local damageTable = {
				victim = target,
				attacker = modifier:GetCaster(),
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage = magicalDamage,
				ability = modifier:GetAbility()
			}
			ApplyDamage(damageTable)
			damageTable.victim = me
			ApplyDamage(damageTable)
		    damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
			damageTable.damage = physicalDamage
			ApplyDamage(damageTable)
			damageTable.victim = target
			ApplyDamage(damageTable)
	end
	TelekeneticBlobFlyUpdateVertical(me, dt, self, dealDamageOnLanding)
end


function telekenetic_blob_throw_modifier:OnHorizontalMotionInterrupted()
	self:Destroy()
end