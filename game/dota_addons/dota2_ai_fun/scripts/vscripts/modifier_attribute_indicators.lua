LinkLuaModifier("modifier_attribute_growth_agi_global", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)

local tClassModifierAttributeIndicator = {
	RemoveOnDeath = function(self)  return false end,
	IsPurgable = function(self)  return false end,
	IsHidden = function(self)  return false end,
	IsDebuff = function(self)  return false end,
	GetTexture = function(self)  return "attribute_indicator" end,
}

local tClassAttributeGrowthSingle = {
	DeclareFunctions = function(self) return {MODIFIER_PROPERTY_TOOLTIP} end,
	OnTooltip = function(self) return self:GetStackCount()/100 end,
	RemoveOnDeath = function(self) return false end,
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return false end,
	IsDebuff = function(self) return false end,
}

modifier_attribute_growth_agi_global = class(tClassAttributeGrowthSingle)
function modifier_attribute_growth_agi_global:GetTexture() return "modifier_attribute_growth_agi" end

LinkLuaModifier("modifier_attribute_growth_int_global", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_growth_int_global = class(tClassAttributeGrowthSingle)
function modifier_attribute_growth_int_global:GetTexture() return "modifier_attribute_growth_int" end

LinkLuaModifier("modifier_attribute_growth_str_global", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_growth_str_global = class(tClassAttributeGrowthSingle)
function modifier_attribute_growth_str_global:GetTexture() return "modifier_attribute_growth_str" end

LinkLuaModifier("modifier_attribute_indicator_astral_trekker", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_astral_trekker = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_void_demon", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_void_demon = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_bastion", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_bastion = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_fluid_engineer", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_fluid_engineer = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_formless", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_formless = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_initimidator", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_initimidator = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_magic_dragon", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_magic_dragon = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_mana_fiend", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_mana_fiend = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_persuasive", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_persuasive = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_telekenetic_blob", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_telekenetic_blob = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_terran_marine", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_terran_marine = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_cleric", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_cleric = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_pet_summoner", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_pet_summoner = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_felguard", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_felguard = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_el_dorado", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_el_dorado = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_hurricane", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_hurricane = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_capslockftw", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_capslockftw = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_templar", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_templar = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_spongebob", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_spongebob = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_hamsterlord", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_hamsterlord = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_exsoldier", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_exsoldier = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_gambler", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_gambler = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_old_lifestealer", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_old_lifestealer = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_rider", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_rider = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_siglos", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_siglos = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_flame_lord", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_flame_lord = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_conjurer", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_conjurer = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_avatar_of_vengeance", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_avatar_of_vengeance = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_old_silencer", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_old_silencer = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_old_stealth_assassin", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_old_stealth_assassin = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_old_holy_knight", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_old_holy_knight = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_invoker_retro", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_invoker_retro = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_old_butcher", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_old_butcher = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_kahmeka", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_kahmeka = class(tClassModifierAttributeIndicator)

LinkLuaModifier("modifier_attribute_indicator_old_storm_spirit", "modifier_attribute_indicators.lua", LUA_MODIFIER_MOTION_NONE)
modifier_attribute_indicator_old_storm_spirit = class(tClassModifierAttributeIndicator)


