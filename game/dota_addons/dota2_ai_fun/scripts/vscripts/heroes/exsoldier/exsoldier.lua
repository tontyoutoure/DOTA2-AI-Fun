LinkLuaModifier("modifier_exsoldier_braver_fly", "heroes/exsoldier/exsoldier_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_exsoldier_omnislash", "heroes/exsoldier/exsoldier_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
ExsoldierMeteorRain = function(keys)
	if keys.caster:IsIllusion() or keys.caster:PassivesDisabled() then return end
	if keys.ability:GetSpecialValueFor("chance") < RandomFloat(0, 100) then return end
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, keys.caster)
	local vTargetPoint = keys.caster:GetOrigin()+keys.caster:GetForwardVector()*250	
	local iDamage = keys.ability:GetSpecialValueFor("damage")
	local fMeteorRadius = keys.ability:GetSpecialValueFor("radius")
	local fStunDuration = keys.ability:GetSpecialValueFor("stun_duration")
	if keys.caster:HasAbility("special_bonus_unique_exsoldier_1") then
		fStunDuration = fStunDuration+keys.caster:FindAbilityByName("special_bonus_unique_exsoldier_1"):GetSpecialValueFor("value")
	end
	ParticleManager:SetParticleControl(iParticle, 0, vTargetPoint+Vector(0,0,2000))
	ParticleManager:SetParticleControl(iParticle, 1, vTargetPoint+Vector(0,0,-2250))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(0.7,0,0))
	keys.caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
	keys.caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
	Timers:CreateTimer(0.7,function () 
		StartSoundEventFromPosition("Hero_Invoker.ChaosMeteor.Impact", vTargetPoint)
		keys.caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
		GridNav:DestroyTreesAroundPoint(vTargetPoint, fMeteorRadius, true)
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), vTargetPoint, nil, fMeteorRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damageTable = {
			damage = iDamage,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = keys.ability
		}
		for k, v in ipairs(tTargets) do
			damageTable.victim = v
			ApplyDamage(damageTable)
			v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = fStunDuration*CalculateStatusResist(v)})
		end
	end)
end

function ExsoldierBraver(keys)
	local fFlyTime = keys.ability:GetSpecialValueFor("fly_time")
	local vMove = keys.target_points[1] - keys.caster:GetOrigin()
	local vHorizantalSpeed = Vector(vMove.Dot(vMove, Vector(1, 0, 0)), vMove.Dot(vMove, Vector(0, 1, 0)), 0)/fFlyTime
	local vVerticalAcceleration = Vector(0, 0, -20000)
	local vVerticalSpeed = Vector(0, 0, vMove.Dot(vMove, Vector(0, 0, 1)))/fFlyTime - vVerticalAcceleration*fFlyTime/2
	local hModifier = keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_exsoldier_braver_fly", {Duration = fFlyTime})
	hModifier.vHorizantalSpeed = vHorizantalSpeed
	hModifier.vVerticalSpeed = vVerticalSpeed
	hModifier.vVerticalAcceleration= vVerticalAcceleration
	hModifier.vDestination = keys.target_points[1]
end

exsoldier_blade_beam = class({})

function exsoldier_blade_beam:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Abaddon.DeathCoil.Cast")
	ProjectileManager:CreateTrackingProjectile({
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		vSourceLoc= self:GetCaster():GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
        bDodgeable = false,                                -- Optional
        bIsAttack = false,                                -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bReplaceExisting = false,                         -- Optional
        flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
		ExtraData = {iTargetStack = 0}
	})
end

function exsoldier_blade_beam:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	local hCaster = self:GetCaster()
	if tExtraData.iTargetStack == 0 then
		if hTarget:TriggerSpellAbsorb( self ) then return end
		self:GetCaster():EmitSound("Hero_Abaddon.DeathCoil.Target")
		ApplyDamage({attacker = hCaster, victim = hTarget, damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType(), ability = self})
		for k, v in ipairs(FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, self:GetSpecialValueFor("blast_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do		
			if hTarget ~= v then
				hTarget:EmitSound("Hero_Abaddon.DeathCoil.Cast")
				ProjectileManager:CreateTrackingProjectile({
					Target = v,
					Source = hTarget,
					Ability = self,
					EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
					iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
					vSourceLoc= hTarget:GetAbsOrigin(),                -- Optional (HOW)
					bDrawsOnMinimap = false,                          -- Optional
					bDodgeable = false,                                -- Optional
					bIsAttack = false,                                -- Optional
					bVisibleToEnemies = true,                         -- Optional
					bReplaceExisting = false,                         -- Optional
					flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
					bProvidesVision = false,                           -- Optional
					ExtraData = {iTargetStack = 1}
				})	
			end
		end
	elseif tExtraData.iTargetStack == 1 then	
		self:GetCaster():EmitSound("Hero_Abaddon.DeathCoil.Target")
		ApplyDamage({attacker = hCaster, victim = hTarget, damage = self:GetSpecialValueFor("blast_damage"), damage_type = self:GetAbilityDamageType(), ability = self})
		if hCaster:HasAbility("special_bonus_unique_exsoldier_4") and hCaster:FindAbilityByName("special_bonus_unique_exsoldier_4"):GetLevel() > 0 then
			for k, v in ipairs(FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, self:GetSpecialValueFor("blast_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do		
				if hTarget ~= v then
					ProjectileManager:CreateTrackingProjectile({
						Target = v,
						Source = hTarget,
						Ability = self,
						EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
						iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
						vSourceLoc= hTarget:GetAbsOrigin(),                -- Optional (HOW)
						bDrawsOnMinimap = false,                          -- Optional
						bDodgeable = false,                                -- Optional
						bIsAttack = false,                                -- Optional
						bVisibleToEnemies = true,                         -- Optional
						bReplaceExisting = false,                         -- Optional
						flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
						bProvidesVision = false,                           -- Optional
						ExtraData = {iTargetStack = 2}
					})	
				end
			end
		end
	else
		ApplyDamage({attacker = hCaster, victim = hTarget, damage = self:GetSpecialValueFor("blast_damage"), damage_type = self:GetAbilityDamageType(), ability = self})	
	end
end

exsoldier_omnislash = class({})

function exsoldier_omnislash:GetCooldown(num)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 50
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)
		end
	end
	return self.BaseClass.GetCooldown(self, num)
end


function exsoldier_omnislash:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_exsoldier_omnislash", {})
end