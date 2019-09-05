
modifier_cleric_berserk = class({})
function modifier_cleric_berserk:CheckState()
	return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
end
function modifier_cleric_berserk:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_cleric_berserk:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_cleric_berserk:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack") end

function modifier_cleric_berserk:IsPurgable() return false end

function modifier_cleric_berserk:IsPurgeException() return false end

function modifier_cleric_berserk:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iOwner = hParent:GetPlayerOwnerID()
	self:StartIntervalThink(0.05)
end

function modifier_cleric_berserk:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local vParent =  hParent:GetAbsOrigin()
	
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), vParent, none, 1200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE , FIND_ANY_ORDER, false)
	
	if #tTargets == 1 then
		if self.hTarget then
			self.hTarget:RemoveModifierByName("modifier_cleric_berserk_target")
			self.hTarget = nil
			hParent:Stop()
		end
	else	
		local iNum = 1
		local iDistance = 99999		
		for i, v in ipairs(tTargets) do
			if (vParent-v:GetOrigin()):Length2D() < iDistance and v ~= hParent then
				iNum = i
				iDistance = (vParent-v:GetOrigin()):Length2D()
			end
		end
		
		
		if not hParent:IsAttackingEntity(tTargets[iNum]) then
			if self.hTarget ~= tTargets[iNum] then 
				if self.hTarget then
					self.hTarget:RemoveModifierByName("modifier_cleric_berserk_target")
				end
				self.hTarget = tTargets[iNum]
				self.hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cleric_berserk_target", {})
			end
			hParent:MoveToTargetToAttack(self.hTarget)
		end
	end
end

function modifier_cleric_berserk:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:RemoveModifierByName("modifier_cleric_berserk_no_order")
	hParent:Stop()
	if self.hTarget then
		self.hTarget:RemoveModifierByName("modifier_cleric_berserk_target")
	end	
	
end

function modifier_cleric_berserk:GetStatusEffectName() return "particles/status_fx/status_effect_gods_strength.vpcf" end

function modifier_cleric_berserk:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_cleric_berserk:GetEffectName() return "particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger.vpcf" end

modifier_cleric_berserk_target = class({})

function modifier_cleric_berserk_target:CheckState()
	return {[MODIFIER_STATE_SPECIALLY_DENIABLE] = true}
end

function modifier_cleric_berserk_target:IsPurgable() return false end

function modifier_cleric_berserk_target:IsDebuff() return true end

function modifier_cleric_berserk_target:IsPurgeException() return false end

function modifier_cleric_berserk_target:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok_ovr.vpcf" end

function modifier_cleric_berserk_target:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

modifier_cleric_magic_mirror = class({})

function modifier_cleric_magic_mirror:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_ABSORB_SPELL
	}
end

function modifier_cleric_magic_mirror:IsPurgable() return false end
function modifier_cleric_magic_mirror:RemoveOnDeath() return false end
function modifier_cleric_magic_mirror:IsHidden() return true end


function modifier_cleric_magic_mirror:GetAbsorbSpell(keys)
	if self.bIsTriggering then return false end
	if self:GetParent():PassivesDisabled() then return end
	local hAbility = self:GetAbility()
	if not hAbility:IsCooldownReady() or hAbility:GetLevel() == 0 then return false end
	local hParent = self:GetParent()
	if hParent:GetTeam() == keys.ability:GetCaster():GetTeam() then return false end
	
	self.bIsTriggering = true
	local hSphere
	--Get all spheres on hero

	
	for i = 0, 8 do
		if hParent:GetItemInSlot(i) and hParent:GetItemInSlot(i):GetName() == "item_sphere" and hParent:GetItemInSlot(i):IsCooldownReady() then
			hSphere = hParent:GetItemInSlot(i)
			break
		end
	end
	
	if hParent:HasModifier("modifier_item_lotus_orb_active") then --borrows effect of lotus orb
		hParent:TriggerSpellAbsorb( keys.ability )
	else
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_lotus_orb_active", {Duration = 0.04})
		hParent:TriggerSpellAbsorb( keys.ability )
		hParent:RemoveModifierByName("modifier_item_lotus_orb_active")
	end
	
	-- recovering spheres and make sound if needed
	local tNewSphereModifierList = hParent:FindAllModifiersByName("modifier_item_sphere_target")
	if hSphere and not hSphere:IsCooldownReady() then
		hSphere:EndCooldown()
	else
		hParent:EmitSound("DOTA_Item.LinkensSphere.Activate")
		local iParticle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	end
	
	if hParent:HasScepter() then 
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		hParent:EmitSound("Hero_Antimage.SpellShield.Block")
		hParent:EmitSound("Hero_Antimage.SpellShield.Reflect")
	end
		
	hAbility:UseResources(false, false, true)
	self.bIsTriggering = false
	return 1
end

modifier_cleric_prayer = class({})
function modifier_cleric_prayer:IsDebuff() return true end
function modifier_cleric_prayer:IsPurgable()	
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_cleric_6" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	
	if self.hSpecial:GetSpecialValueFor("value") > 1 then 
		return true 
	else 
		return false 
	end
end

function modifier_cleric_prayer:GetStatusEffectName() return "particles/status_fx/status_effect_guardian_angel.vpcf" end

function modifier_cleric_prayer:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end

local function PrayerStatusBonus(self)
	return self:GetAbility():GetSpecialValueFor("attribute_bonus")
end

modifier_cleric_prayer.GetModifierBonusStats_Agility = PrayerStatusBonus

modifier_cleric_prayer.GetModifierBonusStats_Intellect = PrayerStatusBonus

modifier_cleric_prayer.GetModifierBonusStats_Strength = PrayerStatusBonus