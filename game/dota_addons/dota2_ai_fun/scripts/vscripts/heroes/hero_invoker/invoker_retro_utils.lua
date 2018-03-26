--[[ ============================================================================================================
	Author: tontyoutoure
	Date: March 11, 2018
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_invoke_thinker", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_quas_instance", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_wex_instance", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_exort_instance", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_cosmetic_manager", "heroes/hero_invoker/invoker_retro_utils.lua", LUA_MODIFIER_MOTION_NONE)

local INVOKER_RETRO_WEARABLE_MAGUS_APEX = 2
local INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE = 4

modifier_invoker_retro_cosmetic_manager = class({})
function modifier_invoker_retro_cosmetic_manager:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_cosmetic_manager:IsHidden() return true end
function modifier_invoker_retro_cosmetic_manager:RemoveOnDeath() return false end
function modifier_invoker_retro_cosmetic_manager:IsPurgable() return false end
function modifier_invoker_retro_cosmetic_manager:OnCreated() 
	self:GetAbility().hModifier = self
	if IsServer() then 
		local tAllManagers = self:GetParent():FindAllModifiersByName("modifier_invoker_retro_cosmetic_manager")
		if #tAllManagers > 1 then
			for i, v in ipairs(tAllManagers) do
				if v ~= self then
					self:SetStackCount(v:GetStackCount())
					break
				end
			end
		end
	end
end

local tInvokerRetroInvokeList = {
	q = {
		q = {q = "invoker_retro_icy_path", w = "invoker_retro_portal", e = "invoker_retro_frost_nova"},
		w = {q = "invoker_retro_betrayal", w = "invoker_retro_tornado_blast", e = "invoker_retro_levitation"},
		e = {q = "invoker_retro_power_word", w = "invoker_retro_invisibility_aura", e = "invoker_retro_shroud_of_flames"}
	},
	w = {
		q = {q = "invoker_retro_mana_burn", w = "invoker_retro_emp", e = "invoker_retro_soul_blast"},
		w = {q = "invoker_retro_telelightning", w = "invoker_retro_shock", e = "invoker_retro_arcane_arts"},
		e = {q = "invoker_retro_scout", w = "invoker_retro_energy_ball", e = "invoker_retro_lightning_shield"}
	},
	e = {
		q = {q = "invoker_retro_chaos_meteor", w = "invoker_retro_confuse", e = "invoker_retro_disarm"},
		w = {q = "invoker_retro_soul_reaver", w = "invoker_retro_firestorm", e = "invoker_retro_incinerate"},
		e = {q = "invoker_retro_deafening_blast", w = "invoker_retro_inferno", e = "invoker_retro_firebolt"}
	}
}

local tPersistAbilities = {invoker_retro_tornado_blast = true, invoker_retro_chaos_meteor = true, invoker_retro_inferno = true, invoker_retro_firebolt = true} -- should not be removed
local tPassiveABilities = {invoker_retro_invisibility_aura = true, invoker_retro_arcane_arts = true}

local tOrbColors = {invoker_retro_quas =Vector(0, 140, 244), invoker_retro_wex = Vector(212,87,220)*0.95, invoker_retro_exort = Vector(255, 182, 0)}
local tOrbsShort = {invoker_retro_quas = 'q', invoker_retro_wex = 'w', invoker_retro_exort = 'e'}
local tOriginalAbilities = {invoker_retro_quas = true, invoker_retro_wex = true, invoker_retro_exort = true, invoker_retro_empty1 = true, invoker_retro_empty2 = true, invoker_retro_invoke = true}

invoker_retro_invoke = class({})

function invoker_retro_invoke:OnHeroLevelUp()
	local hCaster = self:GetCaster()
	if hCaster:GetLevel() == 6 then
		self:SetLevel(1)
	end
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+self.AttributeStrenthGain-hCaster:GetStrengthGain())
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+self.AttributeAgilityGain-hCaster:GetAgilityGain())
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+self.AttributeIntelligenceGain-hCaster:GetIntellectGain())	
end

