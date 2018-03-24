modifier_capslockftw_hax = class({})

function modifier_capslockftw_hax:CheckState() 
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_capslockftw_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then		
		return {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,}
	else
		return {[MODIFIER_STATE_INVISIBLE] = true}
	end
end

function modifier_capslockftw_hax:DeclareFunctions() return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end

function modifier_capslockftw_hax:GetModifierInvisibilityLevel() return 1 end

function modifier_capslockftw_hax:OnCreated() 
	if IsClient() then return end
	self:StartIntervalThink(1) 
end

function modifier_capslockftw_hax:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:ReduceMana(self:GetAbility():GetSpecialValueFor("mana_drain"))
	if hParent:GetMana() == 0 then
		hParent:CastAbilityImmediately(hParent:FindAbilityByName("capslockftw_hax_close"), hParent:GetPlayerOwnerID())
	end
end

modifier_capslockftw_sarcasm = class({})

function modifier_capslockftw_sarcasm:IsHidden() return true end
function modifier_capslockftw_sarcasm:IsPurgable() return false end
function modifier_capslockftw_sarcasm:RemoveOnDeath() return false end
function modifier_capslockftw_sarcasm:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_capslockftw_sarcasm:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	if keys.attacker:PassivesDisabled() then return end
	if keys.target:IsBuilding() or keys.target:GetTeam() == keys.attacker:GetTeam() then return end
	local iLevel = self:GetAbility():GetLevel()
	local fProc = RandomFloat(0,1)
	local hAbility = self:GetAbility()
	local fChance = hAbility:GetSpecialValueFor("chance")/100
	if iLevel >0 and fProc < fChance then
		keys.target:EmitSound("DOTA_Item.DiffusalBlade.Activate")
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
		keys.target:Purge(true, false, false, false, false)
	end
	if iLevel >1 and fProc > fChance and fProc < 2*fChance then
		keys.target:AddNewModifier(keys.attacker, hAbility, "modifier_silence", {Duration = hAbility:GetSpecialValueFor("silence_duration")*CalculateStatusResist(keys.target)})
	end
	if iLevel >2 and fProc > 2*fChance and fProc < 3*fChance then
		self.bLifeSteal = true
	end
	if iLevel >3 and fProc > 3*fChance and fProc < 4*fChance then
		local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetOrigin(), nil, hAbility:GetSpecialValueFor("splash_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i, v in ipairs(tTargets) do
			if v ~= keys.target then
				ApplyDamage({attacker = keys.attacker, victim = v, damage_type = DAMAGE_TYPE_PHYSICAL, ability = hAbility, damage = keys.original_damage, damage_flag = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
			end
		end
	end
end


function modifier_capslockftw_sarcasm:OnTakeDamage(keys)
	if keys.attacker ~= self:GetParent() then return end
	if self.bLifeSteal then
		self.bLifeSteal = false
		local fHeal = keys.damage * self:GetAbility():GetSpecialValueFor("lifesteal_percentage")/100
		keys.attacker:Heal(fHeal, keys.attacker)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)	
		local iParticle = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, keys.attacker, keys.attacker:GetPlayerOwner())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHeal, 0))
		ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHeal))+2, 0))
		ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
	end
end

modifier_capslockftw_flamer_buff = class({})
function modifier_capslockftw_flamer_buff:IsPurgable() return true end
function modifier_capslockftw_flamer_buff:IsBuff() return true end
function modifier_capslockftw_flamer_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_capslockftw_flamer_buff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movement_buff") end
function modifier_capslockftw_flamer_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_capslockftw_flamer_buff:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf" end

modifier_capslockftw_flamer_debuff = class({})
function modifier_capslockftw_flamer_debuff:IsPurgable() return true end
function modifier_capslockftw_flamer_debuff:IsBuff() return false end
function modifier_capslockftw_flamer_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_capslockftw_flamer_debuff:OnRefresh()
	self.fSlow = self:GetAbility():GetSpecialValueFor("movement_slow")
end
function modifier_capslockftw_flamer_debuff:GetModifierMoveSpeedBonus_Percentage() 
	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("movement_slow")
	return self.fSlow
end
function modifier_capslockftw_flamer_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_capslockftw_flamer_debuff:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf" end
