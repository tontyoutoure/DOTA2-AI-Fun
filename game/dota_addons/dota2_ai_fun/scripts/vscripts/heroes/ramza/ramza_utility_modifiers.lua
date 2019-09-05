RAMZA_ATTACK_HERO_JOB_POINT = 5
RAMZA_ATTACK_BUILDING_JOB_POINT = 5
RAMZA_ATTACK_ANCIENT_JOB_POINT = 5
RAMZA_ATTACK_CREEP_JOB_POINT = 1
RAMZA_USE_ABILITY_JOB_POINT = 5
RAMZA_KILL_BUILDING_JOB_POINT = 50
RAMZA_KILL_HERO_PER_LEVEL_JOB_POINT = 50
RAMZA_KILL_ANCIENT_JOB_POINT = 50
RAMZA_KILL_CREEP_JOB_POINT = 10


RAMZA_QUOTE_INTERVAL = 10
RAMZA_QUOTE_DURATION = 3

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
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_DEATH
	}
end

local tAttackSound = {
	[1] = "Hero_DragonKnight.Attack",
	[2] = "Hero_Sniper.attack",
	[3] = "Hero_DragonKnight.Attack",
	[4] = "Hero_Clinkz.Attack",
	[5] = "Hero_KeeperOfTheLight.Attack",
	[6] = "Hero_Invoker.Attack",
	[7] = "hero_bloodseeker.attack",
	[8] = "Hero_Riki.Attack",
	[9] = "Hero_Oracle.Attack",
	[10] = "Hero_Silencer.Attack",
	[11] = "Hero_ShadowShaman.Attack",
	[12] = "Hero_KeeperOfTheLight.Attack",
	[13] = "Hero_Warlock.Attack",
	[14] = "Hero_PhantomLancer.Attack",
	[15] = "Hero_Juggernaut.Attack",
	[16] = "Hero_BountyHunter.Attack",
	[17] = "Hero_Rubick.Attack",
	[18] = "Hero_Bane.Attack",
	[19] = "Hero_Abaddon.Attack",
	[20] = "Hero_Kunkka.Attack"		
}

function modifier_ramza_job_manager:OnDeath(keys)
	if keys.unit ~= self:GetParent() or keys.unit:IsIllusion() then return end	
	CustomGameEventManager:Send_ServerToPlayer( keys.unit:GetOwner(), "ramza_close_selection", nil )
end

function modifier_ramza_job_manager:GetAttackSound()
	return ""
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
	if hParent:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		hParent:EmitSound(tAttackSound[self:GetStackCount()])
	end
end

function modifier_ramza_job_manager:OnAttack(keys)
	if keys.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	if hParent:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		hParent:EmitSound(tAttackSound[self:GetStackCount()])
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
	if keys.damage > keys.target:GetHealth() and keys.target:IsAlive() then 
		if keys.target:IsHero() then 
			if keys.target:IsRealHero() then
				hParent.hRamzaJob:GainJobPoint(RAMZA_KILL_HERO_PER_LEVEL_JOB_POINT*keys.target:GetLevel())
			else 
				hParent.hRamzaJob:GainJobPoint(RAMZA_KILL_CREEP_JOB_POINT*keys.target:GetLevel())
			end
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
	local tRamzaAttackRange = {
		[1] = 150,
		[2] = 600,
		[3] = 150,
		[4] = 625,
		[5] = 550,
		[6] = 500,
		[7] = 150,
		[8] = 150,
		[9] = 575,
		[10] = 500,
		[11] = 400,
		[12] = 600,
		[13] = 500,
		[14] = 150,
		[15] = 150,
		[16] = 150,
		[17] = 700,
		[18] = 600,
		[19] = 150,
		[20] = 150		
	}
	return tRamzaAttackRange[self:GetStackCount()]-150
end


modifier_ramza_job_level = class({})
	

function modifier_ramza_job_level:IsPurgable() return false end
function modifier_ramza_job_level:RemoveOnDeath() return false end	
function modifier_ramza_job_level:GetTexture() return "ramza_job_info" end

function modifier_ramza_job_level:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end

local tJobRequirements = {
	200, 400, 700, 1100, 1600, 2200, 3000, 4000
}
function modifier_ramza_job_level:OnTooltip()
	return tJobRequirements[self:GetStackCount()]
end

modifier_ramza_job_mastered = class({})

function modifier_ramza_job_mastered:IsPurgable() return false end
function modifier_ramza_job_mastered:RemoveOnDeath() return false end	
function modifier_ramza_job_mastered:GetTexture() return "ramza_job_info_mastered" end


