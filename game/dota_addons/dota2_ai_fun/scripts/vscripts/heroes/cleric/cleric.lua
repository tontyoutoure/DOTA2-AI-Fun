LinkLuaModifier("modifier_cleric_berserk", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_berserk_target", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_berserk_no_order", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_prayer", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function ClericMeteorShower(keys)
	ProcsArroundingMagicStick(keys.caster)
	local iMeteorCount = keys.ability:GetSpecialValueFor("meteor_count")
	local vTarget= keys.target_points[1]

	local fMeteorRadius = keys.ability:GetSpecialValueFor("meteor_radius")
	AddFOWViewer(keys.caster:GetTeamNumber(), vTarget, 500, 3, true)
	local fCastRadius = keys.ability:GetSpecialValueFor("cast_radius")
	local iDamage = keys.ability:GetSpecialValueFor("damage")
	local fStunDuration = keys.ability:GetSpecialValueFor("stun_duration")
	for i = 1, iMeteorCount do
		Timers:CreateTimer(0.2*(i-1), function () 
			local vRelative = Vector(RandomFloat(-fCastRadius, fCastRadius), RandomFloat(-fCastRadius, fCastRadius), 0)
			while vRelative:Length2D() > fCastRadius do
				vRelative = Vector(RandomFloat(-fCastRadius, fCastRadius), RandomFloat(-fCastRadius, fCastRadius), 0)
			end
				
			local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, PlayerResource:GetPlayer(0):GetAssignedHero())
			ParticleManager:SetParticleControl(iParticle, 0, vTarget+vRelative+Vector(0,0,2000))
			ParticleManager:SetParticleControl(iParticle, 1, vTarget+vRelative+Vector(0,0,-2250))
			ParticleManager:SetParticleControl(iParticle, 2, Vector(0.7,0,0))
			local hThinker = CreateModifierThinker(keys.caster, keys.ability, "modifier_stunned", {Duration = 1}, vTarget+vRelative+Vector(0,0,2000), keys.caster:GetTeamNumber(), false)	
			hThinker:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
			hThinker:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
			
			Timers:CreateTimer(0.6,function () 
				StartSoundEventFromPosition("Hero_Invoker.ChaosMeteor.Impact", vTarget+vRelative)
				hThinker:StopSound("Hero_Invoker.ChaosMeteor.Loop")
				GridNav:DestroyTreesAroundPoint(vTarget+vRelative, fMeteorRadius, true)
				local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), vTarget+vRelative, nil, fMeteorRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
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
			
		end)
	end	
end

cleric_berserk = class({})

function cleric_berserk:GetBehavior()
	if not self.bSpecial2 then
		self.hSpecial2 = Entities:First()		
		while self.hSpecial2 and (self.hSpecial2:GetName() ~= "special_bonus_unique_cleric_5" or self.hSpecial2:GetCaster() ~= self:GetCaster()) do
			self.hSpecial2 = Entities:Next(self.hSpecial2)
		end	
		self.bSpecial2 = true	
	end
	if self.hSpecial2 and self.hSpecial2:GetLevel() > 0 then
		return DOTA_ABILITY_BEHAVIOR_POINT+DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function cleric_berserk:GetAOERadius()
	if self.hSpecial2 then
		return self.hSpecial2:GetSpecialValueFor("value")
	else
		return 0
	end
end

function cleric_berserk:OnSpellStart()
	
	if self.hSpecial2 and self.hSpecial2:GetLevel() > 0 then
		local hCaster = self:GetCaster()
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetCursorPosition(), nil, self.hSpecial2:GetSpecialValueFor("value"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for k, v in ipairs(tTargets) do
			v:EmitSound("Hero_Axe.Berserkers_Call")
			v:AddNewModifier(hCaster, self, "modifier_cleric_berserk", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(v)})
		end
	else
		local hTarget = self:GetCursorTarget()
		if hTarget:TriggerSpellAbsorb( self ) then return end
		hTarget:EmitSound("Hero_Axe.Berserkers_Call")
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_cleric_berserk", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
	end
	
end

function cleric_berserk:GetCooldown(iLevel)
	if not self.bSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_cleric_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
		self.bSpecial = true
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function ClericPrayer(keys)
	ProcsArroundingMagicStick(keys.caster)
	local hSpecial = Entities:First()	
	while hSpecial and hSpecial:GetName() ~= "special_bonus_unique_cleric_3" do
		hSpecial = Entities:Next(hSpecial)
	end
	keys.caster:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
	local iDuration = keys.ability:GetSpecialValueFor("duration")
	
	for k, v in pairs(keys.target_entities) do
		local hModifier = v:FindModifierByName("modifier_cleric_prayer")
		if not hModifier then
			v:AddNewModifier(keys.caster, keys.ability, "modifier_cleric_prayer", {Duration = iDuration})
			v:EmitSound("Hero_Omniknight.GuardianAngel")
			v:EmitSound("DOTA_Item.Refresher.Activate")
			ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, v), 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			for i = 0, 23 do
				if v:GetAbilityByIndex(i) then 
					v:GetAbilityByIndex(i):EndCooldown() 
					v:GetAbilityByIndex(i):RefreshCharges()
				end
			end
			
			for j,i in ipairs(tItemInventorySlotTable) do
				if v:GetItemInSlot(i) then 
					v:GetItemInSlot(i):EndCooldown() 
					v:GetItemInSlot(i):RefreshCharges()
				end
			end
		elseif hSpecial and hModifier:GetStackCount() < hSpecial:GetSpecialValueFor("value") then
			local iOriginalStackCount = hModifier:GetStackCount()
			v:AddNewModifier(keys.caster, keys.ability, "modifier_cleric_prayer", {Duration = iDuration})
			v:FindModifierByName("modifier_cleric_prayer"):SetStackCount(iOriginalStackCount+1)
			v:EmitSound("Hero_Omniknight.GuardianAngel")
			v:EmitSound("DOTA_Item.Refresher.Activate")
			ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, v), 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			for i = 0, 23 do
				if v:GetAbilityByIndex(i) then 
					v:GetAbilityByIndex(i):EndCooldown() 
					v:GetAbilityByIndex(i):RefreshCharges()
				end
			end
			
			for j,i in ipairs(tItemInventorySlotTable) do
				if v:GetItemInSlot(i) then 
					v:GetItemInSlot(i):EndCooldown() 
					v:GetItemInSlot(i):RefreshCharges()
				end
			end			
		end
	end
end

cleric_magic_mirror = class({})

function cleric_magic_mirror:GetCooldown(iLevel)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 20-iLevel*5
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("scepter_cooldown", iLevel)
		end
	end
	
	return self.BaseClass.GetCooldown(self, iLevel)
end