function invoker_retro_invoke:GetCooldown(num)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 2
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)
		end
	end
	
	return self.BaseClass.GetCooldown(self, num)
end

function invoker_retro_invoke:GetIntrinsicModifierName()
	return "modifier_invoker_retro_invoke_thinker"
end
function invoker_retro_invoke:IsStealable() return false end
function invoker_retro_invoke:IsHiddenWhenStolen() return true end
-- Update orb level for all abilities
local function UpdateInvokerRetroOrbScepter(hInvoker)
	if not hInvoker:FindAbilityByName("invoker_retro_quas") or not hInvoker:FindAbilityByName("invoker_retro_wex") or not hInvoker:FindAbilityByName("invoker_retro_exort") then return end
	local iQuasLevel = hInvoker:FindAbilityByName("invoker_retro_quas"):GetLevel()
	local iWexLevel = hInvoker:FindAbilityByName("invoker_retro_wex"):GetLevel()
	local iExortLevel = hInvoker:FindAbilityByName("invoker_retro_exort"):GetLevel()
	if hInvoker:HasScepter() then
		iQuasLevel = iQuasLevel+1
		iWexLevel = iWexLevel+1
		iExortLevel = iExortLevel+1
		hInvoker:GetAbilityByIndex(4):SetHidden(false)
	else		
		hInvoker:GetAbilityByIndex(4):SetHidden(true)
	end
	
	for i = 0, 23 do
		if hInvoker:GetAbilityByIndex(i) then
			local hAbility = hInvoker:GetAbilityByIndex(i)
			if not tOriginalAbilities[hAbility:GetName()] and not string.match(hAbility:GetName(), "special_bonus") then
				hAbility.iQuasLevel = iQuasLevel
				hAbility.iWexLevel = iWexLevel
				hAbility.iExortLevel = iExortLevel
			end
		end
	end	
end

function invoker_retro_invoke:OnSpellStart()
	local hCaster = self:GetCaster()
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_invoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	hCaster:EmitSound("Hero_Invoker.Invoke")
	if hCaster.invoked_orbs and hCaster.invoked_orbs[1] and hCaster.invoked_orbs[2] and hCaster.invoked_orbs[3] then
		ParticleManager:SetParticleControl(iParticle, 2, (tOrbColors[hCaster.invoked_orbs[1]:GetAbilityName()]+tOrbColors[hCaster.invoked_orbs[2]:GetAbilityName()]+tOrbColors[hCaster.invoked_orbs[3]:GetAbilityName()])/3)
	else
		return
	end
	local sAbilityToInvoke = tInvokerRetroInvokeList[tOrbsShort[hCaster.invoked_orbs[1]:GetAbilityName()]][tOrbsShort[hCaster.invoked_orbs[2]:GetAbilityName()]][tOrbsShort[hCaster.invoked_orbs[3]:GetAbilityName()]]
	local hAbility
	if not hCaster:HasAbility(sAbilityToInvoke) then
		hAbility = hCaster:AddAbility(sAbilityToInvoke)
		hAbility:SetLevel(1)
		UpdateInvokerRetroOrbScepter(hCaster)
	else
		hAbility = hCaster:FindAbilityByName(sAbilityToInvoke)
	end
	local sAbility3Name = hCaster:GetAbilityByIndex(3):GetName()
	local sAbility4Name = hCaster:GetAbilityByIndex(4):GetName()
	
	if sAbilityToInvoke == sAbility3Name then
		self:EndCooldown()
		return
	elseif sAbilityToInvoke == sAbility4Name then
		if hCaster:HasScepter() then
			self:EndCooldown()
			hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, true)
			return
		else
			hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, false)
			return
		end
	end
	
	hCaster:SwapAbilities(sAbilityToInvoke, sAbility4Name, true, false)
	if not tPersistAbilities[sAbility4Name] then
		hCaster:RemoveAbility(sAbility4Name)
		if tPassiveABilities[sAbility4Name] then
			for i, v in ipairs(hCaster:FindAllModifiers()) do
				if string.match(v:GetName(), sAbility4Name) then
					v:Destroy()
				end
			end
		end
	end
	if hCaster:HasScepter() then		
		hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, true)	
	else
		hCaster:SwapAbilities(sAbilityToInvoke, sAbility3Name, true, false)	
	end	
