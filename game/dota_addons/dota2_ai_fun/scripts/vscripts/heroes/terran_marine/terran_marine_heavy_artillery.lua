function TerranMarineHeavyArtillery(keys)
	if keys.target:IsBuilding() then return end
	keys.target:EmitSound("DOTA_Item.MKB.Minibash")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("ministun_duration")*CalculateStatusResist(keys.target)})
	
end
function TerranMarineHeavyArtilleryApply(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_terran_marine_heavy_artillery", {Duration = keys.ability:GetSpecialValueFor("duration")})
end