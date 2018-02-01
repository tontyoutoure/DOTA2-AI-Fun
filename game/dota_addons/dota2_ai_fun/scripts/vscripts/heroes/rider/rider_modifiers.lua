
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
modifier_rider_backstab = class({})
function modifier_rider_backstab:IsHidden() return true end
function modifier_rider_backstab:RemoveOnDeath() return false end
function modifier_rider_backstab:IsPurgable() return false end
function modifier_rider_backstab:DeclareFunctions() return {MODIFIER_EVENT_ON_ORDER, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end

function modifier_rider_backstab:GetAttackSound() return "" end
function modifier_rider_backstab:OnAttackStart(keys)
	if keys.attacker ~= self:GetParent() then return end
	local vFront = Vector2D(keys.target:GetForwardVector()):Normalized()
	local vLine = Vector2D(keys.target:GetOrigin()-keys.attacker:GetOrigin()):Normalized()
	if keys.attacker:PassivesDisabled() or keys.target:IsBuilding() or (Vector(0,0,0).Dot(vFront, vLine)) < math.cos(self:GetAbility():GetSpecialValueFor("backstab_angle")/180*math.pi) then
		self.bBackstabbing = false	
	else
		StartAnimation(keys.attacker, {duration = 1.1/1.7/keys.attacker:GetAttacksPerSecond(), activity=ACT_DOTA_ATTACK_EVENT, rate=(keys.attacker:GetAttacksPerSecond()*1.7)*1})
		self.hAttackingTarget = keys.target
		self.bBackstabbing = true
	end
end

function modifier_rider_backstab:OnAttackLanded(keys) 
	if keys.attacker ~= self:GetParent() then return end
	if self.bBackstabbing then
		keys.attacker:EmitSound("Hero_ChaosKnight.ChaosStrike")
		keys.attacker:EmitSound("Hero_ChaosKnight.Attack")
		keys.attacker:EmitSound("Hero_ChaosKnight.Attack.Impact")
		local hSpecial = keys.attacker:FindAbilityByName("special_bonus_unique_rider_3")
		if hSpecial and hSpecial:GetLevel() > 0 then
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_bashed", {Duration = hSpecial:GetSpecialValueFor("value")*CalculateStatusResist(keys.target)})
		end
	else
		keys.attacker:EmitSound("Hero_ChaosKnight.Attack.Impact")
		keys.attacker:EmitSound("Hero_ChaosKnight.Attack")
	end
end

function modifier_rider_backstab:OnOrder(keys)
	if keys.unit ~= self:GetParent() then return end
	if tSafeOrder[keys.order_type] then return end
	if (keys.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and (not keys.ability or bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE)==0))
	or (keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.target ~= self.hAttackingTarget) then
		EndAnimation(keys.unit)
	end
end

function modifier_rider_backstab:GetModifierPreAttack_BonusDamage()
	if not IsClient() and self.bBackstabbing or self:GetParent():IsIllusion() then
		return self:GetAbility():GetSpecialValueFor("agility_multiplier")*self:GetParent():GetAgility()
	else
		return 0
	end
end

modifier_rider_bloodrage = class({})
function modifier_rider_bloodrage:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_rider_bloodrage:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end

function modifier_rider_bloodrage:CheckState() 
	if IsServer() then
		if not self.bFoundSpecial then
			self.hSpecial = Entities:First()	
			while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_rider_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
				self.hSpecial = Entities:Next(self.hSpecial)
			end	
			self.bFoundSpecial = true
		end
		if self.hSpecial and self.hSpecial:GetLevel() > 0 and self:GetParent():GetTeam() ~= self:GetCaster():GetTeam() then self:SetStackCount(-1) end
	end
	if self:GetStackCount() == 0 then
		return {[MODIFIER_STATE_SILENCED] = true} 
	else
		return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true}
	end
end

function modifier_rider_bloodrage:GetStatusEffectName() return "particles/status_fx/status_effect_bloodrage.vpcf" end
function modifier_rider_bloodrage:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_rider_bloodrage:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("damage_bonus_percentage") end
function modifier_rider_bloodrage:OnCreated()
	if IsClient() then return end
	if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
		self:StartIntervalThink(1)
	else
		self:StartIntervalThink(CalculateStatusResist(self:GetParent()))
	end
end
function modifier_rider_bloodrage:OnIntervalThink()
	local hAbility = self:GetAbility()
	ApplyDamage({damage = hAbility:GetSpecialValueFor("damage"), ability = hAbility, damage_type = hAbility:GetAbilityDamageType(), attacker = self:GetCaster(), victim = self:GetParent()})
end

function modifier_rider_bloodrage:IsDebuff() return true end
function modifier_rider_bloodrage:IsPurgable() return true end

modifier_rider_drag = class({})

function modifier_rider_drag:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true, 
		[MODIFIER_STATE_STUNNED] = true, 
		[MODIFIER_STATE_NO_HEALTH_BAR] = true, 
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end

