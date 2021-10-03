local tPrismaticColors = {
	UnusualRed = {208,61,51},
	UnusualRubiline = {209,31,161},
	UnusualGold = {207,171,49},
	UnusualBlue = {0,151,206},
	UnusualPurple = {130,50,207},
	UnusualOrange = {208,119,51},
	UnusualLightGreen = {183,207,51},
	UnusualDeepBlue = {61,104,196},
	UnusualSeaGreen = {74,183,141},
	UnusualVerdantGreen = {81,179,80},
	UnusualDeepGreen = {55,134,77},
	UnusualBrightPurple = {130,50,237},
	UnusualBrightGreen = {161,255,89},
	UnusualPlacidBlue = {148,202,208},
	UnusualSummerWarmth = {255,238,188},
	UnusualDefensiveRed = {255,66,0},
	UnusualCreatorsLight = {220,242,255},
	UnusualBlossomRed = {215,96,146},
	UnusualCrystallineBlue = {26,61,133},
	UnusualCursedBlack = {6,6,6},
	UnusualPlagueGrey = {98,110,91},
	UnusualInternational2012 = {80,125,254},
	UnusualInternational2013 = {21,165,21},
	UnusualMidasGold = {255,202,21},
	UnusualEarthGreen = {90,195,85},
	UnusualEmberFlame = {255,198,4},
	UnusualDiretideOrange = {247,157,0},
	UnusualDredgeEarth = {189,183,107},
	UnusualDungeonDoom = {123,104,238},
	UnusualMannsMint = {188,221,179},
	UnusualBusinessPants = {240,230,140},
	UnusualUnhallowedGround = {128,128,0},
	UnusualShips = {25,25,112},
	UnusualMiasma = {192,192,192},
	UnusualPristinePlatinum = {213,227,245},
	UnusualVermilionRenewal = {202,1,35},
	UnusualAbysm = {255,60,40},
	UnusualLavaRoshan = {255,120,50},
	UnusualIceRoshan = {50,171,220},
	UnusualPlushShagbark = {255,193,220},
	UnusualInternational2014 = {127,72,195},
	UnusualSwine = {255,175,0},
}

