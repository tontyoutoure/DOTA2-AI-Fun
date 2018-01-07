function mana_fiend_abandon_activate(keys)
    local hCaster = keys.caster
	local ability = keys.ability	
	ProcsArroundingMagicStick(keys.caster)
    hCaster:GiveMana(ability:GetSpecialValueFor("mana_restored"))
end
