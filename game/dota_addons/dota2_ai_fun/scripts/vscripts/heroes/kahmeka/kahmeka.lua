LinkLuaModifier("modifier_kahmeka_fly", "heroes/kahmeka/kahmeka_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kahmeka_ignite", "heroes/kahmeka/kahmeka_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kahmeka_wounding_spear", "heroes/kahmeka/kahmeka_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kahmeka_wounding_spear_debuff", "heroes/kahmeka/kahmeka_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kahmeka_fungwarb", "heroes/kahmeka/kahmeka_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

kahmeka_ignite = class({})

kahmeka_fly = class({})
function kahmeka_fly:OnUpgrade()
	self:GetCaster():FindAbilityByName('kahmeka_fly_down_divebomb'):SetLevel(1)
	if self:GetLevel() == 1 then self:GetCaster():FindAbilityByName('kahmeka_fly_down_divebomb'):SetActivated(false) end
end
function kahmeka_fly:GetAssociatedSecondaryAbilities()
	return 'kahmeka_fly_down_divebomb'
end
function kahmeka_fly:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName('kahmeka_fly_down_divebomb'):SetActivated(true)
	self:SetActivated(false)
	hCaster:AddNewModifier(hCaster, self, 'modifier_kahmeka_fly', nil)
end


function kahmeka_fly:GetCooldown(iLevel)
	if not self.bSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_kahmeka_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
		self.bSpecial = true
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

kahmeka_fly_down_divebomb = class({})
function kahmeka_fly_down_divebomb:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName('kahmeka_fly'):SetActivated(true)
	self:SetActivated(false)
	hCaster:RemoveModifierByName('modifier_kahmeka_fly')
end

kahmeka_fly_down_divebomb.GetCooldown = kahmeka_fly.GetCooldown



function kahmeka_fly_down_divebomb:GetAssociatedPrimaryAbilities()
	return 'kahmeka_fly'
end
kahmeka_wounding_spear = class({})
function kahmeka_wounding_spear:GetIntrinsicModifierName() return "modifier_kahmeka_wounding_spear" end
kahmeka_fungwarb = class({})
function kahmeka_fungwarb:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound('Hero_Batrider.FlamingLasso.Cast')
	hCaster:AddNewModifier(hCaster, self, "modifier_kahmeka_fungwarb", {Duration = self:GetSpecialValueFor('duration')+CheckTalent(hCaster, 'special_bonus_unique_kahmeka_4')})

end

kahmeka_ignite = class({})
function kahmeka_ignite:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound('Hero_OgreMagi.Ignite.Cast')
	ProjectileManager:CreateTrackingProjectile({
	Target = self:GetCursorTarget(),
	Source = hCaster,
	Ability = self,	
	EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf",
    iMoveSpeed = self:GetSpecialValueFor('projectile_speed'),
	vSourceLoc= hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment('attach_attack1')) ,                -- Optional (HOW)
	bDrawsOnMinimap = false,                          -- Optional
	bDodgeable = true,                                -- Optional
	bIsAttack = false,                                -- Optional
	bVisibleToEnemies = true,                         -- Optional
	bReplaceExisting = false,                         -- Optional
	flExpireTime = GameRules:GetGameTime() + 20,      -- Optional but recommended
	bProvidesVision = false,                           -- Optional
})
end

function kahmeka_ignite:OnProjectileHit(hTarget, vLocation)
	if hTarget:TriggerSpellAbsorb(self) then return end
	hTarget:AddNewModifier(self:GetCaster(), self, 'modifier_kahmeka_ignite', {Duration = self:GetSpecialValueFor('duration')*(1-hTarget:GetStatusResistance())})
	hTarget:EmitSound('Hero_OgreMagi.Ignite.Target')
	ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_explosion.vpcf', PATTACH_ABSORIGIN_FOLLOW, hTarget)
end





