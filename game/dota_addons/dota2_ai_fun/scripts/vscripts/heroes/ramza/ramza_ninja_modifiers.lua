modifier_ramza_ninja_reflexes = class({})

function modifier_ramza_ninja_reflexes:IsHidden() return true end
function modifier_ramza_ninja_reflexes:RemoveOnDeath() return true end
function modifier_ramza_ninja_reflexes:IsPurgable() return false end

function modifier_ramza_ninja_reflexes:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_ramza_ninja_reflexes:OnCreated()
	if IsClient() then return end
	self.fChance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_ramza_ninja_reflexes:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	if keys.unit:PassivesDisabled() then return end
	if RandomInt(1, 100) < self.fChance then
		keys.unit:SetHealth(keys.unit:GetHealth()+keys.damage)
		ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
	end
end

modifier_ramza_ninja_dual_wield = class({})

function modifier_ramza_ninja_dual_wield:IsHidden() return true end
function modifier_ramza_ninja_dual_wield:RemoveOnDeath() return true end
function modifier_ramza_ninja_dual_wield:IsPurgable() return false end
function modifier_ramza_ninja_dual_wield:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_ramza_ninja_dual_wield:OnCreated() if IsClient() then return end self:SetStackCount(self:GetAbility():GetSpecialValueFor("attack_bonus")) end
function modifier_ramza_ninja_dual_wield:GetModifierAttackSpeedBonus_Constant() if self:GetParent():PassivesDisabled() then return 0 else return self:GetStackCount() end end