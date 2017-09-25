
LinkLuaModifier("modifier_ramza_mystic_mystic_arts_disbelief", "heroes/ramza/ramza_mystic_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_mystic_absorb_mp", "heroes/ramza/ramza_mystic_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_mystic_defense_boost_armor", "heroes/ramza/ramza_mystic_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_mystic_defense_boost", "heroes/ramza/ramza_mystic_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_mystic_manafont", "heroes/ramza/ramza_mystic_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function RamzaMysticUmbra(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_mystic_mystic_arts_umbra", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound("Hero_Brewmaster.DrunkenHaze.Target")
end

function RamzaMysticEmpowerment(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	local fMana = keys.ability:GetSpecialValueFor("mana")
	if keys.target:GetMana()<fMana then fMana = keys.target:GetMana() end
	keys.target:ReduceMana(fMana)
	keys.caster:GiveMana(fMana)
	ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.caster:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
	keys.target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	local iParticle0 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle0, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle0, 1, keys.caster, PATTACH_POINT, "follow_origin", keys.caster:GetAbsOrigin(), true)
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, math.floor(fMana), 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2+math.floor(math.log10(fMana)), 500))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(20, 20, 100))	
	
	local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fMana), 0))
	ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fMana)), 500))
	ParticleManager:SetParticleControl(iParticle2, 3, Vector(20, 20, 100))	
end

function RamzaMysticDisbelief(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_mystic_mystic_arts_disbelief", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound("Hero_SkywrathMage.AncientSeal.Target")
end

function RamzaMysticHesitation(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_mystic_mystic_arts_hesitation", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.caster:EmitSound("Hero_Oracle.FatesEdict.Cast")
	keys.target:EmitSound("Hero_Oracle.FatesEdict")
end


function RamzaMysticQuiescence(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_mystic_mystic_arts_quiescence", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound("Hero_DeathProphet.Silence")
end

function RamzaMysticInvigoration(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	local iDamage = keys.ability:GetSpecialValueFor("damage")
	local damageTable = {
		damage = iDamage,
		attacker = keys.caster,
		victim = keys.target,
		ability = keys.ability,
		damage_type = DAMAGE_TYPE_PURE
	}
	ApplyDamage(damageTable)
	keys.caster:Heal(iDamage, keys.caster)
	
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true) 
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
	keys.caster:EmitSound('Hero_Bane.BrainSap')
	keys.target:EmitSound('Hero_Bane.BrainSap.Target')
	
	iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, iDamage, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(iDamage))+2, 0))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
end

function RamzaMysticDefenseBoostApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_mystic_defense_boost", {})
end

function RamzaMysticManafontApply(keys)	
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_mystic_manafont", {})
end

function RamzaMysticAbsorbMPApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_mystic_absorb_mp", {})
end