modifier_intimidator_glare_lua = class({})
function modifier_intimidator_glare_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_intimidator_glare_lua:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("attack")
end
function modifier_intimidator_glare_lua:OnRefresh()
	self.fSlow = -self:GetAbility():GetSpecialValueFor("movement_percentage")
end
function modifier_intimidator_glare_lua:GetModifierMoveSpeedBonus_Percentage()
	self.fSlow = self.fSlow or -self:GetAbility():GetSpecialValueFor("movement_percentage")
	return self.fSlow
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
	if IsClient() then return end 
	local parent = self:GetParent()
	parent:SetModelScale(self.originalModelScale)
	if not parent:IsHero() then return end
	parent:SetBaseStrength(self.originalStr-self.str+parent:GetBaseStrength())
	parent:SetBaseAgility(self.originalAgi-self.agi+parent:GetBaseAgility())
	parent:SetBaseIntellect(self.originalInt-self.int+parent:GetBaseIntellect())		
end
modifier_intimidator_glare_lua_buff = class({})
function modifier_intimidator_glare_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_intimidator_glare_lua_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack")
end
function modifier_intimidator_glare_lua_buff:OnRefresh()
	self.fMove = self:GetAbility():GetSpecialValueFor("movement_percentage")
	if IsClient() then return end
	table.insert(self.tStopTime, self:GetDieTime())
	self:IncrementStackCount()
end
function modifier_intimidator_glare_lua_buff:GetModifierMoveSpeedBonus_Percentage()
	self.fMove = self.fMove or self:GetAbility():GetSpecialValueFor("movement_percentage")
	return self.fMove*self:GetStackCount()
end

function modifier_intimidator_glare_lua_buff:OnCreated()	
	if IsClient() then return end  
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	self.originalModelScale = parent:GetModelScale()
	
	if not parent:IsHero() then return end
	
	local primary = parent:GetPrimaryAttribute()
	self.tOriginalStat = {parent:GetBaseStrength(), parent:GetBaseAgility(), parent:GetBaseIntellect()}
	self:SetStackCount(1)
	self.tStopTime={}
	table.insert(self.tStopTime, self:GetDieTime())
	
	self.tNewStat = {self.tOriginalStat[1]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100), self.tOriginalStat[2]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100), self.tOriginalStat[3]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100)}
	self.tNewStat[primary+1]=self.tOriginalStat[primary+1]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100)

	parent:SetModelScale(self.originalModelScale*(1+self:GetStackCount()*ability:GetSpecialValueFor("primary_attribute_percentage")/100))
	parent:SetBaseStrength(self.tNewStat[1])
	parent:SetBaseAgility(self.tNewStat[2])
	parent:SetBaseIntellect(self.tNewStat[3])
	parent:CalculateStatBonus(true)
	self:StartIntervalThink(0.04)
end

function modifier_intimidator_glare_lua_buff:OnIntervalThink()
	if IsClient() then return end
	local ability = self:GetAbility()
	local hParent = self:GetParent()
	local primary = hParent:GetPrimaryAttribute()
	if self.tStopTime[1] < GameRules:GetGameTime() then
		self:DecrementStackCount()
		table.remove(self.tStopTime, 1)
	end
	if math.abs(hParent:GetBaseStrength() - self.tNewStat[1]) > 0.5 or math.abs(hParent:GetBaseAgility() - self.tNewStat[2]) > 0.5 or math.abs(hParent:GetBaseIntellect() - self.tNewStat[3]) > 0.5 then
		self.tOriginalStat[1] = self.tOriginalStat[1]+hParent:GetBaseStrength()-self.tNewStat[1]
		self.tOriginalStat[2] = self.tOriginalStat[2]+hParent:GetBaseStrength()-self.tNewStat[2]
		self.tOriginalStat[3] = self.tOriginalStat[3]+hParent:GetBaseStrength()-self.tNewStat[3]
	end
	
	self.tNewStat[1]=self.tOriginalStat[1]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100)
	self.tNewStat[2]=self.tOriginalStat[2]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100)
	self.tNewStat[3]=self.tOriginalStat[3]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100)
	
	local iPrimaryStat = hParent:GetPrimaryAttribute()
	self.tNewStat[iPrimaryStat+1]=self.tOriginalStat[primary+1]*(1+self:GetStackCount()*ability:GetSpecialValueFor("attribute_percentage")/100)
	
	PrintTable(self.tOriginalStat)
	PrintTable(self.tNewStat)
	hParent:SetBaseStrength(self.tNewStat[1])
	hParent:SetBaseAgility(self.tNewStat[2])
	hParent:SetBaseIntellect(self.tNewStat[3])
	hParent:CalculateStatBonus(true)
	
	hParent:SetModelScale(self.originalModelScale*(1+self:GetStackCount()*ability:GetSpecialValueFor("primary_attribute_percentage")/100))
