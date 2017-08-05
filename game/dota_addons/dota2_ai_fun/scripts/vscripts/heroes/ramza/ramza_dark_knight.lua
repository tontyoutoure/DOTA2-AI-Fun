LinkLuaModifier("modifier_ramza_dark_knight_hp_boost", "heroes/ramza/ramza_dark_knight_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_dark_knight_vehemence", "heroes/ramza/ramza_dark_knight_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
RamzaDarkKnightHPBoostApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_dark_knight_hp_boost", {})
end


RamzaDarkKnightVehemenceToggle = function(keys)
	if keys.caster:HasModifier("modifier_ramza_dark_knight_vehemence") then
		keys.caster:RemoveModifierByName("modifier_ramza_dark_knight_vehemence")
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_dark_knight_vehemence", {})
	end
end


RamzaDarkKnightSanguineSword = function(keys)
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
	keys.caster:EmitSound('Hero_PhantomAssassin.CoupDeGrace')
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_POINT_FOLLOW,keys.target)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.caster, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,keys.caster:GetAbsOrigin(), true)
	
	iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, iDamage, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(iDamage))+2, 0))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
end

RamzaDarkKnightUnholySacrificeSelfDamage = function(keys)
	local iRadius = keys.ability:GetSpecialValueFor("radius")
	local damageTable = {
		damage = keys.caster:GetMaxHealth()*keys.ability:GetSpecialValueFor("self_damage")/100,
		victim = keys.caster,
		attacker = keys.caster,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticle, 4, Vector(iRadius*1.5, iRadius*1.5, iRadius*1.5))
end

RamzaDarkKnightShadowblade = function(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	local fMana = keys.target:GetMana()
	local fHealth = keys.target:GetHealth()
	ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN, keys.target)
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true) 
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true) 
	keys.target:Kill(keys.ability, keys.caster)
	keys.caster:ReduceMana(-fMana)
	keys.caster:Heal(fHealth, keys.caster)
	keys.caster:EmitSound('DOTA_Item.InvisibilitySword.Activate')
	
	
	iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHealth, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHealth))+2, 0))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
	
	
	iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fMana, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fMana))+2, 0))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(100, 100, 255))
	
end

RamzaDarkKnightCrushingBlow = function(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end	
	keys.target:EmitSound("DOTA_Item.AbyssalBlade.Activate")		
	ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("stun_duration")})
	local damageTable = {
		damage = keys.ability:GetSpecialValueFor("damage"),
		victim = keys.target,
		attacker = keys.caster,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
end

RamzaDarkKnightAbyssalBlade = function(keys)
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local fMaxDamage = keys.ability:GetSpecialValueFor("damage")
	local damageTable = {
		attacker = keys.caster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability
	}
	for k, v in pairs(tTargets) do
		damageTable.victim = v
		local fDistance = Vector(0,0,0).Length2D(v:GetAbsOrigin() - keys.caster:GetAbsOrigin())
		if fDistance < 300 then
			damageTable.damage = fMaxDamage
		else
			damageTable.damage = fMaxDamage-(fDistance-300)/(fRadius - 300)*0.75*fMaxDamage
		end
		
		ApplyDamage(damageTable)
		iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_d.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
		ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
		if fDistance < 700 then
			iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
			ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
		end
		if fDistance < 600 then
			iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
			ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
		end
		if fDistance < 500 then
			iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
			ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
		end
		if fDistance < 400 then
			iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
			ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
		end
		if fDistance < 300 then
			iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
			ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
		end		
	end
	
	damageTable = {
		damage = keys.caster:GetMaxHealth()*keys.ability:GetSpecialValueFor("self_damage")/100,
		victim = keys.caster,
		attacker = keys.caster,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
	keys.caster:EmitSound("Hero_DoomBringer.InfernalBlade.Target")
end

RamzaDarkKnightInfernalStrike = function(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end	
	local fMana = keys.ability:GetSpecialValueFor("mana_take")
	local fMana1 = keys.target:GetMana()
	local fActualMana
	if fMana1 > fMana then
		fActualMana = fMana
	else
		fActualMana = fMana1
	end
	keys.target:ReduceMana(fActualMana)
	keys.caster:ReduceMana(-fActualMana)
	local iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fActualMana, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fActualMana))+2, 0))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(150, 150, 255))

	
	keys.target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
end

