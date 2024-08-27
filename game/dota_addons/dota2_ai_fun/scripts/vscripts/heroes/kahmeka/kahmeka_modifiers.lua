modifier_kahmeka_fly = class({})
function modifier_kahmeka_fly:IsPurgable() return false end
function modifier_kahmeka_fly:RemoveOnDeath() return false end
function modifier_kahmeka_fly:CheckState() return {[MODIFIER_STATE_FLYING]=true, [MODIFIER_STATE_DISARMED] = true} end
function modifier_kahmeka_fly:OnCreated() self:StartIntervalThink(FrameTime()) end 
function modifier_kahmeka_fly:OnIntervalThink() 
	if IsClient() then return end
	local hParent = self:GetParent() 
	AddFOWViewer(hParent:GetTeam(), hParent:GetOrigin(), hParent:GetCurrentVisionRange(),FrameTime(), false) 
end
function modifier_kahmeka_fly:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end
function modifier_kahmeka_fly:GetModifierMoveSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor('movespeed_bonus') end
function modifier_kahmeka_fly:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent() 
	local iParticle = ParticleManager:CreateParticle('particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_explosion_second.vpcf', PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticle, 3, hParent:GetOrigin())
	local hAbility = self:GetAbility()
	local iRadius = hAbility:GetSpecialValueFor('divebomb_radius')
	ParticleManager:SetParticleControl(iParticle, 4, Vector(iRadius, iRadius, iRadius))
	hParent:EmitSound('Hero_Gyrocopter.CallDown.Damage')
	local tEnemies = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local tDamageTable = {attacker = hParent, damage = hAbility:GetSpecialValueFor('divebomb_damage'), damage_type = hAbility:GetAbilityDamageType()}
	for i, v in ipairs(tEnemies) do
		tDamageTable.victim  = v
		ApplyDamage(tDamageTable)
	end
end


modifier_kahmeka_wounding_spear=class({})
function modifier_kahmeka_wounding_spear:IsPurgable() return false end
function modifier_kahmeka_wounding_spear:IsHidden() return true end
function modifier_kahmeka_wounding_spear:RemoveOnDeath() return false end
function modifier_kahmeka_wounding_spear:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_kahmeka_wounding_spear:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker or not keys.target:IsHero() or keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() or keys.attacker:IsIllusion() then return end
	keys.target:AddNewModifier(keys.attacker, self:GetAbility(), 'modifier_kahmeka_wounding_spear_debuff', {Duration = (self:GetAbility():GetSpecialValueFor('duration')+CheckTalent(keys.attacker, 'special_bonus_unique_kahmeka_3'))*(1-keys.target:GetStatusResistance())})
	keys.target:EmitSound('Hero_PhantomAssassin.CoupDeGrace')
	local sParticle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local iParticle = ParticleManager:CreateParticle(sParticle, PATTACH_POINT_FOLLOW,keys.target)
	ParticleManager:SetParticleControlForward(iParticle, 1, (keys.attacker:GetOrigin()-keys.target:GetOrigin()):Normalized())
	ParticleManager:SetParticleControl(iParticle, 1, keys.target:GetOrigin())
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.target, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,keys.target:GetAbsOrigin(), true)
end

modifier_kahmeka_wounding_spear_debuff = class({})
function modifier_kahmeka_wounding_spear_debuff:IsPurgable() return false end
function modifier_kahmeka_wounding_spear_debuff:RemoveOnDeath() return true end
function modifier_kahmeka_wounding_spear_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end
function modifier_kahmeka_wounding_spear_debuff:GetModifierBonusStats_Strength() return -self:GetStackCount() end
function modifier_kahmeka_wounding_spear_debuff:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local iCap
	local iLoss
	if hCaster:HasScepter() then
		iCap = hCaster:GetLevel()+hAbility:GetSpecialValueFor('str_loss_cap_increase_per_kill_scepter')*hCaster:GetKills()
		iLoss = hAbility:GetSpecialValueFor('str_loss_scepter')
	else
		iCap = hCaster:GetLevel()
		iLoss = hAbility:GetSpecialValueFor('str_loss')
	end
	self:SetStackCount(self:GetStackCount()+iLoss)
	if self:GetStackCount() > iCap then
		self:SetStackCount(iCap)
	end
	self:GetParent():CalculateStatBonus(true)
end
function modifier_kahmeka_wounding_spear_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_kahmeka_wounding_spear_debuff:GetEffectName() return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_constant.vpcf" end



modifier_kahmeka_wounding_spear_debuff.OnRefresh = modifier_kahmeka_wounding_spear_debuff.OnCreated


modifier_kahmeka_fungwarb=class({})
function modifier_kahmeka_fungwarb:IsPurgable() return false end
function modifier_kahmeka_fungwarb:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, } end
function modifier_kahmeka_fungwarb:OnTooltip() return self:GetAbility():GetSpecialValueFor('reverse') end
function modifier_kahmeka_fungwarb:OnCreated()
	if IsClient() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/kahmeka/ember_ti9_flameguard_shield.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", Vector(0,0,0),true)
end
function modifier_kahmeka_fungwarb:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end


function modifier_kahmeka_fungwarb:GetAbsoluteNoDamagePhysical(keys) 
	if keys.original_damage > 0 then
		keys.target:SetHealth(keys.target:GetHealth()+keys.original_damage*self:GetAbility():GetSpecialValueFor('reverse')/100)
	end
	return 1
end
function modifier_kahmeka_fungwarb:GetAbsoluteNoDamageMagical(keys)
	return 1
end
function modifier_kahmeka_fungwarb:GetAbsoluteNoDamagePure(keys)
	return 1
end

modifier_kahmeka_ignite = class({})
function modifier_kahmeka_ignite:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_kahmeka_ignite:OnTooltip()
	return self.iDamageTooltip
end

function modifier_kahmeka_ignite:GetModifierMoveSpeedBonus_Percentage()
	return self.iMoveSpeedSlow
end

function modifier_kahmeka_ignite:OnCreated()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	self.iDamageTooltip = hAbility:GetSpecialValueFor('damage')
	self.iMoveSpeedSlow = -hAbility:GetSpecialValueFor('slow')
	if IsClient() then return end
	self:StartIntervalThink(0.2*(1-hParent:GetStatusResistance()))

end

function modifier_kahmeka_ignite:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local iDamage = 0.2*(hAbility:GetSpecialValueFor('damage')+CheckTalent(hCaster, 'special_bonus_unique_kahmeka_5'))
	ApplyDamage({
		attacker = hCaster,
		victim = hParent,
		ability = hAbility,
		damage_type = hAbility:GetAbilityDamageType(),
		damage = iDamage
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , hParent, iDamage, nil)	
end

function modifier_kahmeka_ignite:OnDestroy()
	if IsClient() then return end
	CustomNetTables:SetTableValue('client_server', 'unit_modifier_'..tostring(self:GetParent():entindex())..self:GetName(), nil)
end

function modifier_kahmeka_ignite:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_kahmeka_ignite:GetEffectName()
	return 'particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf'
end