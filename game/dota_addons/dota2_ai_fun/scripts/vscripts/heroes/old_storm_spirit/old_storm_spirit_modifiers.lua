modifier_old_storm_spirit_electric_rave = class({
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return false end,
	RemoveOnDeath = function(self) return true end,
})

function modifier_old_storm_spirit_electric_rave:OnCreated()
	self:StartIntervalThink(1)
	if IsServer() then
		self.iParticle = ParticleManager:CreateParticle("particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.iParticle, 2, Vector(0,151,206))
		ParticleManager:SetParticleControl(self.iParticle, 15, Vector(0,151,206))
		ParticleManager:SetParticleControl(self.iParticle, 16, Vector(1,0,0))
	end
end
function modifier_old_storm_spirit_electric_rave:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function modifier_old_storm_spirit_electric_rave:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local fMana = self:GetAbility():GetSpecialValueFor('manacost_per_second')
	self:GetParent():SpendMana(fMana, self:GetAbility())
	if hParent:GetMana() == 0 then
		self:GetAbility():SetActivated(true)
		self:GetAbility():ToggleAbility()
	end
end

function modifier_old_storm_spirit_electric_rave:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_old_storm_spirit_electric_rave:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end

modifier_old_storm_spirit_overload = class({
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return false end,
	RemoveOnDeath = function(self) return true end,
})

function modifier_old_storm_spirit_overload:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_TOOLTIP}
end
function modifier_old_storm_spirit_overload:OnTooltip()
	return self:GetStackCount()
end
function modifier_old_storm_spirit_overload:OnCreated()
	self:SetStackCount(self:GetAbility():GetSpecialValueFor('attack_needed'))
