modifier_el_dorado_refine_weapons = class({})
function modifier_el_dorado_refine_weapons:IsHidden() return false end
function modifier_el_dorado_refine_weapons:IsPurgable() return false end
function modifier_el_dorado_refine_weapons:RemoveOnDeath() return false end


function modifier_el_dorado_refine_weapons:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_el_dorado_refine_weapons:OnIntervalThink()
	if IsClient() then return end
	local tItems = {}
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then return end
	local hAbility = self:GetAbility()
	local iSlot = 5
	if CheckTalent(hParent, 'special_bonus_el_dorado_3') > 0 then
		iSlot = 9
	end
	for i = 0, iSlot do
		if hParent:GetItemInSlot(i) then
			tItems[hParent:GetItemInSlot(i):GetName()] = true
		end
	end
	local iTypes = 0
	for k, v in pairs(tItems) do
		iTypes = iTypes+1
	end
	self:SetStackCount(iTypes)
	hParent:CalculateStatBonus(true)
	if not hParent.tSummons then return end
	
	hParent.iLastFrog = hParent.iLastFrog or 0
	for i = 1, hParent.iLastFrog do
		if hParent.tSummons[i] and not hParent.tSummons[i]:IsNull() and hParent.tSummons[i]:IsAlive() then
			if not hParent.tSummons[i]:HasModifier("modifier_el_dorado_refine_weapons_frog") then
				hParent.tSummons[i]:AddNewModifier(hParent, hAbility, "modifier_el_dorado_refine_weapons_frog", {})
			end
			hParent.tSummons[i]:FindModifierByName("modifier_el_dorado_refine_weapons_frog"):SetStackCount(iTypes)
			if iTypes > 3 then
				if not hParent.tSummons[i]:HasAbility("el_dorado_artificial_frog_blink") then
					hParent.tSummons[i]:AddAbility("el_dorado_artificial_frog_blink")
				end
				hParent.tSummons[i]:FindAbilityByName("el_dorado_artificial_frog_blink"):SetLevel(hAbility:GetLevel())
				if hAbility:GetLevel() == 4 and not hParent.tSummons[i]:HasAbility("el_dorado_artificial_frog_demolish") then
					hParent.tSummons[i]:AddAbility("el_dorado_artificial_frog_demolish"):SetLevel(1)				
				end
			else
				hParent.tSummons[i]:RemoveAbility("el_dorado_artificial_frog_blink")
				hParent.tSummons[i]:RemoveAbility("el_dorado_artificial_frog_demolish")
				hParent.tSummons[i]:RemoveModifierByName("modifier_el_dorado_artificial_frog_demolish")
			end
			
		end
	end
end

function modifier_el_dorado_refine_weapons:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_el_dorado_refine_weapons:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_item")*self:GetStackCount()
end

function modifier_el_dorado_refine_weapons:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_per_item")*self:GetStackCount()
end

function modifier_el_dorado_refine_weapons:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health_per_item")*self:GetStackCount()
end

modifier_el_dorado_refine_weapons_frog = class({})

function modifier_el_dorado_refine_weapons_frog:IsHidden() return false end
function modifier_el_dorado_refine_weapons_frog:IsPurgable() return false end
function modifier_el_dorado_refine_weapons_frog:RemoveOnDeath() return false end

function modifier_el_dorado_refine_weapons_frog:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_el_dorado_refine_weapons_frog:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_item_frog")*self:GetStackCount()
end

function modifier_el_dorado_refine_weapons_frog:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_per_item_frog")*self:GetStackCount()
end

modifier_el_dorado_piracy_method = class({})

function modifier_el_dorado_piracy_method:IsHidden() return true end
function modifier_el_dorado_piracy_method:IsPurgable() return false end
function modifier_el_dorado_piracy_method:RemoveOnDeath() return false end

modifier_el_dorado_artificial_frog_disable_healing = class({})

function modifier_el_dorado_artificial_frog_disable_healing:DeclareFunctions()
	return {MODIFIER_PROPERTY_DISABLE_HEALING, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

function modifier_el_dorado_artificial_frog_disable_healing:IsHidden() return true end
function modifier_el_dorado_artificial_frog_disable_healing:IsPurgable() return false end
function modifier_el_dorado_artificial_frog_disable_healing:RemoveOnDeath() return false end

function modifier_el_dorado_artificial_frog_disable_healing:GetDisableHealing() 
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_el_dorado_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end	
	
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") == 1 then
		return false
	else
		return 1
	end
end

function modifier_el_dorado_artificial_frog_disable_healing:GetModifierConstantHealthRegen()
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_el_dorado_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end	
	
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") == 1 then
		return 100
	else
		return 0
	end	
end