modifier_ramza_job_point = class({})


function modifier_ramza_job_point:IsPurgable() return false end
function modifier_ramza_job_point:RemoveOnDeath() return false end	
function modifier_ramza_job_point:GetTexture() return "ramza_job_info" end
function modifier_ramza_job_point:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end

function modifier_ramza_job_point:OnTooltip()
	return self:GetStackCount()
end


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
	hParent:SetMaterialGroup("1")
	if hParent:GetIdealSpeed() >= 380 and self.hSpeedModifier.translate == "run" and hParent:IsAlive() then
		self.hSpeedModifier:Destroy()
		self.hSpeedModifier = AddAnimationTranslate(hParent, "run_fast")
		self.fSpeedStartTime = Time()
	elseif hParent:GetIdealSpeed() < 380 and self.hSpeedModifier.translate == "run_fast" and Time() - self.fSpeedStartTime > 5 and hParent:IsAlive() then		
		self.hSpeedModifier:Destroy()		
		self.hSpeedModifier = AddAnimationTranslate(hParent, "run")
	end
	
	if hParent:GetHealth()/hParent:GetMaxHealth() < 0.25 and not self.hInjuredModifier and hParent:IsAlive() then
		self.hInjuredModifier = AddAnimationTranslate(hParent, "injured")
	elseif hParent:GetHealth()/hParent:GetMaxHealth() >= 0.25 and self.hInjuredModifier and hParent:IsAlive()  then
		self.hInjuredModifier:Destroy()
		self.hInjuredModifier = nil
	end
	
	tHeroes = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	if #tHeroes > 0 and not self.hAggressiveModifier and hParent:IsAlive() then
		self.hAggressiveModifier = AddAnimationTranslate(hParent, "aggressive")
	elseif #tHeroes == 0 and self.hAggressiveModifier and hParent:IsAlive() then
		self.hAggressiveModifier:Destroy()
		self.hAggressiveModifier = nil
	end
	
end

function modifier_ramza_samurai_run_animation_manager:OnDestroy()
	if IsClient() then return end
	RemoveAnimationTranslate(self:GetParent())
end

modifier_ramza_white_mage_animation_manager = class({})

function modifier_ramza_white_mage_animation_manager:IsPurgable() return false end
function modifier_ramza_white_mage_animation_manager:RemoveOnDeath() return false end	
function modifier_ramza_white_mage_animation_manager:IsHidden() return true end

function modifier_ramza_white_mage_animation_manager:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	AddAnimationTranslate(hParent, "ti6")
	AddAnimationTranslate(hParent, "divine_sorrow_sunstrike")
end

function modifier_ramza_white_mage_animation_manager:OnDestroy()
	if IsClient() then return end
	RemoveAnimationTranslate(self:GetParent())
end