end

modifier_invoker_retro_invoke_thinker = class({})
function modifier_invoker_retro_invoke_thinker:IsHidden() return true end
function modifier_invoker_retro_invoke_thinker:IsPurgable() return false end
function modifier_invoker_retro_invoke_thinker:RemoveOnDeath() return false end
function modifier_invoker_retro_invoke_thinker:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	self.bPreviousScepter = hParent:HasScepter()
	UpdateInvokerRetroOrbScepter(hParent)
	self:StartIntervalThink(0.04)
end

function modifier_invoker_retro_invoke_thinker:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:HasScepter() and not self.bPreviousScepter or not hParent:HasScepter() and self.bPreviousScepter then
		self.bPreviousScepter = hParent:HasScepter()
		UpdateInvokerRetroOrbScepter(hParent)	
		Timers:CreateTimer(0.04, function () CustomGameEventManager:Send_ServerToAllClients( "invoker_scepter_state_change", {entindex = hParent:entindex()}) end)
	end
end


invoker_retro_quas = class({})
invoker_retro_wex = class({})
invoker_retro_exort = class({})
function invoker_retro_quas:IsStealable() return false end
function invoker_retro_wex:IsStealable() return false end
function invoker_retro_exort:IsStealable() return false end
function invoker_retro_quas:IsHiddenWhenStolen() return false end
function invoker_retro_wex:IsHiddenWhenStolen() return false end
function invoker_retro_exort:IsHiddenWhenStolen() return false end

function invoker_retro_quas:GetIntrinsicModifierName() return "modifier_invoker_retro_cosmetic_manager" end
function invoker_retro_wex:GetIntrinsicModifierName() return "modifier_invoker_retro_cosmetic_manager" end
function invoker_retro_exort:GetIntrinsicModifierName() return "modifier_invoker_retro_cosmetic_manager" end

function invoker_retro_quas:GetAbilityTextureName() 
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		return "invoker/magus_apex/invoker_quas"
	else
		return "invoker_quas"
	end
end

function invoker_retro_wex:GetAbilityTextureName() 
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		return "invoker/magus_apex/invoker_wex"
	else
		return "invoker_wex"
	end
end

function invoker_retro_exort:GetAbilityTextureName() 
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		return "invoker/magus_apex/invoker_exort"
	else
		return "invoker_exort"
	end
end


function invoker_retro_quas:OnSpellStart()
	if self:GetCaster():GetUnitName() ~= "npc_dota_hero_invoker" then return end
	local hCaster = self:GetCaster()
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf")
	elseif self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf")
	else
		invoker_retro_replace_orb(hCaster, self, "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf")
	end
	invoker_retro_orb_replace_modifiers(hCaster)
end

function invoker_retro_wex:OnSpellStart()
	if self:GetCaster():GetUnitName() ~= "npc_dota_hero_invoker" then return end
	local hCaster = self:GetCaster()
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf")
	elseif self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf")
	else
		invoker_retro_replace_orb(hCaster, self, "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf")
	end	
	invoker_retro_orb_replace_modifiers(hCaster) 
end

function invoker_retro_exort:OnSpellStart()
	if self:GetCaster():GetUnitName() ~= "npc_dota_hero_invoker" then return end
	local hCaster = self:GetCaster()
	if self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_MAGUS_APEX) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf")
	elseif self.hModifier and bit.band(self.hModifier:GetStackCount(), INVOKER_RETRO_WEARABLE_DARK_ARTISTRY_CAPE) > 0 then
		invoker_retro_replace_orb(hCaster, self, "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf")
	else
		invoker_retro_replace_orb(hCaster, self, "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf")
	end	
	invoker_retro_orb_replace_modifiers(hCaster) 
