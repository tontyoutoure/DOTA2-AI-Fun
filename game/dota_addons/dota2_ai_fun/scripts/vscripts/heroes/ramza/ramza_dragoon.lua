LinkLuaModifier("modifier_ramza_dragoon_dragonheart", "heroes/ramza/ramza_dragoon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_dragoon_jump", "heroes/ramza/ramza_dragoon_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ramza_dragoon_jump_slow", "heroes/ramza/ramza_dragoon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
RamzaDragoonHeartApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_dragoon_dragonheart", {})
end

RamzaDragoonJumpOnSpellStart = function (self)
	local hCaster = self:GetCaster()
	local iFlyTime 
	if hCaster:HasModifier("modifier_ramza_dragoon_ignore_elevation") and not hCaster:PassivesDisabled() then
		fFlyTime = 1
	else
		fFlyTime = 5
	end
	
	local vMove = self:GetCursorPosition() - hCaster:GetOrigin()
	local vHorizantalSpeed = Vector(vMove.Dot(vMove, Vector(1, 0, 0)), vMove.Dot(vMove, Vector(0, 1, 0)), 0)/fFlyTime
	local vVerticalAcceleration = Vector(0, 0, -20000)
	local vVerticalSpeed = Vector(0, 0, vMove.Dot(vMove, Vector(0, 0, 1)))/fFlyTime - vVerticalAcceleration*fFlyTime/2
	local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_ramza_dragoon_jump", {Duration = fFlyTime})
	hModifier.vHorizantalSpeed = vHorizantalSpeed
	hModifier.vVerticalSpeed = vVerticalSpeed
	hModifier.vVerticalAcceleration= vVerticalAcceleration
	hModifier.vDestination = self:GetCursorPosition()
end


ramza_dragoon_jump1 = class({})
ramza_dragoon_jump2 = class({})
ramza_dragoon_jump3 = class({})
ramza_dragoon_jump4 = class({})
ramza_dragoon_jump5 = class({})
ramza_dragoon_jump8 = class({})


ramza_dragoon_jump1.OnSpellStart = RamzaDragoonJumpOnSpellStart
ramza_dragoon_jump2.OnSpellStart = RamzaDragoonJumpOnSpellStart
ramza_dragoon_jump3.OnSpellStart = RamzaDragoonJumpOnSpellStart
ramza_dragoon_jump4.OnSpellStart = RamzaDragoonJumpOnSpellStart
ramza_dragoon_jump5.OnSpellStart = RamzaDragoonJumpOnSpellStart
ramza_dragoon_jump8.OnSpellStart = RamzaDragoonJumpOnSpellStart
