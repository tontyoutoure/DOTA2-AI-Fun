LinkLuaModifier("modifier_ramza_dark_knight_hp_boost", "heroes/ramza/ramza_dark_knight_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

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
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_POINT_FOLLOW,keys.target)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.caster:GetOrigin())
end

