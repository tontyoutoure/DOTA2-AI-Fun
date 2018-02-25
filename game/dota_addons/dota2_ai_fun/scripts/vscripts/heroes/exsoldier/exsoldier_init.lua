local tNewAbilities = {
	"exsoldier_braver",
	"exsoldier_blade_beam",
	"exsoldier_meteorain",
	"generic_hidden",
	"generic_hidden",
	"exsoldier_omnislash",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_exsoldier_1",
	"special_bonus_cast_range_250",
	"special_bonus_unique_exsoldier_2",
	"special_bonus_truestrike",
	"special_bonus_unique_exsoldier_3",
	"special_bonus_unique_exsoldier_4"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.7,
	AttackDamageMin = 27,
	AttackDamageMax = 39,
	AttributeBaseStrength = 24,
	AttributeBaseAgility = 18,
	AttributeBaseIntelligence = 15,
	AttributeStrenthGain = 2.9,
	AttributeAgilityGain = 2.5,
	AttributeIntelligenceGain = 1.3,
	ArmorPhysical = 3,
	ModelScale = 1,
	AttackRange = 250,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH
}

function PrintAllJuggernautWeaponModels()
	if not GameItems.items then return end
	for k, v in pairs(GameItems.items) do
		if v.used_by_heroes and type(v.used_by_heroes) == "table" and v.used_by_heroes.npc_dota_hero_juggernaut and v.item_type_name == "#DOTA_WearableType_Sword" then
			print('["'..v.model_player..'"] = true,')
		end
	end
end


local tJuggernautWeaponModels = {
	["models/items/juggernaut/gifts_of_the_vanished_weapon/gifts_of_the_vanished_weapon.vmdl"] = true,
	["models/items/juggernaut/wandering_demon_sword/wandering_demon_sword.vmdl"] = true,
	["models/items/juggernaut/jadeserpent_weapon/jadeserpent_weapon.vmdl"] = true,
	["models/items/juggernaut/jg_weapon_files2/jg_weapon_files2.vmdl"] = true,
	["models/items/juggernaut/weapon_bladefury512/weapon_bladefury512.vmdl"] = true,
	["models/items/juggernaut/serrakura/serrakura.vmdl"] = true,
	["models/heroes/juggernaut/jugg_sword.vmdl"] = true,
	["models/items/juggernaut/the_elegant_stroke/the_elegant_stroke.vmdl"] = true,
	["models/items/juggernaut/wep_swordbreaker.vmdl"] = true,
	["models/items/juggernaut/generic_wep_solidsword.vmdl"] = true,
	["models/items/juggernaut/thousand_faces_katana/thousand_faces_katana.vmdl"] = true,
	["models/items/juggernaut/generic_wep_broadsword.vmdl"] = true,
	["models/items/juggernaut/juggernaut_sword_cursed/juggernaut_sword_cursed.vmdl"] = true,
	["models/items/juggernaut/dc_weaponupdate/dc_weaponupdate.vmdl"] = true,
	["models/items/juggernaut/juggernaut_horse_sword/juggernaut_horse_sword.vmdl"] = true,
	["models/items/juggernaut/lord_wep_ivorysword.vmdl"] = true,
	["models/items/juggernaut/nomad_broadsword.vmdl"] = true,
	["models/items/juggernaut/brave_sword.vmdl"] = true,
	["models/items/juggernaut/bladesrunner_weapon/bladesrunner_weapon.vmdl"] = true,
	["models/items/juggernaut/generic_sword_nodachi.vmdl"] = true,
	["models/items/juggernaut/highplains_sword_long.vmdl"] = true,
	["models/items/juggernaut/generic_wep_jadesword.vmdl"] = true,
	["models/items/juggernaut/the_discipline_of_kogu/the_discipline_of_kogu.vmdl"] = true,
	["models/items/juggernaut/immortal_warlord_sword/immortal_warlord_sword.vmdl"] = true,
	["models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vmdl"] = true,
	["models/items/juggernaut/esl_dashing_bladelord_weapon/esl_dashing_bladelord_weapon.vmdl"] = true,
	["models/items/juggernaut/armor_for_the_favorite_weapon/armor_for_the_favorite_weapon.vmdl"] = true,
}

CustomNetTables:SetTableValue("fun_hero_abilities", "exsoldier", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "exsoldier", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("exsoldier", tNewAbilities)
LinkLuaModifier("modifier_exsoldier_sword_manager", "heroes/exsoldier/exsoldier_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function ExsoldierReplaceSword(hHero)	
	AddAnimationTranslate(hHero, "odachi")
	for i, v in ipairs(hHero:GetChildren()) do
		if v:GetClassname() == 'dota_item_wearable' then
			if tJuggernautWeaponModels[v:GetModelName()] then 
				local sModel = v:GetModelName()
				v:RemoveSelf()
				hHero.tWearables = {}
				hHero.tWearables[1]={}
				hHero:AddNewModifier(hHero, nil, "modifier_exsoldier_sword_manager", {}).hSword = Attachments:AttachProp(hHero, "attach_sword", "models/items/sven/shattered_greatsword/sven_shattered_greatsword.vmdl", hHero:GetModelScale()*1.5, {
					pitch = 0,
					yaw = 0,
					roll = -105.0,
					XPos = -35,
					YPos = 0,
					ZPos = 0,
					Animation = "idle"
				})
			end
		end
	end
end

function ExsoldierTalentManager(keys)
	if PlayerResource:GetPlayer(keys.player-1):GetAssignedHero():GetName() ~= "npc_dota_hero_juggernaut" then return end
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
	if keys.abilityname == "special_bonus_unique_exsoldier_2" then
		local iLevel = hHero:FindAbilityByName("exsoldier_braver"):GetLevel()
		hHero:RemoveAbility("exsoldier_braver")
		hHero:AddAbility("exsoldier_braver_talented"):SetLevel(iLevel)
	end
end

function ExsoldierInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_exsoldier", {})
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
	ExsoldierReplaceSword(hHero)
	if not GameMode.bExsoldierTalentManagerSet then
		ListenToGameEvent( "dota_player_learned_ability", ExsoldierTalentManager, nil )
		GameMode.bExsoldierTalentManagerSet = true
	end
end