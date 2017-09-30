modifier_ramza_geomancer_wind_blast_tornado = class({})

function modifier_ramza_geomancer_wind_blast_tornado:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle1 = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_funnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)	
	ParticleManager:SetParticleControlEnt(self.iParticle1, 3, hParent, PATTACH_POINT_FOLLOW, 'follow_origin' ,hParent:GetAbsOrigin(), true)
	self.iParticle2 = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)	
	ParticleManager:SetParticleControlEnt(self.iParticle2, 3, hParent, PATTACH_POINT_FOLLOW, 'follow_origin' ,hParent:GetAbsOrigin(), true)
	hParent:EmitSound('Brewmaster_Storm.Cyclone')
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
	
	
end	

function modifier_ramza_geomancer_wind_blast_tornado:UpdateHorizontalMotion(me, dt)
	if not self.hTarget:IsAlive() then 
		self:GetCaster().tWindBlastTarget[self.hTarget] = false
		self:Destroy() 
	end
	local vHorizontalSpeed = Vector2D(self.hTarget:GetOrigin()-me:GetOrigin()):Normalized()*self.fSpeed
	me:SetOrigin(me:GetOrigin()+dt*vHorizontalSpeed)
	if Vector(0,0,0).Dot(self.hTarget:GetOrigin()-me:GetOrigin(), vHorizontalSpeed) <= 0 then
		if self.bReachTarget then
			self:Destroy()
		else
			self.hTargetModifier = self.hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ramza_geomancer_wind_blast", {Duration = 50})
			self.hTargetModifier.fDamage = self.fDamage
			self.hTargetModifier.hThinker = me
			self:GetCaster().tWindBlastTarget[self.hTarget] = false
			self.hTarget = self:GetCaster()
			self.bReachTarget = true
		end
	end
end

function modifier_ramza_geomancer_wind_blast_tornado:UpdateVerticalMotion(me, dt)
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), nil))
end


function modifier_ramza_geomancer_wind_blast_tornado:OnDestroy()
	if IsClient() then return end
	if self.hTargetModifier then self.hTargetModifier:Destroy() end
	ParticleManager:DestroyParticle(self.iParticle1, true)
	ParticleManager:DestroyParticle(self.iParticle2, true)
	local hParent = self:GetParent()
	hParent:StopSound('Brewmaster_Storm.Cyclone')
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	Timers:CreateTimer(0.04, function () UTIL_Remove(hParent) end)
end

modifier_ramza_geomancer_wind_blast = class({})

function modifier_ramza_geomancer_wind_blast:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end

function modifier_ramza_geomancer_wind_blast:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_ramza_geomancer_wind_blast:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_ramza_geomancer_wind_blast:OnCreated()
	if IsClient() then return end
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_ramza_geomancer_wind_blast:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	ApplyDamage({
		damage = self.fDamage,
		attacker = self:GetCaster(),
		victim = hParent,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	})
end

function modifier_ramza_geomancer_wind_blast:UpdateVerticalMotion(me, dt)
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), nil)+Vector(0,0,200))
end

function modifier_ramza_geomancer_wind_blast:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(GetGroundPosition(self.hThinker:GetOrigin(), nil)+Vector(0,0,200))
end

modifier_ramza_geomancer_contortion = class({})

function modifier_ramza_geomancer_contortion:OnCreated(keys)
	self.iRadius = keys.iRadius
	self:StartIntervalThink(0.5)
end

