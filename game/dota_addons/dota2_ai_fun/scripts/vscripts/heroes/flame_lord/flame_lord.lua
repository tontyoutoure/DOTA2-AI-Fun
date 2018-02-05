LinkLuaModifier("modifier_flame_lord_enflame", "heroes/flame_lord/flame_lord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function FlameLordEnflameOnSpellStart(self)
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_flame_lord_enflame", {Duration = self:GetSpecialValueFor("duration")})
end

function FlameLordEnflameCastFilterResultTarget(self, hTarget)
	if hTarget == self:GetCaster() then 
		return UF_FAIL_CUSTOM
	elseif hTarget:IsBuilding() then
		return UF_FAIL_BUILDING
	end
end

function FlameLordEnflameGetCustomCastErrorTarget(self, hTarget)
	return "#dota_hud_error_cant_cast_on_self"
end

flame_lord_enflame = class({})
flame_lord_enflame.OnSpellStart = FlameLordEnflameOnSpellStart
flame_lord_enflame.CastFilterResultTarget = FlameLordEnflameCastFilterResultTarget
flame_lord_enflame.GetCustomCastErrorTarget = FlameLordEnflameGetCustomCastErrorTarget

flame_lord_enflame_talented = class({})
flame_lord_enflame_talented.OnSpellStart = FlameLordEnflameOnSpellStart
flame_lord_enflame_talented.CastFilterResultTarget = FlameLordEnflameCastFilterResultTarget
flame_lord_enflame_talented.GetCustomCastErrorTarget = FlameLordEnflameGetCustomCastErrorTarget
