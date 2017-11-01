function TerranMarineHeavyArtillery(keys)
	keys.target:EmitSound("DOTA_Item.MKB.Minibash")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("ministun_duration")+keys.caster:FindAbilityByName("special_bonus_terran_marine_1"):GetSpecialValueFor("value")})
end