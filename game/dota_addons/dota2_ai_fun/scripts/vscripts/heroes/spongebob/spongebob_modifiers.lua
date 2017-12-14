modifier_spongebob_krabby_food = class({})
function modifier_spongebob_krabby_food:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_spongebob_krabby_food:OnCreated()
	if IsClient() then return end
	if self:GetCaster():HasScepter() then 
		self.iHeal = self:GetAbility():GetSpecialValueFor("heal_scepter") 
	else
		self.iHeal = self:GetAbility():GetSpecialValueFor("heal") 
	end
	self:GetParent():Heal(self.iHeal, self:GetCaster())
	self:StartIntervalThink(1)
end

function modifier_spongebob_krabby_food:OnIntervalThink()
	if IsClient() then return end
	self:GetParent():Heal(self.iHeal, self:GetCaster())
end

function modifier_spongebob_krabby_food:IsPurgable() return false end

function modifier_spongebob_krabby_food:GetEffectName()
	return "particles/healing_flask_modified.vpcf"
end

function modifier_spongebob_krabby_food:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end