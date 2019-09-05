ANIMATIONS_VERSION = "1.00"

--[[
	Lua-controlled Animations Library by BMD

	Installation
	-"require" this file inside your code in order to gain access to the StartAnmiation and EndAnimation global.
	-Additionally, ensure that this file is placed in the vscripts/libraries path and that the vscripts/libraries/modifiers/modifier_animation.lua, modifier_animation_translate.lua, modifier_animation_translate.lua, and modifier_animation_freeze.lua files exist and are in the correct path

	Usage
	-Animations can be started for any unit and are provided as a table of information to the StartAnimation call
	-Repeated calls to StartAnimation for a single unit will cancel any running animation and begin the new animation
	-EndAnimation can be called in order to cancel a running animation
	-Animations are specified by a table which has as potential parameters:
		-duration: The duration to play the animation.	The animation will be cancelled regardless of how far along it is at the end fo the duration.
		-activity: An activity code which will be used as the base activity for the animation i.e. DOTA_ACT_RUN, DOTA_ACT_ATTACK, etc.
		-rate: An optional (will be 1.0 if unspecified) animation rate to be used when playing this animation.
		-translate: An optional translate activity modifier string which can be used to modify the animation sequence.
			Example: For ACT_DOTA_RUN+haste, this should be "haste"
		-translate2: A second optional translate activity modifier string which can be used to modify the animation sequence further.
			Example: For ACT_DOTA_ATTACK+sven_warcry+sven_shield, this should be "sven_warcry" or "sven_shield" while the translate property is the other translate modifier
	-A permanent activity translate can be applied to a unit by calling AddAnimationTranslate for that unit.	This allows for a permanent "injured" or "aggressive" animation stance.
	-Permanent activity translate modifiers can be removed with RemoveAnimationTranslate.
	-Animations can be frozen in place at any time by calling FreezeAnimation(unit[, duration]).	Leaving the duration off will cause the animation to be frozen until UnfreezeAnimation is called.
	-Animations can be unfrozen at any time by calling UnfreezeAnimation(unit)

	Notes
	-Animations can only play for valid activities/sequences possessed by the model the unit is using.
	-Sequences requiring 3+ activity modifier translates (i.e "stun+fear+loadout" or similar) are not possible currently in this library.
	-Calling EndAnimation and attempting to StartAnimation a new animation for the same unit withing ~2 server frames of the animation end will likely fail to play the new animation.	
		Calling StartAnimation directly without ending the previous animation will automatically add in this delay and cancel the previous animation.
	-The maximum animation rate which can be used is 12.75, and animation rates can only exist at a 0.05 resolution (i.e. 1.0, 1.05, 1.1 and not 1.06)
	-StartAnimation and EndAnimation functions can also be accessed through GameRules as GameRules.StartAnimation and GameRules.EndAnimation for use in scoped lua files (triggers, vscript ai, etc)
	-This library requires that the "libraries/timers.lua" be present in your vscripts directory.

	Examples:
	--Start a running animation at 2.5 rate for 2.5 seconds
		StartAnimation(unit, {duration=2.5, activity=ACT_DOTA_RUN, rate=2.5})

	--End a running animation
		EndAnimation(unit)

	--Start a running + hasted animation at .8 rate for 5 seconds
		StartAnimation(unit, {duration=5, activity=ACT_DOTA_RUN, rate=0.8, translate="haste"})

	--Start a shield-bash animation for sven with variable rate
		StartAnimation(unit, {duration=1.5, activity=ACT_DOTA_ATTACK, rate=RandomFloat(.5, 1.5), translate="sven_warcry", translate2="sven_shield"})

	--Start a permanent injured translate modifier
		AddAnimationTranslate(unit, "injured")

	--Remove a permanent activity translate modifier
		RemoveAnimationTranslate(unit)

	--Freeze an animation for 4 seconds
		FreezeAnimation(unit, 4)

	--Unfreeze an animation
		UnfreezeAnimation(unit)

]]

