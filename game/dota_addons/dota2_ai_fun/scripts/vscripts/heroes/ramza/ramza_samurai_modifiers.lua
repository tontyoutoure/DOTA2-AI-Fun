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
	if keys.target:PassivesDisabled() then return end
	local damageTable = {
		victim = keys.attacker,
		attacker = keys.target,
		damage = keys.target:GetMaxHealth(),
		ability = self:GetAbility(),
		damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage(damageTable)	
end

modifier_ramza_samurai_iaido_masamune = class({})

function modifier_ramza_samurai_iaido_masamune:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end

function modifier_ramza_samurai_iaido_masamune:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)	
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'follow_origin' ,hParent:GetAbsOrigin(), true)
end

function modifier_ramza_samurai_iaido_masamune:GetTexture() return "juggernaut_omni_slash" end
function modifier_ramza_samurai_iaido_masamune:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function modifier_ramza_samurai_iaido_masamune:GetModifierMoveSpeed_Absolute()
	self.iSpeed = self.iSpeed or self:GetAbility():GetSpecialValueFor("fixed_move_speed")
	return self.iSpeed
end

function modifier_ramza_samurai_iaido_masamune:GetModifierAttackSpeedBonus_Constant()
	self.iAttack = self.iAttack or self:GetAbility():GetSpecialValueFor("attack_bonus")
	return self.iAttack
end
modifier_ramza_samurai_doublehand = class({})

function modifier_ramza_samurai_doublehand:IsHidden() return true end
function modifier_ramza_samurai_doublehand:RemoveOnDeath() return false end
function modifier_ramza_samurai_doublehand:IsPurgable() return false end
function modifier_ramza_samurai_doublehand:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_ramza_samurai_doublehand:OnCreated() self:SetStackCount(self:GetAbility():GetSpecialValueFor("damage_bonus")) end
function modifier_ramza_samurai_doublehand:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetParent():PassivesDisabled() then 
		return 0 
	else 
		return self:GetStackCount() 
	end
end

modifier_ramza_samurai_shirahadori = class({})
function modifier_ramza_samurai_shirahadori:IsHidden() return true end
function modifier_ramza_samurai_shirahadori:RemoveOnDeath() return false end
function modifier_ramza_samurai_shirahadori:IsPurgable() return false end
function modifier_ramza_samurai_shirahadori:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_ramza_samurai_shirahadori:OnCreated() if IsClient() then return end self:SetStackCount(self:GetAbility():GetSpecialValueFor("evasion")) end
function modifier_ramza_samurai_shirahadori:GetModifierEvasion_Constant() 
	if self:GetParent():PassivesDisabled() then 
		return 0 
	else 
		return self:GetStackCount() 
	end
end

modifier_ramza_samurai_iaido_chirijiraden = class({})
function modifier_ramza_samurai_iaido_chirijiraden:OnCreated()
	if IsClient() then return end
	self.iDamage = self:GetAbility():GetSpecialValueFor("damage")
	self:StartIntervalThink(0.25*CalculateStatusResist(self:GetParent()))
end
function modifier_ramza_samurai_iaido_chirijiraden:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_ramza_samurai_iaido_chirijiraden:GetModifierMoveSpeedBonus_Percentage()
	local fResist
	if IsClient() then 
		fResist = -self:GetStackCount()/1000
	else
		fResist = CalculateStatusResist(self:GetParent())
		self:SetStackCount(-fResist*1000)
	end
	return -50*fResist
end
function modifier_ramza_samurai_iaido_chirijiraden:OnIntervalThink()
	local hParent=self:GetParent()
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT, 'follow_overhead' ,hParent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,hParent:GetAbsOrigin(), true)
	ApplyDamage({victim = hParent, damage = self.iDamage, damage_type = DAMAGE_TYPE_PURE, attacker = self:GetCaster(), ability = self:GetAbility()})
	hParent:EmitSound("Hero_Juggernaut.Attack")
end
function modifier_ramza_samurai_iaido_chirijiraden:IsPurgable() return false end
function modifier_ramza_samurai_iaido_chirijiraden:GetStatusEffectName() return "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf" end
function modifier_ramza_samurai_iaido_chirijiraden:GetTexture() return	"juggernaut_blade_fury_arcana_style1" end

modifier_ramza_samurai_iaido_kikuichimonji=class({})
function modifier_ramza_samurai_iaido_kikuichimonji:GetStatusEffectName() return "particles/status_fx/status_effect_templar_slow.vpcf" end
function modifier_ramza_samurai_iaido_kikuichimonji:GetTexture() return	"juggernaut_blade_fury" end
function modifier_ramza_samurai_iaido_kikuichimonji:OnCreated()
	if IsClient() then return end
	self.iDamage = self:GetAbility():GetSpecialValueFor("damage")
	self:StartIntervalThink(1*CalculateStatusResist(self:GetParent()))
end
function modifier_ramza_samurai_iaido_kikuichimonji:OnIntervalThink()
	local hParent=self:GetParent()
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT, 'follow_overhead' ,hParent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,hParent:GetAbsOrigin(), true)
	ApplyDamage({victim = hParent, damage = self.iDamage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetCaster(), ability = self:GetAbility()})
	hParent:EmitSound("Hero_Juggernaut.OmniSlash")
end