RAMZA_ATTACK_HERO_JOB_POINT = 5
RAMZA_ATTACK_BUILDING_JOB_POINT = 5
RAMZA_ATTACK_ANCIENT_JOB_POINT = 5
RAMZA_ATTACK_CREEP_JOB_POINT = 1
RAMZA_USE_ABILITY_JOB_POINT = 50
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
	ramza_open_stats_lua = true,
	ramza_select_job_lua = true,
	ramza_select_secondary_skill_lua = true,
	ramza_next_page_lua = true,
	ramza_go_back_lua = true,
	ramza_job_squire_JC = true,
	ramza_job_chemist_JC = true,
	ramza_job_knight_JC = true,
	ramza_job_white_mage_JC = true,
	ramza_job_black_mage_JC = true,
	ramza_job_monk_JC = true,
	ramza_job_thief_JC = true,
	ramza_job_mystic_JC = true,
	ramza_job_time_mage_JC = true,
	ramza_job_orator_JC = true,
	ramza_job_summoner_JC = true,
	ramza_job_geomancer_JC = true,
	ramza_job_samurai_JC = true,
	ramza_job_dark_knight_JC = true,
	ramza_squire_defend = true,
	ramza_chemist_autopotion = true,
	ramza_time_mage_mana_shield = true,
	ramza_ninja_vanish = true,
	ramza_dark_knight_vehemence = true
}

modifier_attribute_growth_str = class({})

function modifier_attribute_growth_str:IsBuff() return true end

function modifier_attribute_growth_str:IsHidden() return true end

function modifier_attribute_growth_str:IsPurgable() return true end

function modifier_attribute_growth_str:RemoveOnDeath() return false end

function modifier_attribute_growth_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end


function modifier_attribute_growth_str:OnTooltip()
	return self.fGrowth
end

function modifier_attribute_growth_str:OnCreated()
	self.fGrowth = self.fGrowth or 0
end

function modifier_attribute_growth_str:GetTexture()
	return "modifier_attribute_growth_str"
end
modifier_attribute_growth_agi = class({})

function modifier_attribute_growth_agi:IsBuff() return true end

function modifier_attribute_growth_agi:IsHidden() return true end

function modifier_attribute_growth_agi:IsPurgable() return true end

function modifier_attribute_growth_agi:RemoveOnDeath() return false end

function modifier_attribute_growth_agi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_attribute_growth_agi:OnTooltip()
	return self.fGrowth
end

function modifier_attribute_growth_agi:OnCreated()
	self.fGrowth = self.fGrowth or 0
end

function modifier_attribute_growth_agi:GetTexture()
	return "modifier_attribute_growth_agi"
end
modifier_attribute_growth_int = class({})

function modifier_attribute_growth_int:IsBuff() return true end

function modifier_attribute_growth_int:IsHidden() return true end

function modifier_attribute_growth_int:IsPurgable() return true end

function modifier_attribute_growth_int:RemoveOnDeath() return false end

function modifier_attribute_growth_int:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_attribute_growth_int:OnTooltip()
	return self.fGrowth
end

function modifier_attribute_growth_int:OnCreated()
	self.fGrowth = self.fGrowth or 0
end

function modifier_attribute_growth_int:GetTexture()
	return "modifier_attribute_growth_int"
end


modifier_ramza_job_manager = class({}) -- This modifier will add job points when things happens.

function modifier_ramza_job_manager:IsPurgable() return false end

function modifier_ramza_job_manager:IsHidden() return true end

function modifier_ramza_job_manager:RemoveOnDeath() return false end



function modifier_ramza_job_manager:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end


function modifier_ramza_job_manager:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent.hRamzaJob = CRamzaJob:New({hParent=hParent})
	hParent.hRamzaJob:InitNetTable()
	-- growth of squire
	self.fIntGrowth = 2.5
	self.fStrGrowth = 2.5
	self.fAgiGrowth = 2.5
end

function modifier_ramza_job_manager:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	if keys.target:IsHero() then 
		hParent.hRamzaJob:GainJobPoint(RAMZA_ATTACK_HERO_JOB_POINT)
	elseif keys.target:IsBuilding() then
		hParent.hRamzaJob:GainJobPoint(RAMZA_ATTACK_BUILDING_JOB_POINT)
	elseif keys.target:IsAncient() then 
		hParent.hRamzaJob:GainJobPoint(RAMZA_ATTACK_ANCIENT_JOB_POINT)
	else
		hParent.hRamzaJob:GainJobPoint(RAMZA_ATTACK_CREEP_JOB_POINT)
	end
end

