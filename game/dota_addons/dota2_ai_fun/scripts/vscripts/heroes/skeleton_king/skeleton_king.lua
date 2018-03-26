SkeletonKingMortalStrikeApply = function(keys)
	if keys.caster:PassivesDisabled() or keys.target:GetTeam() == keys.caster:GetTeam() or keys.target:IsBuilding() then return end
	keys.caster:EmitSound("Hero_SkeletonKing.CriticalStrike")
	ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_critical.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, keys.ModifierName, {Duration = 5})
end

function SkeletonKingMortalStrikeInstantKill(keys)
	keys.caster:RemoveModifierByName(keys.ModifierName)
	if keys.target:IsAncient() or keys.target:GetPlayerOwnerID() >= 0 then return end
	keys.target:Kill(keys.ability, keys.caster)
end