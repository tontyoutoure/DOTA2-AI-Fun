
function void_demon_quake_OnSpellStart(keys)
	local hAbility = keys.ability
	local hCaster = keys.caster 
	local vPoint = keys.target_points[1]
	ProcsArroundingMagicStick(hCaster)
	hCaster.hQuakeThinker = CreateModifierThinker(hCaster, hAbility, "modifier_void_demon_quake_aura_lua", {}, vPoint, hCaster:GetTeamNumber(), false)

	local tAllModifiers = hCaster.hQuakeThinker:FindAllModifiers()
	tAllModifiers[1].iRadius = hAbility:GetSpecialValueFor("radius")
	tAllModifiers[1].fDamage = hAbility:GetSpecialValueFor("damage")
end

function void_demon_quake_OnChannelFinish(keys)
	local hCaster = keys.caster 
	hCaster.hQuakeThinker:RemoveSelf()
end
