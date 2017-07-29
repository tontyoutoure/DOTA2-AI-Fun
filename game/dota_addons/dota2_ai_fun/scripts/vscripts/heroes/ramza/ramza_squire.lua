LinkLuaModifier("modifier_ramza_squire_counter_tackle", "heroes/ramza/ramza_squire_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_squire_fundamental_rush", "heroes/ramza/ramza_squire_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)

function RamzaSquireStoneHit(keys)	
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	local damageTable = {
		damage = keys.ability:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		victim = keys.target,
		attacker = keys.caster,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_squire_fundamental_stone_stun", {})
	keys.target:EmitSound("Brewmaster_Earth.Boulder.Target")
end

function RamzaSquireDefendToggle(keys)
	if keys.caster:HasModifier("modifier_ramza_squire_defend") then
		keys.caster:FindModifierByName("modifier_ramza_squire_defend"):Destroy()
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_squire_defend", {})
	end
end

ramza_squire_counter_tackle = class({})

function ramza_squire_counter_tackle:GetIntrinsicModifierName() return "modifier_ramza_squire_counter_tackle" end

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














