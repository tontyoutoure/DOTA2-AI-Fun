LinkLuaModifier("modifier_ramza_white_mage_reraise", "heroes/ramza/ramza_white_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_white_mage_regenerate", "heroes/ramza/ramza_white_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_white_mage_white_magicks_regen", "heroes/ramza/ramza_white_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_white_mage_white_magicks_shell", "heroes/ramza/ramza_white_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_white_mage_white_magicks_protect", "heroes/ramza/ramza_white_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
ramza_white_mage_reraise = class({})

function ramza_white_mage_reraise:CastFilterResultTarget(hTarget)
	if IsClient() then return UF_SUCCESS end
	if hTarget:HasModifier("modifier_ramza_white_mage_reraise") then return UF_FAIL_CUSTOM end
	return UF_SUCCESS
end

function ramza_white_mage_reraise:GetCustomCastErrorTarget(hTarget)	
	if IsClient() then return end
	if hTarget:HasModifier("modifier_ramza_white_mage_reraise") then return "error_already_has_reraise" end
end


function ramza_white_mage_reraise:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ramza_white_mage_reraise", {})
	self:GetCaster():EmitSound("Hero_Omniknight.GuardianAngel.Cast")
end

function RamzaWhiteMageRegenerateApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_white_mage_regenerate", {})
end

function RamzaWhiteMageWallApply(keys)
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_white_mage_white_magicks_shell", {Duration = keys.ability:GetSpecialValueFor("duration")}).fDamageAbsorb = keys.ability:GetSpecialValueFor("damga_absorb")
	keys.target:EmitSound('Hero_ArcWarden.MagneticField.Cast')
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_white_mage_white_magicks_protect", {Duration = keys.ability:GetSpecialValueFor("duration"), fArmor = keys.ability:GetSpecialValueFor("bonus_armor")})
	keys.target:EmitSound('Hero_Sven.WarCry')
end

function RamzaWhiteMageShellApply(keys)
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_white_mage_white_magicks_shell", {Duration = keys.ability:GetSpecialValueFor("duration")}).fDamageAbsorb = keys.ability:GetSpecialValueFor("damga_absorb")
	keys.target:EmitSound('Hero_ArcWarden.MagneticField.Cast')
end

function RamzaWhiteMageRegenApply(keys)
	keys.target:EmitSound('Hero_Huskar.Inner_Vitality')
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_white_mage_white_magicks_regen", {Duration = keys.ability:GetSpecialValueFor("duration"), fRegen = keys.ability:GetSpecialValueFor("regen")})
end

function RamzaWhiteMageProtectApply(keys)
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_white_mage_white_magicks_protect", {Duration = keys.ability:GetSpecialValueFor("duration"), fArmor = keys.ability:GetSpecialValueFor("bonus_armor")})
	keys.target:EmitSound('Hero_Sven.WarCry')
end

function RamzaWhiteMageCuragaSingleTarget(hFrom, tHealedTargets, fHeal, iBounceLeft, hCaster)
	local tTargets = FindUnitsInRadius(hFrom:GetTeamNumber(), hFrom:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	table.sort(tTargets, function (hUnita, hUnitb) return hUnita:GetMaxHealth()-hUnita:GetHealth() > hUnitb:GetMaxHealth()-hUnitb:GetHealth() end)
	local hTo
		
	for j = 1, #tTargets do
		local bFound = true
		for i = 1, #tHealedTargets do
			if tTargets[j] == tHealedTargets[i] then 
				bFound = false 
				break
			end
		end
		if bFound then
			hTo = tTargets[j]
			break 
		end
	end
	
	if hTo then
		local fHealAmount
		if hTo:GetMaxHealth()-hTo:GetHealth() > fHeal then
			fHealAmount = fHeal
		else
			fHealAmount = hTo:GetMaxHealth()-hTo:GetHealth()
		end
		
		
		hTo:Heal(fHeal, hCaster)
		hTo:EmitSound("Hero_Ramza.WhiteMageCuraga"..tostring(7-iBounceLeft))
		table.insert(tHealedTargets, hTo)
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hFrom )
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTo, PATTACH_POINT_FOLLOW, "attach_hitloc", hTo:GetAbsOrigin(), true)
		
		if fHealAmount > 0 then
			iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTo)
			ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHealAmount, 0))
			ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHealAmount))+2,0))
			ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
		end
		
		ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTo)
		if iBounceLeft > 0 then
			Timers:CreateTimer(0.6, function () RamzaWhiteMageCuragaSingleTarget(hTo, tHealedTargets, fHeal, iBounceLeft-1, hCaster ) end)
		end
	end
end

function RamzaWhiteMageCuraga (keys)
	local hFrom = keys.caster
	local hTo = keys.target
	local fHeal = keys.ability:GetSpecialValueFor("heal")
	local fHealAmount
	if hTo:GetMaxHealth()-hTo:GetHealth() > fHeal then
		fHealAmount = fHeal
	else
		fHealAmount = hTo:GetMaxHealth()-hTo:GetHealth()
	end
	hTo:Heal(fHeal, hCaster)
	hTo:EmitSound("Hero_Ramza.WhiteMageCuraga1")
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hFrom )
	ParticleManager:SetParticleControlEnt(iParticle, 1, hTo, PATTACH_POINT_FOLLOW, "attach_hitloc", hTo:GetAbsOrigin(), true)
	
	if fHealAmount > 0 then
		iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTo)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHealAmount, 0))
		ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHealAmount))+2,0))
		ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
	end
	ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTo)
	Timers:CreateTimer(0.6, function () RamzaWhiteMageCuragaSingleTarget(hTo, {hTo}, fHeal, keys.ability:GetSpecialValueFor("bounces"), hFrom ) end)
end

function RamzaWhiteMageCura (keys)
	local fHeal = keys.ability:GetSpecialValueFor("heal")
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target_points[1], nil, keys.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(tTargets) do		
		local fHealAmount
		if v:GetMaxHealth()-v:GetHealth() > fHeal then
			fHealAmount = fHeal
		else
			fHealAmount = v:GetMaxHealth()-v:GetHealth()
		end
		if fHealAmount > 0 then
			v:Heal(fHeal, hCaster)				
			iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
			ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHealAmount, 0))
			ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHealAmount))+2,0))
			ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
		end
	end
end




function RamzaWhiteMageHoly(keys)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_ramza_white_mage_white_magicks_holy", {})
	ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	keys.target:EmitSound('Hero_Chen.PenitenceImpact')
	local damageTable = {
		attacker = keys.caster,
		victim = keys.target, 
		damage = keys.ability:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
end