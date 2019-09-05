LinkLuaModifier('modifier_invoker_retro_shroud_of_flames', 'heroes/hero_invoker/invoker_retro_shroud_of_flames.lua', LUA_MODIFIER_MOTION_NONE)

invoker_retro_shroud_of_flames = class({})

function invoker_retro_shroud_of_flames:OnSpellStart()
	local keys = {caster = self:GetCaster(), ability = self, target = self:GetCursorTarget()}
	
	local iExortLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iExortLevel = keys.caster.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end
	else
		iExortLevel = keys.target.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end	
	end
	
	local iQuasLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iQuasLevel = keys.caster.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end
	else
		iQuasLevel = keys.target.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end	
	end
	
	local hOriginalAbility
	local tAllHeroes=HeroList:GetAllHeroes()
	if keys.caster:GetName() == 'npc_dota_hero_invoker' then 
		hOriginalAbility = self
	else
		for k,v in pairs(tAllHeroes) do
			if v:GetName() == 'npc_dota_hero_invoker' and v:IsRealHero() and v:HasAbility('invoker_retro_shroud_of_flames') then
				hOriginalAbility = v:FindAbilityByName('invoker_retro_shroud_of_flames')
			end
		end
	end
	local fDamage = iExortLevel*keys.ability:GetSpecialValueFor('damage_level_exort')
	local iMagicResistance = iQuasLevel*keys.ability:GetSpecialValueFor('magic_resistance_level_quas')
	local hModifier = keys.target:AddNewModifier(keys.caster, keys.ability, 'modifier_invoker_retro_shroud_of_flames', {Duration = keys.ability:GetSpecialValueFor('duration')})
	hModifier:SetStackCount(-iMagicResistance)
	hModifier.fDamage = fDamage
	hModifier.hOriginalAbility = hOriginalAbility
	hModifier.hCaster = keys.caster
	keys.target:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
end

function invoker_retro_shroud_of_flames:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	if not hTarget then return end
	local hAbility = EntIndexToHScript(tExtraData.iAbilityIndex)
	if hAbility and not hAbility:IsNull() then
		ApplyDamageTestDummy({victim = hTarget, attacker = EntIndexToHScript(tExtraData.iCasterIndex), damage = tExtraData.fDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
	else
		ApplyDamageTestDummy({victim = hTarget, attacker = EntIndexToHScript(tExtraData.iCasterIndex), damage = tExtraData.fDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = hAbility})
	end
end


modifier_invoker_retro_shroud_of_flames = class({})

function modifier_invoker_retro_shroud_of_flames:OnCreated(keys)
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_retro_shroud_of_flames.vpcf", PATTACH_CUSTOMORIGIN, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 0, hParent, PATTACH_POINT_FOLLOW, 'attach_origin', hParent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, 'attach_origin', hParent:GetOrigin(), true)
	self.fDamage = keys.fDamage
end

function modifier_invoker_retro_shroud_of_flames:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)
end

function modifier_invoker_retro_shroud_of_flames:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_invoker_retro_shroud_of_flames:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount()
end

function modifier_invoker_retro_shroud_of_flames:OnAttacked(keys)
	if keys.target == self:GetParent() then
		 projectile_information =  
		{
			EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
			Ability = self.hOriginalAbility,
			vSpawnOrigin = keys.target:GetOrigin(),
			fDistance = self.hOriginalAbility:GetSpecialValueFor('fire_distance'),
			fStartRadius = self.hOriginalAbility:GetSpecialValueFor('fire_start_radius'),
			fEndRadius = self.hOriginalAbility:GetSpecialValueFor('fire_end_radius'),
			Source = self:GetParent(),
			bHasFrontalCone = true,
			bReplaceExisting = false,
			bProvidesVision = false,
			bDrawsOnMinimap = false,
			bVisibleToEnemies = true, 
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			fExpireTime = GameRules:GetGameTime() + 20.0,
			ExtraData = {fDamage = self.fDamage, iCasterIndex = self.hCaster:entindex(), iAbilityIndex = self:GetAbility():entindex()}			
		}
		local vPositionDifference = keys.attacker:GetOrigin()-keys.target:GetOrigin()
		vPositionDifference.z = 0
		projectile_information.vVelocity = self.hOriginalAbility:GetSpecialValueFor('fire_speed')*vPositionDifference:Normalized()
		ProjectileManager:CreateLinearProjectile(projectile_information)
	end
end


