LinkLuaModifier("modifier_ramza_archer_concentration_immune", "heroes/ramza/ramza_archer_modifiers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_archer_archers_bane", "heroes/ramza/ramza_archer_modifiers", LUA_MODIFIER_MOTION_NONE)

function ramza_archer_aim_OnSpellStart(self)
	local hCaster = self:GetCaster()
	self.hTarget = self:GetCursorTarget()
	if hCaster:FindModifierByName("modifier_ramza_archer_concentration") then
		hCaster:AddNewModifier(hCaster, hCaster:FindAbilityByName("ramza_archer_concentration"), "modifier_ramza_archer_concentration_immune", {Duration = self:GetSpecialValueFor("maximum_channel_time")})
	end
end

function ramza_archer_aim_GetChannelAnimation(self)
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function ramza_archer_aim_OnChannelFinish(self)
		ProjectileManager:CreateTrackingProjectile({
		Target = self.hTarget,
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		bDodgeable = true,
		flExpireTime = GameRules:GetGameTime() + 20, 
		bVisibleToEnemies = true,
		ExtraData = {damage = self:GetSpecialValueFor("damage_per_half_sec")*math.floor((GameRules:GetGameTime()-self:GetChannelStartTime())*2), victim = self:GetCursorTarget()}
	})
	self:GetCaster():RemoveModifierByName("modifier_ramza_archer_concentration_immune")
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 3)
end


function ramza_archer_aim_OnProjectileHit_ExtraData(self, hTarget, vLocation, tExtraData)
	local damageTable = {
		damage = tExtraData.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		attacker = self:GetCaster(),
		victim = hTarget,
		ability = self
	}
	ApplyDamage(damageTable)
end


ramza_archer_aim_2 = class({})

ramza_archer_aim_2.OnSpellStart = ramza_archer_aim_OnSpellStart

ramza_archer_aim_2.OnChannelFinish = ramza_archer_aim_OnChannelFinish

ramza_archer_aim_2.OnProjectileHit_ExtraData = ramza_archer_aim_OnProjectileHit_ExtraData

ramza_archer_aim_2.GetChannelAnimation = ramza_archer_aim_GetChannelAnimation


ramza_archer_aim_4 = class({})

ramza_archer_aim_4.OnSpellStart = ramza_archer_aim_OnSpellStart

ramza_archer_aim_4.OnChannelFinish = ramza_archer_aim_OnChannelFinish

ramza_archer_aim_4.OnProjectileHit_ExtraData = ramza_archer_aim_OnProjectileHit_ExtraData

ramza_archer_aim_4.GetChannelAnimation = ramza_archer_aim_GetChannelAnimation


ramza_archer_aim_6 = class({})

ramza_archer_aim_6.OnSpellStart = ramza_archer_aim_OnSpellStart

ramza_archer_aim_6.OnChannelFinish = ramza_archer_aim_OnChannelFinish

ramza_archer_aim_6.OnProjectileHit_ExtraData = ramza_archer_aim_OnProjectileHit_ExtraData

ramza_archer_aim_6.GetChannelAnimation = ramza_archer_aim_GetChannelAnimation



ramza_archer_aim_7 = class({})

ramza_archer_aim_7.OnSpellStart = ramza_archer_aim_OnSpellStart

ramza_archer_aim_7.OnChannelFinish = ramza_archer_aim_OnChannelFinish

ramza_archer_aim_7.OnProjectileHit_ExtraData = ramza_archer_aim_OnProjectileHit_ExtraData

ramza_archer_aim_7.GetChannelAnimation = ramza_archer_aim_GetChannelAnimation



ramza_archer_aim_10 = class({})

ramza_archer_aim_10.OnSpellStart = ramza_archer_aim_OnSpellStart

ramza_archer_aim_10.OnChannelFinish = ramza_archer_aim_OnChannelFinish

ramza_archer_aim_10.OnProjectileHit_ExtraData = ramza_archer_aim_OnProjectileHit_ExtraData

ramza_archer_aim_10.GetChannelAnimation = ramza_archer_aim_GetChannelAnimation


ramza_archer_aim_20 = class({})

ramza_archer_aim_20.OnSpellStart = ramza_archer_aim_OnSpellStart

ramza_archer_aim_20.OnChannelFinish = ramza_archer_aim_OnChannelFinish

ramza_archer_aim_20.OnProjectileHit_ExtraData = ramza_archer_aim_OnProjectileHit_ExtraData

ramza_archer_aim_20.GetChannelAnimation = ramza_archer_aim_GetChannelAnimation

ramza_archer_archers_bane = class({})

function ramza_archer_archers_bane:OnUpgrade() 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_ramza_archer_archers_bane', {})
end

function ramza_archer_archers_bane:OnProjectileHit(hTarget, vLocation)
	local iParticle = ParticleManager:CreateParticle( 'particles/msg_fx/msg_miss.vpcf', PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(iParticle, 1, Vector(63, 0, 0))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, 2, 100))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(255, 255, 255))
end









