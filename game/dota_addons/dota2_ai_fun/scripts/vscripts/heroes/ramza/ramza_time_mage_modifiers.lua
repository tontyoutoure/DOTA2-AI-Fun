modifier_ramza_time_mage_time_magicks_gravity = class({})

function modifier_ramza_time_mage_time_magicks_gravity:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end


function modifier_ramza_time_mage_time_magicks_gravity:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vHorizontalSpeed)
end

function modifier_ramza_time_mage_time_magicks_gravity:UpdateVerticalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vVerticalSpeed)
end

function modifier_ramza_time_mage_time_magicks_gravity:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_ramza_time_mage_time_magicks_gravity:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_ramza_time_mage_time_magicks_gravity:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end
function modifier_ramza_time_mage_time_magicks_gravity:OnDestroy()
	if IsClient() then return end
	hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	ApplyDamage({
		damage = hParent:GetHealth()*self.fHealthPercentage/100,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
		attacker = self:GetCaster(),
		victim = hParent		
	})
end

modifier_ramza_time_mage_mana_shield = class({})

function modifier_ramza_time_mage_mana_shield:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_ramza_time_mage_mana_shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ramza_time_mage_mana_shield:GetEffectName() return "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf" end

function modifier_ramza_time_mage_mana_shield:IsDebuff() return false end

function modifier_ramza_time_mage_mana_shield:IsPurgable() return false end

function modifier_ramza_time_mage_mana_shield:RemoveOnDeath() return false end

function modifier_ramza_time_mage_mana_shield:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	if keys.unit:GetMana() > keys.original_damage then
		keys.unit:SpendMana(keys.original_damage,self:GetAbility())
		keys.unit:SetHealth(keys.unit:GetHealth()+keys.damage)
	else
		keys.unit:SpendMana(keys.original_damage,self:GetAbility())
		keys.unit:SetHealth(keys.unit:GetHealth()+keys.damage*keys.unit:GetMana()/keys.original_damage)
	end
	keys.unit:EmitSound('Hero_Medusa.ManaShield.Proc')
	ParticleManager:CreateParticle('particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.unit)
end

modifier_ramza_time_mage_time_magicks_slow = class({})
function modifier_ramza_time_mage_time_magicks_slow:GetTexture() return "skywrath_mage_concussive_shot" end
function modifier_ramza_time_mage_time_magicks_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ramza_time_mage_time_magicks_slow:GetEffectName() return "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_slow_debuff.vpcf" end
function modifier_ramza_time_mage_time_magicks_slow:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_ramza_time_mage_time_magicks_slow:GetModifierAttackSpeedBonus_Constant() 
	return -50
end

function modifier_ramza_time_mage_time_magicks_slow:GetModifierMoveSpeedBonus_Percentage()
	return -50
end