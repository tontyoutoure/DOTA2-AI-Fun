LinkLuaModifier("modifier_invoker_retro_arcane_arts", "heroes/hero_invoker/invoker_retro_arcane_arts.lua", LUA_MODIFIER_MOTION_NONE)

function InvokerRetroArcaneArtsApply(keys)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_invoker_retro_arcane_arts", {})
end

modifier_invoker_retro_arcane_arts = class({})
function modifier_invoker_retro_arcane_arts:IsPurgable() return false end
function modifier_invoker_retro_arcane_arts:RemoveOnDeath() return false end
function modifier_invoker_retro_arcane_arts:IsHidden() return true end

function modifier_invoker_retro_arcane_arts:OnCreated()
	if IsClient() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self.bWasHidden = false
	self:StartIntervalThink(0.04)
end

function modifier_invoker_retro_arcane_arts:OnIntervalThink()
	if IsClient() then return end
	if self:GetAbility():IsHidden() then
		self:SetStackCount(0)
		ParticleManager:DestroyParticle(self.iParticle, true)
		self.bWasHidden = true
		return
	elseif self.bWasHidden then
		self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self.bWasHidden = false
	end
	self:SetStackCount(self:GetAbility().iWexLevel)
end

function modifier_invoker_retro_arcane_arts:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end


function modifier_invoker_retro_arcane_arts:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_invoker_retro_arcane_arts:GetModifierMagicalResistanceBonus()
	if self:GetParent():PassivesDisabled() then return 0 end
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("magic_resistance_level")
end