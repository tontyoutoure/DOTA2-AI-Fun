--[[ ============================================================================================================
	Author: Rook
	Date: February 18, 2015
	Called when Frost Nova is cast.  Damages the target as well as nearby enemies, and slows them.
	Additional parameters: keys.AreaRadius
================================================================================================================= ]]
function invoker_retro_frost_nova_on_spell_start(keys)
	local frost_nova_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.target:EmitSound("Ability.FrostNova")
	
	--Frost Nova's area damage is dependent on the level of Quas.
	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local frost_nova_area_damage = 0
	if quas_ability ~= nil then
		frost_nova_area_damage = keys.ability:GetLevelSpecialValueFor("area_damage", quas_ability:GetLevel() - 1)
	end
	
	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.AreaRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for i, individual_unit in ipairs(nearby_enemy_units) do
		ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = frost_nova_area_damage, damage_type = DAMAGE_TYPE_MAGICAL,})
		
		keys.ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_invoker_retro_frost_nova_slow", nil)
	end
end