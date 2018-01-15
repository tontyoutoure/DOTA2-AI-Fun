LinkLuaModifier("modifier_ramza_black_mage_magick_counter", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_black_mage_black_magicks_poison", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_black_mage_black_magicks_toad", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_black_mage_black_magicks_blizzaga", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_black_mage_black_magicks_blizzaga_slow", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

RamzaBlackMageDeath = function(keys)
	keys.target:Kill(keys.ability, keys.caster)
	keys.caster:EmitSound("Ability.DarkRitual")
	local iBonusGold = keys.ability:GetSpecialValueFor("bonus_gold")
	keys.caster:ModifyGold(iBonusGold, true, DOTA_ModifyGold_CreepKill)
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_dark_ritual.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "follow_origin", keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.target:GetAbsOrigin(), true)
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iBonusGold, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 4, 100))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
end

ramza_black_mage_magick_counter = class({})

function ramza_black_mage_magick_counter:OnUpgrade() 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ramza_black_mage_magick_counter", {})
end

function RamzaBlackMagicksDamage(hAttacker, hVictim, hAbility)
		local damageTable = {
			attacker = hAttacker,
			victim = hVictim,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility
		}
		if hAttacker:HasModifier("modifier_ramza_black_mage_arcane_strength") and not hAttacker:PassivesDisabled() then
			damageTable.damage = hAbility:GetSpecialValueFor("damage_arcane")
		else			
			damageTable.damage = hAbility:GetSpecialValueFor("damage")
		end
		ApplyDamage(damageTable)
end


RamzaBlackMageBlizzard = function(keys)	
	ProcsArroundingMagicStick(keys.caster)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k, v in pairs(tTargets) do
		ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_ABSORIGIN, v)		
		Timers:CreateTimer(0.3, function() RamzaBlackMagicksDamage(keys.caster, v, keys.ability) end )
	end
	if #tTargets > 0 then
		keys.caster:EmitSound("Ability.FrostNova")
	end
end

RamzaBlackMageFire = function (keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	RamzaBlackMagicksDamage(keys.caster, keys.target, keys.ability)
	keys.target:EmitSound("Hero_OgreMagi.Fireblast.Target")	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(particle, 1, keys.target:GetAbsOrigin())
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("ministun_duration")})
end

RamzaBlackMageThunder = function (keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	RamzaBlackMagicksDamage(keys.caster, keys.target, keys.ability)
	keys.target:Purge(true, false, false, false, false)
	keys.target:EmitSound("Hero_Zuus.LightningBolt")
	local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(particle, 1, keys.target:GetAbsOrigin()+Vector(0,0,2000))
	ParticleManager:SetParticleControl(particle, 3, keys.target:GetAbsOrigin())


	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(particle, 1, keys.target:GetAbsOrigin()+Vector(0,0,1000))
	ParticleManager:SetParticleControl(particle, 3, keys.target:GetAbsOrigin())

end

RamzaBlackMageFlare = function (keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	RamzaBlackMagicksDamage(keys.caster, keys.target, keys.ability)
	keys.target:EmitSound("Hero_EarthShaker.EchoSlam")
	
	
	
	local particle = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)	
	
	ParticleManager:SetParticleControl(particle, 15, Vector(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
end

RamzaBlackMageThundaga = function (keys)	
	ProcsArroundingMagicStick(keys.caster)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k, v in pairs(tTargets) do
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, v)
		-- Raise 1000 if you increase the camera height above 1000
		ParticleManager:SetParticleControl(particle, 0, v:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, v:GetAbsOrigin()+Vector(0, 0, 2000))
		ParticleManager:SetParticleControl(particle, 2, v:GetAbsOrigin())
		RamzaBlackMagicksDamage(keys.caster, v, keys.ability)
		v:EmitSound("Hero_Zuus.GodsWrath.Target")
		v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("ministun_duration")*CalculateStatusResist(v)})
	end
end


RamzaBlackMageToad = function (keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound("Hero_Lion.Voodoo")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_black_mage_black_magicks_toad", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
end

RamzaBlackMagePoison = function(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_black_mage_black_magicks_poison", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
end

function RamzaBlackMageFiragaProcs(keys)	
	ProcsArroundingMagicStick(keys.caster)
end
function RamzaBlackMageFiraga(keys)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k, v in pairs(tTargets) do	
		RamzaBlackMagicksDamage(keys.caster, v, keys.ability)
	end
end

function RamzaBlackMageBlizzaga(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_black_mage_black_magicks_blizzaga", {Duration = 10})
end





