function MagicDragonDragonMagic(keys)
	keys.caster.iDragonForm = keys.caster.iDragonForm or MAGIC_DRAGON_GREEN_DRAGON_FORM
	if keys.caster.iDragonForm < MAGIC_DRAGON_BLACK_DRAGON_FORM then
		MagicDragonTransform[keys.caster.iDragonForm+1](keys.caster)
	else
		MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](keys.caster)
	end
end

function GreenDragonBreathSlowApply(keys)
	local hTarget = keys.target
	local hAttacker = keys.attacker
	if hTarget:IsMagicImmune() or hTarget:IsBuilding() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then return end
	keys.ability:ApplyDataDrivenModifier(hAttacker, hTarget, "modifier_magic_dragon_green_dragon_breath_slow", {Duration = keys.ability:GetSpecialValueFor("duration")})
	hTarget:EmitSound("hero_viper.PoisonAttack.Target")
end

function GhostDragonBreathLifestealApply(keys)
	local hAttacker = keys.attacker
	if not keys.target:IsBuilding() then
		keys.ability:ApplyDataDrivenModifier(hAttacker, hAttacker, "modifier_magic_dragon_ghost_dragon_breath_lifesteal", {duration = 0.03})
	end
end

function RedDragonBreathDamageApply(keys)
	local hTarget = keys.target
	local hAttacker = keys.attacker
	local hAbility = keys.ability
	if hTarget:IsMagicImmune() or hTarget:IsBuilding() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then return end
	local damageTable = {
		victim = hTarget,
		attacker = hAttacker,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage = hAbility:GetSpecialValueFor("damage"),
		ability = hAbility
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound("Hero_Jakiro.LiquidFire")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(particle, 1, Vector(100, 100, 100))
end

function BlueDragonBreathNova(keys)
	local hTarget = keys.target
	local hAttacker = keys.attacker
	local hAbility = keys.ability
	if hTarget:IsMagicImmune() or hTarget:IsBuilding() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then return end
	hAbility:ApplyDataDrivenModifier(hAttacker, hTarget, "modifier_magic_dragon_blue_dragon_breath_target", {Duration = 0.03})
end

function ChainLightningBounce(hCaster, hSource, iRadius, fDamage, iBounce, tTargets, hAbility, fDelay)
	if iBounce == 0 then return end
	tAvailable = FindUnitsInRadius(hCaster:GetTeamNumber(), hSource:GetAbsOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	math.randomseed(GameRules:GetGameTime())
	local tShouldRemove = {}
	for i = 1, #tTargets do
		for j = 1, #tAvailable do
			if tTargets[i] == tAvailable[j] then table.insert(tShouldRemove,1, j) end
		end
	end	
	
	for i = 1, #tShouldRemove do table.remove(tAvailable, tShouldRemove[i]) end
	
	if #tAvailable == 0 then return end
	
	local hTarget = tAvailable[math.random(#tAvailable)]
	local damageTable = {
		victim = hTarget,
		damage = fDamage,
		attacker = hCaster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound("Hero_Zuus.ArcLightning.Target")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(particle, 0, hSource, PATTACH_POINT_FOLLOW, "attach_hitloc", hSource:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	tTargets[#tTargets+1] = hTarget
	iBounce = iBounce-1
	Timers:CreateTimer(fDelay, function () ChainLightningBounce(hCaster, hTarget, iRadius, fDamage, iBounce, tTargets, hAbility, fDelay) end)
end

function GoldDragonBreathLightning(keys)
	local hTarget = keys.target
	local hAttacker = keys.attacker
	local hAbility = keys.ability
	local fDamage = hAbility:GetSpecialValueFor("damage")
	local fDelay = hAbility:GetSpecialValueFor("delay")
	if hTarget:IsMagicImmune() or hTarget:IsBuilding() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then return end
	
	local damageTable = {
		victim = hTarget,
		damage = fDamage,
		attacker = hAttacker,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound("Hero_Zuus.ArcLightning.Target")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(particle, 0, hAttacker, PATTACH_POINT_FOLLOW, "attach_attack1", hAttacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	
	Timers:CreateTimer(fDelay, function () ChainLightningBounce(hAttacker, hTarget, hAbility:GetSpecialValueFor("radius"), fDamage, hAbility:GetSpecialValueFor("bounce"), {hTarget}, hAbility, fDelay) end)
end

function BlackDragonBreathApply(keys)
	if keys.ability:GetLevel() == 0 then return end
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_magic_dragon_black_dragon_breath", {})
end

function GoldDragonHideApply(keys)
	if keys.ability:GetLevel() == 0 then return end	
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_magic_dragon_gold_dragon_hide", {})
end

function BlueDragonRoarFreeze(keys)	
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for i, v in ipairs(tTargets) do
		keys.ability:ApplyDataDrivenModifier(keys.caster, v, "modifier_magic_dragon_blue_dragon_roar", {Duration = keys.ability:GetSpecialValueFor("duration")})
		v:EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")
	end	
	keys.caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
	
	
	MagicDragonTransform[RandomInt(1,6)](keys.caster)
	if keys.caster:FindAbilityByName("special_bonus_magic_dragon_1"):GetSpecialValueFor("value") > 0 then
		for i = 0, 8 do 
			if keys.caster:GetItemInSlot(i) then keys.caster:GetItemInSlot(i):EndCooldown() end
		end		
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	end
end

function GhostDragonRoarLifeDrain(keys)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local iLifeDrain = keys.ability:GetSpecialValueFor("life_drain")
	for i, v in ipairs(tTargets) do
		local damageTable = {
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			victim = v,
			attacker = keys.caster,
			damage = iLifeDrain,
			ability = keys.ability
		}
		ApplyDamage(damageTable)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_POINT_FOLLOW, v)
		ParticleManager:SetParticleControlEnt(particle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "follow_hitloc", v:GetAbsOrigin(), true)
		
	end	
	keys.caster:Heal(#tTargets*iLifeDrain, keys.caster)
	keys.caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
	
	
	MagicDragonTransform[RandomInt(1,6)](keys.caster)
	if keys.caster:FindAbilityByName("special_bonus_magic_dragon_1"):GetSpecialValueFor("value") > 0 then
		for i = 0, 8 do 
			if keys.caster:GetItemInSlot(i) then keys.caster:GetItemInSlot(i):EndCooldown() end
		end		
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	end
end

function RedDragonRoarDamage(keys)	
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local iDamage = keys.ability:GetSpecialValueFor("damage")
	for i, v in ipairs(tTargets) do
		local damageTable = {
			damage_type = DAMAGE_TYPE_MAGICAL,
			victim = v,
			attacker = keys.caster,
			damage = iDamage,
			ability = keys.ability
		}
		ApplyDamage(damageTable)		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_POINT_FOLLOW, v)
		ParticleManager:SetParticleControlEnt(particle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT, "follow_origin", v:GetAbsOrigin(), true)
	end	
	keys.caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
	
	
	MagicDragonTransform[RandomInt(1,6)](keys.caster)
	if keys.caster:FindAbilityByName("special_bonus_magic_dragon_1"):GetSpecialValueFor("value") > 0 then
		for i = 0, 8 do 
			if keys.caster:GetItemInSlot(i) then keys.caster:GetItemInSlot(i):EndCooldown() end
		end		
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	end
end

function GreenDragonRoarAccelerate(keys)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i, v in ipairs(tTargets) do
		keys.ability:ApplyDataDrivenModifier(keys.caster, v, "modifier_magic_dragon_green_dragon_roar", {Duration = keys.ability:GetSpecialValueFor("duration")})
	end
	
	keys.caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
	
	
	MagicDragonTransform[RandomInt(1,6)](keys.caster)
	if keys.caster:FindAbilityByName("special_bonus_magic_dragon_1"):GetSpecialValueFor("value") > 0 then
		for i = 0, 8 do 
			if keys.caster:GetItemInSlot(i) then keys.caster:GetItemInSlot(i):EndCooldown() end
		end		
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	end
end

function BlackDragonRoarManaBurn(keys)	
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
	local iManaBurn = keys.ability:GetSpecialValueFor("mana_burn")
	for i, v in ipairs(tTargets) do
		if iManaBurn < v:GetMana() then
			local damageTable = {
				victim = v,
				attacker = keys.caster,
				damage = keys.ability:GetSpecialValueFor('damage_per_mana')*iManaBurn,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = keys.ability
			}
			ApplyDamage(damageTable)
			v:ReduceMana(iManaBurn)
			ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		else
			local damageTable = {
				victim = v,
				attacker = keys.caster,
				damage = keys.ability:GetSpecialValueFor('damage_per_mana')*v:GetMana(),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = keys.ability
			}
			ApplyDamage(damageTable)
			v:ReduceMana(v:GetMana())
			ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		end
	end	
	keys.caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
	
	
	MagicDragonTransform[RandomInt(1,6)](keys.caster)
	if keys.caster:FindAbilityByName("special_bonus_magic_dragon_1"):GetSpecialValueFor("value") > 0 then
		for i = 0, 8 do 
			if keys.caster:GetItemInSlot(i) then keys.caster:GetItemInSlot(i):EndCooldown() end
		end		
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	end
end

function GoldDragonRoarLightningChain(keys)
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local fDamage = keys.ability:GetSpecialValueFor("damage")
	local fDelay = keys.ability:GetSpecialValueFor("delay")
	for i, v in ipairs(tTargets) do
		local damageTable = {
			victim = v,
			damage = fDamage,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = keys.ability
		}
		ApplyDamage(damageTable)
		v:EmitSound("Hero_Zuus.ArcLightning.Target")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, v)
		ParticleManager:SetParticleControlEnt(particle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
		Timers:CreateTimer(fDelay, function () ChainLightningBounce(keys.caster, v, keys.ability:GetSpecialValueFor("radius"), fDamage, keys.ability:GetSpecialValueFor("bounce"), {v}, keys.ability, fDelay) end)	
	end
	keys.caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")
	
	
	MagicDragonTransform[RandomInt(1,6)](keys.caster)
	if keys.caster:FindAbilityByName("special_bonus_magic_dragon_1"):GetSpecialValueFor("value") > 0 then
		for i = 0, 8 do 
			if keys.caster:GetItemInSlot(i) then keys.caster:GetItemInSlot(i):EndCooldown() end
		end		
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	end
end









