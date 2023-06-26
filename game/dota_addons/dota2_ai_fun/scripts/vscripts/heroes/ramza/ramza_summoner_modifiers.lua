modifier_ramza_summoner_lich = class({})

function modifier_ramza_summoner_lich:OnCreated(keys)
	if IsClient() then return end
	local hParent = self:GetParent()
	self.fRadius = keys.fRadius
	self.fPercentageDamage = keys.fPercentageDamage
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(self.iParticle, 1, Vector(keys.fRadius, keys.fRadius, keys.fRadius))
	hParent:EmitSound("Hero_Enigma.Midnight_Pulse")
	self:StartIntervalThink(1)
end

function modifier_ramza_summoner_lich:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), none, self.fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local damageTable = {
		damage_type = DAMAGE_TYPE_PURE,
		attacker = hCaster,
		ability = self:GetAbility()
	}
	for k, v in pairs(tTargets) do
		damageTable.victim = v
		damageTable.damage = v:GetMaxHealth()*self.fPercentageDamage/100
		ApplyDamage(damageTable)
	end
end

function modifier_ramza_summoner_lich:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:StopSound("Hero_Enigma.Midnight_Pulse")
	ParticleManager:DestroyParticle(self.iParticle, false)
	WearableManager:RemoveAllWearable(hParent)
	hParent:RemoveSelf()
end

modifier_ramza_summoner_odin = class({})

function modifier_ramza_summoner_odin:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	WearableManager:RemoveAllWearable(hParent)
	hParent:RemoveSelf()
end


function modifier_ramza_summoner_odin:OnCreated(keys)
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	hParent:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), none, keys.fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	self.tDead = {}
	for k, v in pairs(tTargets) do		
		local hThinker = CreateUnitByName("npc_dummy_unit", hParent:GetOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber())
		hThinker:SetForwardVector(Vector2D(v:GetOrigin()-hThinker:GetOrigin()))
		hThinker:AddNewModifier(hCaster, hAbility, "modifier_ramza_summoner_odin_tracker", {Duration = 3}).hTarget = v
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hThinker)
		ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "follow_origin", v:GetOrigin(), true)
		v:EmitSound("Hero_Necrolyte.ReapersScythe.Target")		
		
		Timers:CreateTimer(0.95, function ()
			if RandomFloat(0, 1) > v:GetHealth()/v:GetMaxHealth() then
				self.tDead[v] = true
			else
				v:StopSound("Hero_Necrolyte.ReapersScythe.Target")
				ParticleManager:DestroyParticle(iParticle, true)				
			end
		end)
		Timers:CreateTimer(keys.Duration, function () 
			if self.tDead[v] then
				v:Kill(hAbility, hCaster)
			end
		end)
	end
end

modifier_ramza_summoner_odin_tracker = class({})

function modifier_ramza_summoner_odin_tracker:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end

function modifier_ramza_summoner_odin_tracker:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:SetForwardVector(Vector2D(self.hTarget:GetOrigin()-hParent:GetOrigin()))
end

modifier_ramza_summoner_shiva = class({})

function modifier_ramza_summoner_shiva:OnCreated(keys)
	if IsClient() then return end
	local hParent = self:GetParent()
	self.fRadius = keys.fRadius
	self.fDamage = keys.fDamage
	self.fSlowDuration = keys.fSlowDuration
	self.fMoveSlow = keys.fMoveSlow
	self.fAttackSlow = keys.fAttackSlow
	hParent:EmitSound("Hero_Crystal.FreezingField.Arcana")
	self.iParticle0 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_b_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.iParticle1 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_c_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(self.iParticle1, 1, Vector(keys.fRadius, keys.fRadius, keys.fRadius))
	self.iParticle2 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_frostgrow_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.iParticle3 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_caster_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.iParticle4 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_rays_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self.tFrozenTargets = {}
	self:StartIntervalThink(0.1)
end

