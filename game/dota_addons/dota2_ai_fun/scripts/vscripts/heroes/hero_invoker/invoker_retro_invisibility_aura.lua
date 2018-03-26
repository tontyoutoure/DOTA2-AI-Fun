
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
	if hParent:IsIllusion() then return 0 end
	if hAbility:IsHidden() then
		self:SetStackCount(0)
		ParticleManager:DestroyParticle(self.iParticle, true)
		self.bWasHidden = true
		return
	elseif self.bWasHidden then
		self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_invisibility_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self.bWasHidden = false
	end
	
	local iRadius
	if not hAbility:IsHidden() and hAbility.iQuasLevel and self:GetStackCount() ~= hAbility.iQuasLevel then
		self:SetStackCount(hAbility.iQuasLevel)
		iRadius = hAbility:GetSpecialValueFor("radius_base")+self:GetStackCount()*hAbility:GetSpecialValueFor("radius_level")
		ParticleManager:DestroyParticle(self.iParticle, true)
		self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_invisibility_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.iParticle, 1, Vector(iRadius, iRadius, iRadius))
		ParticleManager:SetParticleControl(self.iParticle, 2, Vector(iRadius, iRadius, iRadius)*1.276)
	end
	
	if self:GetStackCount() == 0 then iRadius = 0 end
	
	return iRadius or hAbility:GetSpecialValueFor("radius_base")+self:GetStackCount()*hAbility:GetSpecialValueFor("radius_level")
end
function modifier_invoker_retro_invisibility_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_invoker_retro_invisibility_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_invoker_retro_invisibility_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_invoker_retro_invisibility_aura:GetAuraEntityReject(hEntity) if hEntity == self:GetParent() then return true else return false end end

function modifier_invoker_retro_invisibility_aura:OnCreated()
	if IsClient() then return end
	if self:GetParent():IsIllusion() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_invisibility_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self.bWasHidden = false
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
local function UpdateInvokerRetroOrbScepter(hInvoker)
	if not hInvoker:FindAbilityByName("invoker_retro_quas") or not hInvoker:FindAbilityByName("invoker_retro_wex") or not hInvoker:FindAbilityByName("invoker_retro_exort") then return end
	local iQuasLevel = hInvoker:FindAbilityByName("invoker_retro_quas"):GetLevel()
	local iWexLevel = hInvoker:FindAbilityByName("invoker_retro_wex"):GetLevel()
	local iExortLevel = hInvoker:FindAbilityByName("invoker_retro_exort"):GetLevel()
	if hInvoker:HasScepter() then
		iQuasLevel = iQuasLevel+1
		iWexLevel = iWexLevel+1
		iExortLevel = iExortLevel+1
		hInvoker:GetAbilityByIndex(4):SetHidden(false)
	else		
		hInvoker:GetAbilityByIndex(4):SetHidden(true)
	end
	
	for i = 0, 23 do
		if hInvoker:GetAbilityByIndex(i) then
			local hAbility = hInvoker:GetAbilityByIndex(i)
			if not tOriginalAbilities[hAbility:GetName()] and not string.match(hAbility:GetName(), "special_bonus") then
				hAbility.iQuasLevel = iQuasLevel
				hAbility.iWexLevel = iWexLevel
				hAbility.iExortLevel = iExortLevel
			end
		end
	end	
end
 
invoker_retro_invisibility_aura = class({})
function invoker_retro_invisibility_aura:IsHiddenWhenStolen() return false end
function invoker_retro_invisibility_aura:GetIntrinsicModifierName()
	UpdateInvokerRetroOrbScepter(self:GetCaster())
	return "modifier_invoker_retro_invisibility_aura" 
end