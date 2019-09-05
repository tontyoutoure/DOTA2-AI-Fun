LinkLuaModifier("modifier_old_silencer_infernal_permanent_immolation", "heroes/old_silencer/old_silencer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_silencer_infernal_permanent_immolation_aura", "heroes/old_silencer/old_silencer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_silencer_silencer", "heroes/old_silencer/old_silencer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_silencer_silencer_mute", "heroes/old_silencer/old_silencer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_silencer_silencer_silence", "heroes/old_silencer/old_silencer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


old_silencer_star_storm = class({})

function old_silencer_star_storm:OnSpellStart()
	local hCaster = self:GetCaster()
	local iDamageType = self:GetAbilityDamageType()
	local fDamage = self:GetSpecialValueFor("damage")+CheckTalent(hCaster, "special_bonus_unique_old_silencer_1")
	local tTargets =  FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, true)	
	hCaster:EmitSound("Hero_Mirana.Starstorm.Cast")
	ParticleManager:CreateParticle("particles/old_silencer/old_silencer_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	for k, v in ipairs(tTargets) do	
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		Timers:CreateTimer(0.57, function () 			
			v:EmitSound("Hero_Mirana.Starstorm.Impact")
			ApplyDamage({
				attacker = hCaster,
				victim = v,
				damage = fDamage,
				damage_type = iDamageType,
				ability = self			
			})
		end)
	end
end

old_silencer_healing_wave = class({})

function old_silencer_healing_wave:GetCooldown(iLevel)
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_silencer_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

local function OldSilencerHealSingleTarget(hFrom, tHealedTargets, fHeal, fDeduction, iBounceLeft, fJumpInterval, hCaster)
	local tTargets = FindUnitsInRadius(hFrom:GetTeamNumber(), hFrom:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	table.sort(tTargets, function (hUnita, hUnitb) return hUnita:GetMaxHealth()-hUnita:GetHealth() > hUnitb:GetMaxHealth()-hUnitb:GetHealth() end)
	local hTo
		
	for j = 1, #tTargets do
		local bFound = true
		for i = 1, #tHealedTargets do
			if tTargets[j] == tHealedTargets[i] then 
				bFound = false 
				break
			end
		end
		if bFound then
			hTo = tTargets[j]
			break 
		end
	end
	
	if hTo then
		local fHealAmount
		if hTo:GetMaxHealth()-hTo:GetHealth() > fHeal then
			fHealAmount = fHeal
		else
			fHealAmount = hTo:GetMaxHealth()-hTo:GetHealth()
		end
		
		
		hTo:Heal(fHeal, hCaster)
		hTo:EmitSound("Hero_Omniknight.Purification")
		table.insert(tHealedTargets, hTo)
		iParticle = ParticleManager:CreateParticle("particles/old_silencer/old_silencer_healing_wave_chain.vpcf", PATTACH_ABSORIGIN_FOLLOW, hFrom)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hFrom, PATTACH_POINT_FOLLOW, "attach_attack1", hFrom:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTo, PATTACH_POINT_FOLLOW, "attach_hitloc", hTo:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTo, PATTACH_POINT_FOLLOW, "attach_hitloc", hTo:GetAbsOrigin(), true)
		
		SendOverheadEventMessage(hTo:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , hTo, fHealAmount, nil)
		if iBounceLeft > 0 then
			Timers:CreateTimer(fJumpInterval, function () OldSilencerHealSingleTarget(hTo, tHealedTargets, fHeal*fDeduction, fDeduction, iBounceLeft-1, fJumpInterval,  hCaster ) end)
		end
	end
end

function old_silencer_healing_wave:OnSpellStart()
	local hFrom = self:GetCaster()
	local hTo = self:GetCursorTarget()
	local fHeal = self:GetSpecialValueFor("init_heal")
	local fDeduction = 1-(self:GetSpecialValueFor("heal_loss_percentage")-CheckTalent(hFrom, "special_bonus_unique_old_silencer_0"))/100
	local fHealAmount
	if hTo:GetMaxHealth()-hTo:GetHealth() > fHeal then
		fHealAmount = fHeal
	else
		fHealAmount = hTo:GetMaxHealth()-hTo:GetHealth()
	end
	hTo:Heal(fHeal, hCaster)
	hTo:EmitSound("Hero_Omniknight.Purification")
	iParticle = ParticleManager:CreateParticle("particles/old_silencer/old_silencer_healing_wave_chain.vpcf", PATTACH_ABSORIGIN_FOLLOW, hFrom)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hFrom, PATTACH_POINT_FOLLOW, "attach_attack1", hFrom:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, hTo, PATTACH_POINT_FOLLOW, "attach_hitloc", hTo:GetOrigin(), true)
	
	SendOverheadEventMessage(hTo:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , hTo, fHealAmount, nil)
	Timers:CreateTimer(self:GetSpecialValueFor("jump_interval"), function () OldSilencerHealSingleTarget(hTo, {hTo}, fHeal*fDeduction, fDeduction, self:GetSpecialValueFor("jump"), self:GetSpecialValueFor("jump_interval"), hFrom ) end)

