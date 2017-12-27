LinkLuaModifier("modifier_cleric_berserk", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_berserk_target", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_prayer", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function ClericMeteorShower(keys)
	ProcsArroundingMagicStick(keys.caster)
	local iMeteorCount = keys.ability:GetSpecialValueFor("meteor_count")
	local vTarget= keys.target_points[1]

	local fMeteorRadius = keys.ability:GetSpecialValueFor("meteor_radius")
	AddFOWViewer(keys.caster:GetTeamNumber(), vTarget, 500, 3, true)
	local fCastRadius = keys.ability:GetSpecialValueFor("cast_radius")
	local iDamage
	if keys.caster:FindAbilityByName("special_bonus_cleric_4") then
		iDamage = keys.ability:GetSpecialValueFor("damage")+keys.caster:FindAbilityByName("special_bonus_cleric_4"):GetSpecialValueFor("value")
	else
		iDamage = keys.ability:GetSpecialValueFor("damage")
	end
	local fStunDuration 
	if keys.caster:FindAbilityByName("special_bonus_cleric_1") then
		fStunDuration = keys.ability:GetSpecialValueFor("stun_duration")+keys.caster:FindAbilityByName("special_bonus_cleric_1"):GetSpecialValueFor("value")
	else
		fStunDuration = keys.ability:GetSpecialValueFor("stun_duration")
	end
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
			
			Timers:CreateTimer(0.7,function () 
				StartSoundEventFromPosition("Hero_Invoker.ChaosMeteor.Impact", vTarget+vRelative)
				hThinker:StopSound("Hero_Invoker.ChaosMeteor.Loop")
				GridNav:DestroyTreesAroundPoint(vTarget+vRelative, fMeteorRadius, true)
				local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), vTarget+vRelative, nil, fMeteorRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
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

function ClericBerserkAoE(keys)
	ProcsArroundingMagicStick(keys.caster)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target_points[1], nil, keys.ability:GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k, v in ipairs(tTargets) do
		v:EmitSound("Hero_Axe.Berserkers_Call")
		v:AddNewModifier(keys.caster, keys.ability, "modifier_cleric_berserk", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(v)})
	end
end

cleric_berserk = class({})

function cleric_berserk:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb( self ) then return end
	hTarget:EmitSound("Hero_Axe.Berserkers_Call")
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_cleric_berserk", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
end

function cleric_berserk:GetCooldown(iLevel)
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_cleric_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
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
	while hSpecial and hSpecial:GetName() ~= "special_bonus_cleric_3" do
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
				if v:GetAbilityByIndex(i) then v:GetAbilityByIndex(i):EndCooldown() end
			end
			
			for i = 0, 8 do
				if v:GetItemInSlot(i) then v:GetItemInSlot(i):EndCooldown() end
			end
		elseif hSpecial and hModifier:GetStackCount() < hSpecial:GetSpecialValueFor("value") then
			local iOriginalStackCount = hModifier:GetStackCount()
			v:AddNewModifier(keys.caster, keys.ability, "modifier_cleric_prayer", {Duration = iDuration})
			v:FindModifierByName("modifier_cleric_prayer"):SetStackCount(iOriginalStackCount+1)
			v:EmitSound("Hero_Omniknight.GuardianAngel")
			v:EmitSound("DOTA_Item.Refresher.Activate")
			ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, v), 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			for i = 0, 23 do
				if v:GetAbilityByIndex(i) then v:GetAbilityByIndex(i):EndCooldown() end
			end
			
			for i = 0, 8 do
				if v:GetItemInSlot(i) then v:GetItemInSlot(i):EndCooldown() end
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
