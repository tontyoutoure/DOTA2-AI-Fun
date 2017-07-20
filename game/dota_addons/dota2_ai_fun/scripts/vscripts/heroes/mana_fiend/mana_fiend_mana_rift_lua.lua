function mana_fiend_mana_rift_lua(keys)
	if keys.target:TriggerSpellAbsorb(keys.ability) then return end

	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local mana_burn_multiplier = ability:GetSpecialValueFor("mana_burn_multiplier")
	local mana_burned = (target:GetMaxMana() - target:GetMana()) * mana_burn_multiplier

	if mana_burned > 300 and not caster:HasModifier("modifier_mana_fiend_abandon") then
		mana_burned = 300
	end		

	target:ReduceMana(mana_burned)
end