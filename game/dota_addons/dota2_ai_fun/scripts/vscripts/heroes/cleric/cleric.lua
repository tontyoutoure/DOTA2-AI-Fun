LinkLuaModifier("modifier_cleric_berserk", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_berserk_target", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function ClericMeteorShower(keys)
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
					v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = fStunDuration})
				end
			end)
			
		end)
	end	
end

function ClericBerserk(keys)	
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound("Hero_Axe.Berserkers_Call")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_cleric_berserk", {Duration = keys.ability:GetSpecialValueFor("duration")})
end

function ClericPrayer(keys)
	keys.caster:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
	local iDuration = keys.ability:GetSpecialValueFor("duration")
	for k, v in pairs(keys.target_entities) do
		if not v:HasModifier("modifier_cleric_prayer") then
			keys.ability:ApplyDataDrivenModifier(keys.caster, v, "modifier_cleric_prayer", {Duration = iDuration})
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