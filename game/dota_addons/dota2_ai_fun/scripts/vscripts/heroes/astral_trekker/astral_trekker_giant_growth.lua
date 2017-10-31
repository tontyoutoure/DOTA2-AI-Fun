function astral_trekker_giant_growth_activate(keys)
	local hCaster = keys.caster
	for i = 1, 30 do
		Timers(i/24, function ()
			print(hCaster:GetModelScale())
			hCaster:SetModelScale(hCaster:GetModelScale()*1.02) 			
			
		end)
	end	
end

function astral_trekker_giant_growth_deactivate(keys)
	local hCaster = keys.caster
	for i = 1, 30 do
		Timers(i/24, function () 
			hCaster:SetModelScale(hCaster:GetModelScale()/1.02)
		end)
	end
	
end

AstralTrekkerWarStomp = function (keys)
	local iRadius = keys.ability:GetSpecialValueFor("radius")
	if keys.caster:FindAbilityByName("special_bonus_astral_trekker_2"):GetSpecialValueFor("value") > 0 then
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i, v in ipairs(tTargets) do
			v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("stun_duration")})
			ApplyDamage({
				attacker = keys.caster,
				victim = v,
				ability = keys.ability,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage = keys.ability:GetSpecialValueFor("damage")
			})
		end
		keys.caster:EmitSound("Hero_Centaur.HoofStomp")
		ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_ABSORIGIN, keys.caster), 1, Vector(iRadius, iRadius, iRadius))
	else
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, v in ipairs(tTargets) do
			v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("stun_duration")})
			ApplyDamage({
				attacker = keys.caster,
				victim = v,
				ability = keys.ability,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage = keys.ability:GetSpecialValueFor("damage")
			})
		end
		keys.caster:EmitSound("Hero_Centaur.HoofStomp")
		ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, keys.caster), 1, Vector(iRadius, iRadius, iRadius))
	end
end