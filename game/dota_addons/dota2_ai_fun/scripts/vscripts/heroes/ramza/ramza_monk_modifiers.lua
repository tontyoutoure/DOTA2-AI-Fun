modifier_ramza_monk_lifefont = class({})


function modifier_ramza_monk_lifefont:IsHidden() return true end
function modifier_ramza_monk_lifefont:RemoveOnDeath() return false end
function modifier_ramza_monk_lifefont:IsPurgable() return false end

function modifier_ramza_monk_lifefont:OnCreated()
	if IsClient() then return end
	self.iPercentageDistanceHP = self:GetAbility():GetSpecialValueFor("percentage_distance_hp")
	self.vPreviousPosition = self:GetParent():GetOrigin()
	self:StartIntervalThink(0.25)
end

function modifier_ramza_monk_lifefont:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local fDistance = self.vPreviousPosition.Length(hParent:GetOrigin() - self.vPreviousPosition)
	if not hParent:PassivesDisabled() then
		hParent:Heal(fDistance*self.iPercentageDistanceHP/100, hParent)
	end
	self.vPreviousPosition = hParent:GetOrigin()
end

modifier_ramza_monk_critical_recover_hp = class({})


function modifier_ramza_monk_critical_recover_hp:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_ramza_monk_critical_recover_hp:OnCreated()
	local hAbility = self:GetAbility()
	self.iCriticalHealthPercentage = hAbility:GetSpecialValueFor("critical_health_percentage")
end

function modifier_ramza_monk_critical_recover_hp:IsHidden() return true end
function modifier_ramza_monk_critical_recover_hp:IsPurgable() return false end
function modifier_ramza_monk_critical_recover_hp:IsDebuff() return false end
function modifier_ramza_monk_critical_recover_hp:RemoveOnDeath() return false end

function modifier_ramza_monk_critical_recover_hp:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() or keys.unit:IsIllusion() then return end
	local bIsCooldownReady
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then return end
	if hParent:GetHealth()/hParent:GetMaxHealth() < self.iCriticalHealthPercentage/100 then
		
		if hParent:HasAbility("ramza_monk_critical_recover_hp") then 
			if hParent:FindAbilityByName("ramza_monk_critical_recover_hp"):IsCooldownReady() then
				hParent:FindAbilityByName("ramza_monk_critical_recover_hp"):UseResources(true, true, true, true)
				hParent:SetHealth(hParent:GetMaxHealth())
				Timers(0.04, function () 
					hParent:SetHealth(hParent:GetMaxHealth()) 
					hParent.fScytheTime = nil
					hParent.fReincarnateTime = nil 
				end)
			end
		else
			bIsCooldownReady = Time() > hParent.hRamzaJob.tPassiveCooldownReadyTime["ramza_monk_critical_recover_hp"]
			if bIsCooldownReady then
				fCooldownMultiplier = 1
				if hParent:HasModifier("modifier_item_fun_angelic_alliance_halo") then
					if hParent:HasModifier("modifier_imbalanced_economizer") then
						fCooldownMultiplier = 0
					else
						fCooldownMultiplier = fCooldownMultiplier*0.2 
					end				
				elseif hParent:HasModifier("modifier_item_fun_economizer_mcr") then 
					if hParent:HasModifier("modifier_imbalanced_economizer") then
						fCooldownMultiplier = 0
					else
						fCooldownMultiplier = fCooldownMultiplier*0.5
					end
				elseif hParent:HasModifier("modifier_item_octarine_core") then
					fCooldownMultiplier = fCooldownMultiplier*0.75
				end
				if hParent:HasModifier("modifier_rune_arcane") then fCooldownMultiplier = fCooldownMultiplier*0.7 end
				hParent.hRamzaJob.tPassiveCooldownReadyTime["ramza_monk_critical_recover_hp"] = Time()+100*fCooldownMultiplier		
				hParent:SetHealth(hParent:GetMaxHealth())
				Timers(0.04, function () 
					hParent:SetHealth(hParent:GetMaxHealth()) 
					hParent.fScytheTime = nil
					hParent.fReincarnateTime = nil 
				end)
			end
		end
	end
end

modifier_ramza_monk_brawler = class({})
function modifier_ramza_monk_brawler:IsHidden() return true end
function modifier_ramza_monk_brawler:RemoveOnDeath() return false end
function modifier_ramza_monk_brawler:IsPurgable() return false end
function modifier_ramza_monk_brawler:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_ramza_monk_brawler:OnCreated() if IsClient() then return end self:SetStackCount(self:GetAbility():GetSpecialValueFor("damage_percentage")) end
function modifier_ramza_monk_brawler:GetModifierBaseDamageOutgoing_Percentage() if self:GetParent():PassivesDisabled() then return 0 else return self:GetStackCount() end end

modifier_ramza_monk_martial_arts_doom_fist = class({})
function modifier_ramza_monk_martial_arts_doom_fist:OnCreated()
	if IsClient() then return end
	self.iDamage = self:GetAbility():GetSpecialValueFor("damage")
	self:StartIntervalThink(1*CalculateStatusResist(self:GetParent()))
	self:GetParent():EmitSound('Hero_DoomBringer.Doom')
end
function modifier_ramza_monk_martial_arts_doom_fist:IsPurgable() return false end
function modifier_ramza_monk_martial_arts_doom_fist:OnDestroy() if IsClient() then return end self:GetParent():StopSound('Hero_DoomBringer.Doom') end
function modifier_ramza_monk_martial_arts_doom_fist:CheckState() return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true} end
function modifier_ramza_monk_martial_arts_doom_fist:OnIntervalThink() if IsClient() then return end ApplyDamage({damage = self.iDamage, ability = self:GetAbility(), attacker = self:GetCaster(), victim = self:GetParent(), damage_type=DAMAGE_TYPE_PURE}) end
function modifier_ramza_monk_martial_arts_doom_fist:GetStatusEffectName() return "particles/status_fx/status_effect_doom.vpcf" end
function modifier_ramza_monk_martial_arts_doom_fist:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end
function modifier_ramza_monk_martial_arts_doom_fist:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ramza_monk_martial_arts_doom_fist:GetTexture() return "doom_bringer_doom" end