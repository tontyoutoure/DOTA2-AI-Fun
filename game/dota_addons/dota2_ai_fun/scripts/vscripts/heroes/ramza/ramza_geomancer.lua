LinkLuaModifier("modifier_ramza_geomancer_wind_blast", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_geomancer_wind_blast_tornado", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_geomancer_contortion", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_geomancer_attack_boost", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_geomancer_attack_boost_bonus_damage", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_geomancer_geomancy_sinkhole", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_ramza_geomancer_geomancy_tanglevine", "heroes/ramza/ramza_geomancer_modifiers.lua", LUA_MODIFIER_MOTION_VERTICAL)

function RamzaGeomancerSinkhole(keys)
	local tDamageTable = {
		attacker = keys.caster,
		ability = keys.ability,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage = keys.ability:GetSpecialValueFor("damage")
	}
	for k, v in ipairs(keys.target_entities) do
		tDamageTable.victim = v
		ApplyDamage(tDamageTable)
		v:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_geomancer_geomancy_sinkhole", {Duration = keys.ability:GetSpecialValueFor("stun_duration")})
	end
end

function RamzaGeomancerTorrent(keys)
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 0, keys.caster:GetOrigin())
end

function RamzaGeomancerWillothewisp(keys)
	local vCenter = keys.target:GetOrigin()
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local vRelative = Vector(RandomFloat(-fRadius, fRadius), RandomFloat(-fRadius, fRadius), 0)
	while vRelative:Length2D() > fRadius do
		vRelative = Vector(RandomFloat(-fRadius, fRadius), RandomFloat(-fRadius, fRadius), 0)
	end
	keys.ability:ApplyDataDrivenThinker(keys.caster, vCenter+vRelative, "modifier_ramza_geomancer_geomancy_willothewisp_blast", {})
end

function RamzaGeomancerSandstormStopSound(keys)
	keys.target:StopSound("Ability.SandKing_SandStorm.loop")
end

function RamzaGeomancerTanglevine(keys)	
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.caster:EmitSound("Hero_Treant.Overgrowth.Cast")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_geomancer_geomancy_tanglevine", {Duration = keys.ability:GetSpecialValueFor("duration"), fDamage = keys.ability:GetSpecialValueFor("damage"), fRadius = keys.ability:GetSpecialValueFor("radius")}).tRooted = {[keys.target] = true}
end

function RamzaGeomancerMagmaSurge(keys)
	for k, v in ipairs(keys.target_entities) do
		if v:IsAlive() then
			AddFOWViewer(keys.caster:GetTeamNumber(), v:GetOrigin(), 400, 4, true)
			Timers:CreateTimer(0.04, function () keys.ability:ApplyDataDrivenThinker(keys.caster, v:GetOrigin(), "modifier_ramza_geomancer_geomancy_magma_surge_aura", {}) end)			
		end
	end
end

function RamzaGeomancerWindBlast(keys)
	keys.caster.tWindBlastTarget = keys.caster.tWindBlastTarget or {}
	if not keys.caster.tWindBlastTarget[keys.target] then 
		keys.caster.tWindBlastTarget[keys.target] = true
		keys.caster:EmitSound("Hero_Invoker.Tornado.Cast.Immortal")
		local hThinker = CreateUnitByName("npc_dummy_unit", keys.caster:GetAbsOrigin(), true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
		local hModifier = hThinker:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_geomancer_wind_blast_tornado", {})
		hModifier.hTarget = keys.target
		hModifier.fDamage = keys.ability:GetSpecialValueFor("damage")
		hModifier.fSpeed = keys.ability:GetSpecialValueFor("tornado_speed")
	end
end

function RamzaGeomancerContortion(keys)
	CreateModifierThinker(keys.caster, keys.ability, "modifier_ramza_geomancer_contortion", {iRadius = keys.ability:GetSpecialValueFor("radius"), Duration = 5}, keys.target_points[1], keys.caster:GetTeamNumber(), false):SetModel("models/heroes/earth_spirit/stonesummon.vmdl")
end

function RamzaGeomancerAttackBoostApply(keys)
	local hModifier = keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_geomancer_attack_boost", {})
	hModifier.iBonusDamage = keys.ability:GetSpecialValueFor("damage_bonus")
	hModifier.fDuration = keys.ability:GetSpecialValueFor("duration")
end