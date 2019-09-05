
LinkLuaModifier("modifier_invoker_retro_invisibility_aura", "heroes/hero_invoker/invoker_retro_invisibility_aura", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_invoker_retro_invisibility_aura_effect", "heroes/hero_invoker/invoker_retro_invisibility_aura", LUA_MODIFIER_MOTION_NONE) 
modifier_invoker_retro_invisibility_aura = class({})
function modifier_invoker_retro_invisibility_aura:IsPurgable() return false end
function modifier_invoker_retro_invisibility_aura:RemoveOnDeath() return false end
function modifier_invoker_retro_invisibility_aura:IsHidden() return true end
function modifier_invoker_retro_invisibility_aura:IsAura() return true end
function modifier_invoker_retro_invisibility_aura:GetModifierAura() return "modifier_invoker_retro_invisibility_aura_effect" end
function modifier_invoker_retro_invisibility_aura:GetAuraRadius()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local iRadius
	if hParent:IsIllusion() then return 0 end
	if hAbility:IsHidden() then
		self:SetStackCount(0)
		iRadius = 0
	else	
		local iQuasLevel = hParent.iQuasLevel
		if hParent:HasScepter() then iQuasLevel = iQuasLevel+1 end
		if self:GetStackCount() ~= iQuasLevel then
			self:SetStackCount(iQuasLevel)
		end
		iRadius = hAbility:GetSpecialValueFor("radius_base")+self:GetStackCount()*hAbility:GetSpecialValueFor("radius_level_quas")
	end
	
	if self.iPreviousRadius ~= iRadius then 
		if self.iParticle then
			ParticleManager:DestroyParticle(self.iParticle, true)
		end
		if iRadius > 0 then
			self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_invisibility_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.iParticle, 1, Vector(iRadius, iRadius, iRadius))
			ParticleManager:SetParticleControl(self.iParticle, 2, Vector(iRadius, iRadius, iRadius)*1.276)
		end
	end
	
	self.iPreviousRadius = iRadius
	return iRadius
end
function modifier_invoker_retro_invisibility_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_invoker_retro_invisibility_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_invoker_retro_invisibility_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_invoker_retro_invisibility_aura:GetAuraEntityReject(hEntity) if hEntity == self:GetParent() then return true else return false end end

function modifier_invoker_retro_invisibility_aura:OnCreated()
	self:GetAbility().hModifier = self
	if IsClient() then return end
	if self:GetParent():IsIllusion() then return end
end

function modifier_invoker_retro_invisibility_aura:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

modifier_invoker_retro_invisibility_aura_effect = class({})

function modifier_invoker_retro_invisibility_aura_effect:CheckState()
	if self:GetStackCount() == 0 then
		return {[MODIFIER_STATE_INVISIBLE] = true}
	else
		return {}
	end
end

function modifier_invoker_retro_invisibility_aura_effect:OnCreated()
	self:StartIntervalThink(0.04)
	self.fInvisTime = self:GetAbility():GetSpecialValueFor("fade_time")+GameRules:GetGameTime()
	self.bWasBreak = false
end
function modifier_invoker_retro_invisibility_aura_effect:OnDestroy()
	if IsClient() then return end
	self:GetParent():RemoveModifierByName("modifier_invisible")
end

function modifier_invoker_retro_invisibility_aura_effect:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	local hCaster = self:GetAbility():GetCaster()
	if hCaster:PassivesDisabled() then
		self.fInvisTime = self:GetAbility():GetSpecialValueFor("fade_time")+GameRules:GetGameTime()
	end
	if GameRules:GetGameTime() >= self.fInvisTime and not hParent:HasModifier("modifier_invisible") then
		hParent:EmitSound("Hero_Invoker.GhostWalk")
		hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_invisible", {})
	end	
end

function modifier_invoker_retro_invisibility_aura_effect:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_FINISHED, MODIFIER_EVENT_ON_ABILITY_EXECUTED}
end

function modifier_invoker_retro_invisibility_aura_effect:OnAbilityExecuted(keys)
	if keys.unit ~= self:GetParent() then return end
	self.fInvisTime = self:GetAbility():GetSpecialValueFor("fade_time")+GameRules:GetGameTime()
end
function modifier_invoker_retro_invisibility_aura_effect:OnAttackFinished(keys)
	if keys.attacker ~= self:GetParent() then return end
	self.fInvisTime = self:GetAbility():GetSpecialValueFor("fade_time")+GameRules:GetGameTime()
end

 
invoker_retro_invisibility_aura = class({})
function invoker_retro_invisibility_aura:IsHiddenWhenStolen() return false end
function invoker_retro_invisibility_aura:GetIntrinsicModifierName()
	return "modifier_invoker_retro_invisibility_aura" 
end
--[[
function invoker_retro_invisibility_aura:GetCastRange() 
	return self:GetSpecialValueFor("radius_base")+self.hModifier:GetStackCount()*self:GetSpecialValueFor("radius_level_quas")
end
]]--