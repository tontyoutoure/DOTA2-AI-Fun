modifier_exsoldier_braver_fly = class({})

function modifier_exsoldier_braver_fly:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MUTED] = true,	
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
end

function modifier_exsoldier_braver_fly:IsHidden() return true end
function modifier_exsoldier_braver_fly:IsPurgable() return false end
function modifier_exsoldier_braver_fly:IsDebuff() return false end

function modifier_exsoldier_braver_fly:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_exsoldier_braver_fly:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local fRadius = hAbility:GetSpecialValueFor("radius")
	local fDuration = hAbility:GetSpecialValueFor("stun_duration")
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	hParent:SetOrigin(self.vDestination)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	GridNav:DestroyTreesAroundPoint(self.vDestination, fRadius, true)
	
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local sParticlePath = "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf"
	if hParent:HasAbility("special_bonus_unique_exsoldier_2") and hParent:FindAbilityByName("special_bonus_unique_exsoldier_2"):GetLevel()>0 then		
		local iFlag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		sParticlePath = "particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf"
	end
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = hParent,
		damage = hAbility:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	hParent:EmitSound("Hero_Centaur.HoofStomp")
	local iParticle = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(fRadius, fRadius, fRadius))
	
	for k, v in pairs(tTargets) do
		v:AddNewModifier(hParent, hAbility, "modifier_stunned", {Duration = fDuration*CalculateStatusResist(v)})
		damageTable.victim = v
		ApplyDamage(damageTable)
	end

end

function modifier_exsoldier_braver_fly:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vHorizantalSpeed)
end

function modifier_exsoldier_braver_fly:UpdateVerticalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vVerticalSpeed+dt*dt*self.vVerticalAcceleration/2)
	self.vVerticalSpeed = self.vVerticalSpeed+dt*self.vVerticalAcceleration
end

modifier_exsoldier_omnislash = class({})

function modifier_exsoldier_omnislash:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE	
	}
end

function modifier_exsoldier_omnislash:GetModifierPreAttack_CriticalStrike()
	return self:GetAbility():GetSpecialValueFor("crit")
end

function modifier_exsoldier_omnislash:IsAura() return true end
function modifier_exsoldier_omnislash:GetModifierAura() return "modifier_truesight" end
function modifier_exsoldier_omnislash:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_exsoldier_omnislash:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_exsoldier_omnislash:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_exsoldier_omnislash:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("truesight_radius") end
function modifier_exsoldier_omnislash:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_DISARMED] = true, 
		[MODIFIER_STATE_SILENCED] = true,} end
function modifier_exsoldier_omnislash:IsHidden() return false end
function modifier_exsoldier_omnislash:IsPurgable() return false end
function modifier_exsoldier_omnislash:GetStatusEffectName() return "particles/status_fx/status_effect_omnislash.vpcf" end

local function OmnislashDoAttack(hHero, hModifier)
	local fRadius = hModifier:GetAbility():GetSpecialValueFor("search_radius")
	local tTargets = FindUnitsInRadius(hHero:GetTeamNumber(), hHero:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #tTargets == 0 then return false end
	local vOriginalLocation = hHero:GetOrigin()
	local hTarget = tTargets[RandomInt(1, #tTargets)]
	local vDestination = hTarget:GetOrigin()+Vector2D(RandomVector(1)):Normalized()*150
	hHero:SetOrigin(vDestination)
	Timers:CreateTimer(0.04, function ()
		hHero:SetForwardVector(hTarget:GetOrigin()-vDestination)
		hTarget:EmitSound("Hero_Juggernaut.OmniSlash")
		hTarget:EmitSound("Hero_Sven.Attack.Ring")
		hTarget:EmitSound("Hero_Sven.Attack.Impact")
		hHero:PerformAttack(hTarget, true, true, true, true, false, false, false)
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hTarget, PATTACH_POINT, 'follow_overhead' ,hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,hTarget:GetAbsOrigin(), true)
		
		local iParticle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(iParticle2, 0, hTarget, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticle2, 1, vOriginalLocation)
		hModifier:IncrementStackCount()
		StartAnimation(hHero, {activity = ACT_DOTA_ATTACK, duration = 0.1, rate = 10})
		ExecuteOrderFromTable({
				UnitIndex = hHero:entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP
		})
	end)
	return true
end

function modifier_exsoldier_omnislash:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()	
	
	self.iMaxAttackCount = self:GetAbility():GetSpecialValueFor("attack_count")
	if hParent:HasScepter() then
		self.iMaxAttackCount = self:GetAbility():GetSpecialValueFor("attack_count_scepter")
	end
	if hParent:HasAbility("special_bonus_unique_exsoldier_3") then
		self.iMaxAttackCount = self.iMaxAttackCount+hParent:FindAbilityByName("special_bonus_unique_exsoldier_3"):GetSpecialValueFor("value")
	end
	
	self.vStartPoint = hParent:GetOrigin()
	if not OmnislashDoAttack(hParent, self) then self:Destroy() return end
	self:StartIntervalThink(0.3)
end

function modifier_exsoldier_omnislash:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if self:GetStackCount() >= self.iMaxAttackCount or not OmnislashDoAttack(self:GetParent(), self) then
		self:Destroy() 
		return
	end
end

function modifier_exsoldier_omnislash:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:SetOrigin(self.vStartPoint)
end
modifier_exsoldier_sword_manager = class({})
function modifier_exsoldier_sword_manager:DeclareFunctions()
	return {MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_DEATH, MODIFIER_EVENT_ON_MODEL_CHANGED}
end

function modifier_exsoldier_sword_manager:OnCreated()
	if IsClient() then return end
	self.sOriginalModel = self:GetParent():GetModelName()
	self:StartIntervalThink(0.1)
end

function modifier_exsoldier_sword_manager:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:IsInvisible() then
		if not self.bWasInvisible then
			self.hSword:AddEffects(EF_NODRAW)
			self.bWasInvisible = true
		end
	else
		if self.bWasInvisible then
			self.hSword:RemoveEffects(EF_NODRAW)
			self.bWasInvisible = false
		end
	end
end

function modifier_exsoldier_sword_manager:OnModelChanged(keys)
	if keys.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	if hParent:GetModelName() ~= self.sOriginalModel then
		self.hSword:RemoveSelf()
	else
		self.hSword = Attachments:AttachProp(hParent, "attach_sword", "models/items/sven/shattered_greatsword/sven_shattered_greatsword.vmdl", hParent:GetModelScale()*1.5, {
			pitch = 0,
			yaw = 0,
			roll = -105.0,
			XPos = -35,
			YPos = 0,
			ZPos = 0,
			Animation = "idle"
		})
	end
end

function modifier_exsoldier_sword_manager:GetAttackSound()
	return "Hero_Sven.Attack.Impact"
end

function modifier_exsoldier_sword_manager:OnDeath()
	if self:GetParent():IsIllusion() then
		self.hSword:AddEffects(EF_NODRAW)
	end
end
function modifier_exsoldier_sword_manager:RemoveOnDeath() return false end
function modifier_exsoldier_sword_manager:IsPurgable() return false end
function modifier_exsoldier_sword_manager:IsHidden() return true end

function modifier_exsoldier_sword_manager:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker then return end
	keys.attacker:EmitSound("Hero_Sven.Attack.Ring")
	keys.attacker:EmitSound("Hero_Sven.Attack.Ring")
	keys.attacker:EmitSound("Hero_Sven.Attack.Impact")
	keys.attacker:EmitSound("Hero_Sven.Attack.Impact")
end