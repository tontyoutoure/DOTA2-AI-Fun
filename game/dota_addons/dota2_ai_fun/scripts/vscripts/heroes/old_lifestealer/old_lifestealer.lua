LinkLuaModifier("modifier_old_lifestealer_feast", "heroes/old_lifestealer/old_lifestealer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_lifestealer_anabolic_frenzy", "heroes/old_lifestealer/old_lifestealer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_lifestealer_poison_sting", "heroes/old_lifestealer/old_lifestealer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_lifestealer_poison_sting_slow", "heroes/old_lifestealer/old_lifestealer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_lifestealer_rage_aura", "heroes/old_lifestealer/old_lifestealer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_lifestealer_rage", "heroes/old_lifestealer/old_lifestealer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)



old_lifestealer_feast = class({})
function old_lifestealer_feast:OnUpgrade() self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_old_lifestealer_feast", {}) end

old_lifestealer_anabolic_frenzy = class({})
function old_lifestealer_anabolic_frenzy:OnUpgrade() self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_old_lifestealer_anabolic_frenzy", {}) end

old_lifestealer_poison_sting = class({})
function old_lifestealer_poison_sting:OnUpgrade() self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_old_lifestealer_poison_sting", {}) end


old_lifestealer_rage = class({})

function old_lifestealer_rage:GetCastRange()
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("radius_scepter") else return 0 end
end

function old_lifestealer_rage:GetBehavior()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_lifestealer_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function old_lifestealer_rage:OnSpellStart() 
	local hCaster = self:GetCaster()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_lifestealer_3" or self.hSpecial:GetCaster() ~= hCaster) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	
	StartAnimation(hCaster, {duration = 0.4, activity = ACT_DOTA_LIFESTEALER_RAGE})
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		hCaster:Purge(false, true, false, true, true)
	end
	hCaster:EmitSound("Hero_LifeStealer.Rage")
	hCaster:AddNewModifier(hCaster, self, "modifier_old_lifestealer_rage_aura", {Duration = self:GetSpecialValueFor("duration")})
end