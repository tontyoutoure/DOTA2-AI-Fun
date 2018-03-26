--[[ ============================================================================================================
	Author: Rook
	Date: February 25, 2015
	Called when Soul Blast is cast.  Damages the target enemy unit, and heals Invoker.
================================================================================================================= ]]
function invoker_retro_soul_blast_on_spell_start(keys)
	keys.caster:EmitSound("Hero_Bane.BrainSap")
	keys.target:EmitSound("Hero_Bane.BrainSap.Target")
	
	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local exort_ability = keys.caster:FindAbilityByName("invoker_retro_exort")
	if quas_ability ~= nil and exort_ability ~= nil then
		local damage = keys.ability:GetLevelSpecialValueFor("damage", exort_ability:GetLevel() - 1)  --Damage dealt increases per level of Exort.
		local healing = keys.ability:GetLevelSpecialValueFor("heal", quas_ability:GetLevel() - 1)  --Damage dealt increases per level of Quas.
		
		ApplyDamage({victim = keys.target, attacker = keys.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,})
		keys.caster:Heal(healing, keys.caster)
	end
end