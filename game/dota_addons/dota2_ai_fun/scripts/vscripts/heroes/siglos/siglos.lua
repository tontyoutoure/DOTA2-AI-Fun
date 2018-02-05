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

function siglos_mind_control:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then 
		hCaster:Interrupt() return end
	if not hCaster:HasAbility(self:GetName()) then return end
	local iChannelTime = self:GetSpecialValueFor("duration")
	if self:GetCaster():HasAbility("special_bonus_unique_siglos_3") then
		iChannelTime = iChannelTime+self:GetCaster():FindAbilityByName("special_bonus_unique_siglos_3"):GetSpecialValueFor("value")
	end
	if hCaster:GetTeam() == hTarget:GetTeam() then
		hCaster:Interrupt()
		self:RefundManaCost()
		self:EndCooldown()
		return 
	end
	hTarget:AddNewModifier(hCaster, self, "modifier_siglos_mind_control", {Duration = iChannelTime*CalculateStatusResist(hTarget)})
	hTarget:AddNewModifier(hCaster, self, "modifier_siglos_mind_control_magic_immune", {Duration = iChannelTime*CalculateStatusResist(hTarget)})
	if hCaster:HasScepter() then
		hCaster:AddNewModifier(hCaster, self, "modifier_siglos_mind_control_magic_immune", {Duration = iChannelTime*CalculateStatusResist(hTarget)})
	end
end
function siglos_mind_control:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	hCaster:RemoveModifierByName("modifier_siglos_mind_control_magic_immune")
	local hTarget = self:GetCursorTarget()
	if not hTarget then return end
	hTarget:RemoveModifierByName("modifier_siglos_mind_control")
	hTarget:RemoveModifierByName("modifier_siglos_mind_control_magic_immune")
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
