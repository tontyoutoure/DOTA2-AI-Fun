modifier_hurricane_tempest = class({})
function modifier_hurricane_tempest:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
local function TempestStrike(hAbility, hLastTarget, hUnit, fStunDuration, fDamage)
	local tSurroudingTargets = FindUnitsInRadius(hUnit:GetTeam(), hUnit:GetOrigin(), nil, hAbility:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local iTargets = #tSurroudingTargets
	if iTargets > 2 then
		for i = 1, iTargets do
			if tSurroudingTargets[iTargets+1-i] == hUnit or tSurroudingTargets[iTargets+1-i] == hLastTarget then
				table.remove(tSurroudingTargets, iTargets+1-i)
			end
		end
	elseif iTargets == 2 then
		for i = 1, iTargets do
			if tSurroudingTargets[iTargets+1-i] == hUnit then
				table.remove(tSurroudingTargets, iTargets+1-i)
			end
		end
	else 
		return nil
	end
	iTargets = #tSurroudingTargets
	local hTarget = tSurroudingTargets[RandomInt(1, iTargets)]
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(0,0,1000)+hTarget:GetOrigin())
	hTarget:EmitSound("Hero_Disruptor.ThunderStrike.Target")
	ApplyDamage({attacker = hUnit, victim = hTarget, damage = fDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = hAbility})
	hTarget:AddNewModifier(hUnit, hAbility, "modifier_stunned", {Duration = fStunDuration*CalculateStatusResist(hTarget)})
	return hTarget
end

function modifier_hurricane_tempest:IsHidden() return false end
function modifier_hurricane_tempest:IsPurgable() return true end

function modifier_hurricane_tempest:OnCreated()
	if IsClient() then return end
	self.tTargets = {}
	local hAbility = self:GetAbility()
	self.fStunDuration = hAbility:GetSpecialValueFor("stun_duration")
	self.fDamage = hAbility:GetSpecialValueFor("damage")
	if self:GetCaster():HasAbility("special_bonus_hurricane_1") then
		self.fStunDuration = self.fStunDuration+self:GetCaster():FindAbilityByName("special_bonus_hurricane_1"):GetSpecialValueFor("value")
	end
	self.hLastTarget = TempestStrike(hAbility, nil, self:GetCaster(), self.fStunDuration, self.fDamage)
	self.iStrikeLeft = hAbility:GetSpecialValueFor("bolt_count")-1	
	if self:GetCaster():HasAbility("special_bonus_hurricane_2") then
		self.iStrikeLeft = self.iStrikeLeft + self:GetCaster():FindAbilityByName("special_bonus_hurricane_2"):GetSpecialValueFor("value")
	end
	self:StartIntervalThink(hAbility:GetSpecialValueFor("strike_interval"))
end

function modifier_hurricane_tempest:OnIntervalThink()
	if IsClient() then return end
	self.hLastTarget = TempestStrike(self:GetAbility(), self.hLastTarget, self:GetCaster(), self.fStunDuration, self.fDamage) or self.hLastTarget
	self.iStrikeLeft = self.iStrikeLeft - 1
	if self.iStrikeLeft == 0 then
		self:Destroy()
	end
end

modifier_hurricane_cyclone = class({})

function modifier_hurricane_cyclone:IsPurgable() return false end

function modifier_hurricane_cyclone:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end

