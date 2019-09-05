modifier_telekenetic_blob_mark_target = class({})
function modifier_telekenetic_blob_mark_target:IsHidden() 
	return false
end
function modifier_telekenetic_blob_mark_target:IsPurgable() return false end
function modifier_telekenetic_blob_mark_target:RemoveOnDeath() return true end
function modifier_telekenetic_blob_mark_target:OnCreated()
	if IsClient() then return end
	self.iParticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self.iParticle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end
function modifier_telekenetic_blob_mark_target:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle1, true)
	ParticleManager:DestroyParticle(self.iParticle2, true)
	for k, v in pairs(self:GetAbility().tMarkedTargets) do
		if v == self:GetParent() then
			table.remove(self:GetAbility().tMarkedTargets, k)
			break
		end
	end
end