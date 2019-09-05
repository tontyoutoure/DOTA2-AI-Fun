function stim_pack_activate(keys)
	local hCaster = keys.caster;
	local fCurrentHealth = hCaster:GetHealth();
	local fLifeCost = hCaster:GetMaxHealth()*keys.ability:GetSpecialValueFor("life_cost")/100;
	if fCurrentHealth > fLifeCost then
		hCaster:SetHealth(fCurrentHealth-fLifeCost);
	else
		hCaster:SetHealth(1);
	end
end