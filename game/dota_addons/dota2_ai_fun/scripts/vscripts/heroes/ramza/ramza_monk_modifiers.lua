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
	hParent:Heal(fDistance*self.iPercentageDistanceHP/100, hParent)
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
	if keys.unit ~= self:GetParent() then return end
	local bIsCooldownReady
	local hParent = self:GetParent()
		
	if hParent:GetHealth()/hParent:GetMaxHealth() < self.iCriticalHealthPercentage/100 then
		
		if hParent:HasAbility("ramza_monk_critical_recover_hp") then 
			if hParent:FindAbilityByName("ramza_monk_critical_recover_hp"):IsCooldownReady() then
				hParent:FindAbilityByName("ramza_monk_critical_recover_hp"):UseResources(true, true, true)
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
					if hParent():HasModifier("modifier_imbalanced_economizer") then
						fCooldownMultiplier = 0
					else
						fCooldownMultiplier = fCooldownMultiplier*0.2 
					end				
				elseif hParent:HasModifier("modifier_item_fun_economizer_mcr") then 
					if hParent():HasModifier("modifier_imbalanced_economizer") then
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