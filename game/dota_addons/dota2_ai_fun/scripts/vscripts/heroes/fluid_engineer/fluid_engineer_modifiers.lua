modifier_fluid_engineer_salad_lunch = class({})

function modifier_fluid_engineer_salad_lunch:IsPurgable() return false end

function modifier_fluid_engineer_salad_lunch:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_fluid_engineer_salad_lunch:GetModifierBonusStats_Intellect()
	
	if not self.hSpecial then 
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_fluid_engineer_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
	end
	return self:GetStackCount()*(self:GetAbility():GetSpecialValueFor("int_per_stack")+self.hSpecial:GetSpecialValueFor("value"))
end

modifier_fluid_engineer_bowel_hydraulics = class({})

function modifier_fluid_engineer_bowel_hydraulics:IsPurgable() return false end
function modifier_fluid_engineer_bowel_hydraulics:IsPurgeException() return false end
function modifier_fluid_engineer_bowel_hydraulics:IsDebuff() return true end
function modifier_fluid_engineer_bowel_hydraulics:GetTexture() return "pudge_rot" end

function modifier_fluid_engineer_bowel_hydraulics:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_fluid_engineer_bowel_hydraulics:GetModifierMoveSpeed_Max()
	self.iSpeed = self.iSpeed or self:GetAbility():GetSpecialValueFor("speed")
	return self.iSpeed
end

function modifier_fluid_engineer_bowel_hydraulics:GetModifierMoveSpeed_Limit()
	self.iSpeed = self.iSpeed or self:GetAbility():GetSpecialValueFor("speed")
	return self.iSpeed
end

function modifier_fluid_engineer_bowel_hydraulics:GetModifierMoveSpeed_Absolute()
	self.iSpeed = self.iSpeed or self:GetAbility():GetSpecialValueFor("speed")
	return self.iSpeed
end

function modifier_fluid_engineer_bowel_hydraulics:OnCreated()
	self.iDOTRadius = self:GetAbility():GetSpecialValueFor("dot_radius")
	self.iExplosionRadius = self:GetAbility():GetSpecialValueFor("explosion_radius")
	self:StartIntervalThink(1)
end

function modifier_fluid_engineer_bowel_hydraulics:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if hParent:FindModifierByName("modifier_fountain_aura_buff") then self:Destroy() end

	local tUnits = FindUnitsInRadius(hCaster:GetOwner():GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.iDOTRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = hCaster,
		damage_type = DAMAGE_TYPE_PURE,
		damage = self.fDoT,
		ability = self:GetAbility(),
	}
	for i = 1, #tUnits do
		if tUnits[i] ~= hParent then
			damageTable.victim = tUnits[i]
			ApplyDamage(damageTable)
			local info = {
					Target = tUnits[i],
					Source = hParent,
					Ability = self:GetAbility(),	
					EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
					iMoveSpeed = 4000,
			}
			ProjectileManager:CreateTrackingProjectile(info)
			tUnits[i]:EmitSound("Ability.GushImpact")
		end
	end
	hParent:EmitSound("Ability.GushCast")
	self:DecrementStackCount()
end

function modifier_fluid_engineer_bowel_hydraulics:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if hParent:FindModifierByName("modifier_fountain_aura_buff") then return end
	local tUnits = FindUnitsInRadius(hCaster:GetOwner():GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.iExplosionRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = hCaster,
		damage_type = DAMAGE_TYPE_PURE,
		damage = self.fDamage,
		ability = self:GetAbility(),
	}
	for i = 1, #tUnits do
		damageTable.victim = tUnits[i]
		ApplyDamage(damageTable)
		tUnits[i]:EmitSound("Ability.Torrent")
		ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_ABSORIGIN, tUnits[i])
	end
end

modifier_fluid_engineer_malicious_tampering_aura = class({})

function modifier_fluid_engineer_malicious_tampering_aura:CheckState()
	return {
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
end

function modifier_fluid_engineer_malicious_tampering_aura:OnCreated()
	if IsClient() then return end
	self:GetParent():SetRenderColor(0, 255, 0)
end

function modifier_fluid_engineer_malicious_tampering_aura:OnDestroy()
	if IsClient() then return end
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS then 
		self:GetParent():SetRenderColor(255, 255, 255)
	else		
		self:GetParent():SetRenderColor(60, 60, 60)
	end
end

function modifier_fluid_engineer_malicious_tampering_aura:IsDebuff() return true end

function modifier_fluid_engineer_malicious_tampering_aura:IsAura() return true end

function modifier_fluid_engineer_malicious_tampering_aura:GetAuraDuration() return self:GetAbility():GetSpecialValueFor("linger_time") end

function modifier_fluid_engineer_malicious_tampering_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end

function modifier_fluid_engineer_malicious_tampering_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_fluid_engineer_malicious_tampering_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_fluid_engineer_malicious_tampering_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_fluid_engineer_malicious_tampering_aura:GetModifierAura() return "modifier_fluid_engineer_malicious_tampering" end


modifier_fluid_engineer_malicious_tampering = class({})

function modifier_fluid_engineer_malicious_tampering:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_fluid_engineer_malicious_tampering:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("mana_constant")-self:GetAbility():GetCaster():GetIntellect() end

function modifier_fluid_engineer_malicious_tampering:GetModifierTotalPercentageManaRegen() return self:GetAbility():GetSpecialValueFor("mana_percent") end

function modifier_fluid_engineer_malicious_tampering:GetModifierHealthRegenPercentage() return self:GetAbility():GetSpecialValueFor("health_percent") end
	
function modifier_fluid_engineer_malicious_tampering:GetModifierConstantHealthRegen() return -self:GetAbility():GetCaster():GetIntellect() end

function modifier_fluid_engineer_malicious_tampering:IsDebuff() return true end

function modifier_fluid_engineer_malicious_tampering:IsPurgable() return false end

function modifier_fluid_engineer_malicious_tampering:IsPurgeException() return false end