local tEtherealParticles = {		
	[15] = {"ethereal_flame", "EF", "particles/econ/courier/courier_trail_01/courier_trail_01.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen"}},
	[16] = {"resonant_energy", "RE", "particles/econ/courier/courier_trail_02/courier_trail_02.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen", "UnusualMiasma"}},
	[17] = {"luminous_gaze", "LG", "particles/econ/courier/courier_eye_glow_01/courier_eye_glow_01.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen"}},
	[18] = {"searing_essence", "SE","particles/econ/courier/courier_eye_glow_02/courier_eye_glow_02.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen"}},
	[19] = {"burning_animus", "BA","particles/econ/courier/courier_eye_glow_03/courier_eye_glow_03.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen"}},
	[20] = {"piercing_beams", "PB", "particles/econ/courier/courier_eye_glow_04/courier_eye_glow_04.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen"}},
	[21] = {"felicitys_blessing", "FB", "particles/econ/courier/courier_trail_03/courier_trail_03.vpcf", {"UnusualRed", "UnusualOrange", "UnusualBlue", "UnusualGold", "UnusualPurple", "UnusualLightGreen"}},
	[22] = {"affliction_of_vermin", "AoV", "particles/econ/courier/courier_trail_04/courier_trail_04.vpcf", false},
	[31] = {"triumph_of_champions", "ToC", "particles/econ/courier/courier_eye_glow_defense_01/courier_eye_glow_defense_01.vpcf", "UnusualDefensiveRed"},
	[32] = {"sunfire", "SF", "particles/econ/courier/courier_trail_05/courier_trail_05.vpcf", "UnusualSummerWarmth"},
	[37] = {"champions_aura_2012", "CA2012", "particles/econ/courier/courier_trail_int_2012/courier_trail_international_2012.vpcf", "UnusualInternational2012"},
	[46] = {"diretide_corruption", "DC", "particles/econ/courier/courier_trail_hw_2012/courier_trail_hw_2012.vpcf", "UnusualBrightGreen"},
	[47] = {"touch_of_midas", "ToM", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", "UnusualMidasGold"},
	[57] = {"frostivus_frost", "FF", "particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf", "UnusualPlacidBlue"},
	[61] = {"trail_of_the_lotus_blossom", "TotLB", "particles/econ/courier/courier_trail_blossoms/courier_trail_blossoms.vpcf", "UnusualBlossomRed"},
	[68] = {"crystal_rift", "CR", "particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf", "UnusualCrystallineBlue"},
	[73] = {"cursed_essence", "CE", "particles/econ/courier/courier_trail_cursed/courier_cursed_ambient.vpcf", "UnusualCursedBlack"},
	[74] = {"divine_essence", "DE", "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", "UnusualCreatorsLight"},
	[76] = {"trail_of_the_amanita", "TotA", "particles/econ/courier/courier_trail_fungal/courier_trail_fungal.vpcf", "UnusualPlagueGrey"},
	[96] = {"trail_of_burning_doom", "ToBD", "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf", "UnusualRed"},
	[109] = {"champions_aura_2013", "CA2013", "particles/econ/courier/courier_trail_international_2013/courier_international_2013.vpcf", "UnusualInternational2013"},
	[129] = {"rubiline_sheen", "RS", "particles/econ/courier/courier_trail_ruby/courier_trail_ruby.vpcf", "UnusualRubiline"},
	[138] = {"emerald_ectoplasm", "EE", "particles/econ/courier/courier_polycount_01/courier_trail_polycount_01.vpcf", "UnusualDeepGreen"},
	[155] = {"diretide_blight", "DB", "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", "UnusualShips"},
	[156] = {"spirit_of_ember", "SoEm", "particles/econ/courier/courier_trail_ember/courier_trail_ember.vpcf", "UnusualEmberFlame"},
	[157] = {"spirit_of_earth", "SoEa", "particles/econ/courier/courier_trail_earth/courier_trail_earth.vpcf", "UnusualEarthGreen"},
	[158] = {"orbital_decay", "OD", "particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf", "UnusualUnhallowedGround"},
	[159] = {"bleak_hallucination", "BH", "particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", false},
	[163] = {"ionic_vapor", "IV", "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", "UnusualPristinePlatinum"},
	[185] = {"new_bloom_celebration", "NBC", "particles/econ/courier/courier_trail_fireworks/courier_trail_fireworks.vpcf", "UnusualVermilionRenewal"},
	[196] = {"butterfly_romp", "BR", "particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf", "UnusualPlushShagbark"},
	[205] = {"touch_of_frost", "ToFr", "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", "UnusualIceRoshan"},
	[206] = {"touch_of_flame", "Tofl", "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", "UnusualLavaRoshan"},
	[268] = {"champions_aura_2014", "CA2014", "particles/econ/courier/courier_trail_international_2014/courier_international_2014.vpcf", "UnusualInternational2014"}
}

local tEtherealEye = {
	[17] = true,
	[18] = true,
	[19] = true,
	[20] = true,
	[31] = true,
	[163] = true,
	[47] = true,
	[205] = true,
	[206] = true
}

local function AddEtherealForHero(hHero, iEthereal)
	hHero.iEtherealParticle = ParticleManager:CreateParticle(tEtherealParticles[iEthereal][3], PATTACH_ABSORIGIN_FOLLOW, hHero)
	local sDefaultPrismatic
	if tEtherealParticles[iEthereal][4] then	
		if type(tEtherealParticles[iEthereal][4]) == 'string' then
			sDefaultPrismatic = tEtherealParticles[iEthereal][4]
			ParticleManager:SetParticleControl(hHero.iEtherealParticle, 2, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hHero.iEtherealParticle, 15, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hHero.iEtherealParticle, 16, Vector(1,0,0))
		else
			local iColor = RandomInt(1, #tEtherealParticles[iEthereal][4])
			sDefaultPrismatic = tEtherealParticles[iEthereal][4][iColor]
			ParticleManager:SetParticleControl(hHero.iEtherealParticle, 2, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hHero.iEtherealParticle, 15, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hHero.iEtherealParticle, 16, Vector(1,0,0))
		end
	end
	return sDefaultPrismatic
end

local function AddEtherealForCourier(hCourier, iEthereal)
	hCourier.iEtherealParticle = ParticleManager:CreateParticle(tEtherealParticles[iEthereal][3], PATTACH_ABSORIGIN_FOLLOW, hCourier)
	if tEtherealEye[iEthereal] then		
		ParticleManager:SetParticleControlEnt(hCourier.iEtherealParticle, 0, hCourier, PATTACH_POINT_FOLLOW, "attach_eye_l", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(hCourier.iEtherealParticle, 1, hCourier, PATTACH_POINT_FOLLOW, "attach_eye_r", Vector(0,0,0), true)
	end
	local sDefaultPrismatic
	if tEtherealParticles[iEthereal][4] then	
		if type(tEtherealParticles[iEthereal][4]) == 'string' then
			sDefaultPrismatic = tEtherealParticles[iEthereal][4]
			ParticleManager:SetParticleControl(hCourier.iEtherealParticle, 2, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hCourier.iEtherealParticle, 15, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hCourier.iEtherealParticle, 16, Vector(1,0,0))
		else
			local iColor = RandomInt(1, #tEtherealParticles[iEthereal][4])
			sDefaultPrismatic = tEtherealParticles[iEthereal][4][iColor]
			ParticleManager:SetParticleControl(hCourier.iEtherealParticle, 2, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hCourier.iEtherealParticle, 15, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
			ParticleManager:SetParticleControl(hCourier.iEtherealParticle, 16, Vector(1,0,0))
		end
	end
	return sDefaultPrismatic
end

local function ChangePrismaticColor(hUnit, vColor)
	ParticleManager:SetParticleControl(hUnit.iEtherealParticle, 2, vColor)
	ParticleManager:SetParticleControl(hUnit.iEtherealParticle, 15, vColor)
	ParticleManager:SetParticleControl(hUnit.iEtherealParticle, 16, Vector(1,0,0))
end

local function RemoveEthereal(hUnit)
	if hUnit.iEtherealParticle then
		ParticleManager:DestroyParticle(hUnit.iEtherealParticle, true)
		hUnit.iEtherealParticle = nil
	end
end

local function OnEtherealEffectChange(eventSourceIndex, keys)
	local hHero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	if keys.tab == 1 then
		local iTeam = PlayerResource:GetTeam(keys.PlayerID)
		local hCourier = PlayerResource:GetPlayer(keys.PlayerID).hCourier
		if not hCourier then return end
		RemoveEthereal(hCourier)
		local sDefaultPrismatic = AddEtherealForCourier(hCourier, keys.effect)
		CustomGameEventManager:Send_ServerToTeam(iTeam, "effect_changed", {tab=1, effect = keys.effect})	
		if (sDefaultPrismatic) then
			CustomGameEventManager:Send_ServerToTeam(iTeam, "color_changed", {tab=1, r=tPrismaticColors[sDefaultPrismatic][1], g=tPrismaticColors[sDefaultPrismatic][2], b=tPrismaticColors[sDefaultPrismatic][3]})
		else
			CustomGameEventManager:Send_ServerToTeam(iTeam, "color_changed", {tab=1, r=-1, g=-1, b=-1})
		end
	elseif keys.tab == 2 then
		local sDefaultPrismatic
		local tAllHeros = Entities:FindAllByName(hHero:GetName())
		for k, v in ipairs(tAllHeros) do
			if v:GetPlayerOwner() == hHero:GetPlayerOwner() then
				RemoveEthereal(v)
				sDefaultPrismatic = AddEtherealForHero(v, keys.effect)
			end
		end
		hHero.iEthereal = keys.effect		
		if (sDefaultPrismatic) then
			for k, v in ipairs(tAllHeros) do
				if v:GetPlayerOwner() == hHero:GetPlayerOwner() then
					ChangePrismaticColor(v, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
				end
			end
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "color_changed", {tab=2, r=tPrismaticColors[sDefaultPrismatic][1], g=tPrismaticColors[sDefaultPrismatic][2], b=tPrismaticColors[sDefaultPrismatic][3]})
			hHero.vEtherealColor = Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3])
		else
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "color_changed", {tab=2, r=-1, g=-1, b=-1})
		end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "effect_changed", {tab=2, effect = keys.effect})
	elseif keys.tab == 3 then
		local tWard = Entities:FindAllByName("npc_dota_ward_base")
		local tWardTrue = Entities:FindAllByName("npc_dota_ward_base_truesight")
		local sDefaultPrismatic
		local bOneWard = false
		for k, v in pairs(tWard) do	
			if v:GetOwner():GetPlayerID() == keys.PlayerID then
				RemoveEthereal(v)
				bOneWard = true
				sDefaultPrismatic = AddEtherealForHero(v, keys.effect)
			end
		end
		
		for k, v in pairs(tWardTrue) do	
			if v:GetOwner():GetPlayerID() == keys.PlayerID then
				RemoveEthereal(v)
				bOneWard = true
				sDefaultPrismatic = AddEtherealForHero(v, keys.effect)
			end
		end
		if not bOneWard then return end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "effect_changed", {tab=3, effect = keys.effect})
		if (sDefaultPrismatic) then
			for k, v in pairs(tWard) do	
				if v:GetOwner():GetPlayerID() == keys.PlayerID then
					ChangePrismaticColor(v, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
				end
			end
			for k, v in pairs(tWardTrue) do	
				if v:GetOwner():GetPlayerID() == keys.PlayerID then
					ChangePrismaticColor(v, Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3]))
				end
			end
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "color_changed", {tab=3, r=tPrismaticColors[sDefaultPrismatic][1], g=tPrismaticColors[sDefaultPrismatic][2], b=tPrismaticColors[sDefaultPrismatic][3]})
			hHero.vEtherealColorWards = Vector(tPrismaticColors[sDefaultPrismatic][1], tPrismaticColors[sDefaultPrismatic][2], tPrismaticColors[sDefaultPrismatic][3])
		else
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "color_changed", {tab=3, r=-1, g=-1, b=-1})
		end
		hHero.iEtherealWards = keys.effect		
	end
