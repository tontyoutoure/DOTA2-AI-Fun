modifier_test_ability1 = class({})

function modifier_test_ability1:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER}
end

function modifier_test_ability1:OnAttackLanded(keys)
	PrintTable(keys.cast_target)
	if not self:GetAbility():IsFullyCastable() then 	
		return 
	end
	local hAbility = self:GetAbility()
	if self.bIsCastingOrb or hAbility:GetAutoCastState() then
		ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf",PATTACH_ABSORIGIN_FOLLOW, keys.target)
		hAbility:UseResources(true, true, true)
		self.bIsCastingOrb = false
	end
	
end


function modifier_test_ability1:OnOrder(keys)
	print(keys.ability:GetName())
	if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET and keys.ability == self:GetAbility() then
		self.bIsCastingOrb = true
	elseif not keys.ability or bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE) == 0 then
		self.bIsCastingOrb = false
	end
end

