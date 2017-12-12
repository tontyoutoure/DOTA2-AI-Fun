hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
		fDamage = 500
		local iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_spell.vpcf", PATTACH_OVERHEAD_FOLLOW, hHero)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetOrigin(), true)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(0, fDamage, 6))
		ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fDamage))+2, 100))
		ParticleManager:SetParticleControl(iParticle, 3, Vector(85+80,26+40,139+40))

--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]