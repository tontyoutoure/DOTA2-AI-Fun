modifier_bastion_power_flux_lua = class({})
function modifier_bastion_power_flux_lua:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_EVENT_ON_TAKEDAMAGE}
	return funcs
end


function modifier_bastion_power_flux_lua:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

function modifier_bastion_power_flux_lua:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	else
		return true
	end
end

function modifier_bastion_power_flux_lua:IsBuff()
	return true
end


function modifier_bastion_power_flux_lua:OnTakeDamage(keys)
	if self:GetParent() ~= keys.unit then return end
	local ability = self:GetAbility()
	local level = ability:GetLevel()
	local caster = self:GetCaster()
	local damageNeed = ability:GetSpecialValueFor("damage_need")
	
	self.powerFluxDamageTaken = self.powerFluxDamageTaken or 0
	self.powerFluxDamageTaken = self.powerFluxDamageTaken+keys.damage
	
	if self.powerFluxDamageTaken > damageNeed then
		self.powerFluxDamageTaken = self.powerFluxDamageTaken-damageNeed
		if self:GetStackCount() < ability:GetSpecialValueFor("max_value") then
			self:IncrementStackCount()
		end
	end
end

modifier_bastion_speed_flux_lua = class({})

function modifier_bastion_speed_flux_lua:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
	return funcs
end

function modifier_bastion_speed_flux_lua:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

function modifier_bastion_speed_flux_lua:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	else
		return true
	end
end

function modifier_bastion_speed_flux_lua:IsBuff()
	return true
end

modifier_bastion_speed_flux_speed_boost_lua = class({})

function modifier_bastion_speed_flux_speed_boost_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end


function modifier_bastion_speed_flux_speed_boost_lua:IsHidden()
	return false
end

function modifier_bastion_speed_flux_speed_boost_lua:IsBuff()
	return true
end

function modifier_bastion_speed_flux_speed_boost_lua:IsPurgable()
	return true
end

function modifier_bastion_speed_flux_speed_boost_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_bastion_speed_flux_speed_boost_lua:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("speed")
end




function modifier_bastion_speed_flux_speed_boost_lua:OnTakeDamage(keys)
	if self:GetParent() ~= keys.unit then return end
	local ability = self:GetAbility()
	local buff = self:GetCaster():FindModifierByName(ability:GetIntrinsicModifierName())
	local parent = self:GetParent()
	
	self.attackedCount = self.attackedCount or 0
	self.attackedCount = self.attackedCount+1
	if self.attackedCount == ability:GetSpecialValueFor("attack_need") then
		self.attackedCount = 0
		if buff:GetStackCount() < ability:GetSpecialValueFor("max_value") then
			buff:IncrementStackCount()
		end
	end
end

function modifier_bastion_speed_flux_speed_boost_lua:GetEffectName() 
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" 
end

function modifier_bastion_speed_flux_speed_boost_lua:GetEffectAttachType() 
	return PATTACH_ABSORIGIN_FOLLOW 
end


modifier_bastion_mind_flux_lua = class({})

function modifier_bastion_mind_flux_lua:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_ABSORB_SPELL}
	return funcs
end

function modifier_bastion_mind_flux_lua:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

function modifier_bastion_mind_flux_lua:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	else
		return true
	end
end

function modifier_bastion_mind_flux_lua:IsBuff()
	return true
end

function modifier_bastion_mind_flux_lua:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

function modifier_bastion_mind_flux_lua:GetAbsorbSpell(keys)
	local caster = self:GetCaster()
	self.mindFluxSpellTargeted = self.mindFluxSpellTargeted or 0
	if caster:GetTeamNumber() == keys.ability:GetCaster():GetTeamNumber() then 
		return false 
	end
	self.mindFluxSpellTargeted = self.mindFluxSpellTargeted+1
	if self.mindFluxSpellTargeted == self:GetAbility():GetSpecialValueFor("spell_need") then
		self.mindFluxSpellTargeted = 0
		if keys.ability:GetCaster():IsHero() and self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_value") then
			self:IncrementStackCount()
		end
	end
	return false
end