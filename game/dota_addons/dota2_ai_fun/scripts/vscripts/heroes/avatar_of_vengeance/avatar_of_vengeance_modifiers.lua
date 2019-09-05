modifier_avatar_of_vengeance_phase=class({})
function modifier_avatar_of_vengeance_phase:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	if hCaster:HasAbility("special_bonus_unique_avatar_of_vengeance_3") then
		self:SetStackCount(-self:GetAbility():GetSpecialValueFor("move_speed_bonus_percentage")-hCaster:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_3"):GetSpecialValueFor("value"))
	else
		self:SetStackCount(-self:GetAbility():GetSpecialValueFor("move_speed_bonus_percentage"))
	end
end
function modifier_avatar_of_vengeance_phase:CheckState()
	return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
end
function modifier_avatar_of_vengeance_phase:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_avatar_of_vengeance_phase:GetModifierMoveSpeedBonus_Percentage() return -self:GetStackCount() end
function modifier_avatar_of_vengeance_phase:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_avatar_of_vengeance_phase:GetEffectName() return "particles/avatar_of_vengeance/phase_boots_ti6.vpcf" end

modifier_avatar_of_vengeance_reality = class({})

function modifier_avatar_of_vengeance_reality:IsHidden() return false end
function modifier_avatar_of_vengeance_reality:IsPurgable() return false end

modifier_avatar_of_vengeance_dispersion = class({})
function modifier_avatar_of_vengeance_dispersion:IsHidden() return true end
function modifier_avatar_of_vengeance_dispersion:AllowIllusionDuplicate() return false end

function modifier_avatar_of_vengeance_dispersion:DeclareFunctions()
	return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE}
end


