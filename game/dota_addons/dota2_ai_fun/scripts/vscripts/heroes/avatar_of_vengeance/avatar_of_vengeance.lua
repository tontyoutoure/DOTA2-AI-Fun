LinkLuaModifier("modifier_avatar_of_vengeance_phase", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_reality", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_vengeance_aura", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_vengeance", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_dispersion", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_direct_vengeance", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_haunt_freeze", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_haunt", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avatar_of_vengeance_haunt_uncontrollable", "heroes/avatar_of_vengeance/avatar_of_vengeance_modifiers.lua", LUA_MODIFIER_MOTION_NONE)



AvatarOfVengeancePhase = function(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_avatar_of_vengeance_phase", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.caster:EmitSound("Hero_Spectre.DaggerCast")
end
avatar_of_vengeance_haunt = class({})
function avatar_of_vengeance_haunt:GetAssociatedPrimaryAbilities() return "avatar_of_vengeance_reality" end

function avatar_of_vengeance_haunt:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_avatar_of_vengeance_haunt", {})
	self:GetCaster():EmitSound("Hero_Spectre.HauntCast")
end

function avatar_of_vengeance_haunt:OnUpgrade()
	if self:GetLevel() == 4 then self:GetCaster():FindAbilityByName(self:GetAssociatedPrimaryAbilities()):SetLevel(1) end
end



avatar_of_vengeance_reality = class({})
function avatar_of_vengeance_reality:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_avatar_of_vengeance_reality", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_avatar_of_vengeance_reality")
	end
end
function avatar_of_vengeance_reality:ProcsMagicStick() return false end
function avatar_of_vengeance_reality:IsStealable() return false end


avatar_of_vengeance_direct_vengeance = class({})
function avatar_of_vengeance_direct_vengeance:IsStealable() return false end
function avatar_of_vengeance_direct_vengeance:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	if not hCaster:HasAbility("avatar_of_vengeance_vengeance") then return end
	hTarget:EmitSound("Hero_Spectre.DaggerImpact")
	hTarget:AddNewModifier(hCaster, self, "modifier_avatar_of_vengeance_direct_vengeance", {Duration = CalculateStatusResist(hTarget)*self:GetSpecialValueFor("duration")})
end
function avatar_of_vengeance_direct_vengeance:GetCooldown(iLevel)
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_avatar_of_vengeance_4" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)+self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

avatar_of_vengeance_vengeance = class({})
function avatar_of_vengeance_vengeance:GetIntrinsicModifierName() return "modifier_avatar_of_vengeance_vengeance_aura" end
function avatar_of_vengeance_vengeance:OnUpgrade()
	if self:GetLevel() == 1 then self:GetCaster():FindAbilityByName("avatar_of_vengeance_direct_vengeance"):SetLevel(1) end
end

function avatar_of_vengeance_vengeance:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	local iDamage
	if tExtraData.IsHero == 1 then
		if self:GetCaster():HasScepter() then
			iDamage = self:GetSpecialValueFor("damage_hero_scepter")
		else
			iDamage = self:GetSpecialValueFor("damage_hero")
		end
	else
		if self:GetCaster():HasScepter() then
			iDamage = self:GetSpecialValueFor("damage_creep_scepter")
		else
			iDamage = self:GetSpecialValueFor("damage_creep")
		end
	end
	hTarget:EmitSound("Hero_Spectre.Desolate")
	ApplyDamage({victim = hTarget, damage = iDamage, damage_type = self:GetAbilityDamageType(), ability = self, attacker = self:GetCaster()})
end

avatar_of_vengeance_dispersion = class({})
function avatar_of_vengeance_dispersion:GetIntrinsicModifierName() return "modifier_avatar_of_vengeance_dispersion" end