LinkLuaModifier("modifier_ramza_squire_counter_tackle", "heroes/ramza/ramza_squire_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function RamzaSquireConterTackle(keys)
	PrintTable(keys)
end

function RamzaSquireDefendToggle(keys)
	if keys.caster:HasModifier("modifier_ramza_squire_defend") then
		keys.caster:FindModifierByName("modifier_ramza_squire_defend"):Destroy()
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_ramza_squire_defend", {})
	end
end

ramza_squire_counter_tackle = class({})

function ramza_squire_counter_tackle:GetIntrinsicModifierName() return "modifier_ramza_squire_counter_tackle" end

function RamzaSquireChant(keys)
	local fCurrentHealth = keys.caster:GetHealth()
	local fHealthCost = keys.ability:GetSpecialValueFor("health_cost")
	if fHealthCost < fCurrentHealth-1 then 
		keys.caster:SetHealth(fCurrentHealth-fHealthCost)
	else
		keys.caster:SetHealth(1)
	end
end