local tAbilityStyles = 
{
	ramza_squire_fundamental_ultima = {color = "#00FF00", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_white_mage_white_magicks_cura = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_white_mage_white_magicks_wall = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_white_mage_white_magicks_curaga = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_white_mage_reraise = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_white_mage_white_magicks_holy = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_black_mage_black_magicks_firaga = {color = "red", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_black_mage_black_magicks_blizzaga = {color = "#00bfff", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_black_mage_black_magicks_thundaga = {color = "#e0ffff", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_black_mage_death = {color = "black", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_black_mage_black_magicks_flare = {color = "red", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_monk_martial_arts_shockwave = {color = "gold", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_monk_martial_arts_doom_fist = {color = "orange", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_mystic_mystic_arts_disbelief = {color = "#101263", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_mystic_mystic_arts_hesitation = {color = "#94baab", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_mystic_mystic_arts_quiescence = {color = "#9d28a8", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_mystic_mystic_arts_invigoration = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_time_mage_time_magicks_gravity = {color = "#060e38", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_time_mage_time_magicks_quick = {color = "#f7da00", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_time_mage_time_magicks_stop = {color = "#0031f7", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_time_mage_time_magicks_meteor = {color = "red", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_summon_shiva = {color = "#00bfff", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_summon_ifrit = {color = "red", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_summon_ramuh = {color = "#e0ffff", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_lich = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_summon_golem = {color = "#784800", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_odin = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_summon_bahamut = {color = "red", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_summoner_summon_zodiark = {color = "#9659ff", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_samurai_iaido_ashura = {color = "gold", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_samurai_iaido_osafune = {color = "#070ac1", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_samurai_iaido_murasame = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_samurai_iaido_kikuichimonji = {color = "#ffb7c5", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_samurai_iaido_masamune = {color = "#fff790", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_samurai_iaido_chirijiraden = {color = "#00bfff", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_dark_knight_darkness_sanguine_sword = {color = "#8A0707", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_dark_knight_darkness_crushing_blow = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_dark_knight_darkness_abyssal_blade = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_dark_knight_darkness_unholy_sacrifice = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},
	ramza_dark_knight_darkness_shadowblade = {color = "#5400C3", ["text-shadow"] = "2px 2px 2px 1.0 #333333b0", ["margin-top"] = "0px"},	
}

modifier_ramza_quote_manager = class({})

function modifier_ramza_quote_manager:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end


function modifier_ramza_quote_manager:IsPurgable() return false end
function modifier_ramza_quote_manager:RemoveOnDeath() return false end	
function modifier_ramza_quote_manager:IsHidden() return true end

function modifier_ramza_quote_manager:OnAbilityExecuted(keys)
	if keys.unit ~= self:GetParent() then return end
	local sName = keys.ability:GetName()
	if tAbilityStyles[sName] then
		self.tAbilityExecutedTime = self.tAbilityExecutedTime or {}
		if not (self.tAbilityExecutedTime[sName] and Time() - self.tAbilityExecutedTime[sName] < RAMZA_QUOTE_INTERVAL) then 
			self.tAbilityExecutedTime[sName] = Time()
			Notifications:BottomToAll({text="#" .. sName .. "_quote", duration=RAMZA_QUOTE_DURATION, style= tAbilityStyles[sName]})
		end
	end

end

modifier_ramza_bravery = class({})
function modifier_ramza_bravery:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

function modifier_ramza_bravery:IsPurgable() return false end
function modifier_ramza_bravery:RemoveOnDeath() return false end	
function modifier_ramza_bravery:IsHidden() return true end
function modifier_ramza_bravery:OnCreated() 
	if not self:GetAbility() then return end
	self.iBonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.iBonusStr = self:GetAbility():GetSpecialValueFor("bonus_strength")
	if IsClient() then return end
	self:GetParent():CalculateStatBonus()
end
function modifier_ramza_bravery:OnRefresh() 
	if not self:GetAbility() then return end
	self.iBonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.iBonusStr = self:GetAbility():GetSpecialValueFor("bonus_strength")
	if IsClient() then return end
	self:GetParent():CalculateStatBonus()
end

function modifier_ramza_bravery:GetModifierPreAttack_BonusDamage()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iBonusDamage or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iBonusDamage or 0)
	end
end

function modifier_ramza_bravery:GetModifierBonusStats_Strength()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iBonusStr or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iBonusStr or 0)
	end
end

modifier_ramza_speed = class({})
function modifier_ramza_speed:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
end

function modifier_ramza_speed:IsPurgable() return false end
function modifier_ramza_speed:RemoveOnDeath() return false end	
function modifier_ramza_speed:IsHidden() return true end

function modifier_ramza_speed:OnRefresh()
	if not self:GetAbility() then return end
	self.iMove = self:GetAbility():GetSpecialValueFor("bonus_move")
	self.iAttack = self:GetAbility():GetSpecialValueFor("bonus_attack")
	self.iAgi = self:GetAbility():GetSpecialValueFor("bonus_agility")
	if IsClient() then return end
	self:GetParent():CalculateStatBonus()
end

function modifier_ramza_speed:GetModifierBonusStats_Agility()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iAgi or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iAgi or 0)
	end
end

function modifier_ramza_speed:GetModifierMoveSpeedBonus_Percentage()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iMove or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iMove or 0)
	end
end

function modifier_ramza_speed:GetModifierAttackSpeedBonus_Constant()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iAttack or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iAttack or 0)
	end
end

modifier_ramza_faith = class({})
function modifier_ramza_faith:DeclareFunctions()
	return {MODIFIER_PROPERTY_MANA_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_ramza_faith:IsPurgable() return false end
function modifier_ramza_faith:RemoveOnDeath() return false end	
function modifier_ramza_faith:IsHidden() return true end

function modifier_ramza_faith:OnRefresh()
	if not self:GetAbility() then return end
	self.iMana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.iInt = self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	if IsClient() then return end
	self:GetParent():CalculateStatBonus()
end

function modifier_ramza_faith:GetModifierManaBonus()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iMana or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iMana or 0)
	end
end

function modifier_ramza_faith:GetModifierBonusStats_Intellect()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_ramza_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if not self.hSpecial:IsNull() then
		return (self.iInt or 0)*(1+self.hSpecial:GetSpecialValueFor("value"))
	else
		return (self.iInt or 0)
	end
end