end

function modifier_intimidator_glare_lua_buff:OnDestroy()
	if IsClient() then return end 
	local parent = self:GetParent()
	parent:SetModelScale(self.originalModelScale)
	if not parent:IsHero() then return end
	parent:SetBaseStrength(self.tOriginalStat[1]-self.tNewStat[1]+parent:GetBaseStrength())
	parent:SetBaseAgility(self.tOriginalStat[2]-self.tNewStat[2]+parent:GetBaseAgility())
	parent:SetBaseIntellect(self.tOriginalStat[3]-self.tNewStat[3]+parent:GetBaseIntellect())	
	parent:CalculateStatBonus(true)	
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
	if IsClient() then return end
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

function modifier_intimidator_physical_activity_speed_lua:OnCreated() 
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, "attach_origin", hParent:GetOrigin(), true)
end
function modifier_intimidator_physical_activity_speed_lua:OnDestroy() 
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function modifier_intimidator_physical_activity_speed_lua:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

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
	if caster:PassivesDisabled() then return end
	
	
	if caster ~= keys.attacker then return end
	local ability = self:GetAbility()
	local glare = caster:GetAbilityByIndex(0)
	local grill = caster:GetAbilityByIndex(1)
	local rn = math.random(100)
	local chance
	if caster:FindAbilityByName("special_bonus_intimidator_1") then
		chance = ability:GetSpecialValueFor("chance")+caster:FindAbilityByName("special_bonus_intimidator_1"):GetSpecialValueFor("value")
	else
		chance = ability:GetSpecialValueFor("chance")
	end
	local chanceDislocate = ability:GetSpecialValueFor("chance_dislocate")
	if rn <= chance then
		if glare:GetLevel() > 0 and not target:IsMagicImmune() then 
			local hModifier = target:AddNewModifier(caster, glare, "modifier_intimidator_glare_lua", {Duration = glare:GetSpecialValueFor("duration")*CalculateStatusResist(target)})
			if caster:HasScepter() then
				caster:AddNewModifier(caster, glare, "modifier_intimidator_glare_lua_buff", {Duration = glare:GetSpecialValueFor("duration")})
			end
		end
		caster:EmitSound('Hero_LegionCommander.PressTheAttack')
		caster:AddNewModifier(caster, ability, "modifier_intimidator_physical_activity_speed_lua", {Duration = ability:GetSpecialValueFor("buff_duration")})
		
	elseif rn <= chance*2 then
		if grill:GetLevel() > 0 and not target:IsMagicImmune()  then
			local hModifier = target:AddNewModifier(caster, grill, "modifier_intimidator_grill_lua", {Duration = grill:GetSpecialValueFor("duration")*CalculateStatusResist(target)})
		end
	elseif rn <= chance*2+chanceDislocate then
		caster:AddNewModifier(caster, ability, "modifier_intimidator_physical_activity_dislocate_lua", {Duration = ability:GetSpecialValueFor("dislocate_duration")*CalculateStatusResist(caster)})
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
	if IsClient() then return end
	self:StartIntervalThink(CalculateStatusResist(self:GetParent()))
end

function modifier_intimidator_be_my_friend_lua:OnDestroy()
	if IsClient() then return end
	for i, v in pairs(self:GetAbility().tModifiers) do
		if v == self then
			ParticleManager:DestroyParticle(self:GetAbility().tParticles[i], false)

			table.remove(self:GetAbility().tParticles, i)
			table.remove(self:GetAbility().tModifiers, i)
		end
	end
	if #(self:GetAbility().tModifiers) < 1 then
		self:GetCaster():Interrupt()
	end
end

function modifier_intimidator_be_my_friend_lua:OnIntervalThink()
	if IsClient() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
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