function modifier_ramza_geomancer_contortion:OnIntervalThink()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), none, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)
	if #tTargets > 0 then
		local hTarget = tTargets[RandomInt(1, #tTargets)]
		local info = 
		{
			Target = hTarget,
			Source = hParent,
			Ability = hCaster:FindAbilityByName("ramza_squire_fundamental_stone"),	
			EffectName = "particles/units/heroes/hero_brewmaster/brewmaster_hurl_boulder.vpcf",
			iMoveSpeed = 700,
			vSourceLoc= hParent:GetAbsOrigin(),                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
			bDodgeable = true,                                -- Optional
			bIsAttack = false,                                -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bReplaceExisting = false,                         -- Optional
			flExpireTime = GameRules:GetGameTime() + 20,      -- Optional but recommended
			bProvidesVision = false,                           -- Optional
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end

modifier_ramza_geomancer_attack_boost = class({})

function modifier_ramza_geomancer_attack_boost:IsPurgable() return false end
function modifier_ramza_geomancer_attack_boost:RemoveOnDeath() return false end
function modifier_ramza_geomancer_attack_boost:IsHidden() return true end

function modifier_ramza_geomancer_attack_boost:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACKED
	}
end

function modifier_ramza_geomancer_attack_boost:OnAttacked(keys)
	if keys.target~= self:GetParent() then return end
	keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ramza_geomancer_attack_boost_bonus_damage", {Duration = self.fDuration}):SetStackCount(self.iBonusDamage)
end

modifier_ramza_geomancer_attack_boost_bonus_damage = class({})

function modifier_ramza_geomancer_attack_boost_bonus_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_ramza_geomancer_attack_boost_bonus_damage:IsPurgable() return true end

function modifier_ramza_geomancer_attack_boost_bonus_damage:GetTexture() return "attr_damage" end

function modifier_ramza_geomancer_attack_boost_bonus_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ramza_geomancer_attack_boost_bonus_damage:GetEffectName() return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf" end

function modifier_ramza_geomancer_attack_boost_bonus_damage:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()
end

modifier_ramza_geomancer_geomancy_sinkhole = class({})

function modifier_ramza_geomancer_geomancy_sinkhole:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end

function modifier_ramza_geomancer_geomancy_sinkhole:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end

function modifier_ramza_geomancer_geomancy_sinkhole:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_ramza_geomancer_geomancy_sinkhole:IsPurgable() return false end

function modifier_ramza_geomancer_geomancy_sinkhole:IsPurgeException() return true end

function modifier_ramza_geomancer_geomancy_sinkhole:OnCreated()	
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
end


function modifier_ramza_geomancer_geomancy_sinkhole:UpdateVerticalMotion(me, dt)
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), nil)+Vector(0,0,-50))
end

function modifier_ramza_geomancer_geomancy_sinkhole:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:SetOrigin(GetGroundPosition(hParent:GetOrigin(), nil))
	hParent:RemoveVerticalMotionController(self)
end

modifier_ramza_geomancer_geomancy_tanglevine = class({})

function modifier_ramza_geomancer_geomancy_tanglevine:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_ramza_geomancer_geomancy_tanglevine:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ramza_geomancer_geomancy_tanglevine:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

function modifier_ramza_geomancer_geomancy_tanglevine:OnCreated(keys)
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hParent:EmitSound("Hero_Treant.Overgrowth.Target")
--	keys.tRooted[hParent] = true
	Timers:CreateTimer(0.2, function () 
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), none, keys.fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_ANY_ORDER, false)
		local iCount = #tTargets
		for i = 1, iCount do
			if self.tRooted[tTargets[iCount+1-i]] then
				table.remove(tTargets, iCount+1-i)
			end
		end
		if #tTargets > 0 then
			local iNum = RandomInt(1, #tTargets)
			self.tRooted[tTargets[iNum]]=true
			local hModifier = tTargets[iNum]:AddNewModifier(hCaster, self:GetAbility(), "modifier_ramza_geomancer_geomancy_tanglevine", {Duration = keys.Duration, fDamage = keys.fDamage, fRadius = keys.fRadius})
			hModifier.tRooted = self.tRooted
		end
	end)
	self.fDamage = keys.fDamage
	self:StartIntervalThink(1)
end

function modifier_ramza_geomancer_geomancy_tanglevine:OnIntervalThink()
	if IsClient() then return end
	ApplyDamage({
		attacker = self:GetCaster(),
		ability = self:GetAbility(),
		victim = self:GetParent(),
		damage = self.fDamage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})
end