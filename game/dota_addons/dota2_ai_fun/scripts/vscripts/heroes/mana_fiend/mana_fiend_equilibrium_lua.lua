function mana_fiend_equilibrium_lua(keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local damage_modifier = ability:GetSpecialValueFor("damage_multiplier")
	local mana_burned = caster:GetMana() - target:GetMana()
	
	if mana_burned < 0 then
		return
	elseif mana_burned > 150 and not caster:HasModifier("modifier_mana_fiend_abandon") then
		mana_burned = 150
	end		

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability
	damageTable.damage = mana_burned * damage_modifier

	ApplyDamage(damageTable)
	caster:ReduceMana(mana_burned)
	target:ReduceMana(mana_burned)
end