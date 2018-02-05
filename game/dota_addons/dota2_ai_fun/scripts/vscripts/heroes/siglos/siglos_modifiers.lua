modifier_siglos_disadvantage_silence = class({})
function modifier_siglos_disadvantage_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_siglos_disadvantage_silence:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/siglos/siglos_disadvantage_silence.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, 'follow_origin', hParent:GetOrigin(), true)
end
function modifier_siglos_disadvantage_silence:OnDestroy() 
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)	
end

function modifier_siglos_disadvantage_silence:IsPurgable()
	local hSpecial = self:GetCaster():FindAbilityByName("special_bonus_unique_siglos_2")
	if hSpecial and hSpecial:GetLevel() > 0 then
		return false
	else
		return true
	end
end

modifier_siglos_disadvantage_disarm = class({})
function modifier_siglos_disadvantage_disarm:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
function modifier_siglos_disadvantage_disarm:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/siglos/siglos_disadvantage_disarm.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, 'follow_origin', hParent:GetOrigin(), true)
end
function modifier_siglos_disadvantage_disarm:OnDestroy() 
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)	
end

function modifier_siglos_disadvantage_disarm:IsPurgable()
	local hSpecial = self:GetCaster():FindAbilityByName("special_bonus_unique_siglos_2")
	if hSpecial and hSpecial:GetLevel() > 0 then
		return false
	else
		return true
	end
end

modifier_siglos_reflect = class({})
function modifier_siglos_reflect:IsPurgable() return true end
function modifier_siglos_reflect:OnCreated()
	if IsClient() then return end	
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/siglos/siglos_reflect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
end
function modifier_siglos_reflect:OnDestroy()	
	if IsClient() then return end	
	ParticleManager:DestroyParticle(self.iParticle, false)
end
function modifier_siglos_reflect:DeclareFunctions() return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, MODIFIER_PROPERTY_TOOLTIP} end
function modifier_siglos_reflect:OnTooltip()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_siglos_4" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial then 
		return self:GetAbility():GetSpecialValueFor("percentage_damage")+self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetAbility():GetSpecialValueFor("percentage_damage")
	end
end
function modifier_siglos_reflect:GetAbsoluteNoDamagePhysical(keys) 
	if not keys.attacker or not keys.target or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) > 0 then return 1 end
	local iDamagePercentage = self:GetAbility():GetSpecialValueFor("percentage_damage")
	if keys.target:HasAbility("special_bonus_unique_siglos_4") then 
		iDamagePercentage = iDamagePercentage+keys.target:FindAbilityByName("special_bonus_unique_siglos_4"):GetSpecialValueFor("value")
	end
	ApplyDamage({attacker = keys.target, damage = keys.original_damage*iDamagePercentage/100, damage_type = keys.damage_type, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, victim = keys.attacker, ability = self:GetAbility()})
	
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_dispersion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
	return 1
end
function modifier_siglos_reflect:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_siglos_reflect:GetAbsoluteNoDamagePure()
	return 1
end

modifier_siglos_disruption_aura = class({})
function modifier_siglos_disruption_aura:IsAura() return true end
function modifier_siglos_disruption_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_siglos_disruption_aura:GetModifierAura() return "modifier_siglos_disruption_aura_target" end
function modifier_siglos_disruption_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_siglos_disruption_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_siglos_disruption_aura:IsHidden() return true end
function modifier_siglos_disruption_aura:RemoveOnDeath() return false end
function modifier_siglos_disruption_aura:IsPurgable() return false end
modifier_siglos_disruption_aura_target = class({})
function modifier_siglos_disruption_aura_target:IsHidden() return false end
function modifier_siglos_disruption_aura_target:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_siglos_disruption_aura_target:OnTooltip() 
	print(IsClient())
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_siglos_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial then 
		return self:GetAbility():GetSpecialValueFor("disruption_range")+self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetAbility():GetSpecialValueFor("disruption_range")
	end
end
modifier_siglos_mind_control = class({})
function modifier_siglos_mind_control:OnCreated() 
	if IsClient() then return end 
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.iOwnerID = hParent:GetPlayerOwnerID()
	self.iTeam = hParent:GetTeam()
	hParent:SetControllableByPlayer(self.iOwnerID, false)
	hParent:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	hParent:SetTeam(hCaster:GetTeam())
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_new_arc_blade_golden.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
end
function modifier_siglos_mind_control:OnDestroy()
	if IsClient() then return end 
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hParent:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	hParent:SetControllableByPlayer(self.iOwnerID, true)
	hParent:SetTeam(self.iTeam)
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function modifier_siglos_mind_control:DeclareFunctions() return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE} end
function modifier_siglos_mind_control:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_siglos_mind_control:GetAbsoluteNoDamageMagical() return 1 end
function modifier_siglos_mind_control:GetAbsoluteNoDamagePure() return 1 end


modifier_siglos_mind_control_magic_immune = class({})
function modifier_siglos_mind_control_magic_immune:OnDestroy() if IsClient() then return end ParticleManager:DestroyParticle(self.iParticle, false) end
function modifier_siglos_mind_control_magic_immune:IsPurgable() return false end
function modifier_siglos_mind_control_magic_immune:IsHidden() return true end
function modifier_siglos_mind_control_magic_immune:OnCreated() if IsClient() then return end self.iParticle = ParticleManager:CreateParticle("particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) end
function modifier_siglos_mind_control_magic_immune:OnDestroy() if IsClient() then return end ParticleManager:DestroyParticle(self.iParticle, false) end
function modifier_siglos_mind_control_magic_immune:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE]=true} end
function modifier_siglos_mind_control_magic_immune:GetStatusEffectName() return "particles/status_fx/status_effect_avatar.vpcf" end
