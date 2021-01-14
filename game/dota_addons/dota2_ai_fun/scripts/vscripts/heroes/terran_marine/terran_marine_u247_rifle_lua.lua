LinkLuaModifier("modifier_terran_marine_u247_rifle", "heroes/terran_marine/modifier_terran_marine.lua", LUA_MODIFIER_MOTION_NONE)

terran_marine_u247_rifle_lua = class({})
function terran_marine_u247_rifle_lua:ProcsMagicStick() return false end
function terran_marine_u247_rifle_lua:OnToggle()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("modifier_terran_marine_u247_rifle");
	if hModifier then
		hModifier:Destroy()
		hCaster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		hCaster:CalculateStatBonus(true)
	else		
		ProcsArroundingMagicStick(hCaster)
		hCaster:AddNewModifier(hCaster, self, "modifier_terran_marine_u247_rifle", {})
		hCaster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		hCaster:SetRangedProjectileName("particles/units/heroes/hero_tinker/tinker_missile.vpcf")
		hCaster:CalculateStatBonus(true)		
	end
end