

LinkLuaModifier("modifier_invoker_retro_incinerate_exort_level", "heroes/hero_invoker/invoker_retro_incinerate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_incinerate_channeling", "heroes/hero_invoker/invoker_retro_incinerate.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_incinerate_exort_level = class({})
function modifier_invoker_retro_incinerate_exort_level:IsHidden() return true end
function modifier_invoker_retro_incinerate_exort_level:IsPurgable() return false end
function modifier_invoker_retro_incinerate_exort_level:RemoveOnDeath() return false end
function modifier_invoker_retro_incinerate_exort_level:OnCreated()
	self:StartIntervalThink(0.04)
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iExortLevel+1)
		else
			self:SetStackCount(hParent.iExortLevel)
		end
	end
end
function modifier_invoker_retro_incinerate_exort_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iExortLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iExortLevel+1)
		else
			self:SetStackCount(hParent.iExortLevel)
		end
	end
end

invoker_retro_incinerate = class({})
function invoker_retro_incinerate:GetChannelAnimation() return ACT_DOTA_GENERIC_CHANNEL_1 end
function invoker_retro_incinerate:GetIntrinsicModifierName() return 'modifier_invoker_retro_incinerate_exort_level' end
function invoker_retro_incinerate:GetCastRange() return self.hModifier:GetStackCount()*self:GetSpecialValueFor('cast_range_level_exort') end
function invoker_retro_incinerate:GetAOERadius() return self.hModifier:GetStackCount()*self:GetSpecialValueFor('wave_radius_level_exort') end
function invoker_retro_incinerate:GetChannelTime() return self.hModifier:GetStackCount()*self:GetSpecialValueFor('channel_time_level_exort')+0.05 end


function invoker_retro_incinerate:OnSpellStart()
	local keys = {caster = self:GetCaster(), ability = self}
	
	--Create a dummy unit at the spawn point.
	local incinerate_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_incinerate_unit", self:GetCursorPosition(), false, nil, nil, keys.caster:GetTeam())
	local dummy_unit_ability = incinerate_dummy_unit:FindAbilityByName("dummy_unit_passive")
	if dummy_unit_ability ~= nil then
		dummy_unit_ability:SetLevel(1)
	end
	
	keys.caster.incinerate_current_dummy_unit = incinerate_dummy_unit  --Store a reference to the current Incinerate dummy unit.  This is removed when Invoker stops channeling.
	incinerate_dummy_unit.iExortLevel = self.hModifier:GetStackCount()  --Store the current Exort level.  This helps when Invoker levels up Exort while channeling.
	

	incinerate_dummy_unit:EmitSound("Hero_Warlock.Upheaval")
	
	incinerate_dummy_unit:AddNewModifier(keys.caster, self, "modifier_invoker_retro_incinerate_channeling", {})
end


function invoker_retro_incinerate:OnChannelFinish()
	local keys = {caster = self:GetCaster()}
	if keys.caster.incinerate_current_dummy_unit ~= nil then
		local incinerate_dummy_unit = keys.caster.incinerate_current_dummy_unit
		incinerate_dummy_unit:SetDayTimeVisionRange(0)
		incinerate_dummy_unit:SetNightTimeVisionRange(0)

		incinerate_dummy_unit:StopSound("Hero_Warlock.Upheaval")
		incinerate_dummy_unit:RemoveSelf()
		
		keys.caster.incinerate_current_dummy_unit = nil

	end
end

modifier_invoker_retro_incinerate_channeling = class({})
function modifier_invoker_retro_incinerate_channeling:IsPurgable() return false end
function modifier_invoker_retro_incinerate_channeling:OnCreated()
	if IsClient() then return end
local hParent = self:GetParent()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor('delay_between_waves'))
	self.fDamage = self:GetAbility():GetSpecialValueFor("damage_per_wave")
	self.fRadius = self:GetAbility():GetSpecialValueFor('wave_radius_level_exort')*self:GetParent().iExortLevel
	self.iNumWaves = self:GetAbility():GetSpecialValueFor('num_waves_level_exort')*self:GetParent().iExortLevel
end 
function modifier_invoker_retro_incinerate_channeling:OnIntervalThink()
	if IsClient() then return end
	self.iWaveSpawnSoFar = self.iWaveSpawnSoFar or 0
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if self.iWaveSpawnSoFar < self.iNumWaves then
		local incinerate_wave_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_incinerate.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(incinerate_wave_particle_effect, 1, Vector(self.fRadius, 0, 0))
		
		
		hParent:EmitSound("Hero_Invoker.ForgeSpirit")
		hParent:SetDayTimeVisionRange(self.fRadius)
		hParent:SetNightTimeVisionRange(self.fRadius)
		
		--Damage nearby enemy units.
		local nearby_enemy_units = FindUnitsInRadius(hCaster:GetTeam(), hParent:GetAbsOrigin(), nil, self.fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for i, individual_unit in ipairs(nearby_enemy_units) do
			ApplyDamageTestDummy({victim = individual_unit, attacker = hCaster, damage = self.fDamage, damage_type = DAMAGE_TYPE_MAGICAL,ability = self:GetAbility()})
		end
		
		self.iWaveSpawnSoFar = self.iWaveSpawnSoFar + 1
	end
end
