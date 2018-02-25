modifier_flame_lord_enflame = class({})
function modifier_flame_lord_enflame:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_flame_lord_enflame:IsPurgable() return false end
function modifier_flame_lord_enflame:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if hCaster:HasScepter() then
		self.iRadius = hAbility:GetSpecialValueFor("radius_scepter")
		self.iDamage = hAbility:GetSpecialValueFor("damage_scepter")/10
		self.iParticle0 = ParticleManager:CreateParticle("particles/flame_lord/enflame_ring_large.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self.iParticle = ParticleManager:CreateParticle("particles/flame_lord/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
		ParticleManager:SetParticleControl(self.iParticle, 2, Vector(self.iRadius, 0, 0))
		ParticleManager:SetParticleControl(self.iParticle, 3, Vector(850, 0, 0))
	else
		self.iRadius = hAbility:GetSpecialValueFor("radius")
		self.iDamage = hAbility:GetSpecialValueFor("damage")/10
		self.iParticle0 = ParticleManager:CreateParticle("particles/flame_lord/enflame_ring_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self.iParticle = ParticleManager:CreateParticle("particles/flame_lord/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
		ParticleManager:SetParticleControl(self.iParticle, 2, Vector(self.iRadius, 0, 0))
		ParticleManager:SetParticleControl(self.iParticle, 3, Vector(450, 0, 0))
	end
	self.iDamageType = hAbility:GetAbilityDamageType()
	self:StartIntervalThink(0.1)
	hParent:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
	hParent:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
end

function modifier_flame_lord_enflame:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)
	ParticleManager:DestroyParticle(self.iParticle0, false)
	self:GetParent():StopSound("Hero_EmberSpirit.FlameGuard.Loop")
end

function modifier_flame_lord_enflame:OnIntervalThink()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k, v in ipairs(tTargets) do
		if v ~= hParent then 
			ApplyDamage({victim = v, attacker = hCaster, damage = self.iDamage, damage_type = self.iDamageType, ability = self:GetAbility()})
		end
	end	
end

modifier_flame_lord_liquid_fire_debuff = class({})
function modifier_flame_lord_liquid_fire_debuff:GetEffectName() return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf" end
function modifier_flame_lord_liquid_fire_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_flame_lord_liquid_fire_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_TOOLTIP} end
function modifier_flame_lord_liquid_fire_debuff:OnTooltip() return self.fDamage end
function modifier_flame_lord_liquid_fire_debuff:GetModifierMoveSpeedBonus_Percentage()	
	local fResist
	if IsClient() then 
		fResist = -self:GetStackCount()/1000
	else
		fResist = CalculateStatusResist(self:GetParent())
		self:SetStackCount(-fResist*1000)
	end
	return fResist*self.fSlow
end

function modifier_flame_lord_liquid_fire_debuff:OnRefresh()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:EmitSound("Hero_Jakiro.LiquidFire")
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
end

function modifier_flame_lord_liquid_fire_debuff:OnCreated()
	self.fDamage = self:GetAbility():GetSpecialValueFor("damage")
	self.fSlow = self:GetAbility():GetSpecialValueFor("move_slow")
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:EmitSound("Hero_Jakiro.LiquidFire")
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	self:StartIntervalThink(CalculateStatusResist(self:GetParent()))
end 

function modifier_flame_lord_liquid_fire_debuff:OnIntervalThink()
	if IsClient() then return end	
	local hAbility = self:GetAbility()
	ApplyDamage({damage = self.fDamage, damage_type = hAbility:GetAbilityDamageType(), ability = hAbility, attacker = self:GetCaster(), victim = self:GetParent()})
end


modifier_flame_lord_fire_storm_debuff = class({})
function modifier_flame_lord_fire_storm_debuff:GetEffectName() return "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf" end
function modifier_flame_lord_fire_storm_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_flame_lord_fire_storm_debuff:OnCreated()
	self.fDamage = self:GetAbility():GetSpecialValueFor("burn_damage")
	if IsClient() then return end
	self:StartIntervalThink(CalculateStatusResist(self:GetParent()))
end

function modifier_flame_lord_fire_storm_debuff:OnIntervalThink()
	if IsClient() then return end	
	local hAbility = self:GetAbility()
	ApplyDamage({damage = self.fDamage, damage_type = hAbility:GetAbilityDamageType(), ability = hAbility, attacker = self:GetCaster(), victim = self:GetParent()})
end
function modifier_flame_lord_fire_storm_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_flame_lord_fire_storm_debuff:OnTooltip() return self.fDamage end