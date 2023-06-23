LinkLuaModifier("modifier_ramza_samurai_bonecrusher", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_samurai_iaido_masamune", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_samurai_doublehand", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_samurai_shirahadori", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_samurai_iaido_chirijiraden", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_samurai_iaido_kikuichimonji", "heroes/ramza/ramza_samurai_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
function RamzaSamuraiAshura(keys)
	ProcsArroundingMagicStick(keys.caster)
	local tDamageTable = {
		attacker = keys.caster,
		damage = keys.ability:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_PURE,
		ability = keys.ability
	}
	for k, v in ipairs(keys.target_entities) do
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
		ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, 'attach_attack1' ,keys.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,v:GetAbsOrigin(), true)
		v:EmitSound("Hero_Juggernaut.Attack")
		tDamageTable.victim = v
		ApplyDamage(tDamageTable)
	end
end

function RamzaSamuraiOsafune(keys)
	ProcsArroundingMagicStick(keys.caster)
	for k, v in ipairs(keys.target_entities) do
		if v:GetMana() > 0 then
			local fMana = keys.ability:GetSpecialValueFor("mana")
			if fMana > v:GetMana() then fMana = v:GetMana() end
			v:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
			ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
			v:Script_ReduceMana(fMana, keys.ability)
			local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, v)
			ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, math.floor(fMana), 0))
			ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2+math.floor(math.log10(fMana)), 500))
			ParticleManager:SetParticleControl(iParticle1, 3, Vector(20, 20, 200))
		end
	end
end

function RamzaSamuraiMasamune(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.caster:EmitSound("Hero_LegionCommander.PressTheAttack")
	for k, v in ipairs(keys.target_entities) do
		v:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_iaido_masamune", {Duration = keys.ability:GetSpecialValueFor("duration")})
	end
end

function RamzaSamuraiKikuichimonji(keys)
	ProcsArroundingMagicStick(keys.caster)
	local iRadius = keys.ability:GetSpecialValueFor("radius")
	for i = 1, 100 do
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_petals_serrakura.vpcf", PATTACH_ABSORIGIN, keys.caster)

		ParticleManager:SetParticleControlEnt(iParticle, 3, keys.caster, PATTACH_POINT_FOLLOW, 'attach_attack1' ,keys.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticle, 2, keys.caster:GetAbsOrigin()+RandomVector(iRadius))
	end
	for k, v in pairs(keys.target_entities) do
		v:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_iaido_kikuichimonji", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(v)})
	end
end

function RamzaSamuraiKikuichimonjiRamzaSamuraiKikuichimonjiBlade(keys)
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.target, PATTACH_POINT, 'follow_overhead' ,keys.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, 'attach_hitloc' ,keys.target:GetAbsOrigin(), true)
end

RamzaSamuraiBoneCrusherApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_bonecrusher", {})
end

RamzaSamuraiDoublehandApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_doublehand", {})
end
RamzaSamuraiShirahadoriApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_shirahadori", {})
end

function RamzaSamuraiProc(keys) ProcsArroundingMagicStick(keys.caster) end

function RamzaSamuraiChirijiradenBlade(keys)
	ProcsArroundingMagicStick(keys.caster) 
	for k, v in pairs(keys.target_entities) do
		v:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_samurai_iaido_chirijiraden", {Duration = keys.ability:GetSpecialValueFor("duration")*CalculateStatusResist(v)})
	end
end