function modifier_rider_drag:OnCreated()	
	if IsClient() then return end	
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local fRange = 20
	self.fX = RandomFloat(-fRange, fRange)
	self.fY = RandomFloat(-fRange, fRange)
	self.fZ = RandomFloat(-fRange, fRange)
	self:ApplyHorizontalMotionController()
	hParent:EmitSound("Hero_ShadowShaman.Shackles")
	self.iParticle = ParticleManager:CreateParticle("particles/shadowshaman_shackle.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 3, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 4, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 5, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 6, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true)
end

function modifier_rider_drag:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	hParent:RemoveHorizontalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
	ParticleManager:DestroyParticle(self.iParticle, true)
	hParent:StopSound("Hero_ShadowShaman.Shackles")
	if hCaster:HasScepter() then
		hParent:AddNewModifier(hCaster, hAbility, "modifier_stunned", {Duration = hAbility:GetSpecialValueFor("stun_duration_scepter")*CalculateStatusResist(hParent)})
	end
end

function modifier_rider_drag:UpdateHorizontalMotion(me, dt)
	local hCaster = self:GetCaster()
	local vForward = hCaster:GetForwardVector()
	local vUp = hCaster:GetUpVector()
	local vRight = Vector(0,0,0).Cross(vForward, vUp)
	me:SetOrigin(self:GetCaster():GetOrigin()+vForward*(self.fY)+vUp*(50+self.fZ)+vRight*(50+self.fX))
	if not hCaster:IsAlive() then 
		self:Destroy()
	end
end
modifier_rider_run_down = class({})
function modifier_rider_run_down:IsPurgable() return false end
function modifier_rider_run_down:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
function modifier_rider_run_down:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_ORDER} end
function modifier_rider_run_down:GetModifierMoveSpeedBonus_Constant() 
		if self.iAcceleration then
			return self.iAcceleration*self:GetStackCount()
		else
			return 0
		end
end
function modifier_rider_run_down:OnCreated(keys)
	self.iAcceleration = self:GetAbility():GetSpecialValueFor("acceleration")
	self:StartIntervalThink(1)
	self.iTargetEntIndex = keys.iTargetEntIndex
	if IsServer() then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = keys.iTargetEntIndex
		})
	end
end

function modifier_rider_run_down:OnIntervalThink()
	self:IncrementStackCount()
	if IsClient() then return end
	if not EntIndexToHScript(self.iTargetEntIndex):IsAlive() then
		self:Destroy()
	end
	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = self.iTargetEntIndex
	})
end
function modifier_rider_run_down:OnOrder(keys)
	if keys.unit ~= self:GetParent() then return end
	if tSafeOrder[keys.order_type] then return end
	if (keys.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and not keys.ability ) or (keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.target ~= EntIndexToHScript(self.iTargetEntIndex)) or (keys.ability and bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE)==0) then
		self:Destroy()
	end
end

function modifier_rider_run_down:OnDestroy()
	if IsServer() then
		EntIndexToHScript(self.iTargetEntIndex):RemoveModifierByNameAndCaster("modifier_rider_run_down_target", self:GetParent())
	end
end

modifier_rider_run_down_target = class({})
function modifier_rider_run_down_target:IsPurgable() return false end
function modifier_rider_run_down_target:IsHidden()
	return true
end
function modifier_rider_run_down_target:CheckState() return {[MODIFIER_STATE_INVISIBLE]=false} end
function modifier_rider_run_down_target:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_rider_run_down_target:GetModifierProvidesFOWVision() return 1 end
function modifier_rider_run_down_target:OnCreated()
	self:StartIntervalThink(0.04)
end

function modifier_rider_run_down_target:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hSpecial = hCaster:FindAbilityByName("special_bonus_unique_rider_4")
	if not hSpecial or hSpecial:GetLevel() == 0 then return end
	local fAngle = hSpecial:GetSpecialValueFor("value")/180*math.pi
	local vLine = hParent:GetOrigin() - hCaster:GetOrigin()
	if vLine:Length2D() > 600 then return end
	local vForward = hParent:GetForwardVector()
	if Vector(0,0,0).Dot(vLine:Normalized(), vForward) > math.cos(fAngle) then return end
	
	local vLeft = Vector(0,0,0).Cross(Vector(0,0,1), Vector2D(vLine):Normalized())
	local vRight = Vector(0,0,0).Cross(Vector2D(vLine):Normalized(), Vector(0,0,1))
	if Vector(0,0,0).Dot(vLeft, vLine) > Vector(0,0,0).Dot(vRight, vLine) then
		hParent:SetForwardVector(vLeft*math.sin(fAngle)+Vector2D(vLine):Normalized()*math.cos(fAngle))
	else
		hParent:SetForwardVector(vRight*math.sin(fAngle)+Vector2D(vLine):Normalized()*math.cos(fAngle))
	end
end
