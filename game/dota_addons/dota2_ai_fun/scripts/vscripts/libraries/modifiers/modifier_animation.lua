modifier_animation = class({})

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
}

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

function modifier_animation_translate:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
 
	return funcs
end

function modifier_animation_translate:GetActivityTranslationModifiers(...)
	return self.translate or 0
end