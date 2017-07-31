modifier_ramza_black_mage_magick_counter = class({})

function modifier_ramza_black_mage_magick_counter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REFLECT_SPELL,
	}
end

function modifier_ramza_black_mage_magick_counter:IsHidden() return true end

function modifier_ramza_black_mage_magick_counter:RemoveOnDeath() return false end

function modifier_ramza_black_mage_magick_counter:GetReflectSpell(keys) 
	local hAbility = keys.ability
	local hParent = self:GetParent()
	local hCaster = hAbility:GetCaster()
	if hParent.hRamzaJob.tJobLevels[hParent.hRamzaJob.iCurrentJob] < 3 then return end
	local bHasArcaneStrength = hParent:HasModifier('modifier_ramza_black_mage_arcane_strength')
	local damageTable = {
		victim = hCaster,
		attacker = hParent,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	}
	
	if RandomInt(1, 3) == 3 then
		if not bHasArcaneStrength then damageTable.damage = 125 else damageTable.damage = 187.5	end
		ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_ABSORIGIN, hCaster)		
		Timers:CreateTimer(0.3, function () ApplyDamage(damageTable) end )
		hCaster:EmitSound("Ability.FrostNova")
	elseif RandomInt(1, 2) == 2 then
		if not bHasArcaneStrength then damageTable.damage = 250 else damageTable.damage = 375 end
		hCaster:AddNewModifier(hParent, hAbility, "modifier_stunned", {Duration = 0.01})
		ApplyDamage(damageTable)
		hCaster:EmitSound("Hero_OgreMagi.Fireblast.Target")	
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_POINT_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(particle, 1, hCaster:GetAbsOrigin())
	else
		
		if not bHasArcaneStrength then damageTable.damage = 375 else damageTable.damage = 562.5 end
		ApplyDamage(damageTable)
		hCaster:Purge(true, false, false, false, false)
		hCaster:EmitSound("Hero_Zuus.LightningBolt")
		local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(particle, 1, hCaster:GetAbsOrigin()+Vector(0,0,2000))
		ParticleManager:SetParticleControl(particle, 3, hCaster:GetAbsOrigin())


		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(particle, 1, hCaster:GetAbsOrigin()+Vector(0,0,1000))
		ParticleManager:SetParticleControl(particle, 3, hCaster:GetAbsOrigin())
	end

	return false 
end

modifier_ramza_black_mage_black_magicks_firaga = class({})

function modifier_ramza_black_mage_black_magicks_firaga:OnCreated()
	if IsClient() then return end
	local hAbility = self:GetAbility()
	self:SetDuration(hAbility:GetSpecialValueFor("duration"), false)
	self.iRadius = hAbility:GetSpecialValueFor("radius")
	self:GetParent():EmitSound("Hero_DoomBringer.ScorchedEarthAura")
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.iParticle, 1, Vector(self.iRadius, self.iRadius, self.iRadius))
	ParticleManager:SetParticleControl(self.iParticle, 2, Vector(self.iRadius, self.iRadius, self.iRadius))
	if self:GetCaster():HasModifier("ramza_black_mage_arcane_strength") then 
		self.fDamage = hAbility:GetSpecialValueFor("damage_arcane")
	else
		self.fDamage = hAbility:GetSpecialValueFor("damage")
	end
	
	self:StartIntervalThink(1)
end

function modifier_ramza_black_mage_black_magicks_firaga:OnIntervalThink()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k, v in pairs(tTargets) do	
		
		local damageTable = {
			attacker = hCaster,
			victim = v,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility,
			damage = self.fDamage
		}
		ApplyDamage(damageTable)
	end
end

function modifier_ramza_black_mage_black_magicks_firaga:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle ,true)
	self:GetParent():StopSound("Hero_DoomBringer.ScorchedEarthAura")
end



modifier_ramza_black_mage_black_magicks_poison = class({})

function modifier_ramza_black_mage_black_magicks_poison:IsPurgable() return true end

function modifier_ramza_black_mage_black_magicks_poison:GetTexture() return "dazzle_poison_touch" end

