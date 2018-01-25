hHero = PlayerResource:GetPlayer(0):GetAssignedHero()

			print(hHero:GetModelName())

	for i, v in ipairs(hHero:GetChildren()) do
		if v:GetClassname() == 'dota_item_wearable' then
			print(v:GetModelName())
			if v:GetModelName() == "models/heroes/terrorblade/horns_arcana.vmdl" then 
				StopEffect(v, "particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_body_arcana_horns.vpcf")
				StopEffect(v, "particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_eyes_arcana_horns.vpcf")
			end
		end
				StopEffect(v, "particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_l.vpcf")
				StopEffect(v, "particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_r.vpcf")
				StopEffect(v, "particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade.vpcf")
				StopEffect(v, "particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_2.vpcf")
				StopEffect(hHero, "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf")
				StopEffect(hHero, "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_head.vpcf")
	end
	ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_feet_effects.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero )