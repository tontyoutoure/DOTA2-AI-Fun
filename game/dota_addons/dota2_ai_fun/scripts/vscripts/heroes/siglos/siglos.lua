LinkLuaModifier("modifier_siglos_disadvantage_silence", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siglos_disadvantage_disarm", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siglos_disruption_aura", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siglos_disruption_aura_target", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siglos_reflect", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siglos_mind_control", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siglos_mind_control_magic_immune", "heroes/siglos/siglos_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
siglos_disadvantage = class({})
function siglos_disadvantage:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	local hCaster = self:GetCaster()
	local fDamage = math.abs(hTarget:GetStrength()-hCaster:GetStrength())*self:GetSpecialValueFor("strength_diff_damage")
	ApplyDamage({victim = hTarget, attacker = hCaster, damage = fDamage, ability = self, damage_type = self:GetAbilityDamageType()})
	local iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_spell.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(0, fDamage, 6))
	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fDamage))+2, 100))
	ParticleManager:SetParticleControl(iParticle, 3, Vector(255, 80, 80))
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = CalculateStatusResist(hTarget)*self:GetSpecialValueFor("ministun_duration")})
	if hTarget:GetIntellect() > hTarget:GetAgility() then
		hTarget:EmitSound("Hero_SkywrathMage.AncientSeal.Target")
		hTarget:EmitSound("DOTA_Item.Orchid.Activate")
		hTarget:AddNewModifier(hCaster, self, "modifier_siglos_disadvantage_silence", {Duration = CalculateStatusResist(hTarget)*self:GetSpecialValueFor("duration")})
	else
		hTarget:EmitSound("Hero_SkywrathMage.AncientSeal.Target")
		hTarget:EmitSound("DOTA_Item.HeavensHalberd.Activate")
		hTarget:AddNewModifier(hCaster, self, "modifier_siglos_disadvantage_disarm", {Duration = CalculateStatusResist(hTarget)*self:GetSpecialValueFor("duration")})	
	end
end


siglos_reflect = class({})
function siglos_reflect:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_ArcWarden.MagneticField.Cast")
	hCaster:AddNewModifier(hCaster, self, "modifier_siglos_reflect", {Duration = self:GetSpecialValueFor("duration")})
end



siglos_disruption_aura = class({})
function siglos_disruption_aura:OnUpgrade() self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_siglos_disruption_aura", {}) end

siglos_mind_control = class({})
function siglos_mind_control:GetCooldown(iLevel)
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 20
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", iLevel)
		end
	end
	
	return self.BaseClass.GetCooldown(self, iLevel)

end

local tTransformModifierList = {"modifier_dragon_knight_dragon_form", "modifier_lone_druid_true_form", "modifier_terrorblade_metamorphosis"}

