LinkLuaModifier("modifier_astral_trekker_entrapment", "heroes/astral_trekker/astral_trekker_entrapment.lua", LUA_MODIFIER_MOTION_NONE)

astral_trekker_entrapment = class({})
function astral_trekker_entrapment:GetBehavior()
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_astral_trekker_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE
	else return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end
function astral_trekker_entrapment:OnSpellStart()
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_astral_trekker_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_NagaSiren.Ensnare.Cast")
	local iAOE 
	if self.hSpecial then iAOE = self.hSpecial:GetSpecialValueFor("value") else iAOE = 0 end
	local hTarget = self:GetCursorTarget()

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, iAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i, v in ipairs(tTargets) do
		ProjectileManager:CreateTrackingProjectile({
		Target = v,
		Source = hCaster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("net_speed"),
		vSourceLoc= hCaster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = false,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = hCaster:GetTeamNumber(),       -- Optional
		ExtraData = {bIsTarget = (v==hTarget)}
		})
	end

end

function astral_trekker_entrapment:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	if tExtraData.bIsTarget > 0 then
		if hTarget:TriggerSpellAbsorb( self ) then return end
	end
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_astral_trekker_entrapment", {Duration = self:GetSpecialValueFor("duration")})
	hTarget:EmitSound("Hero_NagaSiren.Ensnare.Target")
end
modifier_astral_trekker_entrapment = class({})

function modifier_astral_trekker_entrapment:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false} end

function modifier_astral_trekker_entrapment:IsDebuff() return true end

function modifier_astral_trekker_entrapment:IsPurgable() return true end

function modifier_astral_trekker_entrapment:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_astral_trekker_entrapment:GetEffectName() return "particles/units/heroes/hero_siren/siren_net.vpcf" end