end

old_silencer_rain_of_chaos = class({})
function old_silencer_rain_of_chaos:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end
function old_silencer_rain_of_chaos:OnSpellStart()
	local hCaster = self:GetCaster()
	local iSummonCount = self:GetSpecialValueFor("summon_count")
	local iDamageMax = self:GetSpecialValueFor("damage_max")
	local iDamageMin = self:GetSpecialValueFor("damage_min")
	local iHealth = self:GetSpecialValueFor("hitpoint")
	local iDuration = self:GetSpecialValueFor("duration")
	local iArmor = self:GetSpecialValueFor("armor")
	local vTarget= self:GetCursorPosition()
	local fHitRadius = self:GetSpecialValueFor("hit_radius")
	local fCastRadius = self:GetSpecialValueFor("aoe_radius")
	local fStunDurationHero = self:GetSpecialValueFor("hit_stun_hero")
	local fStunDurationCreep = self:GetSpecialValueFor("hit_stun_creep")
	local iDamage = self:GetSpecialValueFor("hit_damage")
	
	if CheckTalent(hCaster, "special_bonus_unique_old_silencer_3") > 0 then
		iSummonCount = iSummonCount*CheckTalent(hCaster, "special_bonus_unique_old_silencer_3")
		iDamageMax = iDamageMax*CheckTalent(hCaster, "special_bonus_unique_old_silencer_3")
		iDamageMin = iDamageMin*CheckTalent(hCaster, "special_bonus_unique_old_silencer_3")
		iHealth = iHealth*CheckTalent(hCaster, "special_bonus_unique_old_silencer_3")
	end
	
	for i = 1, iSummonCount do
		Timers:CreateTimer(0.2*(i-1), function () 
			local vRelative = Vector(RandomFloat(-fCastRadius, fCastRadius), RandomFloat(-fCastRadius, fCastRadius), 0)
			while vRelative:Length2D() > fCastRadius do
				vRelative = Vector(RandomFloat(-fCastRadius, fCastRadius), RandomFloat(-fCastRadius, fCastRadius), 0)
			end
				
			local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, PlayerResource:GetPlayer(0):GetAssignedHero())
			ParticleManager:SetParticleControl(iParticle, 0, vTarget+vRelative+Vector(800,800,2000))
			ParticleManager:SetParticleControl(iParticle, 1, vTarget+vRelative+Vector(-900,-900,-2250))
			ParticleManager:SetParticleControl(iParticle, 2, Vector(0.7,0,0))
			local hThinker = CreateModifierThinker(hCaster, self, "modifier_stunned", {Duration = 1}, vTarget+vRelative+Vector(0,0,2000), hCaster:GetTeamNumber(), false)	
			hThinker:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
			hThinker:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
			
			Timers:CreateTimer(0.6,function () 
				StartSoundEventFromPosition("Hero_Invoker.ChaosMeteor.Impact", vTarget+vRelative)
				hThinker:StopSound("Hero_Invoker.ChaosMeteor.Loop")
				local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(iParticle, 0, vTarget+vRelative)
				GridNav:DestroyTreesAroundPoint(vTarget+vRelative, fHitRadius, true)
				local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vTarget+vRelative, nil, fHitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local damageTable = {
					damage = iDamage,
					attacker = hCaster,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
				}
				for k, v in ipairs(tTargets) do
					damageTable.victim = v
					ApplyDamage(damageTable)
					if v:IsHero() then
						v:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = fStunDurationHero*CalculateStatusResist(v)})
					else
						v:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = fStunDurationCreep*CalculateStatusResist(v)})
					end
				end
				local hInfernal = CreateUnitByName("old_silencer_infernal", vTarget+vRelative, true, hCaster, hCaster, hCaster:GetTeamNumber())
				hInfernal:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)	
				FindClearSpaceForUnit(hInfernal, hInfernal:GetOrigin(), true)	
				hInfernal:SetForwardVector(hCaster:GetForwardVector())
				hInfernal:SetBaseMaxHealth(iHealth)
				hInfernal:SetMaxHealth(iHealth)
				hInfernal:SetHealth(iHealth)
				hInfernal:SetPhysicalArmorBaseValue(iArmor)
				hInfernal:SetBaseDamageMax(iDamageMax)
				hInfernal:SetBaseDamageMin(iDamageMin)
				hInfernal:FindAbilityByName("old_silencer_infernal_permanent_immolation"):SetLevel(1)
				hInfernal:AddNewModifier(hCaster, self, "modifier_kill", {Duration = iDuration})
			end)
			
		end)
	end	
end

old_silencer_silencer = class({})
function old_silencer_silencer:GetIntrinsicModifierName() return "modifier_old_silencer_silencer" end
old_silencer_silencer_upgraded = class({})
function old_silencer_silencer_upgraded:GetIntrinsicModifierName() return "modifier_old_silencer_silencer" end


old_silencer_infernal_permanent_immolation = class({})
function old_silencer_infernal_permanent_immolation:GetIntrinsicModifierName() return "modifier_old_silencer_infernal_permanent_immolation_aura" end