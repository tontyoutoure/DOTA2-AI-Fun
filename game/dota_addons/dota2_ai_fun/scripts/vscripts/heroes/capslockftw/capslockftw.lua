LinkLuaModifier("modifier_capslockftw_hax", "heroes/capslockftw/capslockftw_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_capslockftw_sarcasm", "heroes/capslockftw/capslockftw_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_capslockftw_flamer_buff", "heroes/capslockftw/capslockftw_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_capslockftw_flamer_debuff", "heroes/capslockftw/capslockftw_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
capslockftw_flamer = class({})

function capslockftw_flamer:GetCooldown(iLevel)
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_capslockftw_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function capslockftw_flamer:OnSpellStart()
	local hCaster = self:GetCaster()
--	ProcsArroundingMagicStick(hCaster)
	local hTarget = self:GetCursorTarget()
	if hTarget:GetTeam() == hCaster:GetTeam() then
		hTarget:AddNewModifier(hCaster, self, "modifier_capslockftw_flamer_buff", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
		hCaster:EmitSound("Hero_OgreMagi.Fireblast.Cast")
		hTarget:EmitSound("Hero_OgreMagi.Ignite.Target")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControl(iParticle, 1, hTarget:GetOrigin())
		ParticleManager:SetParticleControl(iParticle, 3, hTarget:GetOrigin())
		ApplyDamage({damage = self:GetSpecialValueFor("damage"), attacker = hCaster, victim = hTarget, ability = self, damage_type = self:GetAbilityDamageType()})
	else
		if hTarget:TriggerSpellAbsorb( self ) then return end
		hTarget:AddNewModifier(hCaster, self, "modifier_capslockftw_flamer_debuff", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
		hCaster:EmitSound("Hero_OgreMagi.Fireblast.Cast")
		hTarget:EmitSound("Hero_OgreMagi.Ignite.Target")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControl(iParticle, 1, hTarget:GetOrigin())
		ParticleManager:SetParticleControl(iParticle, 3, hTarget:GetOrigin())
		ApplyDamage({damage = self:GetSpecialValueFor("damage"), attacker = hCaster, victim = hTarget, ability = self, damage_type = self:GetAbilityDamageType()})
	end
end

function CAPSLOCKFTWHaxOn(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.caster:EmitSound("DOTA_Item.InvisibilitySword.Activate")
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_capslockftw_hax", {})
	keys.ability:StartCooldown(0.5)
end

function CAPSLOCKFTWHaxOff(keys)
	keys.caster:RemoveModifierByName("modifier_capslockftw_hax")
end

function CAPSLOCKFTWSarcasmApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_capslockftw_sarcasm", {})
end

capslockftw_ban = class({})
function capslockftw_ban:GetCooldown() 
	if self:GetCaster():HasScepter() then
		return 40
	else
		return 120
	end
end
function capslockftw_ban:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end
function capslockftw_ban:GetAOERadius()
	return self:GetSpecialValueFor("aoe_scepter")
end
function capslockftw_ban:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:HasScepter() then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetCursorTarget():GetOrigin(), nil, self:GetSpecialValueFor("aoe_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for k, hTarget in ipairs(tTargets) do
			ApplyDamage({victim = hTarget, attacker = hCaster, damage_type = self:GetAbilityDamageType(), damage = self:GetSpecialValueFor("damage")*(PlayerResource:GetDeaths(hTarget:GetPlayerOwnerID())-PlayerResource:GetKills(hTarget:GetPlayerOwnerID())), ability = self})
			hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun_duration")})
			hTarget:EmitSound("ui.ban_captains")
			hTarget:EmitSound("ui.ban_captains")
			hTarget:EmitSound("ui.ban_captains")
			hTarget:EmitSound("ui.ban_captains")
			hTarget:EmitSound("ui.ban_captains")
			hTarget:EmitSound("ui.ban_captains")
				
			local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:SetParticleControlEnt(iParticle, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
			ParticleManager:SetParticleControlForward( iParticle, 3, -hCaster:GetForwardVector())
		end
	else	
		local hTarget = self:GetCursorTarget()
		ApplyDamage({victim = hTarget, attacker = hCaster, damage_type = self:GetAbilityDamageType(), damage = self:GetSpecialValueFor("damage")*(PlayerResource:GetDeaths(hTarget:GetPlayerOwnerID())-PlayerResource:GetKills(hTarget:GetPlayerOwnerID())), ability = self})
		hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun_duration")})
		hTarget:EmitSound("ui.ban_captains")
		hTarget:EmitSound("ui.ban_captains")
			
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(iParticle, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
		ParticleManager:SetParticleControlForward( iParticle, 3, -hCaster:GetForwardVector())
	end
end