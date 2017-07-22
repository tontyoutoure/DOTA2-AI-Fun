fluid_engineer_brainstorm_str_lua = class({})
fluid_engineer_brainstorm_agi_lua = class({})
fluid_engineer_brainstorm_int_lua = class({})

function fluid_engineer_brainstorm_str_lua:OnUpgrade()
	local hCaster = self:GetCaster()
	if hCaster.bIsLevelingUp then return end
	hCaster.bIsLevelingUp = true
	hCaster:FindAbilityByName("fluid_engineer_brainstorm_agi_lua"):SetLevel(self:GetLevel())
	hCaster:FindAbilityByName("fluid_engineer_brainstorm_int_lua"):SetLevel(self:GetLevel())
	hCaster.bIsLevelingUp = false
end

function fluid_engineer_brainstorm_agi_lua:OnUpgrade()
	local hCaster = self:GetCaster()
	if hCaster.bIsLevelingUp then return end
	hCaster.bIsLevelingUp = true
	hCaster:FindAbilityByName("fluid_engineer_brainstorm_int_lua"):SetLevel(self:GetLevel())
	hCaster:FindAbilityByName("fluid_engineer_brainstorm_str_lua"):SetLevel(self:GetLevel())
	hCaster.bIsLevelingUp = false
end

function fluid_engineer_brainstorm_int_lua:OnUpgrade()
	local hCaster = self:GetCaster()
	if hCaster.bIsLevelingUp then return end
	hCaster.bIsLevelingUp = true
	hCaster:FindAbilityByName("fluid_engineer_brainstorm_str_lua"):SetLevel(self:GetLevel())
	hCaster:FindAbilityByName("fluid_engineer_brainstorm_agi_lua"):SetLevel(self:GetLevel())
	hCaster.bIsLevelingUp = false
end


function fluid_engineer_brainstorm_str_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local fDamage
	if hTarget:IsHero() then
		fDamage = (hCaster:GetIntellect()-hTarget:GetStrength())*self:GetSpecialValueFor("damage_per_difference")
	else
		fDamage = hCaster:GetIntellect()*self:GetSpecialValueFor("damage_per_difference")
	end
	
	if fDamage < 0 then fDamage = 0 end
	
	local damageTable = {
		attacker = hCaster,
		victim = hTarget,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}
	ApplyDamage(damageTable)
end

function fluid_engineer_brainstorm_agi_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local fDamage
	if hTarget:IsHero() then
		fDamage = (hCaster:GetIntellect()-hTarget:GetAgility())*self:GetSpecialValueFor("damage_per_difference")
	else
		fDamage = hCaster:GetIntellect()*self:GetSpecialValueFor("damage_per_difference")
	end
	
	if fDamage < 0 then fDamage = 0 end
	
	local damageTable = {
		attacker = hCaster,
		victim = hTarget,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}
	ApplyDamage(damageTable)
end

function fluid_engineer_brainstorm_int_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local fDamage
	if hTarget:IsHero() then
		fDamage = (hCaster:GetIntellect()-hTarget:GetIntellect())*self:GetSpecialValueFor("damage_per_difference")
	else
		fDamage = hCaster:GetIntellect()*self:GetSpecialValueFor("damage_per_difference")
	end
	
	if fDamage < 0 then fDamage = 0 end
	
	local damageTable = {
		attacker = hCaster,
		victim = hTarget,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}
	ApplyDamage(damageTable)
end