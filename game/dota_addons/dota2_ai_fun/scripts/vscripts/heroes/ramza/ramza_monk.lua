LinkLuaModifier("modifier_ramza_monk_lifefont", "heroes/ramza/ramza_monk_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_monk_critical_recover_hp", "heroes/ramza/ramza_monk_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_monk_martial_arts_doom_fist", "heroes/ramza/ramza_monk_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_monk_brawler", "heroes/ramza/ramza_monk_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function RamzaMonkAurablast(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.caster:EmitSound("Hero_ChaosKnight.ChaosBolt.Cast")	
	local damageTable = {
		damage = RandomFloat(1, keys.caster:GetMaxHealth()),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		attacker = keys.caster,
		victim = keys.target,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "follow_hitloc", keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, "follow_hitloc", keys.caster:GetAbsOrigin(), true)
	
end

function RamzaMonkPummel(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.caster:EmitSound("Hero_Sven.StormBoltImpact")	
	local damageTable = {
		damage = RandomFloat(1, keys.caster:GetMaxHealth()),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		attacker = keys.caster,
		victim = keys.target,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion_swish.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.caster, PATTACH_POINT_FOLLOW, "attach_origin", keys.target:GetAbsOrigin(), true)
end

function RamzaMonkChakra(keys)
	ProcsArroundingMagicStick(keys.caster)
	local fHeal = RandomFloat(0, keys.caster:GetMaxHealth())
	local fMana = RandomFloat(0, keys.caster:GetMaxMana())
	
	if fHeal > keys.caster:GetMaxHealth() - keys.caster:GetHealth() then fHeal = keys.caster:GetMaxHealth() - keys.caster:GetHealth() end
	if fMana > keys.caster:GetMaxMana() - keys.caster:GetMana() then fMana = keys.caster:GetMaxMana() - keys.caster:GetMana() end
	keys.caster:Heal(fHeal, keys.caster)
	keys.caster:GiveMana(fMana)	
	local iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHeal, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHeal))+2,0))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
	
	
	iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(0, math.floor(fMana), 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, 2+math.floor(math.log10(fMana)), 500))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(150, 150, 255))	
	
	keys.caster:EmitSound("Item.GuardianGreaves.Activate")
	ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
end

function RamzaMonkBrawlerApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_monk_brawler", {})
end

function RamzaMonkLifefontApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_monk_lifefont", {})
end

function RamzaMonkCriticalRecoverHPApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_monk_critical_recover_hp", {})
end

ramza_monk_martial_arts_shockwave = class({})
--[[
function ramza_monk_martial_arts_shockwave:OnAbilityPhaseStart()
	self:GetCaster():EmitSound('Hero_Magnataur.ShockWave.Cast')
end
]]--
function ramza_monk_martial_arts_shockwave:OnSpellStart()
	self:GetCaster():EmitSound('Hero_Magnataur.ShockWave.Particle')
	local tInfo = {
		Ability = self,
		EffectName = "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf",
		fDistance = 1900,
		fStartRadius = 250,
		fEndRadius = 250,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = self:GetCaster():GetForwardVector() * 2000,
		bProvidesVision = false,
		ExtraData = {damage = self:GetSpecialValueFor("damage")}		
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
end

function ramza_monk_martial_arts_shockwave:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	if not hTarget then return end
	local damageTable = {
		damage = tExtraData.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = self:GetCaster(),
		victim = hTarget,
		ability = self
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound('Hero_Magnataur.ShockWave.Target')
	ParticleManager:CreateParticle("particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
end

function RamzaMonkDoomFistApply(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_monk_martial_arts_doom_fist", {Duration=keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
end

function RamzaMonkPurification(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.target:EmitSound('DOTA_Item.DiffusalBlade.Target')
	ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.target:Purge(false, true, false, true, true)
end