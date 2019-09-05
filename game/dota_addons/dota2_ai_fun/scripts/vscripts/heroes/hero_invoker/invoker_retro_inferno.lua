--[[ ============================================================================================================
	Author: Rook
	Date: March 7, 2015
	Called when Inferno is cast.
	Additional parameters: keys.InfernoSpawnRadius, keys.InfernoExplosionDelay, keys.InfernoExplosionDuration,
		keys.InfernoRadius, keys.InfernoDelayBetweenSpawns
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_inferno", "heroes/hero_invoker/invoker_retro_inferno.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_inferno = class({})
function modifier_invoker_retro_inferno:IsPurgable() return false end
function modifier_invoker_retro_inferno:IsHidden() return true end
function modifier_invoker_retro_inferno:RemoveOnDeath() return false end


local function CreateSingleInferno(self)
	local hParent = self:GetParent()
	local caster_point = hParent:GetAbsOrigin()
		
	--Select a random point within the radius around the caster.
	local random_x_offset = RandomInt(0, self.InfernoSpawnRadius) - (self.InfernoSpawnRadius / 2)
	local random_y_offset = RandomInt(0, self.InfernoSpawnRadius) - (self.InfernoSpawnRadius / 2)
	local inferno_point = Vector(caster_point.x + random_x_offset, caster_point.y + random_y_offset, caster_point.z)
	inferno_point = GetGroundPosition(inferno_point, nil)
	
	--Create a dummy unit at the spawn point.
	local inferno_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_inferno_unit", inferno_point, false, nil, nil, hParent:GetTeam())
	
	inferno_dummy_unit:AddAbility(self.sName)
	dummy_unit_inferno_ability = inferno_dummy_unit:FindAbilityByName(self.sName)
	dummy_unit_inferno_ability:SetLevel(1)
	
	inferno_dummy_unit:EmitSound("Hero_Invoker.SunStrike.Charge")
	
	--Store the DPS that the inferno should deal.
	inferno_dummy_unit.inferno_damage_per_second = self.inferno_damage_per_second
	
	--Display the pre-explosion particle effect at the dummy unit's point.
	local inferno_pre_explosion_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_inferno_pre_explosion.vpcf", PATTACH_ABSORIGIN, inferno_dummy_unit)
	
	--Explode the inferno after a delay.
	Timers:CreateTimer({
		endTime = self.InfernoExplosionDelay,
		callback = function()
			dummy_unit_inferno_ability:ApplyDataDrivenModifier(hParent, inferno_dummy_unit, "modifier_invoker_retro_inferno_damage_over_time", nil)
			
			--Destroy the pre-explosion particle effect, and play the explosion particle effect.
			ParticleManager:DestroyParticle(inferno_pre_explosion_particle_effect, false)
			local inferno_explosion_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_inferno.vpcf", PATTACH_ABSORIGIN, inferno_dummy_unit)
			
			--Give vision over the explosion.
			inferno_dummy_unit:SetDayTimeVisionRange(self.InfernoRadius)
			inferno_dummy_unit:SetNightTimeVisionRange(self.InfernoRadius)
			
			inferno_dummy_unit:EmitSound("Hero_Invoker.SunStrike.Ignite")
			inferno_dummy_unit:EmitSound("Hero_Huskar.Burning_Spear")
			
			--Destroy the inferno after its duration ends.
			Timers:CreateTimer({
				endTime = self.InfernoExplosionDuration,
				callback = function()
					inferno_dummy_unit:StopSound("Hero_Huskar.Burning_Spear")
					inferno_dummy_unit:RemoveSelf()
				end
			})
		end
	})
--	print(self:GetStackCount())
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then 
		self:Destroy()
	end

end


function modifier_invoker_retro_inferno:OnCreated(keys)
	if IsClient() then return end
	self.sName = self:GetAbility():GetAbilityName()
	
	self.InfernoRadius = keys.InfernoRadius
	self.InfernoExplosionDuration = keys.InfernoExplosionDuration
	self.InfernoExplosionDelay = keys.InfernoExplosionDelay
	self.InfernoSpawnRadius = keys.InfernoSpawnRadius
	self.inferno_damage_per_second = keys.inferno_damage_per_second
	self:SetStackCount(keys.num_infernos)
	CreateSingleInferno(self)
	self:StartIntervalThink(keys.InfernoDelayBetweenSpawns)
end

function modifier_invoker_retro_inferno:OnIntervalThink()
	if IsClient() then return end
	CreateSingleInferno(self)
end

function invoker_retro_inferno_on_spell_start(keys)	
	local iExortLevel
	if keys.caster:HasScepter() then
		iExortLevel = keys.caster.iExortLevel+1
	else
		iExortLevel = keys.caster.iExortLevel
	end
	
	local iWexLevel
	if keys.caster:HasScepter() then
		iWexLevel = keys.caster.iWexLevel+1
	else
		iWexLevel = keys.caster.iWexLevel
	end
	--The number of infernos to spawn is dependent on the level of Wex.
	local num_infernos = keys.ability:GetSpecialValueFor("num_infernos_level_wex")*iWexLevel
	
	--The damage per second dealt by infernos is dependent on the level of Exort.
	local inferno_damage_per_second = keys.ability:GetSpecialValueFor("inferno_damage_per_second_level_exort")*iExortLevel+keys.ability:GetSpecialValueFor("inferno_damage_per_second_base")
	
	
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_inferno", {InfernoDelayBetweenSpawns = keys.InfernoDelayBetweenSpawns, inferno_damage_per_second = inferno_damage_per_second, InfernoSpawnRadius = keys.InfernoSpawnRadius, InfernoExplosionDelay = keys.InfernoExplosionDelay, InfernoExplosionDuration = keys.InfernoExplosionDuration, InfernoRadius = keys.InfernoRadius, num_infernos = num_infernos})
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 7, 2015
	Called regularly while an inferno is exploding.
	Additional parameters: keys.InfernoRadius, keys.InfernoDamageInterval
================================================================================================================= ]]
function modifier_invoker_retro_inferno_damage_over_time_on_interval_think(keys)
	--Damage nearby enemy units.
	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.InfernoRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for i, individual_unit in ipairs(nearby_enemy_units) do
		if keys.target.inferno_damage_per_second ~= nil then  --The damage per second should have been stored in the dummy unit.
			ApplyDamageTestDummy({victim = individual_unit, attacker = keys.caster, damage = keys.target.inferno_damage_per_second * keys.InfernoDamageInterval, damage_type = DAMAGE_TYPE_MAGICAL,})
		end
	end
end