-- 20 jp
function modifier_ramza_job_manager:OnAbilityExecuted(keys)
	if keys.unit ~= self:GetParent() or keys.unit:FindModifierByName("modifier_fountain_aura_buff") or tBannedAbilities[keys.ability:GetName()] then return end
	local hParent = self:GetParent()
	hParent.hRamzaJob:GainJobPoint(RAMZA_USE_ABILITY_JOB_POINT) 
end

-- 10 jp/50jp
function modifier_ramza_job_manager:OnTakeDamageKillCredit(keys)
	if keys.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	if keys.damage > keys.target:GetHealth() then 
		if keys.target:IsHero() then 
			hParent.hRamzaJob:GainJobPoint(RAMZA_KILL_HERO_PER_LEVEL_JOB_POINT*keys.target:GetLevel())
		elseif keys.target:IsBuilding() then			
			hParent.hRamzaJob:GainJobPoint(RAMZA_KILL_BUILDING_JOB_POINT)
		elseif keys.target:IsAncient() then
			hParent.hRamzaJob:GainJobPoint(RAMZA_KILL_ANCIENT_JOB_POINT)
		else
			hParent.hRamzaJob:GainJobPoint(RAMZA_KILL_CREEP_JOB_POINT)
		end
	end
end

function modifier_ramza_job_manager:GetModifierAttackRangeBonus()
	self.iBonusAttackRange = self.iBonusAttackRange or 0
	return self.iBonusAttackRange
end


modifier_ramza_job_level = class({})
	

function modifier_ramza_job_level:IsPurgable() return false end
function modifier_ramza_job_level:RemoveOnDeath() return false end	
function modifier_ramza_job_level:GetTexture() return "ramza_job_info" end

function modifier_ramza_job_level:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_ramza_job_level:OnTooltip()
	self.iJobpoints = self.iJobpoints or 0
	return self.iJobpoints
end

modifier_ramza_job_mastered = class({})

function modifier_ramza_job_mastered:IsPurgable() return false end
function modifier_ramza_job_mastered:RemoveOnDeath() return false end	
function modifier_ramza_job_mastered:GetTexture() return "ramza_job_info_mastered" end


modifier_ramza_job_point = class({})


function modifier_ramza_job_point:IsPurgable() return false end
function modifier_ramza_job_point:RemoveOnDeath() return false end	
function modifier_ramza_job_point:GetTexture() return "ramza_job_info" end


modifier_ramza_samurai_run_animation_manager = class({})

function modifier_ramza_samurai_run_animation_manager:IsPurgable() return false end
function modifier_ramza_samurai_run_animation_manager:RemoveOnDeath() return false end	
function modifier_ramza_samurai_run_animation_manager:IsHidden() return true end

function modifier_ramza_samurai_run_animation_manager:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.15)
	local hParent = self:GetParent()
	AddAnimationTranslate(hParent, "odachi")
	AddAnimationTranslate(hParent, "arcana")
	AddAnimationTranslate(hParent, "red")
	self.hSpeedModifier = AddAnimationTranslate(hParent, "run")
end

function modifier_ramza_samurai_run_animation_manager:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:GetIdealSpeed() >= 380 and self.hSpeedModifier.translate == "run" then
		self.hSpeedModifier:Destroy()
		self.hSpeedModifier = AddAnimationTranslate(hParent, "run_fast")
		self.fSpeedStartTime = Time()
	elseif hParent:GetIdealSpeed() < 380 and self.hSpeedModifier.translate == "run_fast" and Time() - self.fSpeedStartTime > 5 then		
		self.hSpeedModifier:Destroy()		
		self.hSpeedModifier = AddAnimationTranslate(hParent, "run")
	end
	
	if hParent:GetHealth()/hParent:GetMaxHealth() < 0.25 and not self.hInjuredModifier then
		self.hInjuredModifier = AddAnimationTranslate(hParent, "injured")
	elseif hParent:GetHealth()/hParent:GetMaxHealth() >= 0.25 and self.hInjuredModifier  then
		self.hInjuredModifier:Destroy()
		self.hInjuredModifier = nil
	end
	
	tHeroes = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	if #tHeroes > 0 and not self.hAggressiveModifier then
		self.hAggressiveModifier = AddAnimationTranslate(hParent, "aggressive")
	elseif #tHeroes == 0 and self.hAggressiveModifier then
		self.hAggressiveModifier:Destroy()
		self.hAggressiveModifier = nil
	end
	
end

function modifier_ramza_samurai_run_animation_manager:OnDestroy()
	if IsClient() then return end
	RemoveAnimationTranslate(self:GetParent())
end