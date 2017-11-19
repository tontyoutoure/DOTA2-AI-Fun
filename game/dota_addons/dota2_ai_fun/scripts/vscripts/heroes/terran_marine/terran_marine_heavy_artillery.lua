function TerranMarineHeavyArtillery(keys)
	if keys.target:IsBuilding() then return end
	keys.target:EmitSound("DOTA_Item.MKB.Minibash")
	if keys.caster:FindAbilityByName("special_bonus_terran_marine_1") then
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("ministun_duration")+keys.caster:FindAbilityByName("special_bonus_terran_marine_1"):GetSpecialValueFor("value")})
	else
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("ministun_duration")})
	end
end