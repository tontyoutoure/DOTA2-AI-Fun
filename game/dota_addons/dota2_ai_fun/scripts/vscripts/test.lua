
local hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
--[[
if iParticle then ParticleManager:DestroyParticle(iParticle, true) end
iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1,hHero, PATTACH_POINT_FOLLOW, 'attach_origin', Vector(0,0,0),true)
ParticleManager:SetParticleControlEnt(iParticle, 0,hHero, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
]]
print(hHero)