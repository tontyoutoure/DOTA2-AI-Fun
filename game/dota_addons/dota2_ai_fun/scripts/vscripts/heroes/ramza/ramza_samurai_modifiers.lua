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

modifier_ramza_samurai_murasame = class({})

function modifier_ramza_samurai_murasame:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end

function modifier_ramza_samurai_murasame:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)	
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'follow_origin' ,hParent:GetAbsOrigin(), true)
end

function modifier_ramza_samurai_murasame:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function modifier_ramza_samurai_murasame:GetModifierMoveSpeed_Absolute()
	self.iSpeed = self.iSpeed or self:GetAbility():GetSpecialValueFor("fixed_move_speed")
	return self.iSpeed
end

function modifier_ramza_samurai_murasame:GetModifierAttackSpeedBonus_Constant()
	self.iAttack = self.iAttack or self:GetAbility():GetSpecialValueFor("attack_bonus")
	return self.iAttack
end