end

function InvokerRetroOrbOnUpgrade(self)
	local hCaster = self:GetCaster()
	UpdateInvokerRetroOrbScepter(hCaster)
	if hCaster:GetUnitName() ~= "npc_dota_hero_invoker" then return end
	invoker_retro_orb_replace_modifiers(hCaster) 
end

invoker_retro_quas.OnUpgrade = InvokerRetroOrbOnUpgrade
invoker_retro_wex.OnUpgrade = InvokerRetroOrbOnUpgrade
invoker_retro_exort.OnUpgrade = InvokerRetroOrbOnUpgrade

function InvokerRetroOrbOnOwnerSpawned(self)
	local hCaster = self:GetCaster()
	invoker_retro_orb_replace_modifiers(hCaster) 
end

invoker_retro_quas.OnOwnerSpawned = InvokerRetroOrbOnOwnerSpawned
invoker_retro_wex.OnOwnerSpawned = InvokerRetroOrbOnOwnerSpawned
invoker_retro_exort.OnOwnerSpawned = InvokerRetroOrbOnOwnerSpawned

modifier_invoker_retro_quas_instance = class({})
modifier_invoker_retro_wex_instance = class({})
modifier_invoker_retro_exort_instance = class({})
function modifier_invoker_retro_quas_instance:IsPurgable() return false end
function modifier_invoker_retro_quas_instance:RemoveOnDeath() return false end
function modifier_invoker_retro_quas_instance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_quas_instance:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_invoker_retro_quas_instance:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_percent_per_instance") end
function modifier_invoker_retro_wex_instance:IsPurgable() return false end
function modifier_invoker_retro_wex_instance:RemoveOnDeath() return false end
function modifier_invoker_retro_wex_instance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_wex_instance:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_invoker_retro_wex_instance:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("move_speed_percent_per_instance") end
function modifier_invoker_retro_exort_instance:IsPurgable() return false end
function modifier_invoker_retro_exort_instance:RemoveOnDeath() return false end
function modifier_invoker_retro_exort_instance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_invoker_retro_exort_instance:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end
function modifier_invoker_retro_exort_instance:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("bonus_health_regen_per_instance") end



