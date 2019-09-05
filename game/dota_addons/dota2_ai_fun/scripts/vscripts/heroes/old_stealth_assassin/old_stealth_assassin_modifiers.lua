modifier_old_stealth_assassin_permanent_invisibility = class({})
function modifier_old_stealth_assassin_permanent_invisibility:IsPurgable() return false end
function modifier_old_stealth_assassin_permanent_invisibility:IsHidden() return true end
function modifier_old_stealth_assassin_permanent_invisibility:RemoveOnDeath() return false end
function modifier_old_stealth_assassin_permanent_invisibility:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_old_stealth_assassin_permanent_invisibility:OnCreated()
	if IsClient() then return end
	local fFadeTime = self:GetAbility():GetSpecialValueFor("fade_time")
	self:GetAbility():StartCooldown(fFadeTime)
	self.fTimeToFade = GameRules:GetGameTime() + fFadeTime
	self:StartIntervalThink(FrameTime())
end

function modifier_old_stealth_assassin_permanent_invisibility:OnIntervalThink()
	if self:GetParent():HasModifier("modifier_old_stealth_assassin_permanent_invisibility_invisible") or GameRules:GetGameTime() < self.fTimeToFade then return end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_old_stealth_assassin_permanent_invisibility_invisible", {})
	ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf",PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_old_stealth_assassin_permanent_invisibility:OnAbilityExecuted(keys)
	if keys.unit ~= self:GetParent() or (keys.unit:HasAbility("special_bonus_unique_old_stealth_assassin_5") and keys.unit:FindAbilityByName("special_bonus_unique_old_stealth_assassin_5"):GetLevel() > 0 ) then return end
	keys.unit:RemoveModifierByName("modifier_old_stealth_assassin_permanent_invisibility_invisible")
	local fFadeTime = self:GetAbility():GetSpecialValueFor("fade_time")
	self:GetAbility():StartCooldown(fFadeTime)
	self.fTimeToFade = GameRules:GetGameTime() + fFadeTime	
end

function modifier_old_stealth_assassin_permanent_invisibility:OnAttack(keys)
	if keys.attacker ~= self:GetParent() or (keys.attacker:HasAbility("special_bonus_unique_old_stealth_assassin_5") and keys.attacker:FindAbilityByName("special_bonus_unique_old_stealth_assassin_5"):GetLevel() > 0 ) then return end
	keys.attacker:RemoveModifierByName("modifier_old_stealth_assassin_permanent_invisibility_invisible")
	local fFadeTime = self:GetAbility():GetSpecialValueFor("fade_time")
	self:GetAbility():StartCooldown(fFadeTime)
	self.fTimeToFade = GameRules:GetGameTime() + fFadeTime	
end

modifier_old_stealth_assassin_permanent_invisibility_invisible = class({})

function modifier_old_stealth_assassin_permanent_invisibility_invisible:CheckState() return {[MODIFIER_STATE_INVISIBLE] = true} end

function modifier_old_stealth_assassin_permanent_invisibility_invisible:IsPurgable() return false end
function modifier_old_stealth_assassin_permanent_invisibility_invisible:IsHidden() return false end
function modifier_old_stealth_assassin_permanent_invisibility_invisible:RemoveOnDeath() return false end
function modifier_old_stealth_assassin_permanent_invisibility_invisible:DeclareFunctions() return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end

function modifier_old_stealth_assassin_permanent_invisibility_invisible:GetModifierInvisibilityLevel()
	return 1
end

local function CheckForCritChance(hModifier)
	local iChance = hModifier:GetAbility():GetSpecialValueFor("crit_chance")
	if iChance == 0 then return false end
	if hModifier:GetParent():HasAbility("special_bonus_unique_old_stealth_assassin_3")then 
		iChance = iChance+hModifier:GetParent():FindAbilityByName("special_bonus_unique_old_stealth_assassin_3"):GetSpecialValueFor("value")
	end
	if not hModifier.iChance or hModifier.iChance ~= iChance then
		hModifier.iChance = iChance
		hModifier.hRNG = PseudoRNG.create(iChance/100)		
	end
	return true
end