function modifier_hurricane_cyclone:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_hurricane_cyclone:OnCreated()
	if IsClient() then return end
	local fThrowDistance = self:GetAbility():GetSpecialValueFor("throw_distance")
	if self:GetCaster():HasAbility("special_bonus_hurricane_4") then
		fThrowDistance = fThrowDistance + self:GetCaster():FindAbilityByName("special_bonus_hurricane_4"):GetSpecialValueFor("value")
	end
	self.vSpeedHorizontal = fThrowDistance*Vector2D(RandomVector(1)):Normalized()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self.iDamage = hAbility:GetSpecialValueFor("throw_damage")
	self.iStunDuration = hAbility:GetSpecialValueFor("stun_duration")
	self.iParticle = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/force_staff_fm06.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	hParent:EmitSound("Hero_Invoker.Tornado")
	hParent:SetOrigin(self:GetCaster():GetOrigin())
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_hurricane_cyclone:UpdateHorizontalMotion(me, dt)
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	self.tHitUnits = self.tHitUnits or {}
	for k, v in ipairs(FindUnitsInRadius(me:GetTeam(), me:GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if v:GetTeam() ~= hCaster:GetTeam() and not v:HasModifier("modifier_hurricane_cyclone") and not self.tHitUnits[v:entindex()] then
			self.tHitUnits[v:entindex()] = true
			v:AddNewModifier(hCaster, hAbility, "modifier_stunned", {Duration = self.iStunDuration*CalculateStatusResist(v)})
			ApplyDamage({attacker = hCaster, damage = self.iDamage, damage_type = DAMAGE_TYPE_MAGICAL, victim = v, ability = hAbility})
		end
	end
	me:SetOrigin(me:GetOrigin()+dt*self.vSpeedHorizontal)
end

function modifier_hurricane_cyclone:UpdateVerticalMotion(me, dt)	
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), me))
end

function modifier_hurricane_cyclone:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	ParticleManager:DestroyParticle(self.iParticle, true)
	hParent:StopSound("Hero_Invoker.Tornado")
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	if hParent:GetTeam() ~= hCaster:GetTeam() then
		hParent:AddNewModifier(hCaster, hAbility, "modifier_stunned", {Duration = self.iStunDuration*CalculateStatusResist(hParent)})
		ApplyDamage({attacker = hCaster, damage = self.iDamage, damage_type = DAMAGE_TYPE_MAGICAL, victim = hParent, ability = hAbility})
	end
end

modifier_hurricane_whirlewind = class({})

function modifier_hurricane_whirlewind:IsPurgable() return false end

function modifier_hurricane_whirlewind:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end

function modifier_hurricane_whirlewind:GetOverrideAnimation() return ACT_DOTA_FLAIL end

function modifier_hurricane_whirlewind:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end 

function modifier_hurricane_whirlewind:OnCreated()
	if IsClient() then return end
	local fDamageInterval = 0.1
	self.vSpeedHorizontal = self:GetAbility():GetSpecialValueFor("throw_distance")*Vector2D(RandomVector(1)):Normalized()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self.fDamage1 = hAbility:GetSpecialValueFor("damage_per_second_1")*fDamageInterval
	self.fDamage2 = hAbility:GetSpecialValueFor("damage_per_second_2")*fDamageInterval
	self.fDamage3 = hAbility:GetSpecialValueFor("damage_per_second_3")*fDamageInterval
	self.iRadius1 = hAbility:GetSpecialValueFor("radius_1")
	self.iRadius2 = hAbility:GetSpecialValueFor("radius_2")
	self.iRadius3 = hAbility:GetSpecialValueFor("radius_3")
	self.fSpeedHorizontal = hAbility:GetSpecialValueFor("pull_speed")
	if self:GetCaster():HasAbility("special_bonus_hurricane_3") then
		self.fSpeedHorizontal = self.fSpeedHorizontal+self:GetCaster():FindAbilityByName("special_bonus_hurricane_3"):GetSpecialValueFor("value")
	end
	
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	hParent:EmitSound("n_creep_Wildkin.Tornado")
	self:StartIntervalThink(fDamageInterval)
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_hurricane_whirlewind:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local fDistance = (hParent:GetOrigin()-hCaster:GetOrigin()):Length2D()
	if hCaster:GetTeam() ~= hParent:GetTeam() then
		if fDistance < self.iRadius1 then
			ApplyDamage({attacker = hCaster, damage = self.fDamage1, damage_type = DAMAGE_TYPE_MAGICAL, victim = hParent, ability = hAbility})
		elseif fDistance < self.iRadius2 then
			ApplyDamage({attacker = hCaster, damage = self.fDamage2, damage_type = DAMAGE_TYPE_MAGICAL, victim = hParent, ability = hAbility})
		elseif fDistance < self.iRadius3 then
			ApplyDamage({attacker = hCaster, damage = self.fDamage3, damage_type = DAMAGE_TYPE_MAGICAL, victim = hParent, ability = hAbility})
		end
	end
	if not hAbility:IsChanneling() then self:Destroy() end
