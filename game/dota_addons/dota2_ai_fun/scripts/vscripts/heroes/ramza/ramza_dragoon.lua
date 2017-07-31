LinkLuaModifier("modifier_ramza_dragoon_dragonheart", "heroes/ramza/ramza_dragoon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_dragoon_jump", "heroes/ramza/ramza_dragoon_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)

RamzaDragoonHeartApply = function(keys)
	keys.caster:AddNewModifier("modifier_ramza_dragoon_dragonheart")
end

RamzaDragoonJump = function (self)
	local hCaster = self:GetCaster()
	local iFlyTime 
	if hCaster:HasModifier("ramza_dragoon_ignore_elevation") then
		fFlyTime = 1
	else
		fFlyTime = 5
	end
	
	local vMove = self:GetCursorPosition() - hCaster:GetOrigin()
	local vHorizantalSpeed = Vector(vMove.__Dot(vMove, Vector(1, 0, 0)), vMove.__Dot(vMove, Vector(0, 1, 0)), 0)/fFlyTime
	local vVerticalAcceleration = Vector(0, 0, -500)
	local vVerticalSpeed = Vector(0, 0, vMove.__Dot(vMove, Vector(0, 0, 1)))/fFlyTime - vVerticalAcceleration*fFlyTime/2
	hCaster:AddNewModifier(hCaster, self, "modifier_ramza_dragoon_jump", {Duration = fFlyTime})
end