modifier_old_stealth_assassin_critical_strike = class({})
function modifier_old_stealth_assassin_critical_strike:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
end 

function modifier_old_stealth_assassin_critical_strike:IsPurgable() return false end
function modifier_old_stealth_assassin_critical_strike:IsHidden() return true end
function modifier_old_stealth_assassin_critical_strike:RemoveOnDeath() return false end
function modifier_old_stealth_assassin_critical_strike:OnCreated()
	if IsClient() then return end
	CheckForCritChance(self)
	self.tCritRecords = {}
end

function modifier_old_stealth_assassin_critical_strike:OnAttackStart(keys)
	if self:GetParent() ~= keys.attacker then return end
	if not CheckForCritChance(self) then return end
	self.bCrit = false
	if keys.target:GetTeam()~=keys.attacker:GetTeam() and not keys.target:IsBuilding() and self.hRNG:Next() then
		self.bCrit = true
		if keys.attacker:GetModelName() == "models/heroes/rikimaru/rikimaru.vmdl" then
			StartAnimation(keys.attacker, {translate = "backstab", duration = 0.733/1.7/keys.attacker:GetAttacksPerSecond(), activity=ACT_DOTA_ATTACK, rate=(keys.attacker:GetAttacksPerSecond()*1.7)*1})
		end
		self.hAttackingTarget = keys.target
	end
end

local tSafeOrder
if IsServer() then
tSafeOrder = {
	[DOTA_UNIT_ORDER_TRAIN_ABILITY] = true, 
	[DOTA_UNIT_ORDER_PURCHASE_ITEM] = true, 
	[DOTA_UNIT_ORDER_SELL_ITEM] = true, 
	[DOTA_UNIT_ORDER_DISASSEMBLE_ITEM] = true, 
	[DOTA_UNIT_ORDER_MOVE_ITEM] = true, 
	[DOTA_UNIT_ORDER_TAUNT] = true, 
	[DOTA_UNIT_ORDER_GLYPH] = true, 
	[DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH] = true, 
	[DOTA_UNIT_ORDER_PING_ABILITY] = true, 
	[DOTA_UNIT_ORDER_RADAR] = true, 
	[DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK] = true,
}
end

function modifier_old_stealth_assassin_critical_strike:OnOrder(keys)
	if keys.unit ~= self:GetParent() or keys.unit:GetModelName() ~= "models/heroes/rikimaru/rikimaru.vmdl" then return end
	if tSafeOrder[keys.order_type] then return end
	if (keys.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and (not keys.ability or bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE)==0))
	or (keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.target ~= self.hAttackingTarget) then
		EndAnimation(keys.unit)
	end
end

function modifier_old_stealth_assassin_critical_strike:GetModifierPreAttack_CriticalStrike(keys)
	if self.bCrit then
		self.bCrit = false
		self.tCritRecords[keys.record] = true
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	else
		return false
	end
end

function modifier_old_stealth_assassin_critical_strike:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker then return end
	if self.tCritRecords[keys.record] then
		keys.attacker:EmitSound("Hero_Riki.Backstab")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
		ParticleManager:SetParticleControlEnt(iParticle, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
		self.tCritRecords[keys.record] = nil
	end
end

modifier_old_stealth_assassin_death_ward = class({})
function modifier_old_stealth_assassin_death_ward:IsPurgable() return false end
function modifier_old_stealth_assassin_death_ward:IsHidden() return true end
function modifier_old_stealth_assassin_death_ward:RemoveOnDeath() return true end

function modifier_old_stealth_assassin_death_ward:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, 
		MODIFIER_EVENT_ON_ATTACK, 
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_EVENT_ON_ORDER,
	}
end

function modifier_old_stealth_assassin_death_ward:GetDisableAutoAttack()
	return 1
end
function modifier_old_stealth_assassin_death_ward:OnAttackStart(keys)
	if self:GetParent() ~= keys.attacker then return end
end

