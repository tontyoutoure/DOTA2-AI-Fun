bastion_transference_str = class({})
bastion_transference_agi = class({})
bastion_transference_int = class({})

function bastion_transference_str:IsStealable() return false end
function bastion_transference_agi:IsStealable() return false end
function bastion_transference_int:IsStealable() return false end

function bastion_transference_int:OnUpgrade()
	local caster = self:GetCaster()
	caster:SetAbilityPoints(caster:GetAbilityPoints()+2)	
	caster:UpgradeAbility(caster:GetAbilityByIndex(3))
	caster:UpgradeAbility(caster:GetAbilityByIndex(4))
end

function bastion_transference_int:CastFilterResultTarget(target)
	if IsClient() then return UF_SUCCESS end
	if not self:GetCaster():FindModifierByName("modifier_bastion_mind_flux_lua") or self:GetCaster() == target then 
		return UF_FAIL_CUSTOM 
	elseif self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
		return UF_FAIL_ENEMY
	else 
		return UF_SUCCESS
	end
end


function bastion_transference_int:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then return "error_cannot_self_cast" end
	if not self:GetCaster():FindModifierByName("modifier_bastion_mind_flux_lua") then return "error_flux_not_upgrade" end
end

function bastion_transference_agi:CastFilterResultTarget(target)
	if IsClient() then return UF_SUCCESS end
	if not self:GetCaster():FindModifierByName("modifier_bastion_speed_flux_lua") or self:GetCaster() == target then 
		return UF_FAIL_CUSTOM 
	elseif self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
		return UF_FAIL_ENEMY
	else 
		return UF_SUCCESS
	end
end


function bastion_transference_agi:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then return "error_cannot_self_cast" end
	if not self:GetCaster():FindModifierByName("modifier_bastion_speed_flux_lua") then return "error_flux_not_upgrade" end
end

function bastion_transference_str:CastFilterResultTarget(target)
	if IsClient() then return UF_SUCCESS end
	if not self:GetCaster():FindModifierByName("modifier_bastion_power_flux_lua") or self:GetCaster() == target then 
		return UF_FAIL_CUSTOM 
	elseif self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
		return UF_FAIL_ENEMY
	else 
		return UF_SUCCESS
	end
end


function bastion_transference_str:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then return "error_cannot_self_cast" end
	if not self:GetCaster():FindModifierByName("modifier_bastion_power_flux_lua") then return "error_flux_not_upgrade" end
end



function bastion_transference_str:GetCastRange(...)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("range_scepter")
	end
	return self.BaseClass.GetCastRange(self, ...)
end

function bastion_transference_agi:GetCastRange(...)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("range_scepter")
	end
	return self.BaseClass.GetCastRange(self, ...)
end

function bastion_transference_int:GetCastRange(...)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("range_scepter")
	end
	return self.BaseClass.GetCastRange(self, ...)
end

function bastion_transference_str:GetCooldown(num)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 90-num*30
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)
		end
	end
	
	return self.BaseClass.GetCooldown(self, num)
end

function bastion_transference_agi:GetCooldown(num)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 90-num*30
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)
		end
	end
	return self.BaseClass.GetCooldown(self, num)
end

function bastion_transference_int:GetCooldown(num)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 90-num*30
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)
		end
	end
	return self.BaseClass.GetCooldown(self, num)
end

function bastion_transference_str:OnSpellStart()
	local caster = self:GetCaster()
	ProcsArroundingMagicStick(caster)
	local target = self:GetCursorTarget()
	local buff = caster:FindModifierByName("modifier_bastion_power_flux_lua")
	local bonus
	if not caster:HasScepter() then
		bonus = buff:GetStackCount()*self:GetSpecialValueFor("percentage")/100
	else
		bonus = buff:GetStackCount()*self:GetSpecialValueFor("percentage_scepter")/100
	end
	buff:SetStackCount(0)
	caster:SetBaseStrength(caster:GetBaseStrength()+bonus)
	target:SetBaseStrength(target:GetBaseStrength()+bonus)
	target:CalculateStatBonus()
	caster:CalculateStatBonus()
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "follow_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
	caster:EmitSound("Hero_Chen.HandOfGodHealHero")
	target:EmitSound("Hero_Chen.HandOfGodHealHero")
end

function bastion_transference_agi:OnSpellStart()
	local caster = self:GetCaster()
	ProcsArroundingMagicStick(caster)
	local target = self:GetCursorTarget()
	local buff = caster:FindModifierByName("modifier_bastion_speed_flux_lua")
	local bonus

	if not caster:HasScepter() then
		bonus = buff:GetStackCount()*self:GetSpecialValueFor("percentage")/100
	else
		bonus = buff:GetStackCount()*self:GetSpecialValueFor("percentage_scepter")/100
	end
	buff:SetStackCount(0)
	caster:SetBaseAgility(caster:GetBaseAgility()+bonus)
	target:SetBaseAgility(target:GetBaseAgility()+bonus)
	target:CalculateStatBonus()
	caster:CalculateStatBonus()
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "follow_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
	caster:EmitSound("Hero_Chen.HandOfGodHealHero")
	target:EmitSound("Hero_Chen.HandOfGodHealHero")

end

function bastion_transference_int:OnSpellStart()
	local caster = self:GetCaster()
	ProcsArroundingMagicStick(caster)
	local target = self:GetCursorTarget()
	local buff = caster:FindModifierByName("modifier_bastion_mind_flux_lua")
	local bonus

	if not caster:HasScepter() then
		bonus = buff:GetStackCount()*self:GetSpecialValueFor("percentage")/100
	else
		bonus = buff:GetStackCount()*self:GetSpecialValueFor("percentage_scepter")/100
	end
	buff:SetStackCount(0)
	caster:SetBaseIntellect(caster:GetBaseIntellect()+bonus)
	target:SetBaseIntellect(target:GetBaseIntellect()+bonus)
	target:CalculateStatBonus()
	caster:CalculateStatBonus()
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "follow_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
	caster:EmitSound("Hero_Chen.HandOfGodHealHero")
	target:EmitSound("Hero_Chen.HandOfGodHealHero")		
end