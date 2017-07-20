
LinkLuaModifier("modifier_intimidator_be_my_friend_lua", "heroes/intimidator/intimidator_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

intimidator_be_my_friend_lua = class({})

function intimidator_be_my_friend_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetChannelTime()
	self.appliedModifier = target:AddNewModifier(caster, self, "modifier_intimidator_be_my_friend_lua", {Duration = duration})
	self.particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_new_arc_blade_golden.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT, "follow_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
end

function intimidator_be_my_friend_lua:OnChannelFinish(interrupted)
	if not self.appliedModifier:IsNull() and self.appliedModifier.Destroy then
		self.appliedModifier:Destroy()
	end	
	ParticleManager:DestroyParticle(self.particle, true)

end

function intimidator_be_my_friend_lua:GetChannelAnimation()
	return ACT_DOTA_RUN
end