function modifier_old_stealth_assassin_death_ward:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker then return end
	if self.bHasScepter then	
		local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("ward_splash_radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)		
		for i, v in ipairs(tTargets) do
			if v ~= keys.target and (v:GetOrigin()-keys.target:GetOrigin()):Length2D() < 150 then
				ApplyDamage({
					attacker = keys.attacker,
					victim = v,
					damage = keys.damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
				})
			elseif v ~= keys.target and (v:GetOrigin()-keys.target:GetOrigin()):Length2D() < 200 then
				ApplyDamage({
					attacker = keys.attacker,
					victim = v,
					damage = keys.damage/2,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
				})
			else
				ApplyDamage({
					attacker = keys.attacker,
					victim = v,
					damage = keys.damage/4,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
				})
			end
		end	
	end

end

function modifier_old_stealth_assassin_death_ward:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self:StartIntervalThink(FrameTime())
	self.iParticle1 = ParticleManager:CreateParticle("particles/old_stealth_assassin/old_stealth_assassin_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.bHasScepter = self:GetCaster():HasScepter()
	self.iTargetCount = self:GetAbility():GetSpecialValueFor("target_count")
	if self.bHasScepter then
		self.iRadius = self:GetAbility():GetSpecialValueFor("ward_attack_range_scepter")
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("ward_attack_range_scepter")-self:GetAbility():GetSpecialValueFor("ward_attack_range"))
	else
		self.iRadius = self:GetAbility():GetSpecialValueFor("ward_attack_range")
	end
	ParticleManager:SetParticleControl(self.iParticle1, 1, Vector(self.iRadius,0,self.iRadius))
	ParticleManager:SetParticleControl(self.iParticle1, 2, Vector(250,0,0))
	hParent:EmitSound("Hero_Riki.TricksOfTheTrade")
	
	ExecuteOrderFromTable({
		UnitIndex = hParent:entindex(),		
 		OrderType = DOTA_UNIT_ORDER_STOP,		
	})
	
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)	
	
	if #tTargets > 0 then
		ExecuteOrderFromTable({
			UnitIndex = hParent:entindex(),		
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,		
			TargetIndex = tTargets[1]:entindex()
		})
		self.hTarget = tTargets[1]
	else
		self.hTarget = nil
	end	
end

function modifier_old_stealth_assassin_death_ward:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if not hParent:GetAttackTarget() then
		if self.hSecondaryTarget and self.hSecondaryTarget then
			ExecuteOrderFromTable({
				UnitIndex = hParent:entindex(),		
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,		
				TargetIndex = self.hSecondaryTarget:entindex()
			})			
			self.hSecondaryTarget = nil
		else	
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)	
			
			if #tTargets > 0 then
				ExecuteOrderFromTable({
					UnitIndex = hParent:entindex(),		
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,		
					TargetIndex = tTargets[1]:entindex()
				})
			else
				self.hTarget = nil
			end	
		end
	end
end

function modifier_old_stealth_assassin_death_ward:OnAttack(keys)
	if self.iTargetCount < 2 or self.bSecondaryAttack then return end
	self.bSecondaryAttack = true
	local hParent = self:GetParent()
	if self.hSecondaryTarget and self.hSecondaryTarget:IsAlive() and not self.hSecondaryTarget:IsAttackImmune() and (self.hSecondaryTarget:GetOrigin()-hParent:GetOrigin()):Length2D() < self.iRadius then
		hParent:PerformAttack(self.hSecondaryTarget, true, true, true, false, true, false, false)
	else
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		for i, v in ipairs(tTargets) do
			if v == self.hTarget then
				table.remove(tTargets, i)
			end
		end
		if #tTargets > 0 then
			self.hSecondaryTarget = tTargets[1]
			hParent:PerformAttack(self.hSecondaryTarget, true, true, true, false, true, false, false)
		else
			self.hSecondaryTarget = nil
		end
	end
	
	self.bSecondaryAttack = false
end

function modifier_old_stealth_assassin_death_ward:OnOrder(keys)
	if keys.unit~= self:GetParent() then return end
	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		self.hTarget = keys.target
	end
end


function modifier_old_stealth_assassin_death_ward:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle1, true)
	self:GetParent():StopSound("Hero_Riki.TricksOfTheTrade")
end


function modifier_old_stealth_assassin_death_ward:GetModifierAttackRangeBonus()
	return self:GetStackCount()
end
