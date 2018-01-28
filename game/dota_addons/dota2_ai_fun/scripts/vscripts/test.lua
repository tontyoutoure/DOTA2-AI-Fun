hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
--hHero1 = PlayerResource:GetPlayer(1):GetAssignedHero()

iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)

		ParticleManager:SetParticleControlEnt(iParticle, 1, hHero, PATTACH_POINT_FOLLOW, "follow_origin", hHero:GetOrigin(), true)