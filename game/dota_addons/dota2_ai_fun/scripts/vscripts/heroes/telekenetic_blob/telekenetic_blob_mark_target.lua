LinkLuaModifier("modifier_telekenetic_blob_mark_target", "heroes/telekenetic_blob/telekenetic_blob_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)

telekenetic_blob_mark_target = class({})

function telekenetic_blob_mark_target:GetBehavior()
	if self:GetCaster():HasScepter() then return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING+DOTA_ABILITY_BEHAVIOR_AOE
	else return DOTA_ABILITY_BEHAVIOR_IMMEDIATE +DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING end
end

function telekenetic_blob_mark_target:GetAOERadius()
	return self:GetSpecialValueFor("radius_scepter")
end

function telekenetic_blob_mark_target:OnSpellStart()
	local hCaster = self:GetCaster()
	self.tMarkedTargets = self.tMarkedTargets or {}
	if hCaster:HasScepter() then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		if #tTargets > 0 then
			local iMarkedCount = #self.tMarkedTargets
			for i = 1,iMarkedCount do
				self.tMarkedTargets[iMarkedCount+1-i]:RemoveModifierByName('modifier_telekenetic_blob_mark_target')
			end
			for k, v in pairs(tTargets) do
				v:AddNewModifier(hCaster, self, 'modifier_telekenetic_blob_mark_target', nil)
				-- EmitSoundOnLocationForAllies(v:GetOrigin(), 'Hero_BountyHunter.Target', hCaster:GetPlayerOwner())
				EmitSoundOnLocationForPlayer('Hero_BountyHunter.Target', v:GetOrigin(), hCaster:GetPlayerOwnerID())
				local iParticle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster, hCaster:GetTeam())
				ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
				ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
				table.insert(self.tMarkedTargets, v)
			end
		end
	else
		local hTarget = self:GetCursorTarget()
		local iMarkedCount = #self.tMarkedTargets
		for i = 1,iMarkedCount do
			self.tMarkedTargets[iMarkedCount+1-i]:RemoveModifierByName('modifier_telekenetic_blob_mark_target')
		end
		hTarget:AddNewModifier(hCaster, self, 'modifier_telekenetic_blob_mark_target', nil)
		-- EmitSoundOnLocationForAllies(hTarget:GetOrigin(), 'Hero_BountyHunter.Target', hCaster:GetPlayerOwner())
		
		EmitSoundOnLocationForPlayer('Hero_BountyHunter.Target', hTarget:GetOrigin(), hCaster:GetPlayerOwnerID())
		local iParticle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster, hCaster:GetTeam())
		ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		table.insert(self.tMarkedTargets, hTarget)
	end
end
function ResetLastTargetOnDestory(keys)
	local ability = keys.ability
	ability.lastCastTaget = nil
end

function SetLastTargetOnCreate(keys)
	local ability = keys.ability
	local newTarget = keys.target
	if ability.lastCastTaget ~= nil then
		local oldTarget = ability.lastCastTaget
		if oldTarget:HasModifier("modifier_telekenetic_blob_mark_target") and oldTarget ~= newTarget then
			oldTarget:RemoveModifierByName("modifier_telekenetic_blob_mark_target")
		end
	end
	ability.lastCastTaget = newTarget
end