end

local function GetTangent(vRadical)
	local x = Vector(0,0,0).Dot(Vector(1, 0, 0), vRadical)
	local y = Vector(0,0,0).Dot(Vector(0, 1, 0), vRadical)
	local theta
	if x > 0 then
		theta = math.atan(y/x)
	else
		theta = math.atan(y/x)+math.pi
	end
	return Vector(math.cos(theta+math.pi/2), math.sin(theta+math.pi/2), 0)
end

function modifier_hurricane_whirlewind:UpdateHorizontalMotion(me, dt)
	local vRadical = (self:GetCaster():GetOrigin()-me:GetOrigin()):Normalized()
	me:SetOrigin(me:GetOrigin()+dt*(self.fSpeedHorizontal*vRadical+self.fSpeedHorizontal*2*GetTangent(vRadical)))
end

function modifier_hurricane_whirlewind:UpdateVerticalMotion(me, dt)	
	me:SetOrigin(GetGroundPosition(me:GetOrigin(), me))
end

function modifier_hurricane_whirlewind:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	ParticleManager:DestroyParticle(self.iParticle, true)
	hParent:StopSound("n_creep_Wildkin.Tornado")
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
end

modifier_hurricane_eyes_of_the_storm = class({})
function modifier_hurricane_eyes_of_the_storm:IsHidden() return true end
function modifier_hurricane_eyes_of_the_storm:IsPurgable() return false end
function modifier_hurricane_eyes_of_the_storm:RemoveOnDeath() return false end
function modifier_hurricane_eyes_of_the_storm:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_hurricane_eyes_of_the_storm:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:HasScepter() and hParent:HasAbility("hurricane_eyes_of_the_storm") then
		local iLevel = hParent:FindAbilityByName("hurricane_eyes_of_the_storm"):GetLevel()
		hParent:RemoveAbility("hurricane_eyes_of_the_storm")
		hParent:AddAbility("hurricane_eyes_of_the_storm_upgrade"):SetLevel(iLevel)
		self:Destroy()
	end
end

modifier_hurricane_eyes_of_the_storm_upgrade = class({})
function modifier_hurricane_eyes_of_the_storm_upgrade:IsHidden() return true end
function modifier_hurricane_eyes_of_the_storm_upgrade:IsPurgable() return false end
function modifier_hurricane_eyes_of_the_storm_upgrade:RemoveOnDeath() return false end

function modifier_hurricane_eyes_of_the_storm_upgrade:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_hurricane_eyes_of_the_storm_upgrade:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if not hParent:HasScepter() and hParent:HasAbility("hurricane_eyes_of_the_storm_upgrade") then
		local iLevel = hParent:FindAbilityByName("hurricane_eyes_of_the_storm_upgrade"):GetLevel()
		hParent:RemoveAbility("hurricane_eyes_of_the_storm_upgrade")
		hParent:AddAbility("hurricane_eyes_of_the_storm"):SetLevel(iLevel)
		self:Destroy()
	end
end

modifier_hurricane_sound_manager = class({})

function modifier_hurricane_sound_manager:IsPurgable() return false end
function modifier_hurricane_sound_manager:IsHidden() return true end

function modifier_hurricane_sound_manager:OnCreated()
	if IsClient() then return end
	self:GetParent():EmitSound('n_creep_Wildkin.Tornado')
	self:StartIntervalThink(30)
end

function modifier_hurricane_sound_manager:OnIntervalThink()
	if IsClient() then return end
	self:GetParent():StopSound('n_creep_Wildkin.Tornado')
	self:GetParent():EmitSound('n_creep_Wildkin.Tornado')
end

function modifier_hurricane_sound_manager:OnDestroy()
	if IsClient() then return end
	self:GetParent():StopSound('n_creep_Wildkin.Tornado')
end