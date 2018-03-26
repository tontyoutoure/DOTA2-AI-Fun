--[[ ============================================================================================================
	Author: Rook
	Date: February 24, 2015
	Called when Mana Burn is cast.  Removes mana from the target enemy unit and damages them for the same amount.
================================================================================================================= ]]
function invoker_retro_mana_burn_on_spell_start(keys)
	keys.caster:EmitSound("Hero_NyxAssassin.ManaBurn.Cast")
	keys.target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	
	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_wex")
	if wex_ability ~= nil then
		local mana_to_burn = keys.ability:GetLevelSpecialValueFor("mana_burned", wex_ability:GetLevel() - 1)  --Mana burned increases per level of Wex.
		
		local mana_burn_number = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
		ParticleManager:SetParticleControl(mana_burn_number, 1, Vector(1, mana_to_burn, 0))
		ParticleManager:SetParticleControl(mana_burn_number, 2, Vector(2, string.len(math.floor(mana_to_burn)) + 1, 0))
		
		local mana_burn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
		
		keys.target:ReduceMana(mana_to_burn)
		ApplyDamage({victim = keys.target, attacker = keys.caster, damage = mana_to_burn, damage_type = DAMAGE_TYPE_MAGICAL,})
	end
end