--[[ ============================================================================================================
	Author: Rook
	Date: February 19, 2015
	Called when Tornado Blast is cast.
	Additional parameters: keys.ProjectileSpeed, keys.ProjectileRadius, keys.ProjectileFlyingVision, and 
		keys.ProjectileFlyingVisionMaxRangeDuration
================================================================================================================= ]]

INVOKER_RETRO_WEARABLE_MAGUS_APEX = 2
INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE = 4
INVOKER_RETRO_WEARABLE_EXTRA = 8
LinkLuaModifier("modifier_invoker_retro_tornado_blast_level_quas", "heroes/hero_invoker/invoker_retro_tornado_blast.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_tornado_blast_level_quas = class({})
function modifier_invoker_retro_tornado_blast_level_quas:IsHidden() return true end
function modifier_invoker_retro_tornado_blast_level_quas:IsPurgable() return false end
function modifier_invoker_retro_tornado_blast_level_quas:RemoveOnDeath() return false end
function modifier_invoker_retro_tornado_blast_level_quas:OnCreated()
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		local iHasDarkArtistryCape = 0
		if hParent:FindModifierByName('modifier_invoker_retro_cosmetic_manager') and bit.band(hParent:FindModifierByName('modifier_invoker_retro_cosmetic_manager'):GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
			iHasDarkArtistryCape = 1
		end
		if hParent:HasScepter() then
			self:SetStackCount(2*(hParent.iQuasLevel+1)+iHasDarkArtistryCape)
		else
			self:SetStackCount(hParent.iQuasLevel*2+iHasDarkArtistryCape)
		end
	end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_tornado_blast_level_quas:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iQuasLevel then
		local iHasDarkArtistryCape = 0
		if hParent:FindModifierByName('modifier_invoker_retro_cosmetic_manager') and bit.band(hParent:FindModifierByName('modifier_invoker_retro_cosmetic_manager'):GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
			iHasDarkArtistryCape = 1
		end
		if hParent:HasScepter() then
			self:SetStackCount(2*(hParent.iQuasLevel+1)+iHasDarkArtistryCape)
		else
			self:SetStackCount(hParent.iQuasLevel*2+iHasDarkArtistryCape)
		end
	end
end
invoker_retro_tornado_blast = class({})
function invoker_retro_tornado_blast:GetAbilityTextureName()
	if self.hModifier:GetStackCount()%2 > 0 then
		return "invoker/dark_artistry/invoker_tornado"
	else
		return "invoker_tornado"
	end
end
function invoker_retro_tornado_blast:GetIntrinsicModifierName() return "modifier_invoker_retro_tornado_blast_level_quas" end

function invoker_retro_tornado_blast:GetCastRange()
	return bit.rshift(self.hModifier:GetStackCount(), 1)*self:GetSpecialValueFor('travel_distance_level_quas')
end

function invoker_retro_tornado_blast:OnSpellStart()
	--Tornado Blast's travel distance is dependent on the level of Quas.
	local keys = {
		ability = self, 
		caster = self:GetCaster(), 
		ProjectileRadius = self:GetSpecialValueFor('projectile_radius'),
		ProjectileSpeed = self:GetSpecialValueFor('projectile_speed'),
		ProjectileFlyingVision = self:GetSpecialValueFor('projectile_flying_vision'),
		ProjectileFlyingVisionMaxRangeDuration = self:GetSpecialValueFor('projectile_flying_vision_max_range_duration'),
	}
	
	local iQuasLevel = bit.rshift(self.hModifier:GetStackCount(), 1)
	
	local tornado_blast_travel_distance = iQuasLevel*self:GetSpecialValueFor('travel_distance_level_quas')+keys.caster:GetCastRangeBonus()
	-- GetExtraCastRange is in internal/util.lua
	local caster_origin = keys.caster:GetAbsOrigin()
	local fDamage = self:GetSpecialValueFor('damage_base')+iQuasLevel*self:GetSpecialValueFor('damage_level_quas')
	local hOriginalAbility
	local IsImmortal = false
	if self.hModifier:GetStackCount()%2 > 0 then
		IsImmortal = true
	end
	
	local tAllHeroes=HeroList:GetAllHeroes()
	if keys.caster:GetName() == 'npc_dota_hero_invoker' then 
		hOriginalAbility = self
	else
		for k,v in pairs(tAllHeroes) do
			if v:GetName() == 'npc_dota_hero_invoker' and v:IsRealHero() and v:HasAbility('invoker_retro_tornado_blast') then
				hOriginalAbility = v:FindAbilityByName('invoker_retro_tornado_blast')
			end
		end
	end
	
	local projectile_information =  
	{
		EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
		Ability = hOriginalAbility,
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
		ExtraData = {fDamage = fDamage, iCasterIndex = keys.caster:entindex(), iAbilityIndex = self:entindex()}
	}
	if IsImmortal then 
		projectile_information.EffectName = 'particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf'
	end

	local target_point = self:GetCursorPosition()
	target_point.z = 0
	local caster_point = keys.caster:GetAbsOrigin()
	caster_point.z = 0
	local point_difference_normalized = (target_point - caster_point):Normalized()
	projectile_information.vVelocity = point_difference_normalized * keys.ProjectileSpeed
	local tornado_blast_projectile = ProjectileManager:CreateLinearProjectile(projectile_information)
	if keys.caster:HasAbility('special_bonus_unique_invoker_retro_3') and keys.caster:FindAbilityByName('special_bonus_unique_invoker_retro_3'):GetLevel() > 0 then 
		local fTheta = keys.caster:FindAbilityByName('special_bonus_unique_invoker_retro_3'):GetSpecialValueFor('value')/180*math.pi
		local v1 = Vector(math.cos(fTheta)*point_difference_normalized.x-math.sin(fTheta)*point_difference_normalized.y, math.sin(fTheta)*point_difference_normalized.x+math.cos(fTheta)*point_difference_normalized.y, 0)
		projectile_information.vVelocity = v1 * keys.ProjectileSpeed
		ProjectileManager:CreateLinearProjectile(projectile_information)
		
		local v2 = Vector(math.cos(fTheta)*point_difference_normalized.x+math.sin(fTheta)*point_difference_normalized.y, -math.sin(fTheta)*point_difference_normalized.x+math.cos(fTheta)*point_difference_normalized.y, 0)
		projectile_information.vVelocity = v2 * keys.ProjectileSpeed
		ProjectileManager:CreateLinearProjectile(projectile_information)
	end
	
	if IsImmortal then 
		keys.caster:EmitSound('Hero_Invoker.Tornado.Cast.Immortal')
	else
		keys.caster:EmitSound('Hero_Invoker.Tornado.Cast')
	end
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
function invoker_retro_tornado_blast:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	--Tornado Blast's damage is dependent on the level of Quas.
	if not hTarget then return end
	hTarget:EmitSound("Hero_Invoker.Tornado.LandDamage")
	local hAbility = EntIndexToHScript(tExtraData.iAbilityIndex)
	if hAbility and not hAbility:IsNull() then
		ApplyDamageTestDummy({victim = hTarget, attacker = EntIndexToHScript(tExtraData.iCasterIndex), damage = tExtraData.fDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
	else
		ApplyDamageTestDummy({victim = hTarget, attacker = EntIndexToHScript(tExtraData.iCasterIndex), damage = tExtraData.fDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = hAbility})
	end
end