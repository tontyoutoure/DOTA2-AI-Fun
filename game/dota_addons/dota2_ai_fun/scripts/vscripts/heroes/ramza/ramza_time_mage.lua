LinkLuaModifier("modifier_ramza_time_mage_time_magicks_gravity", "heroes/ramza/ramza_time_mage_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_time_mage_mana_shield", "heroes/ramza/ramza_time_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_time_mage_time_magicks_slow", "heroes/ramza/ramza_time_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function RamzaTimeMageProc(keys)
	ProcsArroundingMagicStick(keys.caster)
end

function RamzaTimeMageStop(keys)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_time_mage_time_magicks_stop", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
end

function RamzaTimeMageHaste(keys)	
	ProcsArroundingMagicStick(keys.caster)
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 2, keys.target, PATTACH_POINT_FOLLOW, "attach_origin", keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 3, keys.target, PATTACH_POINT_FOLLOW, "attach_origin", keys.target:GetAbsOrigin(), true)
end

function RamzaTimeMageUpgradeTeleport(keys)
	if keys.caster:HasAbility("ramza_time_mage_teleport") then
		keys.caster:FindAbilityByName("ramza_time_mage_teleport"):SetLevel(2)
	end
end

function RamzaTimeMageSlow(keys)	
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound("Hero_SkywrathMage.ConcussiveShot.Target")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_time_mage_time_magicks_slow", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
end

function RamzaTimeMageImmobilize(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound("n_creep_Spawnlord.Freeze")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = 0.01})
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_time_mage_time_magicks_immobilize", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
end

function RamzaTimeMageGravity(keys)
	ProcsArroundingMagicStick(keys.caster)
	local vTarget = keys.target_points[1]
	local fDragTime = keys.ability:GetSpecialValueFor("drag_time")
	local fHealthPercentage = keys.ability:GetSpecialValueFor("health_percentage")
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), vTarget, nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	local hThinker = CreateModifierThinker(keys.caster, keys.ability, "modifier_stunned", {Duration = fDragTime+0.05}, vTarget, keys.caster:GetTeamNumber(), false)
	hThinker:EmitSound("Hero_Enigma.Black_Hole")
	hThinker:EmitSound("Hero_Enigma.Black_Hole.Cast")
	local iParticle=ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", PATTACH_ABSORIGIN, hThinker)
	
	ParticleManager:SetParticleControl(iParticle, 1, Vector(fRadius, fRadius, fRadius))
	Timers:CreateTimer(fDragTime, function () hThinker:StopSound("Hero_Enigma.Black_Hole") hThinker:EmitSound("Hero_Enigma.Black_Hole.Stop") end )
	for k, v in ipairs(tTargets) do
		local hModifier = v:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_time_mage_time_magicks_gravity", {Duration = fDragTime})
		hModifier.vHorizontalSpeed = Vector(Vector(0,0,0).Dot((vTarget-v:GetOrigin())/fDragTime, Vector(1,0,0)),Vector(0,0,0).Dot((vTarget-v:GetOrigin())/fDragTime, Vector(0,1,0)),0)
		hModifier.vVerticalSpeed = Vector(0,0,Vector(0,0,0).Dot((vTarget-v:GetOrigin())/fDragTime, Vector(0,0,1)))
		hModifier.fHealthPercentage = fHealthPercentage
	end
end

function RamzaTimeMageMeteor(keys)
	ProcsArroundingMagicStick(keys.caster)
	local vTarget = keys.target_points[1]

	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, PlayerResource:GetPlayer(0):GetAssignedHero())
	ParticleManager:SetParticleControl(iParticle, 0, vTarget+Vector(0,0,2000))
	ParticleManager:SetParticleControl(iParticle, 1, vTarget+Vector(0,0,-2250))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(0.7,0,0))
	local hThinker = CreateModifierThinker(keys.caster, keys.ability, "modifier_stunned", {Duration = 1}, vTarget+Vector(0,0,2000), keys.caster:GetTeamNumber(), false)	
	hThinker:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
	hThinker:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
	
	Timers:CreateTimer(0.7,function () 
		iParticle = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_remote_mines_detonate_arcana.vpcf", PATTACH_CUSTOMORIGIN, keys.caster)
		ParticleManager:SetParticleControl(iParticle, 0, vTarget)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(400,400,400))
		ParticleManager:SetParticleControl(iParticle, 3, Vector(400,400,400))
		ParticleManager:SetParticleControl(iParticle, 15, Vector(RandomInt(1, 255),RandomInt(1, 255),RandomInt(1, 255)))
		ParticleManager:SetParticleControl(iParticle, 16, Vector(400,400,400))	
		StartSoundEventFromPosition("Hero_Invoker.ChaosMeteor.Impact", vTarget)
		hThinker:StopSound("Hero_Invoker.ChaosMeteor.Loop")
		GridNav:DestroyTreesAroundPoint(vTarget, 400, true)
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), vTarget, nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local damageTable = {
			damage = keys.ability:GetSpecialValueFor("damage"),
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = keys.ability
		}
		for k, v in ipairs(tTargets) do
			damageTable.victim = v
			ApplyDamage(damageTable)
			v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
		end
	end)

end

function RamzaTimeMageShieldToggle(keys)
	if keys.caster:HasModifier("modifier_ramza_time_mage_mana_shield") then
		keys.caster:EmitSound("Hero_Medusa.ManaShield.Off")
		keys.caster:RemoveModifierByName("modifier_ramza_time_mage_mana_shield")
	else
		keys.caster:EmitSound("Hero_Medusa.ManaShield.On")
		keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_time_mage_mana_shield", {})
	end
end

function RamzaTimeMageShield(keys)
	PrintTable(keys)
end

function RamzaTimeMageTeleport(keys)
	ProcsArroundingMagicStick(keys.caster)
	local vTarget = keys.target_points[1]
	local fDistance = (vTarget-keys.caster:GetOrigin()):Length2D()
	local fChance = 2000/fDistance
	
	keys.caster:EmitSound("Hero_Wisp.TeleportIn.Arc")
	
	ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", PATTACH_ABSORIGIN, keys.caster), 0, keys.caster:GetOrigin())
	keys.caster:EmitSound("Hero_Wisp.TeleportOut.Arc") 
	ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf", PATTACH_ABSORIGIN, keys.caster) 
	
	if RandomFloat(0, 1) < fChance then
		ProjectileManager:ProjectileDodge(keys.caster)
		FindClearSpaceForUnit(keys.caster, vTarget, true)
	end
end

