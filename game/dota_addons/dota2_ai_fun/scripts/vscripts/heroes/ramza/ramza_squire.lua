LinkLuaModifier("modifier_ramza_squire_counter_tackle", "heroes/ramza/ramza_squire_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_squire_fundamental_rush", "heroes/ramza/ramza_squire_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)

ramza_squire_fundamental_stone = class({})

function ramza_squire_fundamental_stone:OnSpellStart()
	local info = 
	{
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,	
		EffectName = "particles/units/heroes/hero_brewmaster/brewmaster_hurl_boulder.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("speed"),
		vSourceLoc= self:GetCaster():GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = true,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 20,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
	self:GetCaster():EmitSound("Brewmaster_Earth.Boulder.Cast")
end

function ramza_squire_fundamental_stone:OnProjectileHit(hTarget, vLocation)	
	if hTarget:TriggerSpellAbsorb( self ) then return end
	local damageTable = {
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		victim = hTarget,
		attacker = self:GetCaster(),
		ability = self
	}
	ApplyDamage(damageTable)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun")})
	hTarget:EmitSound("Brewmaster_Earth.Boulder.Target")
end

function RamzaSquireDefendToggle(keys)
	if keys.caster:HasModifier("modifier_ramza_squire_defend") then
		keys.caster:FindModifierByName("modifier_ramza_squire_defend"):Destroy()
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_squire_defend", {})
	end
end

ramza_squire_counter_tackle = class({})

function ramza_squire_counter_tackle:OnUpgrade() 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ramza_squire_counter_tackle" ,{})
end

function RamzaSquireChant(keys)
	local fCurrentHealth = keys.caster:GetHealth()
	local fHealthCost = keys.ability:GetSpecialValueFor("health_cost")
	if fHealthCost < fCurrentHealth-1 then 
		keys.caster:SetHealth(fCurrentHealth-fHealthCost)
	else
		keys.caster:SetHealth(1)
	end
end


ramza_squire_fundamental_rush = class({})


function ramza_squire_fundamental_rush:OnSpellStart()	
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vDirection = hTarget:GetAbsOrigin()-hCaster:GetAbsOrigin()
	local vHorizontalDirection = Vector(Vector().Dot(vDirection, Vector(1,0,0)),Vector().Dot(vDirection, Vector(0,1,0)), 0):Normalized()
	local fSpeed  = self:GetSpecialValueFor("knock_speed")
	local vSpeed = fSpeed*vHorizontalDirection
	local hModifier = hTarget:AddNewModifier(hCaster, self, "modifier_ramza_squire_fundamental_rush", {Duration = self:GetSpecialValueFor("knock_back")/fSpeed})
	hModifier.vSpeed = vSpeed
	local damageTable = {
		damage = self:GetSpecialValueFor('damage'),
		attacker = hCaster,
		victim = hTarget,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")
	
end