--[[ ============================================================================================================
	Author: Rook
	Revised: tontyoutoure
	Date: February 15, 2015
	Removes the third-to-most-recent orb created (if applicable) to make room for the newest orb.
================================================================================================================= ]]
function invoker_retro_replace_orb(hInvoker, hAbility, particle_filepath)
	--Initialization, if not already done.
	if hInvoker.invoked_orbs == nil then
		hInvoker.invoked_orbs = {}
	end
	if hInvoker.invoked_orbs_particle == nil then
		hInvoker.invoked_orbs_particle = {}
	end
	if hInvoker.invoked_orbs_particle_attach == nil then
		hInvoker.invoked_orbs_particle_attach = {}
		hInvoker.invoked_orbs_particle_attach[1] = "attach_orb1"
		hInvoker.invoked_orbs_particle_attach[2] = "attach_orb2"
		hInvoker.invoked_orbs_particle_attach[3] = "attach_orb3"
	end
	
	--Invoker can only have three orbs active at any time.  Each time an orb is activated, its hscript is
	--placed into hInvoker.invoked_orbs[3], the old [3] is moved into [2], and the old [2] is moved into [1].
	--Therefore, the oldest orb is located in [1], and the newest is located in [3].
	--Shift the ordered list of currently summoned orbs down.
	hInvoker.invoked_orbs[1] = hInvoker.invoked_orbs[2]
	hInvoker.invoked_orbs[2] = hInvoker.invoked_orbs[3]
	hInvoker.invoked_orbs[3] = hAbility
	
	--Remove the removed orb's particle effect.
	if hInvoker.invoked_orbs_particle[1] ~= nil then
		ParticleManager:DestroyParticle(hInvoker.invoked_orbs_particle[1], false)
		hInvoker.invoked_orbs_particle[1] = nil
	end
	
	--Shift the ordered list of currently summoned orb particle effects down, and create the new particle.
	hInvoker.invoked_orbs_particle[1] = hInvoker.invoked_orbs_particle[2]
	hInvoker.invoked_orbs_particle[2] = hInvoker.invoked_orbs_particle[3]
	hInvoker.invoked_orbs_particle[3] = ParticleManager:CreateParticle(particle_filepath, PATTACH_CUSTOMORIGIN_FOLLOW, hInvoker)
	ParticleManager:SetParticleControlEnt(hInvoker.invoked_orbs_particle[3], 0, hInvoker, PATTACH_POINT_FOLLOW, "attach_hitloc", hInvoker:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(hInvoker.invoked_orbs_particle[3], 1, hInvoker, PATTACH_POINT_FOLLOW, hInvoker.invoked_orbs_particle_attach[1], hInvoker:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(hInvoker.invoked_orbs_particle[3], 2, hInvoker, PATTACH_POINT_FOLLOW, "attach_hitloc", hInvoker:GetAbsOrigin(), false)
	
	--Shift the ordered list of currently summoned orb particle effect attach locations down.
	local temp_attachment_point = hInvoker.invoked_orbs_particle_attach[1]
	hInvoker.invoked_orbs_particle_attach[1] = hInvoker.invoked_orbs_particle_attach[2]
	hInvoker.invoked_orbs_particle_attach[2] = hInvoker.invoked_orbs_particle_attach[3]
	hInvoker.invoked_orbs_particle_attach[3] = temp_attachment_point
	
	 --Remove and reapply the orb instance modifiers.
	if RandomFloat(0,1)>0.5 then
		StartAnimation(hInvoker, {duration=0.5, activity=ACT_DOTA_OVERRIDE_ABILITY_1})
	else
		StartAnimation(hInvoker, {duration=0.5, activity=ACT_DOTA_OVERRIDE_ABILITY_2})
	end
end


--[[ ============================================================================================================
	Author: Rook
	Revised: tontyoutoure
	Date: February 15, 2015
	Called when Quas, Wex, or Exort is cast or upgraded.  Replaces the modifiers on the caster's modifier bar to
	ensure the correct order, which also has the effect of leveling the effects of any currently existing orbs.
================================================================================================================= ]]
function invoker_retro_orb_replace_modifiers(hInvoker)
	if hInvoker.invoked_orbs == nil then
		hInvoker.invoked_orbs = {}
	end
	--Reapply all the orbs Invoker has out in order to benefit from the upgraded ability's level.  By reapplying all
	--three orb modifiers, they will maintain their order on the modifier bar (so long as all are removed before any
	--are reapplied, since ordering problems arise there are two of the same type of orb otherwise).
	hInvoker:RemoveModifierByName("modifier_invoker_retro_quas_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_quas_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_quas_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_wex_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_wex_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_wex_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_exort_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_exort_instance")
	hInvoker:RemoveModifierByName("modifier_invoker_retro_exort_instance")
	for i=1, 3 do
		if hInvoker.invoked_orbs[i] ~= nil then
			local orb_name = hInvoker.invoked_orbs[i]:GetName()
			if orb_name == "invoker_retro_quas" then
				hInvoker:AddNewModifier(hInvoker, hInvoker:FindAbilityByName("invoker_retro_quas"), "modifier_invoker_retro_quas_instance", {})
			elseif orb_name == "invoker_retro_wex" then
				hInvoker:AddNewModifier(hInvoker, hInvoker:FindAbilityByName("invoker_retro_wex"), "modifier_invoker_retro_wex_instance", {})
			elseif orb_name == "invoker_retro_exort" then
				hInvoker:AddNewModifier(hInvoker, hInvoker:FindAbilityByName("invoker_retro_exort"), "modifier_invoker_retro_exort_instance", {})
			end
		end
	end 
end
