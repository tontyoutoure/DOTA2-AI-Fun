--[[ ============================================================================================================
	Author: wFX
	Date: March 05, 2015
	Called when Soul Reaver is cast.
================================================================================================================= ]]

LinkLuaModifier('modifier_invoker_retro_soul_reaver_movement_speed', 'heroes/hero_invoker/invoker_retro_soul_reaver.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_invoker_retro_soul_reaver_damage', 'heroes/hero_invoker/invoker_retro_soul_reaver.lua', LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_soul_reaver_movement_speed = class({})
function modifier_invoker_retro_soul_reaver_movement_speed:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_invoker_retro_soul_reaver_movement_speed:GetEffectName() return 'particles/units/heroes/hero_invoker/invoker_retro_soul_reaver_movement_speed_boost_modifier.vpcf' end
function modifier_invoker_retro_soul_reaver_movement_speed:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_invoker_retro_soul_reaver_movement_speed:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount() end

modifier_invoker_retro_soul_reaver_damage = class({})
function modifier_invoker_retro_soul_reaver_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_invoker_retro_soul_reaver_damage:GetEffectName() return  "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_ring_e_copy.vpcf" end
function modifier_invoker_retro_soul_reaver_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_invoker_retro_soul_reaver_damage:IsPurgable() return false end
function modifier_invoker_retro_soul_reaver_damage:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_invoker_retro_soul_reaver_damage:OnTooltip() return self:GetStackCount() end


function invoker_retro_soul_reaver_on_spell_start(keys)
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
		
	local iQuasLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iQuasLevel = keys.caster.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end
	else
		iQuasLevel = keys.target.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end	
	end
		
	local iWexLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iWexLevel = keys.caster.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end
	else
		iWexLevel = keys.target.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end	
	end
		



	local damageTable = {
		victim = keys.target,
		attacker = keys.caster,
		damage = keys.ability:GetSpecialValueFor("initial_damage_level_quas")*iQuasLevel,
		damage_type = keys.ability:GetAbilityDamageType(),
		ability = keys.ability
	}
	ApplyDamageTestDummy(damageTable)
	
	local secondary_damage = keys.ability:GetSpecialValueFor("after_damage_level_exort")*iExortLevel+keys.ability:GetSpecialValueFor("after_damage_base")
	local fDamageDelay = keys.ability:GetSpecialValueFor('damage_delay')*CalculateStatusResist(keys.target)
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_soul_reaver_damage", {duration = fDamageDelay}):SetStackCount(secondary_damage)
	ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_soul_reaver_damage_initial.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.target:EmitSound("retro_dota.invoker_retro_soul_reaver_initial_damage")
	keys.target:EmitSound("Hero_Jakiro.LiquidFire")
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_soul_reaver_movement_speed", {duration = fDamageDelay}):SetStackCount(keys.ability:GetSpecialValueFor('bonus_ms_level_wex')*iWexLevel)
	ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_soul_reaver_movement_speed_boost_begin.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	keys.caster:EmitSound("retro_dota.soul_reaver_buff")
	
	ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_soul_reaver_movement_speed_boost_begin.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	
	Timers:CreateTimer({
		endTime = fDamageDelay,
		callback = function()
			local damageTable = {
				victim = keys.target,
				attacker = keys.caster,
				damage = secondary_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = keys.ability
			}
			ApplyDamageTestDummy(damageTable)
			
			keys.target:EmitSound("retro_dota.invoker_retro_soul_reaver_delayed_damage")
			keys.target:EmitSound("Hero_Jakiro.LiquidFire")
			
			PopupCriticalDamage(keys.target, secondary_damage)
			
			--[[ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_soul_reaver_damage_delayed.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			
			local soul_reaver_number = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_soul_reaver_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
			ParticleManager:SetParticleControl(soul_reaver_number, 1, Vector(1, damageTable.damage, 0))
			ParticleManager:SetParticleControl(soul_reaver_number, 2, Vector(2, string.len(math.floor(damageTable.damage)) + 1, 0))]]
		end
	})
end