LinkLuaModifier("modifier_invoker_retro_arcane_arts", "heroes/hero_invoker/invoker_retro_arcane_arts.lua", LUA_MODIFIER_MOTION_NONE)
invoker_retro_arcane_arts = class({})
function invoker_retro_arcane_arts:GetBehavior()
	if bit.band(self.hModifier:GetStackCount(), 1) > 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
	end
end
function invoker_retro_arcane_arts:GetCastAnimation() return ACT_DOTA_CAST_SUN_STRIKE end

function invoker_retro_arcane_arts:GetIntrinsicModifierName() return "modifier_invoker_retro_arcane_arts" end
function invoker_retro_arcane_arts:GetAbilityTextureName()
	if bit.band(self.hModifier:GetStackCount(), 2) > 0 then
		return 'invoker_retro_arcane_arts_red'
	else
		return 'invoker_retro_arcane_arts'
	end
end
function invoker_retro_arcane_arts:OnSpellStart()
	local hCaster = self:GetCaster()
	StartAnimation(hCaster, {duration=0.25, activity=ACT_DOTA_CAST_SUN_STRIKE, rate=2, translate="divine_sorrow_sunstrike"})
	if bit.band(self.hModifier:GetStackCount(), 2) > 0 then
		self.hModifier:SetStackCount(self.hModifier:GetStackCount()-2)
		hCaster:EmitSound('Hero_Rubick.NullField.Defense')
	else
		self.hModifier:SetStackCount(self.hModifier:GetStackCount()+2)
		hCaster:EmitSound('Hero_Rubick.NullField.Offense')
	end
end
-- zero stack count means ability is hidden
-- first bit of stack count means if the ability is togglable.
-- second bit of stack count means if the ability is for spell amp
-- rest bit means level of wex

modifier_invoker_retro_arcane_arts = class({})
function modifier_invoker_retro_arcane_arts:IsPurgable() return false end
function modifier_invoker_retro_arcane_arts:RemoveOnDeath() return false end
function modifier_invoker_retro_arcane_arts:IsHidden() return true end

function modifier_invoker_retro_arcane_arts:OnCreated()
	self:GetAbility().hModifier = self
	if IsClient() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self.bWasHidden = false
	self:StartIntervalThink(0.04)
end

function modifier_invoker_retro_arcane_arts:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if self:GetAbility():IsHidden() then
		self:SetStackCount(0)
		ParticleManager:DestroyParticle(self.iParticle, true)
		self.bWasHidden = true
		return
	elseif self.bWasHidden then
		if bit.band(2, self:GetStackCount()) == 0 then
			self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self.bWasAmp = false
		else
			self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self.bWasAmp = true
		end
		self.bWasHidden = false
	end
	
	if self.bWasAmp then
		if bit.band(2, self:GetStackCount()) == 0 then
			ParticleManager:DestroyParticle(self.iParticle, true)
			self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self.bWasAmp = false
		end
	else
		if bit.band(2, self:GetStackCount()) ~= 0 then
			ParticleManager:DestroyParticle(self.iParticle, true)
			self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_arcane_arts_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self.bWasAmp = true
		end
	end
	
	local iTalented = 0
	if hParent:HasAbility('special_bonus_unique_invoker_retro_4') then
		iTalented = hParent:FindAbilityByName('special_bonus_unique_invoker_retro_4'):GetSpecialValueFor('value')
	end
	
	local iWexLevel
	if hParent:HasScepter() then
		iWexLevel = hParent.iWexLevel+1
	else
		iWexLevel = hParent.iWexLevel
	end
	self:SetStackCount(bit.lshift(iWexLevel, 2)+bit.band(2, self:GetStackCount())+iTalented)
end

function modifier_invoker_retro_arcane_arts:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end


function modifier_invoker_retro_arcane_arts:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_invoker_retro_arcane_arts:GetModifierMagicalResistanceBonus()
	if self:GetParent():PassivesDisabled() then return 0 end
	if bit.band(self:GetStackCount(),2) > 0 then return 0 end
	return bit.rshift(self:GetStackCount(),2)*self:GetAbility():GetSpecialValueFor("magic_resistance_level_wex")
end

function modifier_invoker_retro_arcane_arts:GetModifierSpellAmplify_Percentage()
	if self:GetParent():PassivesDisabled() then return 0 end
	if bit.band(self:GetStackCount(),2) == 0 then return 0 end
	return bit.rshift(self:GetStackCount(),2)*self:GetAbility():GetSpecialValueFor("magic_resistance_level_wex")
end