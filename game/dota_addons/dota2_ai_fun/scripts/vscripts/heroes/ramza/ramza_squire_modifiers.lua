modifier_ramza_squire_counter_tackle = class({})

function modifier_ramza_squire_counter_tackle:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_ramza_squire_counter_tackle:IsHidden() return true end
function modifier_ramza_squire_counter_tackle:OnAttackLanded(keys)
	if keys.target ~= self:GetParent() or keys.attaker:IsRangedAttacker() then return end
	local hAbility = self:GetAbility()
	local damageTable = {
		damage = keys.original_damage*hAbility:GetSpecialValueFor("damage_return")/100,
		attacker = keys.target,
		victim = keys.attacker,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = hAbility
	}
	ApplyDamage(damageTable)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_POINT_FOLLOW, keys.attacker)
	ParticleManager:SetParticleControlEnt(particle, 1, keys.target, PATTACH_POINT_FOLLOW, "follow_hitloc", keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "follow_hitloc", keys.attacker:GetAbsOrigin(), true)
end