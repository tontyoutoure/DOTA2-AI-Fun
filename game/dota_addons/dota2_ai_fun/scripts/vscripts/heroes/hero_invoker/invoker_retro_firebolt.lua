--[[ ============================================================================================================
	Author: Rook, tontyoutoure
	Date: November 11, 2018
	Soft projectile implementation
================================================================================================================= ]]

invoker_retro_firebolt = class({})



function invoker_retro_firebolt:OnSpellStart()
	--Firebolt's damage is dependent on the level of Exort.
	local keys = {ability = self, caster = self:GetCaster(), target = self:GetCursorTarget()}
	
	local tAllHeroes=HeroList:GetAllHeroes()
	local hOriginalAbility
	if self:GetCaster():GetName() == 'npc_dota_hero_invoker' then
		hOriginalAbility = keys.ability
	else		
		for k,v in pairs(tAllHeroes) do
			if v:GetName() == 'npc_dota_hero_invoker' and v:IsRealHero() and v:HasAbility('invoker_retro_firebolt') then
				hOriginalAbility = v:FindAbilityByName('invoker_retro_firebolt')
			end
		end
	end
	
	local iExortLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) == keys.ability then
		iExortLevel = keys.caster.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end
	else
		iExortLevel = keys.target.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end	
	end
	local iDamage = keys.ability:GetSpecialValueFor("damage_base")+keys.ability:GetSpecialValueFor("damage_level_exort")*iExortLevel
	keys.caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
	
	local info = 
	{
		EffectName = "particles/units/heroes/hero_invoker/invoker_retro_firebolt.vpcf",
		Ability = hOriginalAbility,
		Target = keys.target,
		Source = keys.caster,
		bDodgeable = true,
		bProvidesVision = false,
		vSpawnOrigin = keys.caster:GetAbsOrigin(),
		iMoveSpeed = hOriginalAbility:GetSpecialValueFor('projectile_movement_speed'),
		iVisionRadius = 0,
		iVisionTeamNumber = keys.caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		ExtraData= {iDamage = iDamage, iCasterIndex = keys.caster:entindex()}
	}
	
	local projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function invoker_retro_firebolt:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)	
	--Firebolt's damage is dependent on the level of Exort. 
	local hCaster = EntIndexToHScript(tExtraData.iCasterIndex)
	if hCaster:HasAbility(self:GetName()) then
		if hTarget:TriggerSpellAbsorb(hCaster:FindAbilityByName(self:GetName())) then return end
	else
		local hAbilityAdd = hCaster:AddAbility(self:GetName())
		if hTarget:TriggerSpellAbsorb(hAbilityAdd) then hCaster:RemoveAbility(self:GetName()) return end
		hCaster:RemoveAbility(self:GetName())
	end
	hTarget:EmitSound("Hero_OgreMagi.Fireblast.Target")
	ApplyDamageTestDummy({victim = hTarget, attacker = hCaster, damage = tExtraData.iDamage, damage_type = DAMAGE_TYPE_MAGICAL,ability = self})
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor('stun_duration')})
end