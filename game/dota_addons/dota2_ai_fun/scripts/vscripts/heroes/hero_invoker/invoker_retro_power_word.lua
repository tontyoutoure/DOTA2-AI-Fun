--[[ ============================================================================================================
	Author: Rook
	Date: February 23, 2015
	Called when Power Word is cast.  Applies an armor buff if cast on an ally, and an armor debuff if cast on an enemy.
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_power_word_armor_debuff", "heroes/hero_invoker/invoker_retro_power_word.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_power_word_armor_buff", "heroes/hero_invoker/invoker_retro_power_word.lua", LUA_MODIFIER_MOTION_NONE)

invoker_retro_power_word = class({})
function invoker_retro_power_word:CastFilterResultTarget(hTarget)
	if hTarget == self:GetCaster() then return UF_FAIL_CUSTOM
	elseif hTarget:IsBuilding() then return UF_FAIL_BUILDING
	elseif hTarget:IsCourier() then return UF_FAIL_COURIER
	else return UF_SUCCESS
	end
end

function  invoker_retro_power_word:GetCustomCastErrorTarget(hTarget)
	if hTarget == self:GetCaster() then return '#dota_hud_error_cant_cast_on_self' end
end

function invoker_retro_power_word:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	hTarget:EmitSound("DOTA_Item.MedallionOfCourage.Activate")		
	local iQuasLevel = hCaster.iQuasLevel
	if hCaster:HasScepter() then iQuasLevel = iQuasLevel+1 end
	
	if hTarget:GetTeam() == hCaster:GetTeam() then
		hTarget:AddNewModifier(hCaster, self, 'modifier_invoker_retro_power_word_armor_buff', {Duration = self:GetSpecialValueFor('duration')}):SetStackCount(iQuasLevel)
	else
		hTarget:AddNewModifier(hCaster, self, 'modifier_invoker_retro_power_word_armor_debuff', {Duration = self:GetSpecialValueFor('duration')*CalculateStatusResist(hTarget)}):SetStackCount(iQuasLevel)
	end

end

modifier_invoker_retro_power_word_armor_buff = class({})
function modifier_invoker_retro_power_word_armor_buff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_invoker_retro_power_word_armor_buff:GetModifierPhysicalArmorBonus()
	self.iArmorPerStack = self.iArmorPerStack or self:GetAbility():GetSpecialValueFor('armor_bonus_ally_level_quas') 
	return self:GetStackCount()*self.iArmorPerStack 
end
function modifier_invoker_retro_power_word_armor_buff:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_armor_friend_shield.vpcf" end
function modifier_invoker_retro_power_word_armor_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_invoker_retro_power_word_armor_buff:OnCreated()
	if IsClient() then return end
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_power_word_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetAbsOrigin(), false)
	Timers:CreateTimer({
		endTime = 4,
		callback = function()
			ParticleManager:DestroyParticle(iParticle, false)
		end
	})
end


modifier_invoker_retro_power_word_armor_debuff = class({})
function modifier_invoker_retro_power_word_armor_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_invoker_retro_power_word_armor_debuff:GetModifierPhysicalArmorBonus()
	self.iArmorPerStack = self.iArmorPerStack or self:GetAbility():GetSpecialValueFor('armor_reduction_enemy_level_quas') 
	return self:GetStackCount()*self.iArmorPerStack 
end
function modifier_invoker_retro_power_word_armor_debuff:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_armor_enemy_shield.vpcf" end
function modifier_invoker_retro_power_word_armor_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_invoker_retro_power_word_armor_debuff:OnCreated()
	if IsClient() then return end
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_power_word_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetAbsOrigin(), false)
	Timers:CreateTimer({
		endTime = 4,
		callback = function()
			ParticleManager:DestroyParticle(iParticle, false)
		end
	})
end
