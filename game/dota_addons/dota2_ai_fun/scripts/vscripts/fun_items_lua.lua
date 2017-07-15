LinkLuaModifier("modifier_item_fun_sprint_shoes_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_regen_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ragnarok_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

item_fun_sprint_shoes = class({})

function item_fun_sprint_shoes:GetIntrinsicModifierName()
	return "modifier_item_fun_sprint_shoes_lua"
end

function item_fun_sprint_shoes:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	caster:EmitSound("Hero_Wisp.TeleportIn.Arc")
	ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", PATTACH_ABSORIGIN, caster)

	ProjectileManager:ProjectileDodge(caster)

	caster:SetAbsOrigin(target)
	FindClearSpaceForUnit(caster, target, false)
	
	Timers:CreateTimer(0.07, function ()
			caster:EmitSound("Hero_Wisp.TeleportOut.Arc") 
			ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf", PATTACH_ABSORIGIN, caster) 
		end)
	
end

item_fun_escutcheon = class({})

function item_fun_escutcheon:GetIntrinsicModifierName()
	return "modifier_item_fun_escutcheon_lua"
end

item_fun_ragnarok = class({})

function item_fun_ragnarok:GetIntrinsicModifierName()
	return "modifier_item_fun_ragnarok_lua"
end