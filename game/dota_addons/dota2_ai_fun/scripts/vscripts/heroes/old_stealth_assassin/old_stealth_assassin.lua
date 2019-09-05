LinkLuaModifier("modifier_old_stealth_assassin_permanent_invisibility", "heroes/old_stealth_assassin/old_stealth_assassin_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_stealth_assassin_permanent_invisibility_invisible", "heroes/old_stealth_assassin/old_stealth_assassin_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_stealth_assassin_critical_strike", "heroes/old_stealth_assassin/old_stealth_assassin_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_stealth_assassin_critical_strike_crit", "heroes/old_stealth_assassin/old_stealth_assassin_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_stealth_assassin_death_ward", "heroes/old_stealth_assassin/old_stealth_assassin_modifiers.lua", LUA_MODIFIER_MOTION_NONE)




old_stealth_assassin_permanent_invisibility = class({})
function old_stealth_assassin_permanent_invisibility:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_old_stealth_assassin_permanent_invisibility", {})
end

old_stealth_assassin_critical_strike = class({})
function old_stealth_assassin_critical_strike:OnUpgrade() 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_old_stealth_assassin_critical_strike", {})
end

old_stealth_assassin_blink = class({})

function old_stealth_assassin_blink:GetCooldown(iLevel)
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_stealth_assassin_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)+self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function old_stealth_assassin_blink:GetCastRange(vLocation, hTarget)
	if IsServer() then 
		return 99999
	else
		self.hSpecial2 = Entities:First()
		
		while self.hSpecial2 and (self.hSpecial2:GetName() ~= "special_bonus_unique_old_stealth_assassin_2" or self.hSpecial2:GetCaster() ~= self:GetCaster()) do
			self.hSpecial2 = Entities:Next(self.hSpecial2)
		end		
		if self.hSpecial2 then
			return self:GetSpecialValueFor("distance_max")+self.hSpecial2:GetSpecialValueFor("value")
		else
			return self:GetSpecialValueFor("distance_max")
		end
	end
end

function old_stealth_assassin_blink:OnSpellStart()
	local vDestination = self:GetCursorPosition()
	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetOrigin()
	local fMaxDistance = self:GetSpecialValueFor("distance_max")+self:GetCaster():GetCastRangeBonus()
	if hCaster:HasAbility("special_bonus_unique_old_stealth_assassin_2") then
		fMaxDistance = fMaxDistance+hCaster:FindAbilityByName("special_bonus_unique_old_stealth_assassin_2"):GetSpecialValueFor("value")
	end
	if (vDestination-vOrigin):Length2D() > fMaxDistance then
		local vDirection = Vector2D(vDestination-vOrigin):Normalized()
		vDestination = vOrigin+vDirection*fMaxDistance
	end
	FindClearSpaceForUnit(hCaster, vDestination, true)
	ProjectileManager:ProjectileDodge(hCaster)
	self.vDestination = hCaster:GetOrigin()	
--	FindClearSpaceForUnit(hCaster, vOrigin, true)
	hCaster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local iParticle1 = ParticleManager:CreateParticle("particles/econ/events/ti4/blink_dagger_end_ti4.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticle1, 0, self.vDestination)
	local iParticle2 = ParticleManager:CreateParticle("particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticle2, 0, vOrigin)
end
function old_stealth_assassin_blink:CastFilterResultLocation(vLocation)
	if IsClient() then return UF_SUCCESS end
	if (vLocation-self:GetCaster():GetOrigin()):Length2D() < self:GetSpecialValueFor("distance_min") then return UF_FAIL_CUSTOM end
	return UF_SUCCESS
end
function old_stealth_assassin_blink:GetCustomCastErrorLocation(vLocation)
	return "#error_destination_out_of_range"
end


old_stealth_assassin_death_ward = class({})
function old_stealth_assassin_death_ward:OnSpellStart()
	local tSummonLocations = {}
	local hCaster = self:GetCaster()
	if hCaster:HasAbility("special_bonus_unique_old_stealth_assassin_6") and hCaster:FindAbilityByName("special_bonus_unique_old_stealth_assassin_6"):GetLevel() > 0 then 
		local vCursor = self:GetCursorPosition()
		tSummonLocations[1] = vCursor+50*Vector(0,0,0).Cross(Vector(0,0,1), vCursor-hCaster:GetOrigin()):Normalized()
		tSummonLocations[2] = vCursor-50*Vector(0,0,0).Cross(Vector(0,0,1), vCursor-hCaster:GetOrigin()):Normalized()
	else
		tSummonLocations[1] = self:GetCursorPosition()
	end
	
	for _, v in ipairs(tSummonLocations) do
		local hWard = CreateUnitByName("old_stealth_assassin_death_ward", v, true, hCaster, hCaster, hCaster:GetTeamNumber())		
		hWard:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hWard, hWard:GetOrigin(), true)
		hWard:AddNewModifier(hCaster, self, "modifier_kill", {Duration = self:GetSpecialValueFor("duration")})
		hWard:SetBaseDamageMax(self:GetSpecialValueFor("attack")+2)
		hWard:SetBaseDamageMin(self:GetSpecialValueFor("attack")-2)
		hWard:SetPhysicalArmorBaseValue(self:GetSpecialValueFor("ward_armor"))
		if hCaster:HasAbility("special_bonus_unique_old_stealth_assassin_4") and hCaster:FindAbilityByName("special_bonus_unique_old_stealth_assassin_4"):GetLevel() > 0 then		
			hWard:AddNewModifier(hCaster, hCaster:FindAbilityByName("old_stealth_assassin_critical_strike"), "modifier_old_stealth_assassin_critical_strike", {})
		end
		hWard:AddNewModifier(hCaster, self, "modifier_old_stealth_assassin_death_ward", {})
		hWard:EmitSound("Hero_Riki.TricksOfTheTrade.Cast")
		ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hWard)
	end
end
