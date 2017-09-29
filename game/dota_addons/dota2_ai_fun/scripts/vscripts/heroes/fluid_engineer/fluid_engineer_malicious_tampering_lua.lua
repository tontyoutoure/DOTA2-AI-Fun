LinkLuaModifier("modifier_fluid_engineer_malicious_tampering_aura", "heroes/fluid_engineer/fluid_engineer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fluid_engineer_malicious_tampering", "heroes/fluid_engineer/fluid_engineer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
fluid_engineer_malicious_tampering_lua = class({})

function fluid_engineer_malicious_tampering_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:GetTeamNumber() == DOTA_TEAM_BADGUYS then 	
		self.hFountain = Entities:FindByName(nil, "ent_dota_fountain_good")
	else
		self.hFountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
--		print(self.hFountain:GetName())
	end
	local hModifier = self.hFountain:AddNewModifier(self.hFountain, self, "modifier_fluid_engineer_malicious_tampering_aura", {Duration = self:GetSpecialValueFor("duration")})

--	print(self:GetSpecialValueFor("duration"))
end


function fluid_engineer_malicious_tampering_lua:OnChannelFinish(bInterrupted)
	if bInterrupted then 
		self.hFountain:RemoveModifierByName("modifier_fluid_engineer_malicious_tampering_aura")
	end
end

function fluid_engineer_malicious_tampering_lua:GetChannelAnimation()
	return ACT_DOTA_RUN
end