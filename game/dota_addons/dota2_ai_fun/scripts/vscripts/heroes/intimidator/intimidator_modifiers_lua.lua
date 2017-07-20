modifier_intimidator_glare_lua = class({})

function modifier_intimidator_glare_lua:IsDebuff()
	return true
end

function modifier_intimidator_glare_lua:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
	return func
end

function modifier_intimidator_glare_lua:GetModifierAttackSpeedBonus_Constant()
	return -(self:GetAbility():GetSpecialValueFor("attack"))
end

function modifier_intimidator_glare_lua:GetModifierMoveSpeedBonus_Percentage()
	return -(self:GetAbility():GetSpecialValueFor("movement_percentage"))
end

function modifier_intimidator_glare_lua:GetTexture()
	return "intimidator_glare"
end

function modifier_intimidator_glare_lua:OnCreated()	
	if IsClient() then return end -- Buggy API
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	self.originalModelScale = parent:GetModelScale()
	parent:SetModelScale(self.originalModelScale*(1-ability:GetSpecialValueFor("primary_attribute_percentage")/100))
	
	if not parent:IsHero() then return end
	
	local primary = parent:GetPrimaryAttribute()
	self.originalStr = parent:GetBaseStrength()
	self.originalAgi = parent:GetBaseAgility()
	self.originalInt = parent:GetBaseIntellect()
	if primary == 0 then
		self.str = self.originalStr*(1-ability:GetSpecialValueFor("primary_attribute_percentage")/100)
		self.agi = self.originalAgi*(1-ability:GetSpecialValueFor("attribute_percentage")/100)
		self.int = self.originalInt*(1-ability:GetSpecialValueFor("attribute_percentage")/100)
	elseif primary == 1 then
		self.str = self.originalStr*(1-ability:GetSpecialValueFor("attribute_percentage")/100)
		self.agi = self.originalAgi*(1-ability:GetSpecialValueFor("primary_attribute_percentage")/100)
		self.int = self.originalInt*(1-ability:GetSpecialValueFor("attribute_percentage")/100)
	else
		self.str = self.originalStr*(1-ability:GetSpecialValueFor("attribute_percentage")/100)
		self.agi = self.originalAgi*(1-ability:GetSpecialValueFor("attribute_percentage")/100)
		self.int = self.originalInt*(1-ability:GetSpecialValueFor("primary_attribute_percentage")/100)
	end
	parent:SetBaseStrength(self.str)
	parent:SetBaseAgility(self.agi)
	parent:SetBaseIntellect(self.int)
	
end

function modifier_intimidator_glare_lua:OnDestroy()
	if IsClient() then print("clent request ignored") return end -- Buggy API
	local parent = self:GetParent()
	parent:SetModelScale(self.originalModelScale)
	if not parent:IsHero() then return end
	parent:SetBaseStrength(self.originalStr-self.str+parent:GetBaseStrength())
	parent:SetBaseAgility(self.originalAgi-self.agi+parent:GetBaseAgility())
	parent:SetBaseIntellect(self.originalInt-self.int+parent:GetBaseIntellect())
		
end


modifier_intimidator_grill_lua = class({})

function modifier_intimidator_grill_lua:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_column.vpcf"
end

function modifier_intimidator_grill_lua:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_intimidator_grill_lua:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_intimidator_grill_lua:GetTexture()
	return "intimidator_grill"
end

function modifier_intimidator_grill_lua:OnIntervalThink()
	if IsClient() then print("clent request ignored") return end -- Buggy API
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	parent:EmitSound("Hero_Treant.LeechSeed.Tick")
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	local count = 0
	local damagePerUnit = ability:GetSpecialValueFor("damage_per_unit")
	
	for _, v in pairs(units) do
		count = count+1
		v:Heal(damagePerUnit, caster)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
	end
	local damageTable = {
		victim  = parent,
		attacker = caster,
		damage  = count*damagePerUnit,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		ability = ability}
	ApplyDamage(damageTable)
end


modifier_intimidator_physical_activity_dislocate_lua = class({})

function modifier_intimidator_physical_activity_dislocate_lua:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

function modifier_intimidator_physical_activity_dislocate_lua:IsDebuff()
	return true
end


modifier_intimidator_physical_activity_speed_lua = class({})

function modifier_intimidator_physical_activity_speed_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_intimidator_physical_activity_speed_lua:IsBuff()
	return true
end

function modifier_intimidator_physical_activity_speed_lua:GetEffectName() 
	return "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
end

function modifier_intimidator_physical_activity_speed_lua:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("movement_percentage")
end

function modifier_intimidator_physical_activity_speed_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("attack")
end


modifier_intimidator_physical_activity_lua = class({})

function modifier_intimidator_physical_activity_lua:IsHidden()
	return true
end



function modifier_intimidator_physical_activity_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_intimidator_physical_activity_lua:OnAttackLanded(keys)
	local target = keys.target
	local caster = self:GetCaster()
	
	
	if caster ~= keys.attacker then return end
	local ability = self:GetAbility()
	local glare = caster:GetAbilityByIndex(0)
	local grill = caster:GetAbilityByIndex(1)
	local rn = math.random(100)
	
	
	
	local chance = ability:GetSpecialValueFor("chance")
	local chanceDislocate = ability:GetSpecialValueFor("chance_dislocate")
	if rn <= chance then
		if glare:GetLevel() > 0 then 
			local hModifier = target:AddNewModifier(caster, glare, "modifier_intimidator_glare_lua", {Duration = glare:GetSpecialValueFor("duration")})
		end
		caster:EmitSound('Hero_LegionCommander.PressTheAttack')
		caster:AddNewModifier(caster, ability, "modifier_intimidator_physical_activity_speed_lua", {Duration = ability:GetSpecialValueFor("buff_duration")})
		
	elseif rn <= chance*2 then
		if grill:GetLevel() > 0 then
			local hModifier = target:AddNewModifier(caster, grill, "modifier_intimidator_grill_lua", {Duration = grill:GetSpecialValueFor("duration")})
		end
	elseif rn <= chance*2+chanceDislocate then
		caster:AddNewModifier(caster, ability, "modifier_intimidator_physical_activity_dislocate_lua", {Duration = ability:GetSpecialValueFor("dislocate_duration")})
	end
	
end




modifier_intimidator_be_my_friend_lua = class({})

function modifier_intimidator_be_my_friend_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_intimidator_be_my_friend_lua:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_intimidator_be_my_friend_lua:IsStunDebuff() return true end

function modifier_intimidator_be_my_friend_lua:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_intimidator_be_my_friend_lua:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ApplyDamage then return end -- API is buggy, so...
	local damageTable = {
		victim  = parent,
		attacker = caster,
		damage  = ability:GetSpecialValueFor("dps"),
		damage_type  = DAMAGE_TYPE_MAGICAL,
		ability = ability}
	ApplyDamage(damageTable)
end

function modifier_intimidator_be_my_friend_lua:OnTakeDamage(keys)
	if self:GetParent() ~= keys.unit then return end
	local caster = self:GetCaster()
	if keys.attacker == caster then return end
	local ability = self:GetAbility()
	local damageTable = {
		victim  = self:GetParent(),
		attacker = caster,
		damage  = ability:GetSpecialValueFor("damage_percentage")*keys.damage/100,
		damage_type  = DAMAGE_TYPE_PURE,
		ability = ability
	}
	ApplyDamage(damageTable)
end
