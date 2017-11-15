modifier_terran_marine_precision = class({})

function modifier_terran_marine_precision:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_terran_marine_precision:IsBuff()
	return true
end

function modifier_terran_marine_precision:OnTooltip()
	
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_terran_marine_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end	
	if self.hSpecial then
		return self:GetAbility():GetSpecialValueFor("shots")+self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetAbility():GetSpecialValueFor("shots")
	end
end 

function modifier_terran_marine_precision:OnAttackLanded(keys)	
	local hParent = self:GetParent();
	if keys.attacker~=hParent then return end;
	self.iShotCount = self.iShotCount or 0;
	self.iShotCount = self.iShotCount+1;
	local iShotToGo
	if self:GetCaster():FindAbilityByName("special_bonus_terran_marine_2") then
		iShotToGo = self:GetAbility():GetSpecialValueFor("shots")+self:GetCaster():FindAbilityByName("special_bonus_terran_marine_2"):GetSpecialValueFor("value")
	else
		iShotToGo = self:GetAbility():GetSpecialValueFor("shots")
	end
	if self.iShotCount >= iShotToGo then
		self.iShotCount = 0;
		hParent:SetBaseAgility(hParent:GetBaseAgility()+1)
		hParent:CalculateStatBonus()
		self:IncrementStackCount()
	end
end

modifier_terran_marine_u247_rifle = class({})

function modifier_terran_marine_u247_rifle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_terran_marine_u247_rifle:IsBuff()
	return true
end

function modifier_terran_marine_u247_rifle:IsPermanent()
	return true
end

function modifier_terran_marine_u247_rifle:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("movement_override")
end

function modifier_terran_marine_u247_rifle:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("attack_range")-650
end

function modifier_terran_marine_u247_rifle:GetModifierProjectileSpeedBonus()
	return -200
end