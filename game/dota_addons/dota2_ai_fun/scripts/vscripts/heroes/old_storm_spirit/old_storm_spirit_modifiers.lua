modifier_old_storm_spirit_electric_rave = class({
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return false end,
	RemoveOnDeath = function(self) return true end,
})

local function FindTalent(hObject, sTalentName, i)
	local sSpecialHandleName = 'hSpecial'
	if i then
		sSpecialHandleName = sSpecialHandleName..tostring(i)
	end
	if not hObject[sSpecialHandleName] then
		hObject[sSpecialHandleName] = Entities:First()
		
		while hObject[sSpecialHandleName] and (hObject[sSpecialHandleName]:GetName() ~= sTalentName or hObject[sSpecialHandleName]:GetCaster() ~= hObject:GetCaster()) do
			hObject[sSpecialHandleName] = Entities:Next(hObject[sSpecialHandleName])
		end		
	end
end

function modifier_old_storm_spirit_electric_rave:OnCreated()
	self:StartIntervalThink(1)
	FindTalent(self, 'special_bonus_unique_old_storm_spirit_4')
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
	if CheckTalent(hParent, 'special_bonus_unique_old_storm_spirit_4') > 0 then
		fMana = fMana*CheckTalent(hParent, 'special_bonus_unique_old_storm_spirit_4')
	end
	self:GetParent():ReduceMana(fMana)
	if hParent:GetMana() == 0 then
		self:GetAbility():SetActivated(true)
		self:GetAbility():ToggleAbility()
	end
end

function modifier_old_storm_spirit_electric_rave:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_old_storm_spirit_electric_rave:GetModifierAttackSpeedBonus_Constant()
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then
		return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')*self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
	end
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
	local fDamage = hAbility:GetSpecialValueFor('bonus_damage')+CheckTalent(keys.attacker, 'special_bonus_unique_old_storm_spirit_2')
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
function modifier_old_storm_spirit_barrier:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end
function modifier_old_storm_spirit_barrier:OnCreated(keys)
	self.fDamageAbsorption = keys.fDamageAbsorption
end

function modifier_old_storm_spirit_barrier:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() or keys.damage_type ~= DAMAGE_TYPE_MAGICAL then return end
	hParent = self:GetParent()
	if self.fDamageAbsorption > keys.damage then
		hParent:SetHealth(self.OrigianHealth-self.fDamageAlreadyAbsorbed+self.fDamageAbsorb)
		self:Destroy()
	else
		hParent:SetHealth(self.OrigianHealth)
	end
end

modifier_old_storm_spirit_barrier_passive = class({})