

--[[ ============================================================================================================
	Author: Rook, with help from Noya
	Date: February 26, 2015
	Returns a reference to a newly-created illusion unit.
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_confuse_illusion", "heroes/hero_invoker/invoker_retro_confuse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_confuse_ghost", "heroes/hero_invoker/invoker_retro_confuse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_confuse_exort_level", "heroes/hero_invoker/invoker_retro_confuse.lua", LUA_MODIFIER_MOTION_NONE)



--[[ ============================================================================================================
	Author: Rook
	Date: February 26, 2015
	Called when Confuse is cast.
================================================================================================================= ]]
invoker_retro_confuse = class({})
function invoker_retro_confuse:GetIntrinsicModifierName() return 'modifier_invoker_retro_confuse_exort_level' end
function invoker_retro_confuse:GetCastRange()
	return self.hModifier:GetStackCount()*self:GetSpecialValueFor('cast_range_level_exort')
end
function invoker_retro_confuse:OnSpellStart(keys)
	local keys = {
		ability = self,
		caster = self:GetCaster()
	}
	local target_point = self:GetCursorPosition()
	
	local iQuasLevel
	local iWexLevel
	if keys.caster:HasScepter() then
		iQuasLevel = keys.caster.iQuasLevel+1
	else
		iQuasLevel = keys.caster.iQuasLevel
	end
	if keys.caster:HasScepter() then
		iWexLevel = keys.caster.iWexLevel+1
	else
		iWexLevel = keys.caster.iWexLevel
	end

--	local quas_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
--	local wex_ability = keys.caster:FindAbilityByName("invoker_retro_quas")
	local illusion_duration = keys.ability:GetSpecialValueFor("duration_level_quas")*iQuasLevel
	local illusion_incoming_damage_percent = keys.ability:GetSpecialValueFor("incoming_damage_percent_base")+keys.ability:GetSpecialValueFor("incoming_damage_percent_level_wex")*iWexLevel

	--Create the illusions.
	local tConfuse_Illusions = CreateIllusions(keys.caster, keys.caster, {outgoing_damage = 0, incoming_damage=illusion_incoming_damage_percent, duration = illusion_duration, bounty_base = 0, bounty_growth=2}, 1, 1, true, true);
	local confuse_illusion = tConfuse_Illusions[1]
	local tConfuse_ghosts = CreateIllusions(keys.caster, keys.caster, {outgoing_damage = 0, incoming_damage=0, duration = illusion_duration*2, bounty_base = 0, bounty_growth=2}, 1, 1, true, true);
	local confuse_ghost = tConfuse_ghosts[1]
	
	--Make it so all of the units are facing the same direction.
	local caster_forward_vector = keys.caster:GetForwardVector()
	
	--Set the illusion's health and mana values to those of the real Invoker.
	
	--Limit how the ghost and illusion can be interacted with.
	confuse_illusion:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_confuse_illusion", nil)
	confuse_ghost:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_confuse_illusion", nil)
	confuse_ghost:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_confuse_ghost", nil)
	FindClearSpaceForUnit(confuse_illusion, target_point, true)
	FindClearSpaceForUnit(confuse_ghost, target_point, true)
	confuse_ghost:SetForwardVector(caster_forward_vector)
	confuse_illusion:SetForwardVector(caster_forward_vector)
	
	--Give Invoker's orb particle effects and modifiers to the illusions.
	for i=1, 3, 1 do
		if keys.caster.invoked_orbs[i] ~= nil then
			local orb_name = keys.caster.invoked_orbs[i]:GetName()
			if orb_name == "invoker_retro_quas" then
				local orb_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf", PATTACH_OVERHEAD_FOLLOW, confuse_illusion)
				ParticleManager:SetParticleControlEnt(orb_particle_effect, 1, confuse_illusion, PATTACH_POINT_FOLLOW, "attach_orb" .. i, confuse_illusion:GetAbsOrigin(), false)
				local illusion_quas_ability = confuse_illusion:FindAbilityByName("invoker_retro_quas")
				if illusion_quas_ability ~= nil then
					Timers:CreateTimer(0.1, function ()
						confuse_illusion:AddNewModifier(confuse_illusion, illusion_quas_ability, "modifier_invoker_retro_quas_instance", nil)
					end)
				end
				
				local orb_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf", PATTACH_OVERHEAD_FOLLOW, confuse_ghost)
				ParticleManager:SetParticleControlEnt(orb_particle_effect, 1, confuse_ghost, PATTACH_POINT_FOLLOW, "attach_orb" .. i, confuse_ghost:GetAbsOrigin(), false)
				local illusion_quas_ability = confuse_ghost:FindAbilityByName("invoker_retro_quas")
				if illusion_quas_ability ~= nil then
					Timers:CreateTimer(0.1, function ()
						confuse_ghost:AddNewModifier(confuse_ghost, illusion_quas_ability, "modifier_invoker_retro_quas_instance", nil)
					end)
				end
			elseif orb_name == "invoker_retro_wex" then
				local orb_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf", PATTACH_OVERHEAD_FOLLOW, confuse_illusion)
				ParticleManager:SetParticleControlEnt(orb_particle_effect, 1, confuse_illusion, PATTACH_POINT_FOLLOW, "attach_orb" .. i, confuse_illusion:GetAbsOrigin(), false)
				local illusion_wex_ability = confuse_illusion:FindAbilityByName("invoker_retro_wex")
				if illusion_wex_ability ~= nil then
					Timers:CreateTimer(0.1, function ()
						confuse_illusion:AddNewModifier(confuse_illusion, illusion_wex_ability, "modifier_invoker_retro_wex_instance", nil)
					end)
				end
				
				local orb_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf", PATTACH_OVERHEAD_FOLLOW, confuse_ghost)
				ParticleManager:SetParticleControlEnt(orb_particle_effect, 1, confuse_ghost, PATTACH_POINT_FOLLOW, "attach_orb" .. i, confuse_ghost:GetAbsOrigin(), false)
				local illusion_wex_ability = confuse_ghost:FindAbilityByName("invoker_retro_wex")
				if illusion_wex_ability ~= nil then
					Timers:CreateTimer(0.1, function ()
						confuse_ghost:AddNewModifier(confuse_ghost, illusion_wex_ability, "modifier_invoker_retro_wex_instance", nil)
					end)
				end
			elseif orb_name == "invoker_retro_exort" then
				local orb_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf", PATTACH_OVERHEAD_FOLLOW, confuse_illusion)
				ParticleManager:SetParticleControlEnt(orb_particle_effect, 1, confuse_illusion, PATTACH_POINT_FOLLOW, "attach_orb" .. i, confuse_illusion:GetAbsOrigin(), false)
				local illusion_exort_ability = confuse_illusion:FindAbilityByName("invoker_retro_exort")
				if illusion_exort_ability ~= nil then
					Timers:CreateTimer(0.1, function ()
						confuse_illusion:AddNewModifier(confuse_illusion, illusion_exort_ability, "modifier_invoker_retro_exort_instance", nil)
					end)
				end
				
				local orb_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf", PATTACH_OVERHEAD_FOLLOW, confuse_ghost)
				ParticleManager:SetParticleControlEnt(orb_particle_effect, 1, confuse_ghost, PATTACH_POINT_FOLLOW, "attach_orb" .. i, confuse_ghost:GetAbsOrigin(), false)
				local illusion_exort_ability = confuse_ghost:FindAbilityByName("invoker_retro_exort")
				if illusion_exort_ability ~= nil then
					Timers:CreateTimer(0.1, function ()
						confuse_ghost:AddNewModifier(confuse_ghost, illusion_exort_ability, "modifier_invoker_retro_exort_instance", nil)
					end)
				end
			end
		end
	end
	--Play some particle effects and sound.
	ParticleManager:CreateParticle("particles/generic_gameplay/illusion_created.vpcf", PATTACH_ABSORIGIN_FOLLOW, confuse_illusion)
	keys.caster:EmitSound("Hero_Terrorblade.ConjureImage")
end






modifier_invoker_retro_confuse_illusion = class({})
function modifier_invoker_retro_confuse_illusion:IsHidden() return true end
function modifier_invoker_retro_confuse_illusion:IsPurgable() return false end

function modifier_invoker_retro_confuse_illusion:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED]= true,
		[MODIFIER_STATE_STUNNED]= true,
	}

