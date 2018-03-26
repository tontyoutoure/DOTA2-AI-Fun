--[[ ============================================================================================================
	Author: Rook
	Date: February 19, 2015
	Called when Tornado Blast is cast.
	Additional parameters: keys.ProjectileSpeed, keys.ProjectileRadius, keys.ProjectileFlyingVision, and 
		keys.ProjectileFlyingVisionMaxRangeDuration
================================================================================================================= ]]
function invoker_retro_tornado_blast_on_spell_start(keys)
	--Tornado Blast's travel distance is dependent on the level of Quas.
	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local tornado_blast_travel_distance = 0
	if quas_ability ~= nil then
		tornado_blast_travel_distance = keys.ability:GetLevelSpecialValueFor("travel_distance", quas_ability:GetLevel() - 1)
	end
	
	local caster_origin = keys.caster:GetAbsOrigin()

	local projectile_information =  
	{
		EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = caster_origin,
		fDistance = tornado_blast_travel_distance,
		fStartRadius = keys.ProjectileRadius,
		fEndRadius = keys.ProjectileRadius,
		Source = keys.caster,
		bHasFrontalCone = false,
		iMoveSpeed = keys.ProjectileSpeed,
		bReplaceExisting = false,
		bProvidesVision = true,
		iVisionTeamNumber = keys.caster:GetTeam(),
		iVisionRadius = keys.ProjectileFlyingVision,
		bDrawsOnMinimap = false,
		bVisibleToEnemies = true, 
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		fExpireTime = GameRules:GetGameTime() + 20.0,
	}

	local target_point = keys.target_points[1]
	target_point.z = 0
	local caster_point = keys.caster:GetAbsOrigin()
	caster_point.z = 0
	local point_difference_normalized = (target_point - caster_point):Normalized()
	projectile_information.vVelocity = point_difference_normalized * keys.ProjectileSpeed
	
	local tornado_blast_projectile = ProjectileManager:CreateLinearProjectile(projectile_information)
	
	--Calculate where and when the Tornado projectile will end up.
	local tornado_blast_duration = tornado_blast_travel_distance / keys.ProjectileSpeed
	local tornado_blast_final_position = caster_origin + (projectile_information.vVelocity * tornado_blast_duration)
	local tornado_blast_velocity_per_frame = projectile_information.vVelocity * .03
	
	--Create a dummy unit that will follow the path of the tornado, providing flying vision and sound.
	local tornado_blast_dummy_unit = CreateUnitByName("npc_dota_invoker_retro_tornado_blast_unit", caster_origin, false, nil, nil, keys.caster:GetTeam())
	local tornado_blast_dummy_unit_ability = tornado_blast_dummy_unit:FindAbilityByName("dummy_unit_passive")
	if tornado_blast_dummy_unit_ability ~= nil then
		tornado_blast_dummy_unit_ability:SetLevel(1)
	end
	
	tornado_blast_dummy_unit:EmitSound("Hero_Invoker.Tornado")  --Emit a sound that will follow the tornado.
	
	tornado_blast_dummy_unit:SetDayTimeVisionRange(keys.ProjectileFlyingVision)
	tornado_blast_dummy_unit:SetNightTimeVisionRange(keys.ProjectileFlyingVision)
	
	--Adjust the dummy unit's position every frame to match that of the tornado particle effect.
	local endTime = GameRules:GetGameTime() + tornado_blast_duration
	Timers:CreateTimer({
		endTime = .03,
		callback = function()
			tornado_blast_dummy_unit:SetAbsOrigin(tornado_blast_dummy_unit:GetAbsOrigin() + tornado_blast_velocity_per_frame)
			if GameRules:GetGameTime() > endTime then
				tornado_blast_dummy_unit:StopSound("Hero_Invoker.Tornado")
				
				--Have the dummy unit linger in the position the tornado ended up in, in order to provide vision.
				Timers:CreateTimer({
					endTime = keys.ProjectileFlyingVisionMaxRangeDuration,
					callback = function()
						tornado_blast_dummy_unit:RemoveSelf()
					end
				})
				
				return 
			else 
				return .03
			end
		end
	})
end


--[[ ============================================================================================================
	Author: Rook
	Date: February 19, 2015
	Called when Tornado Blast hits an enemy unit.  Damages them.
================================================================================================================= ]]
function invoker_retro_tornado_blast_on_projectile_hit_unit(keys)
	--Tornado Blast's damage is dependent on the level of Quas.
	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local tornado_blast_damage = 0
	if quas_ability ~= nil then
		tornado_blast_damage = keys.ability:GetLevelSpecialValueFor("damage", quas_ability:GetLevel() - 1)
	end
	
	keys.target:EmitSound("Hero_Invoker.Tornado.LandDamage")
	
	ApplyDamage({victim = keys.target, attacker = keys.caster, damage = tornado_blast_damage, damage_type = DAMAGE_TYPE_MAGICAL,})
end