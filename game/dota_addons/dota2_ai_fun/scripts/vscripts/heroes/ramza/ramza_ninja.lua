LinkLuaModifier("modifier_ramza_ninja_reflexes", "heroes/ramza/ramza_ninja_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


RmazaNinjaReflexesApply = function (keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_ninja_reflexes", {})
end

RamzaNinjaVanishApply = function (keys)
	keys.unit:AddNewModifier(keys.unit, keys.ability, 'modifier_invisible', {Duration = keys.ability:GetSpecialValueFor("duration")})
end


RamzaNinjaVanishToggle = function(keys)
	if keys.caster:HasModifier('modifier_ramza_ninja_vanish') then
		keys.caster:RemoveModifierByName('modifier_ramza_ninja_vanish')
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, 'modifier_ramza_ninja_vanish', {})
	end
end

local tThrowProjectiles = {
	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
	"particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf",
	"particles/units/heroes/hero_lone_druid/lone_druid_base_attack.vpcf",
	"particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf",
	"particles/units/heroes/hero_techies/techies_base_attack.vpcf",
	"particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf"
}

local tThrowDamge = {
	{1, 100},
	{101, 200},
	{201, 300},
	{301, 400},
	{401, 500},
	{501, 600},	
}

local tThrowSound = {
	"Hero_BountyHunter.Shuriken",
	"Hero_TrollWarlord.WhirlingAxes.Ranged",
	"DOTA_Item.Necronomicon.Activate",
	"Hero_Enchantress.Attack",
	"Hero_Techies.Attack",
	"Hero_PhantomAssassin.Dagger.Cast"
}


local tImpactSound = {
	"Hero_BountyHunter.Shuriken.Impact",
	"Hero_TrollWarlord.ProjectileImpact",
	"Item.TomeOfKnowledge",
	"Hero_Enchantress.ProjectileImpact",
	"Hero_Techies.ProjectileImpact",
	"Hero_PhantomAssassin.Dagger.Target"
}

local tThrowStun = {1, 2, 3, 4, 5, 6}

ramza_ninja_throw_shuriken = class({})
ramza_ninja_throw_axe = class({})
ramza_ninja_throw_book = class({})
ramza_ninja_throw_polearm = class({})
ramza_ninja_throw_bomb = class({})
ramza_ninja_throw_ninja_blade = class({})

local RamzaThrowOnSpellStart = function(self)
	local iMax 
	if self:GetName() == "ramza_ninja_throw_shuriken" then 
		iMax = 1
	elseif self:GetName() == "ramza_ninja_throw_axe" then
		iMax = 2
	elseif self:GetName() == "ramza_ninja_throw_book" then
		iMax = 3
	elseif self:GetName() == "ramza_ninja_throw_polearm" then
		iMax = 4
	elseif self:GetName() == "ramza_ninja_throw_bomb" then
		iMax = 5
	else 
		iMax = 6
	end
	local iThrow = RandomInt(1, iMax)
	self:GetCaster():EmitSound(tThrowSound[iThrow])
	ProjectileManager:CreateTrackingProjectile({
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,
		EffectName = tThrowProjectiles[iThrow],
		iMoveSpeed = 1000,
		bDodgeable = true,
		flExpireTime = GameRules:GetGameTime() + 20, 
		bVisibleToEnemies = true,
		ExtraData = {damage = RandomFloat(tThrowDamge[iThrow][1], tThrowDamge[iThrow][2]), stun_duration = tThrowStun[iThrow], impact_sound = tImpactSound[iThrow]}
	})
end

local RamzaThrowOnProjectileHit_ExtraData = function(self, hTarget, vLocation, tExtraData)		
	if hTarget:TriggerSpellAbsorb( self ) then return end
	local damageTable = {
		damage = tExtraData.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		attacker = self:GetCaster(),
		victim = hTarget,
		ability = self
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound(tExtraData.impact_sound)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration = tExtraData.stun_duration})
end

ramza_ninja_throw_shuriken.OnSpellStart = RamzaThrowOnSpellStart
ramza_ninja_throw_axe.OnSpellStart = RamzaThrowOnSpellStart
ramza_ninja_throw_book.OnSpellStart = RamzaThrowOnSpellStart
ramza_ninja_throw_polearm.OnSpellStart = RamzaThrowOnSpellStart
ramza_ninja_throw_bomb.OnSpellStart = RamzaThrowOnSpellStart
ramza_ninja_throw_ninja_blade.OnSpellStart = RamzaThrowOnSpellStart

ramza_ninja_throw_shuriken.OnProjectileHit_ExtraData = RamzaThrowOnProjectileHit_ExtraData
ramza_ninja_throw_axe.OnProjectileHit_ExtraData = RamzaThrowOnProjectileHit_ExtraData
ramza_ninja_throw_book.OnProjectileHit_ExtraData = RamzaThrowOnProjectileHit_ExtraData
ramza_ninja_throw_polearm.OnProjectileHit_ExtraData = RamzaThrowOnProjectileHit_ExtraData
ramza_ninja_throw_bomb.OnProjectileHit_ExtraData = RamzaThrowOnProjectileHit_ExtraData
ramza_ninja_throw_ninja_blade.OnProjectileHit_ExtraData = RamzaThrowOnProjectileHit_ExtraData