end

modifier_invoker_retro_confuse_ghost = class({})
function modifier_invoker_retro_confuse_ghost:IsHidden() return true end
function modifier_invoker_retro_confuse_ghost:IsPurgable() return false end

function modifier_invoker_retro_confuse_ghost:CheckState()
	return 
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION]= true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO]= true,
		[MODIFIER_STATE_NO_TEAM_SELECT]= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED]= true,
		[MODIFIER_STATE_ATTACK_IMMUNE]= true,
		[MODIFIER_STATE_MAGIC_IMMUNE]= true,
		[MODIFIER_STATE_INVULNERABLE]= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]= true,
		[MODIFIER_STATE_UNSELECTABLE]= true,
		[MODIFIER_STATE_OUT_OF_GAME]= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]= true,
	}

end

modifier_invoker_retro_confuse_exort_level = class({})
function modifier_invoker_retro_confuse_exort_level:IsHidden() return true end
function modifier_invoker_retro_confuse_exort_level:IsPurgable() return false end
function modifier_invoker_retro_confuse_exort_level:RemoveOnDeath() return false end
function modifier_invoker_retro_confuse_exort_level:OnCreated()
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iExortLevel+1)
		else
			self:SetStackCount(hParent.iExortLevel)
		end
	end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_confuse_exort_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iExortLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iExortLevel+1)
		else
			self:SetStackCount(hParent.iExortLevel)
		end
	end
end