end
function modifier_old_storm_spirit_overload:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker or keys.target:IsBuilding() or keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() then return end
	local hAbility = self:GetAbility()
	local iRadius = hAbility:GetSpecialValueFor('radius')
	local fDamage = hAbility:GetSpecialValueFor('bonus_damage')
	local fSlowDuration = hAbility:GetSpecialValueFor('slow_duration')
	
	if self:GetStackCount() == 0 then
		local iTalented = CheckTalent(keys.attacker, 'special_bonus_unique_old_storm_spirit_5')
		if not keys.target:IsMagicImmune() or iTalented > 0 then
			local tTargets = FindUnitsInRadius(keys.attacker:GetTeam(), keys.target:GetAbsOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE+iTalented*DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local tDamageTable = {attacker = keys.attacker, damage = fDamage, damage_type = hAbility:GetAbilityDamageType(), ability = hAbility}
			local sModifier = 'modifier_old_storm_spirit_overload_slow'
			if iTalented > 0 then 
				tDamageTable.damage_type = DAMAGE_TYPE_PURE
				sModifier = 'modifier_bashed'
			end
			for k, v in pairs(tTargets) do
				tDamageTable.victim = v
				ApplyDamage(tDamageTable)
				v:AddNewModifier(keys.attacker, hAbility, sModifier, {Duration = (1-v:GetStatusResistance())*fSlowDuration})
			end
			ParticleManager:CreateParticle('particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.target)
			keys.target:EmitSound('Hero_StormSpirit.Overload')
			ParticleManager:DestroyParticle(self.iParticle, true)
			self:SetStackCount(hAbility:GetSpecialValueFor('attack_needed')-1)
		end
		return
	end
	self:DecrementStackCount()
	
	if self:GetStackCount() == 0 then
		self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)		
		ParticleManager:SetParticleControlEnt(self.iParticle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
	end
end


modifier_old_storm_spirit_overload_slow = class({})
function modifier_old_storm_spirit_overload_slow:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_old_storm_spirit_overload_slow:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_old_storm_spirit_overload_slow:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor('attack_speed_slow') end
function modifier_old_storm_spirit_overload_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor('move_speed_slow_pct') end

modifier_old_storm_spirit_barrier = class({})
function modifier_old_storm_spirit_barrier:IsPurgable() return true end
function modifier_old_storm_spirit_barrier:OnCreated() 
	if IsServer() then
		self.iParticle = ParticleManager:CreateParticle('particles/old_storm_spirit/ember_ti9_flameguard_shield.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.iParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", Vector(0,0,0), true)
		self.shield = self:GetAbility():GetSpecialValueFor('damage_absorption')
		self:SetHasCustomTransmitterData(true)
	end
	self:StartIntervalThink(FrameTime())
end

function modifier_old_storm_spirit_barrier:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function modifier_old_storm_spirit_barrier:OnRefresh()
	if IsServer() then
		self.shield = self:GetAbility():GetSpecialValueFor('damage_absorption')
	end
	self:StartIntervalThink(FrameTime())
end

function modifier_old_storm_spirit_barrier:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_old_storm_spirit_barrier:OnTooltip() 
	return self.shield
end

function modifier_old_storm_spirit_barrier:AddCustomTransmitterData()
    return {
        shield = self.shield,
    }
end

function modifier_old_storm_spirit_barrier:HandleCustomTransmitterData( data )
	-- print(self.shield)
    self.shield = data.shield
end

function modifier_old_storm_spirit_barrier:OnIntervalThink()
	if IsClient() then return end
    self:SendBuffRefreshToClients()
end

function modifier_old_storm_spirit_barrier:GetModifierIncomingSpellDamageConstant(keys) 
	if not IsServer() then 
		return self.shield 
	end
	if keys.damage_type == DAMAGE_TYPE_MAGICAL then
		if keys.damage < self.shield then
			self.shield = self.shield - keys.damage
			return -keys.damage
		else
			shield_left = self.shield
			self:Destroy()
			return -shield_left
		end
	end
end 

modifier_old_storm_spirit_barrier_passive = class({})
function modifier_old_storm_spirit_barrier_passive:IsPurgable() return false end
function modifier_old_storm_spirit_barrier_passive:RemoveOnDeath() return false end
function modifier_old_storm_spirit_barrier_passive:IsHidden() return not self:GetParent():HasScepter() end
function modifier_old_storm_spirit_barrier_passive:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT, MODIFIER_PROPERTY_TOOLTIP} end
function modifier_old_storm_spirit_barrier_passive:OnCreated()
	self:StartIntervalThink(0.1)
	self.shield = 0
	self:SetHasCustomTransmitterData(true)
end
function modifier_old_storm_spirit_barrier_passive:AddCustomTransmitterData()
    return {
        shield = self.shield,
    }
end

function modifier_old_storm_spirit_barrier_passive:HandleCustomTransmitterData( data )
	-- print(self.shield)
    self.shield = data.shield
end
function modifier_old_storm_spirit_barrier_passive:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local fMaxAbsorption = hAbility:GetSpecialValueFor('damage_absorption')
	
	if hParent:HasScepter() then
		self.shield = self.shield + hAbility:GetSpecialValueFor('restore_scepter')*0.1
		if self.shield > fMaxAbsorption then
			self.shield = fMaxAbsorption
		end
		self:SendBuffRefreshToClients()
		if not self.iParticle then
			self.iParticle = ParticleManager:CreateParticle('particles/old_storm_spirit/barrier_passive.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.iParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", Vector(0,0,0), true)
		end
	else
		self.shield = 0
		if self.iParticle then
			ParticleManager:DestroyParticle(self.iParticle, true)
		end
		self:SendBuffRefreshToClients()
		self.iParticle = nil
	end
end

function modifier_old_storm_spirit_barrier_passive:OnTooltip()
	return self.shield 
end

function modifier_old_storm_spirit_barrier_passive:GetModifierIncomingDamageConstant(keys)
	if not IsServer() then 
		return self.shield 
	end
	
	if keys.damage < self.shield then
		self.shield = self.shield - keys.damage
		return -keys.damage
	else
		shield_left = self.shield
		self.shield = 0
		return -shield_left
	end

end
modifier_old_storm_spirit_lightning_grapple = class({})
function modifier_old_storm_spirit_lightning_grapple:IsPurgable() return false end
function modifier_old_storm_spirit_lightning_grapple:IsHidden() return false end
function modifier_old_storm_spirit_lightning_grapple:RemoveOnDeath() return true end
function modifier_old_storm_spirit_lightning_grapple:OnCreated(keys)
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self:ApplyHorizontalMotionController()
	if hParent == hCaster then
		hCaster:EmitSound('Hero_StormSpirit.BallLightning.Loop')
		self.iParticle = ParticleManager:CreateParticle('particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'attach_origin', Vector(0,0,0),true)
		ParticleManager:SetParticleControlEnt(self.iParticle, 0, hParent, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
	else
		self.iParticle = ParticleManager:CreateParticle('particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(self.iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, 'attach_attack1', Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0), true)
	end
end

function modifier_old_storm_spirit_lightning_grapple:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	hParent:SetOrigin(self.vDestination)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	ParticleManager:DestroyParticle(self.iParticle, true)
	if hParent == self:GetCaster() then
		self:GetCaster():StopSound('Hero_StormSpirit.BallLightning.Loop')
	end
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(),300,true)
end



function modifier_old_storm_spirit_lightning_grapple:UpdateHorizontalMotion(me, dt)
	if (self.vDestination-me:GetOrigin()):Length2D() < dt*self.vHorizantalSpeed:Length2D() then 
		self:Destroy()
	end
	me:SetOrigin(me:GetOrigin()+dt*self.vHorizantalSpeed)
end
function modifier_old_storm_spirit_lightning_grapple:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_old_storm_spirit_lightning_grapple:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_INVULNERABLE] = true} end
function modifier_old_storm_spirit_lightning_grapple:GetOverrideAnimation()
	if self:GetParent() == self:GetCaster() then
		return ACT_DOTA_OVERRIDE_ABILITY_4
	else
		return ACT_DOTA_FLAIL
	end
end















