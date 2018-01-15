modifier_ramza_archer_concentration_immune = class({})

function modifier_ramza_archer_concentration_immune:IsPurgable() return false end

function modifier_ramza_archer_concentration_immune:GetStatusEffectName() return "particles/status_fx/status_effect_avatar.vpcf" end

function modifier_ramza_archer_concentration_immune:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end

function modifier_ramza_archer_concentration_immune:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ramza_archer_concentration_immune:GetTexture() return "modifier_magicimmune" end

function modifier_ramza_archer_concentration_immune:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true;
	}
end

modifier_ramza_archer_archers_bane = class({})

function modifier_ramza_archer_archers_bane:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSORB_SPELL
	}
end

function modifier_ramza_archer_archers_bane:IsHidden() return true end
function modifier_ramza_archer_archers_bane:RemoveOnDeath() return false end
function modifier_ramza_archer_archers_bane:IsPurgable() return false end

function modifier_ramza_archer_archers_bane:GetAbsorbSpell(keys)
	if not self:GetParent():PassivesDisabled() and keys.ability:GetCaster():IsRangedAttacker() and math.random(100) < self:GetAbility():GetSpecialValueFor("evasion") then
		self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
		ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		return 1
	else
		return false
	end
end

modifier_ramza_archer_aimed = class({})
function modifier_ramza_archer_aimed:IsHidden() return false end
function modifier_ramza_archer_aimed:IsPurgable() return false end
function modifier_ramza_archer_aimed:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_ramza_archer_aimed:GetModifierProvidesFOWVision() return 1 end
function modifier_ramza_archer_aimed:CheckState() return {[MODIFIER_STATE_INVISIBLE]= false} end