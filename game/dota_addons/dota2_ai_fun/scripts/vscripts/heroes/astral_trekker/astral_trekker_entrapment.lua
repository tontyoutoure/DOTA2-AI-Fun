function AstralTrekkerEntrapmentOnSpellStart(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_astral_trekker_entrapment_datadriven", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound("Hero_NagaSiren.Ensnare.Target")
end