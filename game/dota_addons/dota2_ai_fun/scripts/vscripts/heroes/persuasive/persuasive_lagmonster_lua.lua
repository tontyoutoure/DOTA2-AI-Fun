LinkLuaModifier("modifier_persuasive_lagmonster_lua", "heroes/persuasive/persuasive_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_persuasive_kill_steal_lua", "heroes/persuasive/persuasive_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_persuasive_high_stakes", "heroes/persuasive/persuasive_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
persuasive_lagmonster_lua = class({})

function persuasive_lagmonster_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hModifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_persuasive_lagmonster_lua", {Duration = self:GetSpecialValueFor("duration")})
end
persuasive_high_stakes = class({})

function persuasive_high_stakes:GetIntrinsicModifierName() 
	return "modifier_persuasive_high_stakes"
end

persuasive_kill_steal = class({})

function persuasive_kill_steal:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_persuasive_kill_steal_lua", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(self:GetCursorTarget())})
end

function persuasive_kill_steal:GetCooldown(iLevel)
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_persuasive_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end