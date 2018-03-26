hHero = PlayerResource:GetPlayer(0):GetAssignedHero() 
if iParticle then ParticleManager:DestroyParticle(iParticle, true) end
if iParticle0 then ParticleManager:DestroyParticle(iParticle0, true) end
iParticle0 = ParticleManager:CreateParticle("particles/flame_lord/enflame_ring_large.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
iParticle = ParticleManager:CreateParticle("particles/flame_lord/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1, hHero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hHero:GetOrigin(), true)
ParticleManager:SetParticleControl(iParticle, 2, Vector(200, 0, 0))
ParticleManager:SetParticleControl(iParticle, 3, Vector(700, 0, 0))
