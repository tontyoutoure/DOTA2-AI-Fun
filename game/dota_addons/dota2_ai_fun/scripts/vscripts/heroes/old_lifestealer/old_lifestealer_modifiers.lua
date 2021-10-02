modifier_old_lifestealer_feast = class({})
function modifier_old_lifestealer_feast:IsHidden() return true end
function modifier_old_lifestealer_feast:RemoveOnDeath() return false end
function modifier_old_lifestealer_feast:IsPurgable() return false end
function modifier_old_lifestealer_feast:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_old_lifestealer_feast:OnTakeDamage(keys)
	-- PrintTable(keys)
	if keys.attacker ~= self:GetParent() then return end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL or keys.attacker:PassivesDisabled() or keys.attacker:GetTeam() == keys.unit:GetTeam() or keys.unit:IsBuilding() then return end
	ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	
	local iHealPercent = self:GetAbility():GetSpecialValueFor("lifesteal") 
	if keys.attacker:HasAbility("special_bonus_unique_old_lifestealer_2") then
		iHealPercent = iHealPercent+keys.attacker:FindAbilityByName("special_bonus_unique_old_lifestealer_2"):GetSpecialValueFor("value")
	end
	local fHeal = keys.damage*iHealPercent/100
	if keys.unit:IsIllusion() then fHeal = fHeal/3 end
	keys.attacker:Heal(fHeal, keys.attacker)
	local iParticle2 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, keys.attacker, keys.attacker:GetPlayerOwner())		
	ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fHeal), 0))
	ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fHeal)), 200))
	ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
end


modifier_old_lifestealer_anabolic_frenzy = class({})
function modifier_old_lifestealer_anabolic_frenzy:IsHidden() return true end
function modifier_old_lifestealer_anabolic_frenzy:RemoveOnDeath() return false end
function modifier_old_lifestealer_anabolic_frenzy:IsPurgable() return false end
function modifier_old_lifestealer_anabolic_frenzy:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_old_lifestealer_anabolic_frenzy:GetModifierMoveSpeedBonus_Percentage()	
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_lifestealer_1" or self.hSpecial:GetCaster() ~= self:GetParent()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial then
		return self:GetAbility():GetSpecialValueFor("move_bonus")+self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetAbility():GetSpecialValueFor("move_bonus")
	end
end
function modifier_old_lifestealer_anabolic_frenzy:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attack_bonus") end

modifier_old_lifestealer_poison_sting = class({})
function modifier_old_lifestealer_poison_sting:IsHidden() return true end
function modifier_old_lifestealer_poison_sting:RemoveOnDeath() return false end
function modifier_old_lifestealer_poison_sting:IsPurgable() return false end
function modifier_old_lifestealer_poison_sting:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_old_lifestealer_poison_sting:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or keys.attacker:IsIllusion() then return end
	local iDuration = self:GetAbility():GetSpecialValueFor("duration")
	if keys.attacker:HasAbility("special_bonus_unique_old_lifestealer_4") then iDuration = iDuration+keys.attacker:FindAbilityByName("special_bonus_unique_old_lifestealer_4"):GetSpecialValueFor("value") end 
	keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_old_lifestealer_poison_sting_slow", {Duration = iDuration*CalculateStatusResist(keys.target)})
end
modifier_old_lifestealer_poison_sting_slow = class({})
function modifier_old_lifestealer_poison_sting_slow:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(CalculateStatusResist(self:GetParent()))
end
function modifier_old_lifestealer_poison_sting_slow:OnRefresh()
	self.fSlow = self:GetAbility():GetSpecialValueFor("move_slow")

end
function modifier_old_lifestealer_poison_sting_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_old_lifestealer_poison_sting_slow:GetModifierMoveSpeedBonus_Percentage() 
	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("move_slow")
	return self.fSlow
end
function modifier_old_lifestealer_poison_sting_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_old_lifestealer_poison_sting_slow:GetEffectName() return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf" end
function modifier_old_lifestealer_poison_sting_slow:GetStatusEffectName() return "particles/status_fx/status_effect_poison_venomancer.vpcf" end


function modifier_old_lifestealer_poison_sting_slow:OnIntervalThink()
	if IsClient() then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local fDamage = hAbility:GetSpecialValueFor("damage")
	local iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_spell.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(0, fDamage, 6))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fDamage))+2, 100))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(85+80,26+40,139+40))
	ApplyDamage({victim = self:GetParent(), damage_type = hAbility:GetAbilityDamageType(), damage = fDamage, attacker = self:GetCaster(), ability = hAbility})
end


modifier_old_lifestealer_rage_aura = class({})

function modifier_old_lifestealer_rage_aura:IsAura() 
	return true 
end

function modifier_old_lifestealer_rage_aura:GetAuraRadius() 
	if self:GetParent():HasScepter() then 
		return self:GetAbility():GetSpecialValueFor("radius_scepter") 
	else 
		return 0 
	end
end

function modifier_old_lifestealer_rage_aura:GetAuraEntityReject(hEntity)
	if hEntity == self:GetParent() then 
		return true 
	else 
		return false 
	end
end

function modifier_old_lifestealer_rage_aura:IsPurgable() return false end
function modifier_old_lifestealer_rage_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_old_lifestealer_rage_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_old_lifestealer_rage_aura:GetModifierAura() return "modifier_old_lifestealer_rage" end
function modifier_old_lifestealer_rage_aura:IsAura() 
	return true 
end

function modifier_old_lifestealer_rage_aura:OnCreated()
	if self:GetParent():HasScepter() then
		self.iParticle = ParticleManager:CreateParticle("particles/old_lifestealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	else
		self.iParticle = ParticleManager:CreateParticle("particles/old_lifestealer_rage_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end
function modifier_old_lifestealer_rage_aura:OnDestroy()
	ParticleManager:DestroyParticle(self.iParticle, false)
end

function modifier_old_lifestealer_rage_aura:GetStatusEffectName() return "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/status_effect_life_stealer_immortal_rage_gold.vpcf" end
function modifier_old_lifestealer_rage_aura:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_old_lifestealer_rage_aura:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage_applied") end
function modifier_old_lifestealer_rage_aura:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end


modifier_old_lifestealer_rage = class({})

function modifier_old_lifestealer_rage:OnCreated()
	self.iParticle = ParticleManager:CreateParticle("particles/old_lifestealer_rage_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end
function modifier_old_lifestealer_rage:OnDestroy()
	ParticleManager:DestroyParticle(self.iParticle, false)
end
function modifier_old_lifestealer_rage:IsPurgable() return false end
function modifier_old_lifestealer_rage:GetStatusEffectName() return "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/status_effect_life_stealer_immortal_rage_gold.vpcf" end
function modifier_old_lifestealer_rage:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_old_lifestealer_rage:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage_applied") end
function modifier_old_lifestealer_rage:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end