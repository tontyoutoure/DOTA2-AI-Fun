
LinkLuaModifier("modifier_intimidator_be_my_friend_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

intimidator_be_my_friend_lua = class({})

function intimidator_be_my_friend_lua:GetBehavior()
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_intimidator_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_CHANNELLED
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
end	
function intimidator_be_my_friend_lua:OnSpellStart()
	self.appliedModifier = nil
	self.hSpecial = self.hSpecial or self:GetCaster():FindAbilityByName("special_bonus_intimidator_2")
	
	if (not self.hSpecial or self.hSpecial:GetLevel() == 0) and self:GetCursorTarget():TriggerSpellAbsorb( self ) then 
		self:GetCaster():Interrupt()
		return 
	end
	self.tModifiers = self.tModifiers or {}
	self.tParticles = self.tParticles or {}
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		local caster = self:GetCaster()
		local duration = self:GetChannelTime()
		local tTargets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for k, v in ipairs(tTargets) do
			self.tModifiers[k] = v:AddNewModifier(caster, self, "modifier_intimidator_be_my_friend_lua", {Duration = duration*CalculateStatusResist(v)})
			self.tParticles[k] = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_new_arc_blade_golden.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, v)
			ParticleManager:SetParticleControlEnt(self.tParticles[k], 0, caster, PATTACH_POINT, "follow_attack1", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.tParticles[k], 1, v, PATTACH_POINT, "follow_origin", v:GetAbsOrigin(), true)
				print(self.tParticles[k])
			
		end
	else
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local duration = self:GetChannelTime()
		self.appliedModifier = target:AddNewModifier(caster, self, "modifier_intimidator_be_my_friend_lua", {Duration = duration*CalculateStatusResist(target)})
		self.particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_new_arc_blade_golden.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT, "follow_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
	end
	
end

function intimidator_be_my_friend_lua:OnChannelFinish(interrupted)
	if self.appliedModifier and not self.appliedModifier:IsNull() and self.appliedModifier.Destroy then
		self.appliedModifier:Destroy()
		self.appliedModifier= nil
	end	
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		self.particle = nil
	end
	if #self.tModifiers > 0 then
		local iSize = #self.tModifiers
		for i = 1, iSize do
			if self.tModifiers[iSize+1-i] and not self.tModifiers[iSize+1-i]:IsNull() then
				self.tModifiers[iSize+1-i]:Destroy()
			end
		end
	end

end

function intimidator_be_my_friend_lua:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end