end

local function OnPrismaticColorChange(eventSourceIndex, keys)
	local hHero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	if keys.tab == 1 then
		local iTeam = PlayerResource:GetTeam(keys.PlayerID)
		local hCourier = PlayerResource:GetPlayer(keys.PlayerID).hCourier
		if not hCourier or not hCourier.iEtherealParticle then return end
		ChangePrismaticColor(hCourier, Vector(keys.r, keys.g, keys.b))
		CustomGameEventManager:Send_ServerToTeam(iTeam, "color_changed", {tab=1, r=keys.r, g=keys.g, b=keys.b})		
	elseif keys.tab == 2 then
		local tAllHeros = Entities:FindAllByName(hHero:GetName())
		if not hHero.iEtherealParticle then return end
		for k, v in ipairs(tAllHeros) do
			if v:GetPlayerOwner() == hHero:GetPlayerOwner() then
				ChangePrismaticColor(v, Vector(keys.r, keys.g, keys.b))
			end
		end
		hHero.vEtherealColor = Vector(keys.r, keys.g, keys.b)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "color_changed",{tab=2, r=keys.r, g=keys.g, b=keys.b})
	elseif keys.tab == 3 then
		local tWard = Entities:FindAllByName("npc_dota_ward_base")
		local tWardTrue = Entities:FindAllByName("npc_dota_ward_base_truesight")
		if not hHero.iEtherealWards then return end
		for k, v in pairs(tWard) do	
			if v:GetOwner():GetPlayerID() == keys.PlayerID then
				ChangePrismaticColor(v, Vector(keys.r, keys.g, keys.b))
			end
		end
		for k, v in pairs(tWardTrue) do	
			if v:GetOwner():GetPlayerID() == keys.PlayerID then
				ChangePrismaticColor(v, Vector(keys.r, keys.g, keys.b))				
			end
		end
		hHero.vEtherealColorWards = Vector(keys.r, keys.g, keys.b)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "color_changed",{tab=3, r=keys.r, g=keys.g, b=keys.b})
	end
end

local function OnEtherealEffectRemove(eventSourceIndex, keys)
	local hHero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	if keys.tab == 1 then
		local iTeam = PlayerResource:GetTeam(keys.PlayerID)
		local hCourier = PlayerResource:GetPlayer(keys.PlayerID).hCourier
		RemoveEthereal(hCourier)
		CustomGameEventManager:Send_ServerToTeam(iTeam, "effect_removed", {tab=1})		
	elseif keys.tab == 2 then
		local tAllHeros = Entities:FindAllByName(hHero:GetName())
		for k, v in ipairs(tAllHeros) do
			if v:GetPlayerOwner() == hHero:GetPlayerOwner() then
				RemoveEthereal(v)
			end
		end
		hHero.iEthereal = nil
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "effect_removed", {tab=2})
	elseif keys.tab == 3 then
		local tWard = Entities:FindAllByName("npc_dota_ward_base")
		local tWardTrue = Entities:FindAllByName("npc_dota_ward_base_truesight")
		for k, v in pairs(tWard) do	
			if v:GetOwner():GetPlayerID() == keys.PlayerID then
				RemoveEthereal(v)
			end
		end
		for k, v in pairs(tWardTrue) do	
			if v:GetOwner():GetPlayerID() == keys.PlayerID then
				RemoveEthereal(v)			
			end
		end
		hHero.iEtherealWards = nil
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "effect_removed", {tab=3})
	end