LinkLuaModifier( "modifier_animation", "libraries/animations.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_animation_translate", "libraries/animations.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_animation_freeze", "libraries/animations.lua", LUA_MODIFIER_MOTION_NONE )

require('libraries/timers')

local _ANIMATION_TRANSLATE_TO_CODE = {
	run_fast = 1,
	run = 2,
	odachi = 3,
	aggressive = 4,
	injured = 5,
	walk = 6,
	arcana = 7,
	red = 8,
	ti6 = 9,
	divine_sorrow_sunstrike = 10,
	wardstaff = 11,
	lightning = 12,
	juggle_gesture = 13,
	backstab = 14,
}

local _CODE_TO_ANIMATION_TRANSLATE = {	
	[1] = "run_fast",
	[2] = "run",
	[3] = "odachi",
	[4] = "aggressive",
	[5] = "injured",
	[6] = "walk",
	[7] = "arcana",
	[8] = "red",
	[9] = "ti6",
	[10] = "divine_sorrow_sunstrike",
	[11] = "wardstaff",
	[12] = "lightning",
	[13] = "juggle_gesture",
	[14] = "backstab"
}

function StartAnimation(unit, table)
	local duration = table.duration
	local activity = table.activity
	local translate = table.translate
	local translate2 = table.translate2
	local rate = table.rate or 1.0
	rate = math.floor(math.max(0,math.min(255/20, rate)) * 20 + .5)

	local stacks = activity + bit.lshift(rate,11)

	if translate ~= nil then
		if _ANIMATION_TRANSLATE_TO_CODE[translate] == nil then
			print("[ANIMATIONS.lua] ERROR, no translate-code found for '" .. translate .. "'.	This translate may be misspelled or need to be added to the enum manually.")
			return
		end
		stacks = stacks + bit.lshift(_ANIMATION_TRANSLATE_TO_CODE[translate],19)
	end

	if translate2 ~= nil and _ANIMATION_TRANSLATE_TO_CODE[translate2] == nil then
		print("[ANIMATIONS.lua] ERROR, no translate-code found for '" .. translate2 .. "'.	This translate may be misspelled or need to be added to the enum manually.")
		return
	end

	if unit:HasModifier("modifier_animation") or (unit._animationEnd ~= nil and unit._animationEnd + .067 > GameRules:GetGameTime()) then
		EndAnimation(unit)
		Timers:CreateTimer(.066, function() 
			if translate2 ~= nil then
				unit:AddNewModifier(unit, nil, "modifier_animation_translate", {duration=duration, translate=translate2})
				unit:SetModifierStackCount("modifier_animation_translate", unit, _ANIMATION_TRANSLATE_TO_CODE[translate2])
			end

			unit._animationEnd = GameRules:GetGameTime() + duration
			unit:AddNewModifier(unit, nil, "modifier_animation", {duration=duration, translate=translate})
			unit:SetModifierStackCount("modifier_animation", unit, stacks)
		end)
	else
		if translate2 ~= nil then
			unit:AddNewModifier(unit, nil, "modifier_animation_translate", {duration=duration, translate=translate2})
			unit:SetModifierStackCount("modifier_animation_translate", unit, _ANIMATION_TRANSLATE_TO_CODE[translate2])
		end
		unit._animationEnd = GameRules:GetGameTime() + duration
		unit:AddNewModifier(unit, nil, "modifier_animation", {duration=duration, translate=translate})
		unit:SetModifierStackCount("modifier_animation", unit, stacks)
	end
end

function FreezeAnimation(unit, duration)
	if duration then
		unit:AddNewModifier(unit, nil, "modifier_animation_freeze", {duration=duration})
	else
		unit:AddNewModifier(unit, nil, "modifier_animation_freeze", {})
	end
end

function UnfreezeAnimation(unit)
	unit:RemoveModifierByName("modifier_animation_freeze")
end

function EndAnimation(unit)
	unit._animationEnd = GameRules:GetGameTime()
	unit:RemoveModifierByName("modifier_animation")
	unit:RemoveModifierByName("modifier_animation_translate")
