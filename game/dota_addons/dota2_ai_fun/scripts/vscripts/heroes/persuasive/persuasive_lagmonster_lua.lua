LinkLuaModifier("modifier_persuasive_lagmonster_lua", "heroes/persuasive/persuasive_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_persuasive_lagmonster_stun_lua", "heroes/persuasive/persuasive_modifiers.lua",  LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_persuasive_kill_steal_lua", "heroes/persuasive/persuasive_modifiers.lua",  LUA_MODIFIER_MOTION_NONE)
persuasive_lagmonster_lua = class({})

function persuasive_lagmonster_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hModifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_persuasive_lagmonster_lua", {Duration = self:GetSpecialValueFor("duration")})
end

persuasive_kill_steal = class({})

function persuasive_kill_steal:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_persuasive_kill_steal_lua", {Duration = self:GetSpecialValueFor("duration")})
end

function persuasive_kill_steal:GetCooldown(iLevel)
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_persuasive_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end