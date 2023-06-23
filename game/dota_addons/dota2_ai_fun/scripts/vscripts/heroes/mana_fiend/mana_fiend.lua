LinkLuaModifier("modifier_mana_fiend_osmose", "heroes/mana_fiend/mana_fiend_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier("modifier_mana_fiend_osmose_image", "heroes/mana_fiend/mana_fiend_modifiers.lua", LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier("modifier_mana_fiend_abandon", "heroes/mana_fiend/mana_fiend_modifiers.lua", LUA_MODIFIER_MOTION_NONE);


mana_fiend_osmose = class({GetIntrinsicModifierName = function (self) return "modifier_mana_fiend_osmose" end})
mana_fiend_equilibrium = class({})

function mana_fiend_equilibrium:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	if not hCaster:HasModifier('modifier_mana_fiend_osmose_image') then
		local hModifier = hCaster:FindModifierByName('modifier_mana_fiend_osmose')
		if hModifier and hModifier.hImage and hCaster:HasScepter() then
			for i = 0,23 do
				if hModifier.hImage:GetAbilityByIndex(i) then
					hModifier.hImage:GetAbilityByIndex(i):SetLevel(hCaster:GetAbilityByIndex(i):GetLevel())
				end
				for i = 0, 8 do
					hModifier.hImage:RemoveItem(hModifier.hImage:GetItemInSlot(i))
					if hCaster:GetItemInSlot(i) then
						hModifier.hImage:AddItemByName(hCaster:GetItemInSlot(i):GetName()):SetCurrentCharges(hCaster:GetItemInSlot(i):GetCurrentCharges())
					end
				end
			end
			hModifier.hImage:SetMana(hCaster:GetMana())
			
			hModifier.hImage:FindAbilityByName(self:GetName()).hTarget = hTarget
			hModifier.hImage:FindAbilityByName(self:GetName()):OnSpellStart()
		end
	else
		hTarget = self.hTarget
	end
	
	if hTarget:TriggerSpellAbsorb(self) then return end
	
	local fMana_burned = hCaster:GetMana() - hTarget:GetMana()
	
	if fMana_burned < 0 then
		return
	elseif fMana_burned > 150 and not hCaster:HasModifier("modifier_mana_fiend_abandon") then
		fMana_burned = 150
	end		

	ApplyDamage({
	attacker = hCaster,
	victim = hTarget,
	damage_type = self:GetAbilityDamageType(),
	ability = self,
	damage = fMana_burned * (self:GetSpecialValueFor("damage_multiplier")+CheckTalent(hCaster, 'special_bonus_unique_mana_fiend_2'))})
	hCaster:Script_ReduceMana(fMana_burned, self)
	hTarget:Script_ReduceMana(fMana_burned, self)
	hTarget:EmitSound('Hero_Antimage.ManaVoid')
	ParticleManager:CreateParticle('particles/units/heroes/hero_antimage/antimage_manavoid.vpcf',PATTACH_ABSORIGIN_FOLLOW, hTarget)

end

mana_field_mana_rift = class({})
function mana_field_mana_rift:OnSpellStart()	
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	if not hCaster:HasModifier('modifier_mana_fiend_osmose_image') then
		local hModifier = hCaster:FindModifierByName('modifier_mana_fiend_osmose')
		if hModifier and hModifier.hImage and hCaster:HasScepter() then
			for i = 0,23 do
				if hModifier.hImage:GetAbilityByIndex(i) then
					hModifier.hImage:GetAbilityByIndex(i):SetLevel(hCaster:GetAbilityByIndex(i):GetLevel())
				end
				for i = 0, 8 do
					hModifier.hImage:RemoveItem(hModifier.hImage:GetItemInSlot(i))
					if hCaster:GetItemInSlot(i) then
						hModifier.hImage:AddItemByName(hCaster:GetItemInSlot(i):GetName()):SetCurrentCharges(hCaster:GetItemInSlot(i):GetCurrentCharges())
					end
				end
			end
			hModifier.hImage:SetMana(hCaster:GetMana())
			
			hModifier.hImage:FindAbilityByName(self:GetName()).hTarget = hTarget
			hModifier.hImage:FindAbilityByName(self:GetName()):OnSpellStart()
		end
	else
		hTarget = self.hTarget
	end
	
	if hTarget:TriggerSpellAbsorb(self) then return end
	
	 
	local mana_burn_multiplier = self:GetSpecialValueFor("mana_burn_multiplier")+CheckTalent(hCaster, 'special_bonus_unique_mana_fiend_3')
	local mana_burned = (hTarget:GetMaxMana() - hTarget:GetMana()) * mana_burn_multiplier

	if mana_burned > 300 and not hCaster:HasModifier("modifier_mana_fiend_abandon") then
		mana_burned = 300
	end		
	hTarget:EmitSound('Hero_NyxAssassin.ManaBurn.Target')
	ParticleManager:CreateParticle('particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf',PATTACH_ABSORIGIN_FOLLOW, hTarget)
	hTarget:Script_ReduceMana(mana_burned, self)
end

mana_fiend_abandon=class({})
function mana_fiend_abandon:OnSpellStart()
    local hCaster = self:GetCaster()
	hCaster:EmitSound("DOTA_Item.MaskOfMadness.Activate")
    hCaster:GiveMana(self:GetSpecialValueFor("mana_restored"))
	hCaster:AddNewModifier(hCaster, self, 'modifier_mana_fiend_abandon', {attack_speed_bonus = self:GetSpecialValueFor('attack_speed_bonus')+CheckTalent(hCaster,'special_bonus_unique_mana_fiend_1'), Duration = self:GetSpecialValueFor('duration')})
	if hCaster:HasModifier('modifier_mana_fiend_osmose') then 
		hCaster:FindModifierByName('modifier_mana_fiend_osmose').hImage:AddNewModifier(hCaster, self, 'modifier_mana_fiend_abandon', {attack_speed_bonus = self:GetSpecialValueFor('attack_speed_bonus')+CheckTalent(hCaster,'special_bonus_unique_mana_fiend_1'), Duration = self:GetSpecialValueFor('duration')})
	end
end
