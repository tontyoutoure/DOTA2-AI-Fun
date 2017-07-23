RAMZA_ATTACK_HERO_JOB_POINT = 5
RAMZA_ATTACK_BUILDING_JOB_POINT = 5
RAMZA_ATTACK_ANCIENT_JOB_POINT = 5
RAMZA_ATTACK_CREEP_JOB_POINT = 1
RAMZA_USE_ABILITY_JOB_POINT = 20
RAMZA_KILL_BUILDING_JOB_POINT = 50
RAMZA_KILL_HERO_PER_LEVEL_JOB_POINT = 50
RAMZA_KILL_ANCIENT_JOB_POINT = 50
RAMZA_KILL_CREEP_JOB_POINT = 10

local tBannedAbilities = {
	item_armlet = true,
	item_power_treads = true,
	item_ring_of_aquila = true,
	item_ring_of_basilius = true,
	item_radiance = true,
}


modifier_attribute_growth_str = class({})

function modifier_attribute_growth_str:IsBuff() return true end

function modifier_attribute_growth_str:IsHidden() return false end

function modifier_attribute_growth_str:IsPurgable() return true end

function modifier_attribute_growth_str:RemoveOnDeath() return false end

function modifier_attribute_growth_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_attribute_growth_str:OnTooltip()
	return tostring(self.fGrowth)
end

function modifier_attribute_growth_str:OnCreated()
	self.fGrowth = self.fGrowth or 0
end

function modifier_attribute_growth_str:GetTexture()
	return "modifier_attribute_growth_str"
end
modifier_attribute_growth_agi = class({})

function modifier_attribute_growth_agi:IsBuff() return true end

function modifier_attribute_growth_agi:IsHidden() return false end

function modifier_attribute_growth_agi:IsPurgable() return true end

function modifier_attribute_growth_agi:RemoveOnDeath() return false end

function modifier_attribute_growth_agi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_attribute_growth_agi:OnTooltip()
	return toagiing(self.fGrowth)
end

function modifier_attribute_growth_agi:OnCreated()
	self.fGrowth = self.fGrowth or 0
end

function modifier_attribute_growth_agi:GetTexture()
	return "modifier_attribute_growth_agi"
end
modifier_attribute_growth_int = class({})

function modifier_attribute_growth_int:IsBuff() return true end

function modifier_attribute_growth_int:IsHidden() return false end

function modifier_attribute_growth_int:IsPurgable() return true end

function modifier_attribute_growth_int:RemoveOnDeath() return false end

function modifier_attribute_growth_int:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_attribute_growth_int:OnTooltip()
	return tointing(self.fGrowth)
end

function modifier_attribute_growth_int:OnCreated()
	self.fGrowth = self.fGrowth or 0
end

function modifier_attribute_growth_int:GetTexture()
	return "modifier_attribute_growth_int"
end


modifier_ramza_job_manager = class({}) -- This modifier will add job points when things happens.

function modifier_ramza_job_manager:IsPurgable() return false end

function modifier_ramza_job_manager:IsHidden() return false end

function modifier_ramza_job_manager:RemoveOnDeath() return false end



function modifier_ramza_job_manager:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	}
end

function modifier_ramza_job_manager:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent.hRamzaJob = CRamzaJob:New()
end



function modifier_ramza_job_manager:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	if keys.target:IsHero() then 
		self:GainJobPoint(RAMZA_ATTACK_HERO_JOB_POINT)
	elseif keys.target:IsBuilding() then
		self:GainJobPoint(RAMZA_ATTACK_BUILDING_JOB_POINT)
	elseif keys.target:IsAncient() then 
		self:GainJobPoint(RAMZA_ATTACK_ANCIENT_JOB_POINT)
	else
		self:GainJobPoint(RAMZA_ATTACK_CREEP_JOB_POINT)
	end
end

-- 20 jp
function modifier_ramza_job_manager:OnAbilityExecuted(keys)
	if keys.unit ~= self:GetParent() or keys.unit:FindModifierByName("modifier_fountain_aura_buff") or tBannedAbilities[keys.ability:GetName()] then return end
	self:GainJobPoint(RAMZA_USE_ABILITY_JOB_POINT) 
end

-- 10 jp/50jp
function modifier_ramza_job_manager:OnTakeDamageKillCredit(keys)
	if keys.attacker ~= self:GetParent() then return end
	if keys.damage > keys.target:GetHealth() then 
		if keys.target:IsHero() then 
			self:GainJobPoint(RAMZA_KILL_HERO_PER_LEVEL_JOB_POINT*keys.target:GetLevel())
		elseif keys.target:IsBuilding() then			
			self:GainJobPoint(RAMZA_KILL_BUILDING_JOB_POINT)
		elseif keys.target:IsAncient() then
			self:GainJobPoint(RAMZA_KILL_ANCIENT_JOB_POINT)
		else
			self:GainJobPoint(RAMZA_KILL_CREEP_JOB_POINT)
		end
	end
end


function modifier_ramza_job_manager:GainJobPoint(iJobPoint)
	print(iJobPoint, "points get!")
end







