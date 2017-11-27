hHero = PlayerResource:GetPlayer(0):GetAssignedHero()

		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
		ParticleManager:SetParticleControl(iParticle, 1, hHero:GetOrigin())
		ParticleManager:SetParticleControl(iParticle, 3, hHero:GetOrigin())

--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]