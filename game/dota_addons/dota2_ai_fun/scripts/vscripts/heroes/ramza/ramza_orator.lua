LinkLuaModifier("modifier_ramza_orator_speechcraft_mimic_darlavon", "heroes/ramza/ramza_orator_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function RamzaOratorPraise(keys)
	keys.target:ModifyStrength(1)
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, 1, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2, 200))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 60, 60))
	
	keys.target:EmitSound("Hero_Chen.HandOfGodHealHero")
end

function RamzaOratorPreach(keys)
	keys.target:ModifyIntellect(1)
	
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, 1, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2, 200))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(60, 255, 60))
	keys.target:EmitSound("Hero_Chen.HandOfGodHealHero")
end

function RamzaOratorMimicDarlavon(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_orator_speechcraft_mimic_darlavon", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound('Hero_Bane.Nightmare')
	keys.target:EmitSound('Hero_Bane.Nightmare.Loop')
end

function RamzaOratorEntice(keys)
	if keys.target:GetOwner() then 
		keys.target:SetTeam(keys.caster:GetTeamNumber())
		keys.target:SetOwner(keys.caster)
		keys.target:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
		keys.target:EmitSound("Hero_Enchantress.EnchantCreep")
		ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	else
		local vLocation = keys.target:GetAbsOrigin()
		local sName = keys.target:GetUnitName()
		local fHealth = keys.target:GetHealth()
		local fMaxHealth = keys.target:GetMaxHealth()
		local fAttackMin = keys.target:GetBaseDamageMin()
		local fAttackMax = keys.target:GetBaseDamageMax()
		local iGoldBountyMin = keys.target:GetMinimumGoldBounty()
		local iGoldBountyMax = keys.target:GetMaximumGoldBounty()
		UTIL_Remove(keys.target)
		local hNewUnit = CreateUnitByName(sName, vLocation, true, keys.caster, nil, keys.caster:GetTeamNumber())
		hNewUnit:SetOwner(keys.caster)
		hNewUnit:SetBaseDamageMin(fAttackMin)
		hNewUnit:SetBaseDamageMax(fAttackMax)
		hNewUnit:SetMaxHealth(fMaxHealth)
		hNewUnit:SetBaseMaxHealth(fMaxHealth)
		hNewUnit:SetMinimumGoldBounty(iGoldBountyMin)
		hNewUnit:SetMaximumGoldBounty(iGoldBountyMax)
		hNewUnit:SetHealth(fHealth)
		hNewUnit:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
		hNewUnit:EmitSound("Hero_Enchantress.EnchantCreep")
		ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, hNewUnit)
	end
end

function RamzaOratorBeg(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	if keys.target:IsIllusion() then return end
	
	keys.caster:EmitSound("General.CoinsBig")
	
	local iGold = keys.ability:GetSpecialValueFor("multiplier")*keys.caster:GetLevel()
	if iGold > keys.target:GetGold() then iGold = keys.target:GetGold() end
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGold))+2, 100))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
	
	local iParticle2 = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle2, 0, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticle2, 1, keys.caster:GetAbsOrigin())
	
	local iParticle3 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(iParticle3, 1, Vector(1, iGold, 0))
	ParticleManager:SetParticleControl(iParticle3, 2, Vector(1, math.floor(math.log10(iGold))+2, 100))
	ParticleManager:SetParticleControl(iParticle3, 3, Vector(255, 230, 0))
	
	PlayerResource:ModifyGold(keys.caster:GetPlayerID(), iGold, false, DOTA_ModifyGold_Unspecified)
	PlayerResource:ModifyGold(keys.target:GetPlayerID(), -iGold, false, DOTA_ModifyGold_Unspecified)
end

function RamzaOratorStall(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = keys.ability:GetSpecialValueFor("stun_duration")})
end

function RamzaOratorCondemn(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_orator_speechcraft_condemn", {duration = keys.ability:GetSpecialValueFor("duration")})
end

function RamzaOratorCondemnStopSound(keys)
	keys.target:StopSound('Hero_DoomBringer.Doom')
end

function RamzaOratorEnlighten(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound('Hero_Axe.BerserkersCall.Start')
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, 1, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2, 200))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(60, 60, 255))
	keys.target:ModifyIntellect(-1)
end

function RamzaOratorIntimidate(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.target:EmitSound('Hero_Axe.BerserkersCall.Start')
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, 1, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2, 200))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 60, 60))
	keys.target:ModifyStrength(-1)
end


function RamzaOratorBeastTongue(keys)
	if not keys.target:IsHero() and not keys.target:IsAncient() and not keys.IsBuilding() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() and keys.target:GetHealth()/keys.target:GetMaxHealth() < 0.5 then

		if keys.target:GetOwner() then 
			keys.target:SetTeam(keys.attacker:GetTeamNumber())
			keys.target:SetOwner(keys.attacker)
			keys.target:SetControllableByPlayer(keys.attacker:GetPlayerID(), true)
			keys.target:EmitSound("Hero_Enchantress.EnchantCreep")
			ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
		else
			local vLocation = keys.target:GetAbsOrigin()
			local sName = keys.target:GetUnitName()
			local fHealth = keys.target:GetHealth()
			local fMaxHealth = keys.target:GetMaxHealth()
			local fAttackMin = keys.target:GetBaseDamageMin()
			local fAttackMax = keys.target:GetBaseDamageMax()
			local iGoldBountyMin = keys.target:GetMinimumGoldBounty()
			local iGoldBountyMax = keys.target:GetMaximumGoldBounty()
			UTIL_Remove(keys.target)
			local hNewUnit = CreateUnitByName(sName, vLocation, true, keys.attacker, nil, keys.attacker:GetTeamNumber())
			hNewUnit:SetOwner(keys.attacker)
			hNewUnit:SetBaseDamageMin(fAttackMin)
			hNewUnit:SetBaseDamageMax(fAttackMax)
			hNewUnit:SetMaxHealth(fMaxHealth)
			hNewUnit:SetMinimumGoldBounty(iGoldBountyMin)
			hNewUnit:SetMaximumGoldBounty(iGoldBountyMax)
			hNewUnit:SetHealth(fHealth)
			hNewUnit:SetControllableByPlayer(keys.attacker:GetPlayerID(), true)
			hNewUnit:EmitSound("Hero_Enchantress.EnchantCreep")
			ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, hNewUnit)
		end
	end
end