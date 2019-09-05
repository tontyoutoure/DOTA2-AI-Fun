modifier_mana_fiend_color = class({
	IsHidden = function (self) return true end,
	IsPurgable = function (self) return false end,
	RemoveOnDeath = function (self) return false end,
	GetStatusEffectName = function (self) return "particles/status_effect_mana_fiend.vpcf" end
})

modifier_mana_fiend_osmose = class({
	IsHidden = function (self) return true end,
	IsPurgable = function (self) return false end,
	RemoveOnDeath = function (self) return false end,})
	
function modifier_mana_fiend_osmose:OnCreated()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsClient() or hAbility:GetLevel() == 0 or self:GetParent():HasModifier('modifier_mana_fiend_osmose_image') then return end
	self.hImage = CreateUnitByName(hParent:GetUnitName(), hParent:GetOrigin(), true, hParent, hParent, hParent:GetTeamNumber())
	self.hImage:AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_mana_fiend_osmose_image', nil)
	self.hImage:SetPlayerID(hParent:GetPlayerID())	
	self.hImage:AddEffects(EF_NODRAW)
	if hParent:IsIllusion() then
		self.hImage:MakeIllusion()
	end
end



function modifier_mana_fiend_osmose:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_DEATH, MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ABILITY_START}
end

function modifier_mana_fiend_osmose:OnAttack(keys)
	if IsClient() then return end
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or not keys.attacker:HasScepter() or keys.target:IsBuilding() or keys.attacker:GetTeam() == keys.target:GetTeam() or keys.attacker:HasModifier('modifier_mana_fiend_osmose_image') then return end
	self.hImage:PerformAttack(keys.target, true, true, true, false, true, false, false)
	for i = 0, 8 do
		self.hImage:RemoveItem(self.hImage:GetItemInSlot(i))
	end
end

function modifier_mana_fiend_osmose:OnAttackStart(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or not keys.attacker:HasScepter() or keys.target:IsBuilding() or keys.attacker:GetTeam() == keys.target:GetTeam() or keys.attacker:HasModifier('modifier_mana_fiend_osmose_image') then return end
	FindClearSpaceForUnit(self.hImage, keys.attacker:GetOrigin(), true)
	self.hImage:SetForwardVector(Vector2D(keys.target:GetOrigin()-keys.attacker:GetOrigin()):Normalized())
	self.hImage:FindAbilityByName('mana_fiend_osmose'):SetLevel(self:GetAbility():GetLevel())
	self.hImage:FindAbilityByName('special_bonus_unique_mana_fiend_4'):SetLevel(keys.attacker:FindAbilityByName('special_bonus_unique_mana_fiend_4'):GetLevel())
	self.hImage:RemoveEffects(EF_NODRAW)
	for i = 0, 8 do
		self.hImage:RemoveItem(self.hImage:GetItemInSlot(i))
		if keys.attacker:GetItemInSlot(i) then
			self.hImage:AddItemByName(keys.attacker:GetItemInSlot(i):GetName())
		end
	end
	
	local fTime = keys.attacker:GetAttackAnimationPoint()/keys.attacker:GetAttackSpeed()+0.1
	StartAnimation(self.hImage, {duration=fTime, activity=ACT_DOTA_ATTACK, rate=keys.attacker:GetAttackSpeed()})
	Timers:CreateTimer(fTime, function () self.hImage:AddEffects(EF_NODRAW) end)
end


function modifier_mana_fiend_osmose:OnDeath(keys)
	if keys.unit == self:GetParent() and keys.unit:IsIllusion() then
		self.hImage:AddEffects(EF_NODRAW)
		UTIL_Remove(self.hImage)
	for i = 0, 8 do
		self.hImage:RemoveItem(self.hImage:GetItemInSlot(i))
	end
	end
end

function modifier_mana_fiend_osmose:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or keys.target:IsBuilding() or keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	
	local hAbility = self:GetAbility()
	if(keys.target:GetMaxMana() > 0) then
		local manaDrained = hAbility:GetSpecialValueFor("mana_drained")+CheckTalent(keys.attacker,'special_bonus_unique_mana_fiend_4')
		if keys.target:GetMana() < manaDrained then
			manaDrained = keys.target:GetMana()
		end	
		keys.attacker:GiveMana(manaDrained)
		keys.target:ReduceMana(manaDrained)
		ParticleManager:CreateParticle('particles/units/heroes/hero_antimage/antimage_blade_hit.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.target)
		keys.target:EmitSound("Hero_Antimage.ManaBreak")
	end
end

function modifier_mana_fiend_osmose:OnAbilityStart(keys)
	if keys.unit ~= self:GetParent() or not keys.unit:HasScepter() or keys.unit:PassivesDisabled() or keys.unit:HasModifier('modifier_mana_fiend_osmose_image') or (keys.ability:GetName() ~= 'mana_field_mana_rift' and keys.ability:GetName() ~= 'mana_fiend_equilibrium') then return end
	
	
	FindClearSpaceForUnit(self.hImage, keys.unit:GetOrigin(), true)
	self.hImage:SetForwardVector(Vector2D(keys.target:GetOrigin()-keys.unit:GetOrigin()):Normalized())
	self.hImage:RemoveEffects(EF_NODRAW)
	if keys.ability:GetName() ~= 'mana_field_mana_rift' then
		StartAnimation(self.hImage, {duration=keys.ability:GetCastPoint()+0.1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
	else
		StartAnimation(self.hImage, {duration=keys.ability:GetCastPoint()+0.1, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
	end
	Timers:CreateTimer(keys.ability:GetCastPoint()+0.1, function () self.hImage:AddEffects(EF_NODRAW) end)
end


modifier_mana_fiend_osmose_image = class({})
function modifier_mana_fiend_osmose_image:CheckState()
	return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_UNSELECTABLE] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] =
 true, [MODIFIER_STATE_FLYING] = true,[MODIFIER_STATE_NO_UNIT_COLLISION]=true}
end
function modifier_mana_fiend_osmose_image:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE } end
function modifier_mana_fiend_osmose_image:GetModifierPreAttack_BonusDamage()
	return -99999999
end

function modifier_mana_fiend_osmose_image:GetStatusEffectName() return 'particles/status_fx/status_effect_vengeful_venge_image.vpcf' end

modifier_mana_fiend_abandon = class({})
function modifier_mana_fiend_abandon:IsPurgable() return false end
function modifier_mana_fiend_abandon:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_mana_fiend_abandon:OnCreated(keys) if IsClient() then return end self:SetStackCount(-keys.attack_speed_bonus) end
function modifier_mana_fiend_abandon:OnRefresh(keys) if IsClient() then return end self:SetStackCount(-keys.attack_speed_bonus) end
function modifier_mana_fiend_abandon:GetModifierAttackSpeedBonus_Constant() return -self:GetStackCount() end
