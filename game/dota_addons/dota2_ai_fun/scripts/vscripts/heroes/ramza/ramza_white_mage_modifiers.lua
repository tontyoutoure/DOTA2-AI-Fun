modifier_ramza_white_mage_reraise_buff = class({})
function modifier_ramza_white_mage_reraise_buff:IsPurgable() return false end
function modifier_ramza_white_mage_reraise_buff:GetTexture() return "omniknight_guardian_angel" end
function modifier_ramza_white_mage_reraise_buff:IsBuff() return true end

function modifier_ramza_white_mage_reraise_buff:GetEffectName() return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf" end
function modifier_ramza_white_mage_reraise_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ramza_white_mage_reraise_buff:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_REINCARNATION
	}
end

function modifier_ramza_white_mage_reraise_buff:OnCreated()
	if IsClient() then return end
	self.fReincarnateTime = self:GetAbility():GetSpecialValueFor("reincarnate_time")
end

function modifier_ramza_white_mage_reraise_buff:ReincarnateTime()
	self:GetParent().fReincarnateTime = self.fReincarnateTime
	return self.fReincarnateTime
end

modifier_ramza_white_mage_regenerate = class({})

function modifier_ramza_white_mage_regenerate:IsHidden() return true end
function modifier_ramza_white_mage_regenerate:RemoveOnDeath() return false end
function modifier_ramza_white_mage_regenerate:IsPurgable() return false end

function modifier_ramza_white_mage_regenerate:OnCreated()
	if IsClient() then return end
	self.fDuration = self:GetAbility():GetSpecialValueFor("duration")
	self.fRegen = self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_ramza_white_mage_regenerate:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_ramza_white_mage_regenerate:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	if keys.unit:PassivesDisabled() then return end
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, nil, "modifier_ramza_white_mage_white_magicks_regen", {Duration = self.fDuration, fRegen = self.fRegen})
end

modifier_ramza_white_mage_arcane_defense = class({})
function modifier_ramza_white_mage_arcane_defense:OnCreated() self.iResist = self:GetAbility():GetSpecialValueFor("magic_resist") end
function modifier_ramza_white_mage_arcane_defense:IsHidden() return true end
function modifier_ramza_white_mage_arcane_defense:RemoveOnDeath() return false end
function modifier_ramza_white_mage_arcane_defense:IsPurgable() return false end
function modifier_ramza_white_mage_arcane_defense:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_ramza_white_mage_arcane_defense:GetModifierMagicalResistanceBonus() 
	if self:GetParent():PassivesDisabled() then return 0
	else return self.iResist end
end


modifier_ramza_white_mage_white_magicks_regen = class({})

function modifier_ramza_white_mage_white_magicks_regen:IsPurgable() return true end
function modifier_ramza_white_mage_white_magicks_regen:IsBuff() return true end
function modifier_ramza_white_mage_white_magicks_regen:GetEffectName() return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf" end
function modifier_ramza_white_mage_white_magicks_regen:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ramza_white_mage_white_magicks_regen:GetTexture() return "huskar_inner_vitality" end

function modifier_ramza_white_mage_white_magicks_regen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_ramza_white_mage_white_magicks_regen:OnCreated(keys)
	if IsClient() then return end
	self.fRegen = keys.fRegen
end

function modifier_ramza_white_mage_white_magicks_regen:GetModifierConstantHealthRegen()
	return self.fRegen
end


modifier_ramza_white_mage_white_magicks_shell = class({})

function modifier_ramza_white_mage_white_magicks_shell:IsPurgable() return true end
function modifier_ramza_white_mage_white_magicks_shell:IsBuff() return true end
function modifier_ramza_white_mage_white_magicks_shell:GetTexture() return "arc_warden_magnetic_field" end
function modifier_ramza_white_mage_white_magicks_shell:GetEffectName() return "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_warp.vpcf" end
function modifier_ramza_white_mage_white_magicks_shell:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ramza_white_mage_white_magicks_shell:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.03)
	self:SetHasCustomTransmitterData(true)
	self.shield = self:GetAbility():GetSpecialValueFor("damga_absorb")
end
function modifier_ramza_white_mage_white_magicks_shell:AddCustomTransmitterData()
    return {
        shield = self.shield,
    }
end

function modifier_ramza_white_mage_white_magicks_shell:HandleCustomTransmitterData( data )
	-- print(self.shield)
    self.shield = data.shield
end

function modifier_ramza_white_mage_white_magicks_shell:OnIntervalThink()
    self:SendBuffRefreshToClients()
end

function modifier_ramza_white_mage_white_magicks_shell:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
end
function modifier_ramza_white_mage_white_magicks_shell:GetModifierIncomingDamageConstant(keys)
	if not IsServer() then 
		return self.shield 
	end
	
	if keys.damage < self.shield then
		self.shield = self.shield - keys.damage
		return -keys.damage
	else
		self:Destroy()
		return -self.shield
	end
end


modifier_ramza_white_mage_white_magicks_protect = class({})
function modifier_ramza_white_mage_white_magicks_protect:IsPurgable() return true end
function modifier_ramza_white_mage_white_magicks_protect:IsBuff() return true end
function modifier_ramza_white_mage_white_magicks_protect:GetTexture() return "omniknight_repel" end
function modifier_ramza_white_mage_white_magicks_protect:GetEffectName() return "particles/items2_fx/medallion_of_courage_friend_shield.vpcf" end
function modifier_ramza_white_mage_white_magicks_protect:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_ramza_white_mage_white_magicks_protect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_ramza_white_mage_white_magicks_protect:GetModifierPhysicalArmorBonus()
	return 25
end
