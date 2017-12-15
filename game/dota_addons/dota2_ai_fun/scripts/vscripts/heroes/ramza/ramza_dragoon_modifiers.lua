modifier_ramza_dragoon_dragonheart = class({})

function modifier_ramza_dragoon_dragonheart:DeclareFunctions()
	return {MODIFIER_PROPERTY_REINCARNATION}
end

function modifier_ramza_dragoon_dragonheart:OnCreated()
	if IsClient() then return end
	local hAbility = self:GetAbility()
	self.fReincarnateTime = hAbility:GetSpecialValueFor("reincarnate_time")
end

function modifier_ramza_dragoon_dragonheart:IsHidden() return true end
function modifier_ramza_dragoon_dragonheart:IsPurgable() return false end
function modifier_ramza_dragoon_dragonheart:IsDebuff() return false end
function modifier_ramza_dragoon_dragonheart:RemoveOnDeath() return false end

function modifier_ramza_dragoon_dragonheart:ReincarnateTime()
	local bIsCooldownReady
	local hParent = self:GetParent()
	if IsClient() then return end
	if hParent:HasAbility("ramza_dragoon_dragonheart") then 
		bIsCooldownReady = hParent:FindAbilityByName("ramza_dragoon_dragonheart"):IsCooldownReady()
		if bIsCooldownReady then
			hParent:FindAbilityByName("ramza_dragoon_dragonheart"):UseResources(true, true, true)
			hParent.fReincarnateTime = self.fReincarnateTime
			return self.fReincarnateTime
		else
			return -1
		end
	else
		bIsCooldownReady = Time() > hParent.hRamzaJob.tPassiveCooldownReadyTime["ramza_dragoon_dragonheart"]
		if bIsCooldownReady then
			fCooldownMultiplier = 1
			if hParent:HasModifier("modifier_item_fun_angelic_alliance_halo") then
				if hParent:HasModifier("modifier_imbalanced_economizer") then
					fCooldownMultiplier = 0
				else
					fCooldownMultiplier = fCooldownMultiplier*0.2	
				end
			elseif hParent:HasModifier("modifier_item_fun_economizer_mcr") then 
				if hParent:HasModifier("modifier_imbalanced_economizer") then
					fCooldownMultiplier = 0
				else
					fCooldownMultiplier = fCooldownMultiplier*0.5
				end
			elseif hParent:HasModifier("modifier_item_octarine_core") then
				fCooldownMultiplier = fCooldownMultiplier*0.75
			end
			if hParent:HasModifier("modifier_rune_arcane") then fCooldownMultiplier = fCooldownMultiplier*0.7 end
			hParent.hRamzaJob.tPassiveCooldownReadyTime["ramza_dragoon_dragonheart"] = Time()+60*fCooldownMultiplier		
			hParent.fReincarnateTime = self.fReincarnateTime
			return self.fReincarnateTime
		else
			return -1
		end
	end

end

modifier_ramza_dragoon_jump = class({})

function modifier_ramza_dragoon_jump:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MUTED] = true,		
	}
end

function modifier_ramza_dragoon_jump:IsHidden() return true end
function modifier_ramza_dragoon_dragonheart:IsPurgable() return false end
function modifier_ramza_dragoon_dragonheart:IsDebuff() return false end

function modifier_ramza_dragoon_jump:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_ramza_dragoon_jump:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local fRadius = hAbility:GetSpecialValueFor("radius")
	local fDuration = hAbility:GetSpecialValueFor("duration")
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	hParent:SetOrigin(self.vDestination)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
		
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = hParent,
		damage = hAbility:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	if hParent:HasModifier("modifier_ramza_dragoon_polearm") then
		hParent:EmitSound("Hero_Centaur.HoofStomp")
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(fRadius, fRadius, fRadius))
		
		for k, v in pairs(tTargets) do
			v:AddNewModifier(hParent, hAbility, "modifier_stunned", {Duration = fDuration})
			damageTable.victim = v
			ApplyDamage(damageTable)
		end
	else
		hParent:EmitSound("Hero_Brewmaster.ThunderClap")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(fRadius, fRadius, fRadius))		
		
		for k, v in pairs(tTargets) do
			v:AddNewModifier(hParent, hAbility, "modifier_ramza_dragoon_jump_slow", {Duration = fDuration})
			damageTable.victim = v
			ApplyDamage(damageTable)
		end
	end
end

function modifier_ramza_dragoon_jump:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vHorizantalSpeed)
end

function modifier_ramza_dragoon_jump:UpdateVerticalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vVerticalSpeed+dt*dt*self.vVerticalAcceleration/2)
	self.vVerticalSpeed = self.vVerticalSpeed+dt*self.vVerticalAcceleration
end

modifier_ramza_dragoon_jump_slow = class({})

function modifier_ramza_dragoon_jump_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_ramza_dragoon_jump_slow:IsHidden() return false end
function modifier_ramza_dragoon_jump_slow:IsPurgable() return true end
function modifier_ramza_dragoon_jump_slow:GetTexture() return "brewmaster_storm_wind_walk" end
function modifier_ramza_dragoon_jump_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("move_slow") end
function modifier_ramza_dragoon_jump_slow:GetStatusEffectName() return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf" end