end

local tEmblems = {
	"particles/econ/events/ti7/ti7_hero_effect.vpcf",
	"particles/econ/events/ti8/ti8_hero_effect.vpcf",
	"particles/econ/events/ti9/ti9_emblem_effect.vpcf",
	"particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf",
	"particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf",
	"particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf",
	"particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf",
	"particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf",
	"particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf"
}

local function OnEmblemToggled(eventSourceIndex, keys)
	local hHero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	local tAllHeros = Entities:FindAllByName(hHero:GetName())

	local iHeroNum =  #tAllHeros
	for i = 1, iHeroNum do -- remove other players heroes
		if tAllHeros[iHeroNum+1-i]:GetPlayerOwnerID() ~= keys.PlayerID then
			table.remove(tAllHeros,iHeroNum+1-i)
		end
	end

	if hHero.iEmblem and hHero.iEmblem > 0 then -- remove particle
		for k, v in ipairs(tAllHeros) do
			ParticleManager:DestroyParticle(v.iEmblemParticle, true)
			v.iEmblemParticle = nil
		end
	end 

	if hHero.iEmblem then -- increment particle type
		hHero.iEmblem = hHero.iEmblem+1
		if hHero.iEmblem > #tEmblems then
			hHero.iEmblem = 0
		end
	else
		hHero.iEmblem = 1
	end

	if hHero.iEmblem > 0 then
		for k, v in ipairs(tAllHeros) do
			v.iEmblemParticle = ParticleManager:CreateParticle(tEmblems[hHero.iEmblem], PATTACH_ABSORIGIN_FOLLOW, v)
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "hero_emblem_toggle", {hHeroEmblem=hHero.iEmblem})


end


local function OnProjectileToggled(eventSourceIndex, keys)
	local hHero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	local tAllHeros = Entities:FindAllByName(hHero:GetName())

	local iHeroNum =  #tAllHeros
	for i = 1, iHeroNum do -- remove other players heroes
		if tAllHeros[iHeroNum+1-i]:GetPlayerOwnerID() ~= keys.PlayerID then
			table.remove(tAllHeros,iHeroNum+1-i)
		end
	end

	if not hHero:HasModifier('modifier_ti9_attack_modifier') then
		for k, v in ipairs(tAllHeros) do
			v:AddNewModifier(hHero, nil, 'modifier_ti9_attack_modifier', nil)
		end
	end
	for k, v in ipairs(tAllHeros) do
		v:FindModifierByName('modifier_ti9_attack_modifier'):IncrementStackCount()
	end

	--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "ti9_attack_modifier_toggle", {bEnabled=1})
	
end
				
CustomGameEventManager:RegisterListener( "ChangePrismaticColor", OnPrismaticColorChange )
CustomGameEventManager:RegisterListener( "ChangeEtherealEffect", OnEtherealEffectChange )
CustomGameEventManager:RegisterListener( "RemoveEtherealEffect", OnEtherealEffectRemove )
CustomGameEventManager:RegisterListener( "ToggleEmblem", OnEmblemToggled )
CustomGameEventManager:RegisterListener( "ToggleProjectile", OnProjectileToggled )
local function AddEffectOnSpawn(keys)
	local hUnit = EntIndexToHScript(keys.entindex)
	if hUnit:GetName() == "npc_dota_ward_base" or hUnit:GetName() == "npc_dota_ward_base_truesight" then
		local hHero = hUnit:GetOwner():GetAssignedHero()
		if hHero.iEtherealWards then
			AddEtherealForHero(hUnit, hHero.iEtherealWards)
			ChangePrismaticColor(hUnit, hHero.vEtherealColorWards)
		end
	end
	if hUnit:IsIllusion() then
		local hHero = hUnit:GetOwner():GetAssignedHero()
		if hHero.iEthereal then
			AddEtherealForHero(hUnit, hHero.iEthereal)
			ChangePrismaticColor(hUnit, hHero.vEtherealColor)
		end
		if hHero.sEmblem then
			hUnit.iEmblemParticle = ParticleManager:CreateParticle(hHero.sEmblem, PATTACH_ABSORIGIN_FOLLOW, hUnit)
		end
		if hHero.sProjectile then
			hUnit:SetRangedProjectileName(hHero.sProjectile)
		end
	end
end


ListenToGameEvent('npc_spawned', AddEffectOnSpawn, nil)
