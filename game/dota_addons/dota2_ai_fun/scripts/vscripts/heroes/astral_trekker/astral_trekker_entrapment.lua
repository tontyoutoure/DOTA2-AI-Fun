LinkLuaModifier("modifier_astral_trekker_entrapment", "heroes/astral_trekker/astral_trekker_entrapment.lua", LUA_MODIFIER_MOTION_NONE)

astral_trekker_entrapment = class({})

function astral_trekker_entrapment:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_NagaSiren.Ensnare.Cast")
	ProjectileManager:CreateTrackingProjectile({
		Target = self:GetCursorTarget(),
		Source = shCaster,
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
		iVisionTeamNumber = hCaster:GetTeamNumber()        -- Optional	
	})
end

function astral_trekker_entrapment:OnProjectileHit(hTarget, vLocation)
	if hTarget:TriggerSpellAbsorb( self ) then return end
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_astral_trekker_entrapment", {Duration = self:GetSpecialValueFor("duration")})
	hTarget:EmitSound("Hero_NagaSiren.Ensnare.Target")
end
modifier_astral_trekker_entrapment = class({})

function modifier_astral_trekker_entrapment:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false} end

function modifier_astral_trekker_entrapment:IsDebuff() return true end

function modifier_astral_trekker_entrapment:IsPurgable() return true end

function modifier_astral_trekker_entrapment:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_astral_trekker_entrapment:GetEffectName() return "particles/units/heroes/hero_siren/siren_net.vpcf" end