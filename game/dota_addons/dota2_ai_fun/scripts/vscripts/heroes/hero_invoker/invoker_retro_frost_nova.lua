--[[ ============================================================================================================
	Author: Rook
	Date: February 18, 2015
	Called when Frost Nova is cast.  Damages the target as well as nearby enemies, and slows them.
	Additional parameters: keys.AreaRadius
================================================================================================================= ]]
function invoker_retro_frost_nova_on_spell_start(keys)
	if keys.target:TriggerSpellAbsorb(keys.ability) then return end
	local frost_nova_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.target:EmitSound("Ability.FrostNova")
	
	--Frost Nova's area damage is dependent on the level of Quas.
	local iQuasLevel
	
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) == keys.ability then
		iQuasLevel = keys.caster.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end
	else
		iQuasLevel = keys.target.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end	
	end
	frost_nova_area_damage = keys.ability:GetSpecialValueFor("area_damage_level_quas")*iQuasLevel
	
	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.AreaRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for i, individual_unit in ipairs(nearby_enemy_units) do
		ApplyDamageTestDummy({victim = individual_unit, attacker = keys.caster, damage = frost_nova_area_damage, damage_type = DAMAGE_TYPE_MAGICAL,})
		
		keys.ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_invoker_retro_frost_nova_slow", nil)
	end
end