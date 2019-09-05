--[[ ============================================================================================================
	Author: Rook
	Date: March 5, 2015
	Called when Deafening Blast is cast.  Mutes the unit.
================================================================================================================= ]]
function invoker_retro_deafening_blast_on_spell_start(keys)
	
	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end
	local iExortLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iExortLevel = keys.caster.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end
	else
		iExortLevel = keys.target.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end	
	end
		
		local mute_duration = keys.ability:GetSpecialValueFor("mute_duration_base")+iExortLevel*keys.ability:GetSpecialValueFor("mute_duration_level_exort")
		local damage_to_deal = keys.ability:GetSpecialValueFor("damage_level_exort")*iExortLevel
		
		keys.target:EmitSound("Hero_Invoker.DeafeningBlast")
		ApplyDamageTestDummy({victim = keys.target, attacker = keys.caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_MAGICAL,})
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_invoker_retro_deafening_blast", {duration = mute_duration})

end