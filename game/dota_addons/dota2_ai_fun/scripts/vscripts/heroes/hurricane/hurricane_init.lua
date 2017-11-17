function HurricaneAddParticle(keys)
	if IsClient() then return end
	if EntIndexToHScript(keys.entindex):GetName() == "npc_dota_hero_disruptor" then
		local hHero = EntIndexToHScript(keys.entindex)
		hHero.iParticle1 = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_funnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)	
		ParticleManager:SetParticleControlEnt(hHero.iParticle1, 3, hHero, PATTACH_POINT_FOLLOW, 'follow_origin' ,hHero:GetAbsOrigin(), true)
		hHero.iParticle2 = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)	
		ParticleManager:SetParticleControlEnt(hHero.iParticle2, 3, hHero, PATTACH_POINT_FOLLOW, 'follow_origin' ,hHero:GetAbsOrigin(), true)
	end
end

function HurricaneRemoveParticle(keys)
	if IsClient() then return end
	if EntIndexToHScript(keys.entindex_killed):GetName() == "npc_dota_hero_disruptor" then
		local hHero = EntIndexToHScript(keys.entindex_killed)
		ParticleManager:DestroyParticle(hHero.iParticle1 ,false)
		ParticleManager:DestroyParticle(hHero.iParticle2 ,false)
	end
end


HurricaneInit = function (hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_hurricane", {})
	hHero:SetBaseMoveSpeed(310)
	if not GameMode.bHurricanParticleListenerSet then
		GameMode.bHurricanParticleListenerSet = true
		ListenToGameEvent("npc_spawned", HurricaneAddParticle, nil)
		ListenToGameEvent("entity_killed", HurricaneRemoveParticle, nil)
	end
end


