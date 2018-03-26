--[[ ============================================================================================================
	Author: Rook
	Date: March 6, 2015
	Called when Firebolt is cast.
	Additional parameters: keys.ProjectileMovementSpeed
================================================================================================================= ]]
function invoker_retro_firebolt_on_spell_start(keys)
	--Firebolt's damage is dependent on the level of Exort.
	local exort_ability = keys.caster:FindAbilityByName("invoker_retro_exort")
	local damage_to_deal = 0
	if exort_ability ~= nil then
		damage_to_deal = keys.ability:GetLevelSpecialValueFor("damage", exort_ability:GetLevel() - 1)
	end
	
	keys.caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
	
	local info = 
	{
		EffectName = "particles/units/heroes/hero_invoker/invoker_retro_firebolt.vpcf",
		Ability = keys.ability,
		Target = keys.target,
		Source = keys.caster,
		bDodgeable = true,
		bProvidesVision = false,
		vSpawnOrigin = keys.caster:GetAbsOrigin(),
		iMoveSpeed = keys.ProjectileMovementSpeed,
		iVisionRadius = 0,
		iVisionTeamNumber = keys.caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	
	local projectile = ProjectileManager:CreateTrackingProjectile(info)
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 6, 2015
	Called when Firebolt hits an enemy unit.  Damages and mini-stuns them.
================================================================================================================= ]]
function invoker_retro_firebolt_on_projectile_hit_unit(keys)	
	--Firebolt's damage is dependent on the level of Exort.
	local exort_ability = keys.caster:FindAbilityByName("invoker_retro_exort")
	local damage_to_deal = 0
	if exort_ability ~= nil then
		damage_to_deal = keys.ability:GetLevelSpecialValueFor("damage", exort_ability:GetLevel() - 1)
	end
	
	keys.target:EmitSound("Hero_OgreMagi.Fireblast.Target")
	
	ApplyDamage({victim = keys.target, attacker = keys.caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_MAGICAL,})
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_invoker_retro_firebolt_ministun", nil)
end