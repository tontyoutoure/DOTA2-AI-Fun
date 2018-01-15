modifier_ramza_squire_counter_tackle = class({})

function modifier_ramza_squire_counter_tackle:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_ramza_squire_counter_tackle:RemoveOnDeath() return false end
function modifier_ramza_squire_counter_tackle:IsHidden() return true end
function modifier_ramza_squire_counter_tackle:OnCreated()
	if IsClient() then return end
	self.iDamageReturn = self.iDamageReturn or self:GetAbility():GetSpecialValueFor("damage_return")
end
function modifier_ramza_squire_counter_tackle:OnAttackLanded(keys)
	if keys.target ~= self:GetParent() or keys.attacker:IsRangedAttacker() or keys.target:PassivesDisabled() then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local damageTable = {
		damage = keys.original_damage*self.iDamageReturn/100,
		attacker = keys.target,
		victim = keys.attacker,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = hAbility
	}
	ApplyDamage(damageTable)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_POINT_FOLLOW, keys.attacker)
	ParticleManager:SetParticleControlEnt(particle, 1, keys.target, PATTACH_POINT_FOLLOW, "follow_hitloc", keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "follow_hitloc", keys.attacker:GetAbsOrigin(), true)
end

modifier_ramza_squire_fundamental_rush = class({})

function modifier_ramza_squire_fundamental_rush:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end


function modifier_ramza_squire_fundamental_rush:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vSpeed)
end

function modifier_ramza_squire_fundamental_rush:UpdateVerticalMotion(me, dt)
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), me))
end

function modifier_ramza_squire_fundamental_rush:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_ramza_squire_fundamental_rush:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function modifier_ramza_squire_fundamental_rush:GetEffectName() return "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_target.vpcf" end

function modifier_ramza_squire_fundamental_rush:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end

function modifier_ramza_squire_fundamental_rush:OnDestroy()
	if IsClient() then return end
	hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
end

modifier_ramza_squire_move1 = class({})

function modifier_ramza_squire_move1:IsHidden() return true end
function modifier_ramza_squire_move1:RemoveOnDeath() return false end
function modifier_ramza_squire_move1:IsPurgable() return false end

function modifier_ramza_squire_move1:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_ramza_squire_move1:OnCreated() 
	if IsClient() then return end
	self:SetStackCount(-self:GetAbility():GetSpecialValueFor("bonus_speed")) end
function modifier_ramza_squire_move1:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():PassivesDisabled() then return 0 else return -self:GetStackCount() end
end






