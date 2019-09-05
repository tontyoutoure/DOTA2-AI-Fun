modifier_ti9_attack_modifier = class({})

function modifier_ti9_attack_modifier:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_ti9_attack_modifier:OnAttack(keys)
	if keys.attacker == self:GetParent() and keys.attacker:IsRangedAttacker() then
		ProjectileManager:CreateTrackingProjectile({
			Target = keys.target,
			Source = keys.attacker,
			Ability = nil,	
			EffectName = 'particles/econ/attack/attack_modifier_ti9.vpcf',
			iMoveSpeed = keys.attacker:GetProjectileSpeed(),
			vSourceLoc= keys.attacker:GetAbsOrigin(),                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
			bDodgeable = true,                                -- Optional
			bIsAttack = false,                                -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bReplaceExisting = false,                         -- Optional
			bProvidesVision = false,                           -- Optional
		})
	end
end


 