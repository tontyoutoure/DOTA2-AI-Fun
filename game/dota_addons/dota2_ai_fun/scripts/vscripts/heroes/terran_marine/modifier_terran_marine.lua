modifier_terran_marine_precision = class({})

function modifier_terran_marine_precision:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_terran_marine_precision:RemoveOnDeath() return false end
function modifier_terran_marine_precision:IsPurgable() return false end

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
	if hParent:PassivesDisabled() then return end
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
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_terran_marine_u247_rifle:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or not keys.attacker:HasScepter() or keys.target:IsBuilding() or keys.target:GetTeam() == keys.attacker:GetTeam() then return end
	local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k, v in pairs(tTargets) do
		if v ~= keys.target then
			ApplyDamage({
				attacker = keys.attacker,
				victim = v,
				damage = keys.damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			})
		end
	end
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_ABSORIGIN, keys.target)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(1,1,self:GetAbility():GetSpecialValueFor("radius_scepter")))
	keys.target:EmitSound('Hero_Techies.LandMine.Detonate')
end

function modifier_terran_marine_u247_rifle:IsBuff()
	return true
end

function modifier_terran_marine_u247_rifle:IsPurgable()
	return false
end
function modifier_terran_marine_u247_rifle:RemoveOnDeath()
	return false
end

function modifier_terran_marine_u247_rifle:GetModifierBaseAttackTimeConstant() return self:GetAbility():GetSpecialValueFor("attack_time") end

function modifier_terran_marine_u247_rifle:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("movement_override")
end

function modifier_terran_marine_u247_rifle:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("attack_range")-650
end

function modifier_terran_marine_u247_rifle:GetModifierProjectileSpeedBonus()
	return -200
end

modifier_terran_marine_attack_sound = class({})
function modifier_terran_marine_attack_sound:IsPurgable() return false end
function modifier_terran_marine_attack_sound:IsHidden() return true end
function modifier_terran_marine_attack_sound:RemoveOnDeath() return false end
function modifier_terran_marine_attack_sound:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND} end
function modifier_terran_marine_attack_sound:GetAttackSound() return "Hero_Gyrocopter.FlackCannon" end