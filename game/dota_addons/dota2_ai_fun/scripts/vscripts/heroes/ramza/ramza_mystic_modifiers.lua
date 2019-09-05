modifier_ramza_mystic_mystic_arts_disbelief = class({})

function modifier_ramza_mystic_mystic_arts_disbelief:IsPurgable() return false end

function modifier_ramza_mystic_mystic_arts_disbelief:GetStatusEffectName() return "particles/status_fx/status_effect_avatar.vpcf" end

function modifier_ramza_mystic_mystic_arts_disbelief:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end

function modifier_ramza_mystic_mystic_arts_disbelief:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ramza_mystic_mystic_arts_disbelief:GetTexture() return "elder_titan_natural_order" end

function modifier_ramza_mystic_mystic_arts_disbelief:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_ramza_mystic_mystic_arts_disbelief:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.fMana = hParent:GetMana()
	hParent:SetMana(0)
	self:StartIntervalThink(0.1)
end

function modifier_ramza_mystic_mystic_arts_disbelief:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.fMana = self.fMana+hParent:GetMana()
	hParent:SetMana(0)	
end


function modifier_ramza_mystic_mystic_arts_disbelief:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:SetMana(self.fMana)
end

modifier_ramza_mystic_defense_boost = class({})

function modifier_ramza_mystic_defense_boost:IsHidden() return true end
function modifier_ramza_mystic_defense_boost:RemoveOnDeath() return false end
function modifier_ramza_mystic_defense_boost:IsPurgable() return false end

function modifier_ramza_mystic_defense_boost:OnCreated()
	if IsClient() then return end	
	self.iBonusArmor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.fDuration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_ramza_mystic_defense_boost:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_ramza_mystic_defense_boost:OnAttacked(keys)
	if keys.target ~= self:GetParent() then return end
	if keys.target:PassivesDisabled() then return end
	keys.target:AddNewModifier(keys.target, nil, "modifier_ramza_mystic_defense_boost_armor", {Duration = self.fDuration}):SetStackCount(self.iBonusArmor)
end

modifier_ramza_mystic_defense_boost_armor = class({})

function modifier_ramza_mystic_defense_boost_armor:IsPurgable() return true end

function modifier_ramza_mystic_defense_boost_armor:GetTexture() return "ramza_mystic_defense_boost" end

function modifier_ramza_mystic_defense_boost_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end

function modifier_ramza_mystic_defense_boost_armor:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end

function modifier_ramza_mystic_defense_boost_armor:OnCreated()
	if IsClient() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_crimson_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, self:GetParent(), PATTACH_POINT, "follow_origin", self:GetParent():GetAbsOrigin(), true)
end

function modifier_ramza_mystic_defense_boost_armor:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)

end

modifier_ramza_mystic_manafont = class({})

function modifier_ramza_mystic_manafont:IsHidden() return true end
function modifier_ramza_mystic_manafont:RemoveOnDeath() return false end
function modifier_ramza_mystic_manafont:IsPurgable() return false end

function modifier_ramza_mystic_manafont:OnCreated()
	if IsClient() then return end
	self.iPercentageDistanceMP = self:GetAbility():GetSpecialValueFor("percentage_distance_mp")
	self.vPreviousPosition = self:GetParent():GetOrigin()
	self:StartIntervalThink(0.25)
end

function modifier_ramza_mystic_manafont:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local fDistance = self.vPreviousPosition.Length(hParent:GetOrigin() - self.vPreviousPosition)
	if not hParent:PassivesDisabled() then
		hParent:GiveMana(fDistance*self.iPercentageDistanceMP/100)
	end

	self.vPreviousPosition = hParent:GetOrigin()
end

modifier_ramza_mystic_absorb_mp = class({})

function modifier_ramza_mystic_absorb_mp:IsHidden() return true end
function modifier_ramza_mystic_absorb_mp:RemoveOnDeath() return false end
function modifier_ramza_mystic_absorb_mp:IsPurgable() return false end
function modifier_ramza_mystic_absorb_mp:DeclareFunctions() return {MODIFIER_PROPERTY_ABSORB_SPELL} end

function modifier_ramza_mystic_absorb_mp:GetAbsorbSpell(keys)
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then return end
	local fMana = keys.ability:GetManaCost(keys.ability:GetLevel()-1)
	hParent:GiveMana(fMana)
	ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	hParent:EmitSound("Hero_ObsidianDestroyer.EssenceAura")	
	local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_add.vpcf", PATTACH_POINT_FOLLOW, hParent)
	ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fMana), 0))
	ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fMana)), 500))
	ParticleManager:SetParticleControl(iParticle2, 3, Vector(20, 20, 100))	
	return false
end