function modifier_ramza_black_mage_black_magicks_poison:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end

function modifier_ramza_black_mage_black_magicks_poison:GetEffectAttachType() return PATTACH_POINT_FOLLOW end

function modifier_ramza_black_mage_black_magicks_poison:OnCreated()
	if IsClient() then return end
	local hAbility = self:GetAbility()
	if self:GetCaster():HasModifier("ramza_black_mage_arcane_strength") then 
		self.fDamage = hAbility:GetSpecialValueFor("damage_arcane")
	else
		self.fDamage = hAbility:GetSpecialValueFor("damage")
	end
	self:StartIntervalThink(1)
end

function modifier_ramza_black_mage_black_magicks_poison:OnIntervalThink()
	if IsClient() then return end
	local damageTable = {
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
		damage = self.fDamage
	}
	ApplyDamage(damageTable)
end


modifier_ramza_black_mage_black_magicks_toad = class({})

function modifier_ramza_black_mage_black_magicks_toad:CheckState()
	return {	
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end

function modifier_ramza_black_mage_black_magicks_toad:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
	}
end

function modifier_ramza_black_mage_black_magicks_toad:GetModifierModelChange()
	return "models/courier/frog/frog.vmdl"
end

function modifier_ramza_black_mage_black_magicks_toad:GetModifierMoveSpeedOverride()
	return 140
end

function modifier_ramza_black_mage_black_magicks_toad:IsPurgable() return true end
function modifier_ramza_black_mage_black_magicks_toad:GetTexture() return "lion_voodoo" end

modifier_ramza_black_mage_black_magicks_blizzaga = class({})
function modifier_ramza_black_mage_black_magicks_blizzaga:IsHidden() return true end
function modifier_ramza_black_mage_black_magicks_blizzaga:IsPurgable() return false end

function modifier_ramza_black_mage_black_magicks_blizzaga:OnCreated()
	if IsClient() then return end
	hAbility = self:GetAbility()
	if self:GetCaster():HasModifier("ramza_black_mage_arcane_strength") then 
		self.fDamage = hAbility:GetSpecialValueFor("damage_arcane")
	else
		self.fDamage = hAbility:GetSpecialValueFor("damage")
	end
	hParent = self:GetParent()
	self.iSlowDuration = hAbility:GetSpecialValueFor("slow_duration")
	self.iSlow = hAbility:GetSpecialValueFor("move_slow")
	self.iRadius = hAbility:GetSpecialValueFor("radius")
	self:StartIntervalThink(0.2)
	self.iMaxCount = hAbility:GetSpecialValueFor("max_count")
	self.iCount = 0
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_frostgrow_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(self.iParticle, 1, Vector(self.iRadius, self.iRadius, self.iRadius ))
end

function modifier_ramza_black_mage_black_magicks_blizzaga:OnIntervalThink()
	if IsClient() then return end	
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #tTargets > 0 then
		local hTarget = tTargets[RandomInt(1, #tTargets)]
		ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf", PATTACH_ABSORIGIN, hTarget)		
		
		hTarget:EmitSound('Ability.FrostNova')
		local damageTable = {
			damage = self.fDamage,
			victim = hTarget,
			attacker = hParent,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damageTable)
		local hModifier = hTarget:AddNewModifier(hParent, nil, "modifier_ramza_black_mage_black_magicks_blizzaga_slow", {Duration = self.iSlowDuration})
		
		
		self.iCount = self.iCount + 1
	end
	if self.iCount == self.iMaxCount then
		self:Destroy()
	end
end

function modifier_ramza_black_mage_black_magicks_blizzaga:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

modifier_ramza_black_mage_black_magicks_blizzaga_slow = class({})

function modifier_ramza_black_mage_black_magicks_blizzaga_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_ramza_black_mage_black_magicks_blizzaga_slow:GetModifierMoveSpeedBonus_Percentage()
	return -30
end

function modifier_ramza_black_mage_black_magicks_blizzaga_slow:GetTexture()
	return "crystal_maiden_freezing_field_alt1"
end

function modifier_ramza_black_mage_black_magicks_blizzaga_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end







