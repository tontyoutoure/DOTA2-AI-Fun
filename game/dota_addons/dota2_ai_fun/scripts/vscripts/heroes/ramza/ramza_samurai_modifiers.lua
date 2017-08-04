modifier_ramza_samurai_bonecrusher = class({})

function modifier_ramza_samurai_bonecrusher:IsHidden() return true end
function modifier_ramza_samurai_bonecrusher:RemoveOnDeath() return false end
function modifier_ramza_samurai_bonecrusher:IsPurgable() return false end

function modifier_ramza_samurai_bonecrusher:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_ramza_samurai_bonecrusher:OnCreated()
	if IsClient() then return end
	self.fRatio = self:GetAbility():GetSpecialValueFor("health_percentage")/100
end

function modifier_ramza_samurai_bonecrusher:OnAttackLanded(keys)
	if keys.target ~= self:GetParent() or keys.target:GetHealth()/keys.target:GetMaxHealth() > self.fRatio then return end
	local damageTable = {
		victim = keys.attacker,
		attacker = keys.target,
		damage = keys.target:GetMaxHealth(),
		ability = self:GetAbility(),
		damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage(damageTable)	
end