function modifier_avatar_of_vengeance_dispersion:GetAbsoluteNoDamagePhysical(keys)
	if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL or keys.target:PassivesDisabled() or keys.target:IsIllusion() then return 0 end
	local hAbility = self:GetAbility()
	local iProcChance = hAbility:GetSpecialValueFor("proc_chance")
	if keys.target:HasAbility("special_bonus_unique_avatar_of_vengeance_5") then iProcChance = iProcChance+keys.target:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_5"):GetSpecialValueFor("value") end
	if RandomFloat(0,100)<iProcChance then
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == 0 then
			for i, v in ipairs(FindUnitsInRadius(keys.target:GetTeamNumber(), keys.target:GetOrigin(), nil, hAbility:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				ApplyDamage({damage=keys.damage, damage_type=DAMAGE_TYPE_PURE,damage_flags=DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, ability=hAbility, victim=v,attacker=keys.target})
				v:AddNewModifier(keys.target, hAbility, "modifier_stunned", {Duration = hAbility:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
				local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_dispersion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.target)
				ParticleManager:SetParticleControlEnt(iParticle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
			end
		end
		return 1
	end
	return 0
end
function modifier_avatar_of_vengeance_dispersion:GetAbsoluteNoDamageMagical(keys)
	if keys.damage_type ~= DAMAGE_TYPE_MAGICAL or keys.target:PassivesDisabled() or keys.target:IsIllusion() then return 0 end
	local hAbility = self:GetAbility()
	local iProcChance = hAbility:GetSpecialValueFor("proc_chance")
	if keys.target:HasAbility("special_bonus_unique_avatar_of_vengeance_5") then iProcChance = iProcChance+keys.target:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_5"):GetSpecialValueFor("value") end
	if RandomFloat(0,100)<iProcChance then
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == 0 then
			for i, v in ipairs(FindUnitsInRadius(keys.target:GetTeamNumber(), keys.target:GetOrigin(), nil, hAbility:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				ApplyDamage({damage=keys.damage, damage_type=DAMAGE_TYPE_PURE,damage_flags=DOTA_DAMAGE_FLAG_REFLECTION, ability=hAbility, victim=v,attacker=keys.target})
				v:AddNewModifier(keys.target, hAbility, "modifier_stunned", {Duration = hAbility:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
				local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_dispersion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.target)
				ParticleManager:SetParticleControlEnt(iParticle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
			end
		end
		return 1
	end
	return 0
end
function modifier_avatar_of_vengeance_dispersion:GetAbsoluteNoDamagePure(keys)
	if keys.damage_type ~= DAMAGE_TYPE_PURE or keys.target:PassivesDisabled() or keys.target:IsIllusion() then return 0 end
	local hAbility = self:GetAbility()
	local iProcChance = hAbility:GetSpecialValueFor("proc_chance")
	if keys.target:HasAbility("special_bonus_unique_avatar_of_vengeance_5") then iProcChance = iProcChance+keys.target:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_5"):GetSpecialValueFor("value") end
	if RandomFloat(0,100)<iProcChance then
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == 0 then
			for i, v in ipairs(FindUnitsInRadius(keys.target:GetTeamNumber(), keys.target:GetOrigin(), nil, hAbility:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				ApplyDamage({damage=keys.damage, damage_type=DAMAGE_TYPE_PURE,damage_flags=DOTA_DAMAGE_FLAG_REFLECTION, ability=hAbility, victim=v,attacker=keys.target})
				v:AddNewModifier(keys.target, hAbility, "modifier_stunned", {Duration = hAbility:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
				local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_dispersion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.target)
				ParticleManager:SetParticleControlEnt(iParticle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
			end
		end
		return 1
	end
	return 0
end

modifier_avatar_of_vengeance_vengeance_aura = class({})
function modifier_avatar_of_vengeance_vengeance_aura:IsHidden() return true end
function modifier_avatar_of_vengeance_vengeance_aura:IsAura() return true end

function modifier_avatar_of_vengeance_vengeance_aura:GetModifierAura()
	if self:GetAbility():GetLevel() > 0 then
		return "modifier_avatar_of_vengeance_vengeance"
	else
		return ""
	end
end
function modifier_avatar_of_vengeance_vengeance_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_avatar_of_vengeance_vengeance_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_avatar_of_vengeance_vengeance_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_avatar_of_vengeance_vengeance_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

modifier_avatar_of_vengeance_vengeance=class({})
function modifier_avatar_of_vengeance_vengeance:IsHidden() return false end
function modifier_avatar_of_vengeance_vengeance:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end


local function VengeanceFireProjectile(hSource, hTarget, hAbility)
	ProjectileManager:CreateTrackingProjectile({
		Target = hTarget,
		Source = hSource,
		Ability = hAbility,	
		EffectName = "particles/avatar_of_vengeance/skeletonking_hellfireblast.vpcf",
		iMoveSpeed = hAbility:GetSpecialValueFor("projectile_speed"),
		vSourceLoc= hSource:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = false,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 40,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
		ExtraData={IsHero=hSource:IsHero()}
	})
	hSource:EmitSound("Hero_Necrolyte.Attack")
end

function modifier_avatar_of_vengeance_vengeance:OnDeath(keys)
--	PrintTable(keys)
	if keys.unit ~= self:GetParent() or self:GetCaster():PassivesDisabled() or keys.unit:IsIllusion() or keys.reincarnate then return end
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	if hAbility.tTargets and #hAbility.tTargets>0 then
		if hCaster:HasScepter() then
			for k, v in ipairs(hAbility.tTargets) do				
				VengeanceFireProjectile(keys.unit, v, hAbility)
			end
		else
			local iDistance=99999
			local hTarget
			for k, v in pairs(hAbility.tTargets) do
				if iDistance > (v:GetOrigin()-keys.unit:GetOrigin()):Length2D() then
					iDistance = (v:GetOrigin()-keys.unit:GetOrigin()):Length2D()
					hTarget = v
				end				
			end				
			VengeanceFireProjectile(keys.unit, hTarget, hAbility)
		end
	elseif keys.attacker:GetTeam() ~= keys.unit:GetTeam() and not keys.attacker:IsBuilding() then
		VengeanceFireProjectile(keys.unit, keys.attacker, hAbility)
	end
end
modifier_avatar_of_vengeance_direct_vengeance =class({})
function modifier_avatar_of_vengeance_direct_vengeance:OnCreated()
	if IsClient() then return end
	local hVengeance = self:GetCaster():FindAbilityByName("avatar_of_vengeance_vengeance")
	hVengeance.tTargets = hVengeance.tTargets or {}
	table.insert(hVengeance.tTargets, self:GetParent())
end

function modifier_avatar_of_vengeance_direct_vengeance:OnDestroy()
	if IsClient() then return end
	local hVengeance = self:GetCaster():FindAbilityByName("avatar_of_vengeance_vengeance")
	for k, v in ipairs(hVengeance.tTargets) do
		if v == self:GetParent() then
			table.remove(hVengeance.tTargets, k)
		end
	end
end

function modifier_avatar_of_vengeance_direct_vengeance:IsPurgable() return false end
function modifier_avatar_of_vengeance_direct_vengeance:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_avatar_of_vengeance_direct_vengeance:GetEffectName() return "particles/avatar_of_vengeance/skeletonking_hellfireblast_debuff.vpcf" end

local tAddModifierList = {"modifier_dragon_knight_dragon_form", "modifier_lone_druid_true_form", "modifier_terrorblade_metamorphosis", "modifier_legion_commander_duel_damage_boost", "modifier_silencer_int_steal", "modifier_pudge_flesh_heap", "modifier_item_armlet_unholy_strength"}
local function HauntInstance(hModifier)
	local hAbility = hModifier:GetAbility()
	local hCaster = hModifier:GetCaster()
	local hParent = hModifier:GetParent()
	local vPos = GetGroundPosition(Vector2D(hCaster:GetOrigin()-hParent:GetOrigin()):Normalized()*50+hParent:GetOrigin(), hCaster)
	local vForward = Vector2D(hParent:GetOrigin()-hCaster:GetOrigin()):Normalized()
	if hCaster:HasModifier("modifier_avatar_of_vengeance_reality") then
		hParent:AddNewModifier(hCaster, hAbility, "modifier_avatar_of_vengeance_haunt_freeze", {Duration=hModifier.fStunShort*CalculateStatusResist(hParent)})
		FindClearSpaceForUnit(hCaster, vPos, true)
		hCaster:SetForwardVector(vForward)
		hCaster:MoveToTargetToAttack(hParent)
		hCaster:EmitSound("Hero_Spectre.Reality")
		if not hCaster:HasAbility("special_bonus_unique_avatar_of_vengeance_2") or hCaster:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_2"):GetLevel() == 0 then
			hModifier:Destroy()
		end
	else
		local iStunDuration
		if hParent:CanEntityBeSeenByMyTeam(hCaster) then
			iStunDuration = hModifier.fStunShort
		else
			iStunDuration = hModifier.fStunLong
		end
		hParent:AddNewModifier(hCaster, hAbility, "modifier_avatar_of_vengeance_haunt_freeze", {Duration=iStunDuration*CalculateStatusResist(hParent)})
		local tIllusion = CreateIllusions(hCaster, hCaster, {duration = iStunDuration, outgoing_damage = hModifier.fOutgoing-100, incoming_damage = hModifier.fIncoming-100, bounty_base = 0, bounty_growth=2}, 1, 1, true, true);
		
		tIllusion[1]:SetForwardVector(vForward)
		tIllusion[1]:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(tIllusion[1], vPos, true) 
		Timers:CreateTimer(0.04, function () hIllusion:MoveToTargetToAttack(hParent) end)
		tIllusion[1]:EmitSound("Hero_Spectre.Haunt")
		tIllusion[1]:AddNewModifier(hCaster, hAbility, 'modifier_avatar_of_vengeance_haunt_uncontrollable', nil)
		
	end
	
	hModifier:DecrementStackCount()
end

modifier_avatar_of_vengeance_haunt = class({})
function modifier_avatar_of_vengeance_haunt:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_avatar_of_vengeance_haunt:OnTooltip() return self:GetStackCount() end
function modifier_avatar_of_vengeance_haunt:IsPurgable() return false end
function modifier_avatar_of_vengeance_haunt:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_avatar_of_vengeance_haunt:OnCreated()
	if IsClient() then return end
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.fStunShort = hAbility:GetSpecialValueFor("haunt_duration_see")
	self.fStunLong = hAbility:GetSpecialValueFor("haunt_duration_cannot_see")
	self.fIntervalMin = hAbility:GetSpecialValueFor("haunt_interval_min")
	self.fIntervalMax = hAbility:GetSpecialValueFor("haunt_interval_max")
	if hCaster:HasAbility("special_bonus_unique_avatar_of_vengeance_1") then
		self.fStunShort=self.fStunShort+hCaster:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_1"):GetSpecialValueFor("value")
		self.fStunLong=self.fStunLong+hCaster:FindAbilityByName("special_bonus_unique_avatar_of_vengeance_1"):GetSpecialValueFor("value")
	end
	self.fOutgoing = hAbility:GetSpecialValueFor("illusion_damage_outgoing")
	self.fIncoming = hAbility:GetSpecialValueFor("illusion_damage_incoming")	
	self:SetStackCount(hAbility:GetSpecialValueFor("haunt_count"))
	self:StartIntervalThink(RandomFloat(self.fIntervalMin, self.fIntervalMax))
	HauntInstance(self)
end
function modifier_avatar_of_vengeance_haunt:OnIntervalThink()
	if IsClient() then return end
	HauntInstance(self)
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
	self:StartIntervalThink(RandomFloat(self.fIntervalMin, self.fIntervalMax))
end
modifier_avatar_of_vengeance_haunt_freeze = class({})
function modifier_avatar_of_vengeance_haunt_freeze:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true} end
function modifier_avatar_of_vengeance_haunt_freeze:GetStatusEffectName() return "particles/avatar_of_vengeance/status_effect_haunt_freeze.vpcf" end

modifier_avatar_of_vengeance_haunt_uncontrollable = class({})
function modifier_avatar_of_vengeance_haunt_uncontrollable:IsHidden() return true end
function modifier_avatar_of_vengeance_haunt_uncontrollable:IsPurgable() return false end
function modifier_avatar_of_vengeance_haunt_uncontrollable:RemoveOnDeath() return true end
function modifier_avatar_of_vengeance_haunt_uncontrollable:CheckState() return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,[MODIFIER_STATE_COMMAND_RESTRICTED] = true} end


