modifier_ramza_orator_speechcraft_mimic_darlavon = class({})

function modifier_ramza_orator_speechcraft_mimic_darlavon:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_ramza_orator_speechcraft_mimic_darlavon:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_ramza_orator_speechcraft_mimic_darlavon:GetOverrideAnimationRate() return 0.2 end
function modifier_ramza_orator_speechcraft_mimic_darlavon:CheckState()
	return {
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true		
	}
end

function modifier_ramza_orator_speechcraft_mimic_darlavon:GetEffectName() return "particles/units/heroes/hero_bane/bane_nightmare.vpcf" end
function modifier_ramza_orator_speechcraft_mimic_darlavon:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_ramza_orator_speechcraft_mimic_darlavon:OnDestroy()
	if IsClient() then return end
	self:GetParent():StopSound("Hero_Bane.Nightmare.Loop")
	self:GetParent():EmitSound("Hero_Bane.Nightmare.End")
end

function modifier_ramza_orator_speechcraft_mimic_darlavon:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	self:Destroy()
end

modifier_ramza_orator_speechcraft_condemn = class({})
function modifier_ramza_orator_speechcraft_condemn:OnCreated()
	if IsClient() then return end
	self.iDamage = self:GetAbility():GetSpecialValueFor("damage")
	self:StartIntervalThink(1*CalculateStatusResist(self:GetParent()))
	self:GetParent():EmitSound('Hero_DoomBringer.Doom')
end
function modifier_ramza_orator_speechcraft_condemn:IsPurgable() return false end
function modifier_ramza_orator_speechcraft_condemn:OnDestroy() if IsClient() then return end self:GetParent():StopSound('Hero_DoomBringer.Doom') end
function modifier_ramza_orator_speechcraft_condemn:CheckState() return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true} end
function modifier_ramza_orator_speechcraft_condemn:OnIntervalThink() if IsClient() then return end ApplyDamage({damage = self.iDamage, ability = self:GetAbility(), attacker = self:GetCaster(), victim = self:GetParent(), damage_type=DAMAGE_TYPE_PURE}) end
function modifier_ramza_orator_speechcraft_condemn:GetStatusEffectName() return "particles/status_fx/status_effect_doom.vpcf" end
function modifier_ramza_orator_speechcraft_condemn:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end
function modifier_ramza_orator_speechcraft_condemn:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ramza_orator_speechcraft_condemn:GetTexture() return "doom_bringer_doom" end