function siglos_mind_control:OnSpellStart()
	local hCaster = self:GetCaster()
	self.hTarget = self:GetCursorTarget()
	if self.hTarget:TriggerSpellAbsorb(self) then 
		hCaster:Interrupt() return end
	if not hCaster:HasAbility(self:GetName()) then return end
	local iChannelTime = self:GetSpecialValueFor("duration")
	if self:GetCaster():HasAbility("special_bonus_unique_siglos_3") then
		iChannelTime = iChannelTime+self:GetCaster():FindAbilityByName("special_bonus_unique_siglos_3"):GetSpecialValueFor("value")
	end
	if hCaster:GetTeam() == self.hTarget:GetTeam() then
		hCaster:Interrupt()
		self:RefundManaCost()
		self:EndCooldown()
		return 
	end
	self.hTarget:AddNewModifier(hCaster, self, "modifier_siglos_mind_control", {Duration = iChannelTime*CalculateStatusResist(self.hTarget)})
	if hCaster:HasScepter() then
		hCaster:AddNewModifier(hCaster, self, "modifier_siglos_mind_control_magic_immune", {Duration = iChannelTime*CalculateStatusResist(self.hTarget)})
	end
	self.hHeroCreated = CreateUnitByName(self.hTarget:GetName(), GetGroundPosition(self.hTarget:GetOrigin(), nil), true, hCaster, hCaster, hCaster:GetTeam())
	self.hHeroCreated:AddNewModifier(hCaster, self,"modifier_invulnerable", {})
	self.hHeroCreated:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	self.hHeroCreated:SetForwardVector(self.hTarget:GetForwardVector())
	for i = 0, 8 do
		local hItem = self.hTarget:GetItemInSlot(i)
		if hItem then
			local hItemCreated = self.hHeroCreated:AddItemByName(hItem:GetName())
			hItemCreated:StartCooldown(hItem:GetCooldownTimeRemaining())
			hItemCreated:SetCurrentCharges(hItem:GetCurrentCharges())
		end
	end
	
	if self.hTarget:GetPlayerOwner().bIsPlayingFunHero then
		if self.hTarget.hRamzaJob then
			self.hHeroCreated.hRamzaOrigin = self.hTarget
		end
		if self.hTarget.iDragonForm then
			self.hHeroCreated.hFormToGo = self.hTarget
		end
		GameMode:InitializeFunHero(self.hHeroCreated) 
	end
	
	local iLevel = self.hTarget:GetLevel()
	while iLevel > 1 do
		self.hHeroCreated:HeroLevelUp(false)
		iLevel = iLevel -1
	end
	self.hHeroCreated:SetAbilityPoints(0)
	
	for i = 0, 23 do
		if self.hTarget:GetAbilityByIndex(i) and not self.hTarget.hRamzaJob then
			self.hHeroCreated:GetAbilityByIndex(i):SetLevel(self.hTarget:GetAbilityByIndex(i):GetLevel())
			self.hHeroCreated:GetAbilityByIndex(i):StartCooldown(self.hTarget:GetAbilityByIndex(i):GetCooldownTimeRemaining())
		end
	end	
	local tModifiers = self.hTarget:FindAllModifiers()
	for i, v in ipairs(tModifiers) do
		if v:GetRemainingTime() < 0 and v:GetStackCount() > 0 and not v:IsHidden() then
			local sAbilityName
			if v:GetAbility() then
				sAbilityName = v:GetAbility():GetName()
			end
			local sModifierName = v:GetName()
			if self.hHeroCreated:HasModifier(sModifierName) then
				self.hHeroCreated:FindModifierByName(sModifierName):SetStackCount(v:GetStackCount())
			end
			if self.hHeroCreated:HasAbility(sAbilityName) then
				self.hHeroCreated:AddNewModifier(self.hHeroCreated, self.hHeroCreated:FindAbilityByName(sAbilityName), sModifierName, {}):SetStackCount(v:GetStackCount())
			else
				self.hHeroCreated:AddNewModifier(v:GetCaster(), v:GetAbility(), sModifierName, {}):SetStackCount(v:GetStackCount())				
			end
		end
	end
	for i, v in ipairs(tTransformModifierList) do
		if self.hTarget:HasModifier(v) then
			local hModifier = self.hTarget:FindModifierByName(v)
			local sAbilityName = hModifier:GetAbility():GetName() 
			if hModifier:GetRemainingTime() > 0 then
				self.hHeroCreated:AddNewModifier(self.hHeroCreated, self.hHeroCreated:FindAbilityByName(sAbilityName), v, {Duration=hModifier:GetRemainingTime()})
			else
				self.hHeroCreated:AddNewModifier(self.hHeroCreated, self.hHeroCreated:FindAbilityByName(sAbilityName), v, {})
			end
		end
	end
	self.hHeroCreated:SetHealth(self.hTarget:GetHealth())
	self.hHeroCreated:SetMana(self.hTarget:GetMana())
	CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "siglos_select_unit", {iEntIndex = self.hHeroCreated:entindex()} )
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_new_arc_blade_golden.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(self.iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, self.hHeroCreated, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hHeroCreated:GetAbsOrigin(), true)
	print(hCaster:entindex(), self.hHeroCreated:entindex(), self.hTarget:entindex())
end
function siglos_mind_control:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	if not self.hHeroCreated then return end
	local vLastLocation = self.hHeroCreated:GetOrigin()
	local vLastDirection = self.hHeroCreated:GetForwardVector()	
	self.hHeroCreated:InterruptChannel()
	for i, v in ipairs(self.hHeroCreated:FindAllModifiers()) do
		v:Destroy()
	end	
	hCaster:RemoveModifierByName("modifier_siglos_mind_control_magic_immune")
	CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "siglos_select_unit", {iEntIndex = hCaster:entindex()} )
	self.hHeroCreated:AddNewModifier(hCaster, self, "modifier_siglos_mind_control", {Duration = 6})
	local hHeroCreated = self.hHeroCreated
	Timers:CreateTimer(5, function () UTIL_Remove(hHeroCreated) end)
	self.hTarget:RemoveModifierByName("modifier_siglos_mind_control")
	self.hTarget:SetOrigin(vLastLocation)
	self.hTarget:SetForwardVector(vLastDirection)
	ParticleManager:DestroyParticle(self.iParticle, true)
end

function siglos_mind_control:CastFilterResultTarget(hTarget)
	if hTarget:IsCreep() then return UF_FAIL_CREEP end
	if hTarget:IsCourier() then return UF_FAIL_COURIER end
	if hTarget:IsBuilding() then return UF_FAIL_BUILDING end
	if not hTarget:IsHero() then return UF_FAIL_OTHER end
	return UF_SUCCESS
end

function siglos_mind_control:GetChannelAnimation() return ACT_DOTA_GENERIC_CHANNEL_1 end
function siglos_mind_control:GetChannelTime()
	local hCaster = self:GetCaster()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_siglos_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	local iChannelTime = self:GetSpecialValueFor("duration")
	if self.hSpecial then
		iChannelTime = iChannelTime+self.hSpecial:GetSpecialValueFor("value")
	end
	if IsClient() then return iChannelTime end
	if not hCaster:HasAbility(self:GetName()) then return iChannelTime end
	return iChannelTime*CalculateStatusResist(self:GetCursorTarget())
end
