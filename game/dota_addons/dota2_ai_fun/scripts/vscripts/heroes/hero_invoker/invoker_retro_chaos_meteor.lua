--[[ ============================================================================================================
	Author: Rook
	Date: February 26, 2015
	Called when Chaos Meteor is cast.
	Additional parameters: keys.LandDelay, keys.TravelDistance, keys.TravelSpeed, keys.VisionDistance,
		keys.EndVisionDuration
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_chaos_meteor_main_damage", "heroes/hero_invoker/invoker_retro_chaos_meteor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_chaos_meteor_burn_damage", "heroes/hero_invoker/invoker_retro_chaos_meteor.lua", LUA_MODIFIER_MOTION_NONE)
invoker_retro_chaos_meteor = class({})
function invoker_retro_chaos_meteor:OnSpellStart()
	local keys = {caster = self:GetCaster(), TravelSpeed = self:GetSpecialValueFor("travel_speed"), TravelDistance = self:GetSpecialValueFor("travel_distance"), VisionDistance = self:GetSpecialValueFor("vision_distance"), EndVisionDuration = self:GetSpecialValueFor("end_vision_duration"), ability = self, LandDelay = self:GetSpecialValueFor("land_delay")}
	local caster_point = keys.caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()
	
	local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
	local target_point_temp = Vector(target_point.x, target_point.y, 0)
	
	local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
	local velocity_per_second = point_difference_normalized * keys.TravelSpeed
	
	keys.caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
	keys.caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
	local iExortLevel
	if keys.caster:HasScepter() then
		iExortLevel = keys.caster.iExortLevel+1
	else
		iExortLevel = keys.caster.iExortLevel
	end

	--Create a particle effect consisting of the meteor falling from the sky and landing at the target point.
	local meteor_fly_original_point = (target_point - (velocity_per_second * keys.LandDelay)) + Vector (0, 0, 1200)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
	local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point+Vector(0,0,100))
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(1.3, 0, 0))
	
	--Chaos Meteor's main damage is dependent on the level of Exort.  This value is stored now since leveling up Exort while the meteor is in midair should have no effect.
	
	--Spawn the rolling meteor after the delay.
	local chaos_meteor_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_chaos_meteor_unit", target_point, false, nil, nil, keys.caster:GetTeam())
	chaos_meteor_dummy_unit.main_damage_interval = self:GetSpecialValueFor("main_damage_interval")
	chaos_meteor_dummy_unit.main_damage_per_interval_level_exort = self:GetSpecialValueFor("main_damage_per_interval_level_exort")	
	chaos_meteor_dummy_unit.main_damage_radius = self:GetSpecialValueFor("main_damage_radius")
	chaos_meteor_dummy_unit.burn_duration = self:GetSpecialValueFor("burn_duration")
	chaos_meteor_dummy_unit.burn_interval = self:GetSpecialValueFor("burn_interval")
	chaos_meteor_dummy_unit.burn_damage_per_interval = self:GetSpecialValueFor("burn_damage_per_interval")
	chaos_meteor_dummy_unit.iExortLevel = iExortLevel
	Timers:CreateTimer({
		endTime = keys.LandDelay,
		callback = function()
			local chaos_meteor_duration = keys.TravelDistance / keys.TravelSpeed
			local chaos_meteor_velocity_per_frame = velocity_per_second * .03
			
			--It would seem that the Chaos Meteor projectile needs to be attached to a particle in order to move and roll and such.
			local projectile_information =  
			{
				EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
				Ability = keys.ability,
				vSpawnOrigin = target_point,
				fDistance = keys.TravelDistance,
				fStartRadius = 0,
				fEndRadius = 0,
				Source = keys.caster,
				bHasFrontalCone = false,
				iMoveSpeed = keys.TravelSpeed,
				bReplaceExisting = false,
				bProvidesVision = true,
				iVisionTeamNumber = keys.caster:GetTeam(),
				iVisionRadius = keys.VisionDistance,
				bDrawsOnMinimap = false,
				bVisibleToEnemies = true, 
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_NONE ,
				fExpireTime = GameRules:GetGameTime() + chaos_meteor_duration + keys.EndVisionDuration,
			}
			
			projectile_information.vVelocity = velocity_per_second
			local chaos_meteor_projectile = ProjectileManager:CreateLinearProjectile(projectile_information)
			
			--Create a dummy unit will follow the path of the meteor, providing flying vision, sound, damage, etc.
			
--			FindClearSpaceForUnit(chaos_meteor_dummy_unit, target_point, true)
			local chaos_meteor_dummy_unit_ability = chaos_meteor_dummy_unit:FindAbilityByName("dummy_unit_passive")
			if chaos_meteor_dummy_unit_ability ~= nil then
				chaos_meteor_dummy_unit_ability:SetLevel(1)
			end
			
			keys.caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
			chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
			chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Loop")  --Emit a sound that will follow the meteor.
			
			chaos_meteor_dummy_unit:SetDayTimeVisionRange(keys.VisionDistance)
			chaos_meteor_dummy_unit:SetNightTimeVisionRange(keys.VisionDistance)
			
			
			
			
			
			--Store the damage to deal in a variable attached to the dummy unit, so leveling Exort after Meteor is cast will have no effect.
			
			chaos_meteor_dummy_unit:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_chaos_meteor_main_damage", {iExortLevel = iExortLevel})
			
			--Adjust the dummy unit's position every frame.
			local endTime = GameRules:GetGameTime() + chaos_meteor_duration
			Timers:CreateTimer({
				callback = function()
					chaos_meteor_dummy_unit:SetAbsOrigin(chaos_meteor_dummy_unit:GetAbsOrigin() + chaos_meteor_velocity_per_frame)
					if GameRules:GetGameTime() > endTime then
						--Have the dummy unit linger in the position the meteor ended up in, in order to provide vision.
						Timers:CreateTimer({
							endTime = keys.EndVisionDuration,
							callback = function()
								chaos_meteor_dummy_unit:RemoveSelf()
							end
						})
						return 
					else 
						return .03
					end
				end
			})
			
			--Stop the sound, particle, and damage when the meteor disappears.
			Timers:CreateTimer({
				endTime = chaos_meteor_duration,
				callback = function()
					chaos_meteor_dummy_unit:StopSound("Hero_Invoker.ChaosMeteor.Loop")
					chaos_meteor_dummy_unit:StopSound("Hero_Invoker.ChaosMeteor.Destroy")
					chaos_meteor_dummy_unit:RemoveModifierByName("modifier_invoker_retro_chaos_meteor_main_damage")
				end
			})
		end
	})
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 2, 2015
	Called regularly while the Chaos Meteor is rolling.
	Additional parameters: keys.MainDamageRadius
