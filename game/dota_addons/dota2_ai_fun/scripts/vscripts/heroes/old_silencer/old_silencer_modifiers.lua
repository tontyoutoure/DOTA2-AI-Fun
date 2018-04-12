modifier_old_silencer_infernal_permanent_immolation_aura = class({})
function modifier_old_silencer_infernal_permanent_immolation_aura:IsPurgable() return false end
function modifier_old_silencer_infernal_permanent_immolation_aura:IsAura() return true end
function modifier_old_silencer_infernal_permanent_immolation_aura:IsHidden() return true end
function modifier_old_silencer_infernal_permanent_immolation_aura:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_old_silencer_infernal_permanent_immolation_aura:GetModifierAura() return "modifier_old_silencer_infernal_permanent_immolation" end
function modifier_old_silencer_infernal_permanent_immolation_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_old_silencer_infernal_permanent_immolation_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_old_silencer_infernal_permanent_immolation_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_old_silencer_infernal_permanent_immolation_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_old_silencer_infernal_permanent_immolation_aura:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	ParticleManager:SetParticleControl(self.iParticle, 2, Vector(150, 0, 0))
	ParticleManager:SetParticleControl(self.iParticle, 3, Vector(150, 0, 0))
end


function modifier_old_silencer_infernal_permanent_immolation_aura:OnDeath(keys)
	if keys.unit == self:GetParent() then
		self:Destroy()
	end
end
function modifier_old_silencer_infernal_permanent_immolation_aura:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	ParticleManager:DestroyParticle(self.iParticle, false)
	Timers:CreateTimer(2.5, function () hParent:AddEffects(EF_NODRAW) end)
end



modifier_old_silencer_infernal_permanent_immolation = class({})
function modifier_old_silencer_infernal_permanent_immolation:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_old_silencer_infernal_permanent_immolation:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_old_silencer_infernal_permanent_immolation:OnTooltip() return self:GetAbility():GetSpecialValueFor("damage") end
function modifier_old_silencer_infernal_permanent_immolation:OnCreated()
	if IsClient() then return end
	self.iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", Vector(0,0,0), true)
	self:StartIntervalThink(0.1)
end
function modifier_old_silencer_infernal_permanent_immolation:OnDestroy()	
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)
end
function modifier_old_silencer_infernal_permanent_immolation:OnIntervalThink()
	if IsClient() then return end
	if self:GetCaster():PassivesDisabled() then return end
	local hAbility = self:GetAbility()
	ApplyDamage({damage_type = hAbility:GetAbilityDamageType(), damage = hAbility:GetSpecialValueFor("damage")/10, ability= hAbility, attacker = self:GetCaster(), victim = self:GetParent()})
end



modifier_old_silencer_silencer = class({})
function modifier_old_silencer_silencer:OnCreated() self:StartIntervalThink(FrameTime()) end
function modifier_old_silencer_silencer:OnIntervalThink() 
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:HasScepter() and not hParent:HasAbility("old_silencer_silencer_upgraded") then
		local iLevel = hParent:FindAbilityByName("old_silencer_silencer"):GetLevel()
		hParent:RemoveAbility("old_silencer_silencer")
		hParent:AddAbility("old_silencer_silencer_upgraded"):SetLevel(iLevel)
	end
	if not hParent:HasScepter() and hParent:HasAbility("old_silencer_silencer_upgraded") then
		local iLevel = hParent:FindAbilityByName("old_silencer_silencer_upgraded"):GetLevel()
		hParent:RemoveAbility("old_silencer_silencer_upgraded")
		hParent:AddAbility("old_silencer_silencer"):SetLevel(iLevel)
	end
end
function modifier_old_silencer_silencer:IsHidden() return true end
function modifier_old_silencer_silencer:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ATTACK_FINISHED, MODIFIER_EVENT_ON_ATTACK_RECORD} end

function modifier_old_silencer_silencer:OnAttack(keys)
	if keys.attacker ~= self:GetParent() then return end
	if keys.attacker:PassivesDisabled() or self:GetAbility():GetLevel() == 0 then return end
	if self.bLocked then return end
	self.bLocked = true
	if keys.attacker:HasScepter() then
		local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.attacker:GetOrigin(), nil, keys.attacker:GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, true)
		for i = 1, #tTargets do
			if tTargets[i] == keys.target then
				table.remove(tTargets, i)
			end
		end
		for i = 1, self:GetAbility():GetSpecialValueFor("extra_target_scepter") do
			if #tTargets > 0 then
				local iTargetToGo = RandomInt(1, #tTargets)
				keys.attacker:PerformAttack(tTargets[iTargetToGo], true, true, true, false, true, false, false)
				table.remove(tTargets, iTargetToGo)
			end
		end
	end
	self.bLocked = false
end

function modifier_old_silencer_silencer:OnAttackLanded(keys) 
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or (not keys.attacker:HasScepter() and keys.target:IsMagicImmune()) or self:GetAbility():GetLevel() == 0 or keys.attacker:GetTeam() == keys.target:GetTeam() or keys.target:IsBuilding() then return end
	keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_old_silencer_silencer_silence", {Duration = self:GetAbility():GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})
	if CheckTalent(keys.attacker, "special_bonus_unique_old_silencer_4") > 0 then
		keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_old_silencer_silencer_mute", {Duration = self:GetAbility():GetSpecialValueFor("duration")*CalculateStatusResist(keys.target)})		
	end
	keys.target:EmitSound("Hero_Silencer.LastWord.Damage")

end
modifier_old_silencer_silencer_silence = class({})
function modifier_old_silencer_silencer_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_old_silencer_silencer_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_old_silencer_silencer_silence:GetEffectName() return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_ti6_silence.vpcf" end

modifier_old_silencer_silencer_mute = class({})
function modifier_old_silencer_silencer_mute:CheckState() return {[MODIFIER_STATE_MUTED] = true} end
function modifier_old_silencer_silencer_mute:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_old_silencer_silencer_mute:GetEffectName() return "particles/items4_fx/nullifier_mute.vpcf" end


modifier_remove_silencer_int_steal = class({})
function modifier_remove_silencer_int_steal:IsHidden() return true end
function modifier_remove_silencer_int_steal:RemoveOnDeath() return false end
function modifier_remove_silencer_int_steal:IsPurgable() return false end
function modifier_remove_silencer_int_steal:OnCreated() self:StartIntervalThink(0.1) end
function modifier_remove_silencer_int_steal:OnIntervalThink() if IsServer() then self:GetParent():RemoveModifierByName("modifier_silencer_int_steal") end end