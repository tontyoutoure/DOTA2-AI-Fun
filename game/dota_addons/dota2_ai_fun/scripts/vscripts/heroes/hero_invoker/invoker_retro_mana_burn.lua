--[[ ============================================================================================================
	Author: Rook
	Date: February 24, 2015
	Called when Mana Burn is cast.  Removes mana from the target enemy unit and damages them for the same amount.
================================================================================================================= ]]
function invoker_retro_mana_burn_on_spell_start(keys)
	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end
	keys.caster:EmitSound("Hero_NyxAssassin.ManaBurn.Cast")
	keys.target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	
	local iWexLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iWexLevel = keys.caster.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end
	else
		iWexLevel = keys.target.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end	
	end
	
	local mana_to_burn = keys.ability:GetSpecialValueFor("mana_burned_level_wex")*iWexLevel
	if mana_to_burn > keys.target:GetMana() then mana_to_burn = keys.target:GetMana() end
--	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, keys.target, mana_to_burn, nil)
	local mana_burn_number = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(mana_burn_number, 1, Vector(1, mana_to_burn, 0))
	ParticleManager:SetParticleControl(mana_burn_number, 2, Vector(2, string.len(math.floor(mana_to_burn)) + 1, 0))
	
	local mana_burn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	
	keys.target:Script_ReduceMana(mana_to_burn, keys.ability)
	ApplyDamageTestDummy({victim = keys.target, attacker = keys.caster, damage = mana_to_burn, damage_type = DAMAGE_TYPE_MAGICAL,})
end