function modifier_ramza_summoner_shiva:OnIntervalThink()
	if IsClient() then return end	
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), none, self.fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local iCount = #tTargets
	for i = 1, iCount do
		if self.tFrozenTargets[tTargets[iCount+1-i]] then 
			table.remove(tTargets, iCount+1-i)
		end
	end
	if #tTargets > 0 then
		local iNum = RandomInt(1, #tTargets)
		self.tFrozenTargets[tTargets[iNum]] = true
		local damageTable = {
			victim = tTargets[iNum],
			damage = self.fDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			attacker = hCaster,
			ability = self:GetAbility()
		}
		ApplyDamage(damageTable)
		tTargets[iNum]:EmitSound("hero_Crystal.freezingField.explosion")
		ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf", PATTACH_ABSORIGIN, tTargets[iNum])
		tTargets[iNum]:AddNewModifier(hCaster, self:GetAbility(), "modifier_ramza_summoner_shiva_slow", {Duration = self.fSlowDuration*CalculateStatusResist(tTargets[iNum]), fMoveSlow = self.fMoveSlow, fAttackSlow = self.fAttackSlow})
	end
end

function modifier_ramza_summoner_shiva:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	ParticleManager:DestroyParticle(self.iParticle0, true)
	ParticleManager:DestroyParticle(self.iParticle1, true)
	ParticleManager:DestroyParticle(self.iParticle2, true)
	ParticleManager:DestroyParticle(self.iParticle3, true)
	ParticleManager:DestroyParticle(self.iParticle4, true)
	hParent:StopSound("Hero_Crystal.FreezingField.Arcana")
end

modifier_ramza_summoner_shiva_slow = class({})

function modifier_ramza_summoner_shiva_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_ramza_summoner_shiva_slow:GetModifierAttackSpeedBonus_Constant()
	return -30
end	

function modifier_ramza_summoner_shiva_slow:GetModifierMoveSpeedBonus_Percentage()
	return -30
end

function modifier_ramza_summoner_shiva_slow:GetTexture() return "crystal_maiden_freezing_field_alt1" end

function modifier_ramza_summoner_shiva_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end

modifier_ramza_summoner_golem_slow = class({})

function modifier_ramza_summoner_golem_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_ramza_summoner_golem_slow:GetModifierAttackSpeedBonus_Constant()
	return -50
end	

function modifier_ramza_summoner_golem_slow:GetModifierMoveSpeedBonus_Percentage()
	return -50
end

function modifier_ramza_summoner_golem_slow:GetTexture() return "granite_golem_bash" end

function modifier_ramza_summoner_golem_slow:GetStatusEffectName() return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf" end

modifier_ramza_summoner_critical_recover_mp = class({})


function modifier_ramza_summoner_critical_recover_mp:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_ramza_summoner_critical_recover_mp:OnCreated()
	local hAbility = self:GetAbility()
	self.iCriticalHealthPercentage = hAbility:GetSpecialValueFor("critical_health")
end

function modifier_ramza_summoner_critical_recover_mp:IsHidden() return true end
function modifier_ramza_summoner_critical_recover_mp:IsPurgable() return false end
function modifier_ramza_summoner_critical_recover_mp:IsDebuff() return false end
function modifier_ramza_summoner_critical_recover_mp:RemoveOnDeath() return false end

function modifier_ramza_summoner_critical_recover_mp:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	local bIsCooldownReady
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then return end
	if hParent:GetHealth()/hParent:GetMaxHealth() < self.iCriticalHealthPercentage/100 then
		
		if hParent:HasAbility("ramza_summoner_critical_recover_mp") then 
			if hParent:FindAbilityByName("ramza_summoner_critical_recover_mp"):IsCooldownReady() then
				hParent:FindAbilityByName("ramza_summoner_critical_recover_mp"):UseResources(true, true, true, true)
				hParent:SetMana(hParent:GetMaxMana())
			end
		else
			bIsCooldownReady = Time() > hParent.hRamzaJob.tPassiveCooldownReadyTime["ramza_summoner_critical_recover_mp"]
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
				hParent.hRamzaJob.tPassiveCooldownReadyTime["ramza_summoner_critical_recover_mp"] = Time()+100*fCooldownMultiplier		
				hParent:SetMana(hParent:GetMaxMana())
			end
		end
	end
end