end

function AddAnimationTranslate(unit, translate, duration)
	if translate == nil or _ANIMATION_TRANSLATE_TO_CODE[translate] == nil then
		print("[ANIMATIONS.lua] ERROR, no translate-code found for '" .. translate .. "'.	This translate may be misspelled or need to be added to the enum manually.")
		return
	end
	local hModifier
	if duration then
		hModifier = unit:AddNewModifier(unit, nil, "modifier_animation_translate", {Duration=duration, translate=translate})
		hModifier.translate = translate
	else
		hModifier = unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate=translate})
		hModifier.translate = translate
	end
	hModifier:SetStackCount(_ANIMATION_TRANSLATE_TO_CODE[translate])
	return hModifier
end

function RemoveAnimationTranslate(unit)
	while unit:HasModifier("modifier_animation_translate") do
		unit:RemoveModifierByName("modifier_animation_translate")
	end
end

function RemoveOneAnimationTranslate(hUnit, sTranslate)
	local tAllModifiers = hUnit:FindAllModifiersByName("modifier_animation_translate")
	for k, v in pairs(tAllModifiers) do
		if v.translate == sTranslate then
			v:Destroy()
		end
	end
end

GameRules.StartAnimation = StartAnimation
GameRules.EndAnimation = EndAnimation
GameRules.AddAnimationTranslate = AddAnimationTranslate
GameRules.RemoveAnimationTranslate = RemoveAnimationTranslate

modifier_animation = class({})

function modifier_animation:OnCreated(keys) 
	self.keys = keys
	if not IsServer() then
		local stack = keys.stack_count
		local activity = bit.band(stack, 0x07FF)
		local rate = bit.rshift(bit.band(stack, 0x7F800), 11)
		local rest = bit.rshift(bit.band(stack, 0xFFF80000), 19)
		self.activity = activity
		self.rate = rate / 20 
		self.rest = rest
		--print(self.activity)
		--print(self.rate)
		--print(self.rest)

		self.translate = _CODE_TO_ANIMATION_TRANSLATE[self.rest]
	else
		self.translate = keys.translate
	end
end

function modifier_animation:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE --+ MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_animation:IsHidden()
	return true
end

function modifier_animation:IsDebuff() 
	return false
end

function modifier_animation:IsPurgable() 
	return false
end

function modifier_animation:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
 
	return funcs
end
function modifier_animation:RemoveOnDeath() return false end
function modifier_animation:GetOverrideAnimation(...)
	return self.activity
end

function modifier_animation:GetOverrideAnimationRate(...)
	return self.rate
end

function modifier_animation:GetOverrideAnimationWeight(...)
	return 1
end

function modifier_animation:GetActivityTranslationModifiers(...)
	--print('MA: ', self.translate, IsServer())
	return self.translate or 0
end

modifier_animation_freeze = class({})

function modifier_animation_freeze:OnCreated(keys) 

end

function modifier_animation_freeze:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE --+ MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_animation_freeze:IsHidden()
	return true
end

function modifier_animation_freeze:IsDebuff() 
	return false
end
function modifier_animation_freeze:RemoveOnDeath() return false end

function modifier_animation_freeze:IsPurgable() 
	return false
end

function modifier_animation_freeze:CheckState() 
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

modifier_animation_translate = class({})

function modifier_animation_translate:OnCreated(keys) 
	if not IsServer() then
		self.translate = _CODE_TO_ANIMATION_TRANSLATE[keys.stack_count]
	else
		self.translate = keys.translate
	end
end

function modifier_animation_translate:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_animation_translate:IsHidden()
	return true
end

function modifier_animation_translate:IsDebuff() 
	return false
end

function modifier_animation_translate:IsPurgable() 
	return false
end
function modifier_animation_translate:RemoveOnDeath() return false end

function modifier_animation_translate:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
 
	return funcs
end

function modifier_animation_translate:GetActivityTranslationModifiers(...)
	return self.translate or 0
end