================================================================================================================= ]]

local function modifier_invoker_retro_chaos_meteor_main_damage_on_interval_think(keys)
	local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.MainDamageRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local fDamage = keys.iExortLevel*keys.target.main_damage_per_interval_level_exort
	local fDuration = keys.target.burn_duration
	
	for i, individual_unit in ipairs(nearby_enemy_units) do
		individual_unit:EmitSound("Hero_Invoker.ChaosMeteor.Damage")
		
		ApplyDamageTestDummy({victim = individual_unit, attacker = keys.caster, damage = fDamage, damage_type = DAMAGE_TYPE_MAGICAL,})
		individual_unit:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_chaos_meteor_burn_damage", {burn_interval = keys.target.burn_interval*CalculateStatusResist(individual_unit), Duration = fDuration*CalculateStatusResist(individual_unit), burn_damage_per_interval = keys.target.burn_damage_per_interval})
	end
end

modifier_invoker_retro_chaos_meteor_main_damage = class({})
function modifier_invoker_retro_chaos_meteor_main_damage:IsHidden() return true end
function modifier_invoker_retro_chaos_meteor_main_damage:IsPurgable() return false end
function modifier_invoker_retro_chaos_meteor_main_damage:OnCreated(keys) 
	if IsClient() then return end
	modifier_invoker_retro_chaos_meteor_main_damage_on_interval_think({
		target = self:GetParent(), 
		caster = self:GetCaster(), 
		ability = self:GetAbility(), 
		MainDamageRadius = self:GetParent().main_damage_radius, 
		iExortLevel = keys.iExortLevel})
	self.iExortLevel = keys.iExortLevel
	self:StartIntervalThink(self:GetParent().main_damage_interval)
end

function modifier_invoker_retro_chaos_meteor_main_damage:OnIntervalThink()
	if IsClient() then return end
	modifier_invoker_retro_chaos_meteor_main_damage_on_interval_think({target = self:GetParent(), caster = self:GetCaster(), ability = self:GetAbility(), MainDamageRadius = self:GetParent().main_damage_radius, iExortLevel = self.iExortLevel})
end



--[[ ============================================================================================================
	Author: Rook
	Date: March 2, 2015
	Called regularly a unit is still burned from a Chaos Meteor.
	Additional parameters: keys.BurnDamagePerInterval
================================================================================================================= ]]
modifier_invoker_retro_chaos_meteor_burn_damage = class({})
function modifier_invoker_retro_chaos_meteor_burn_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_invoker_retro_chaos_meteor_burn_damage:OnCreated(keys)
	if IsClient() then return end

	self:StartIntervalThink(keys.burn_interval)
	self.burn_damage_per_interval = keys.burn_damage_per_interval
end

function modifier_invoker_retro_chaos_meteor_burn_damage:OnIntervalThink()
	if IsClient() then return end
	ApplyDamageTestDummy({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.burn_damage_per_interval, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end