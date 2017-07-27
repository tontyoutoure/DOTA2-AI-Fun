function TimeVoidSpellStart(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound("Hero_Nightstalker.Void")
	local damageTable = {
		attacker = keys.caster,
		victim = keys.target,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability,
		damage = keys.ability:GetSpecialValueFor("damage")
	}
	ApplyDamage(damageTable)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_void_demon_time_void", {Duration = keys.ability:GetSpecialValueFor("duration")})
end