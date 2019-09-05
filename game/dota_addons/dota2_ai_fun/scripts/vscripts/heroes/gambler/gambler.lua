LinkLuaModifier("modifier_gambler_ante_up", "heroes/gambler/gambler_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gambler_lucky_stars", "heroes/gambler/gambler_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

gambler_ante_up = class({})


function gambler_ante_up:CastFilterResultTarget(hTarget)
	if self:GetCaster() == hTarget then return UF_FAIL_CUSTOM end
	if hTarget:IsBuilding() then return UF_FAIL_BUILDING end
	if not hTarget:IsHero() then return UF_FAIL_CREEP end
end

function gambler_ante_up:GetCustomCastErrorTarget(hTarget)
	return "#dota_hud_error_cant_cast_on_self"
end

function gambler_ante_up:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	if hTarget:GetTeam() ~= hCaster:GetTeam() then
		if hTarget:TriggerSpellAbsorb( self ) then return end
		hCaster:EmitSound("Hero_BountyHunter.Target")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)		
		ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "follow_origin", hTarget:GetOrigin(), true)
		ApplyDamage({attacker = hCaster, victim = hTarget, damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType(), ability = self})
		hTarget:AddNewModifier(hCaster, self, "modifier_gambler_ante_up", {Duration = self:GetSpecialValueFor("buff_duration")*CalculateStatusResist(hTarget)})
	else
		hCaster:EmitSound("Hero_BountyHunter.Target")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)		
		ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "follow_origin", hTarget:GetOrigin(), true)
		local iHeal = self:GetSpecialValueFor("heal")
		hTarget:Heal(iHeal, hCaster)
		hTarget:AddNewModifier(hCaster, self, "modifier_gambler_ante_up", {Duration = self:GetSpecialValueFor("buff_duration")})
		local iParticle2 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hTarget, hTarget:GetPlayerOwner())		
		ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(iHeal), 0))
		ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(iHeal)), 200))
		ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
	end
	if hCaster:HasAbility("special_bonus_unique_gambler_3") and hCaster:FindAbilityByName("special_bonus_unique_gambler_3"):GetLevel() > 0 then		
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)		
		ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
		local iHeal = self:GetSpecialValueFor("heal")
		hCaster:Heal(iHeal, hCaster)
		hCaster:AddNewModifier(hCaster, self, "modifier_gambler_ante_up", {Duration = self:GetSpecialValueFor("buff_duration")})
		local iParticle2 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hCaster, hCaster:GetPlayerOwner())		
		ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(iHeal), 0))
		ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(iHeal)), 200))
		ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
	end
end

gambler_chip_stack = class({})
function gambler_chip_stack:GetCooldown(iLevel)
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_gambler_4" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end
function gambler_chip_stack:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	if hTarget:TriggerSpellAbsorb( self ) then return end
	local iDamagePercentage = self:GetSpecialValueFor("gold_percentage_damage")
	
	ApplyDamage({victim = hTarget, attacker = hCaster, ability = self, damage = iDamagePercentage/100*hTarget:GetGold(), damage_type = self:GetAbilityDamageType()})	
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(iParticle, 0, hTarget, PATTACH_POINT_FOLLOW, "follow_origin", hTarget:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
	hTarget:EmitSound("General.Coins")
end

gambler_lucky_stars = class({})

function gambler_lucky_stars:GetIntrinsicModifierName() return "modifier_gambler_lucky_stars" end

gambler_all_in = class({})

function gambler_all_in:GetBehavior()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_gambler_5" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		return DOTA_ABILITY_BEHAVIOR_POINT+DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function gambler_all_in:GetAOERadius()
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		return self.hSpecial:GetSpecialValueFor("value")
	else
		return 0
	end
end

function gambler_all_in:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	local iFailChance = self:GetSpecialValueFor("fail_chance")
	local iDamageCap = self:GetSpecialValueFor("damage_cap")
	if hCaster:HasScepter() then
		iChance = self:GetSpecialValueFor("fail_chance_scepter")		
	end
	local iDamage = RandomFloat(0, hCaster:GetGold())
	if iDamage > iDamageCap and not hCaster:HasScepter() then iDamage = iDamageCap end
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then	
		if RandomFloat(0, 100) > iFailChance then
			local tTargets = FindUnitsInRadius(hCaster:GetTeam(), self:GetCursorPosition(), nil, self.hSpecial:GetSpecialValueFor("value"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for k, v in ipairs(tTargets) do
				ApplyDamage({victim = v, attacker = hCaster, ability = self, damage = iDamage, damage_type = self:GetAbilityDamageType()})
				hCaster:EmitSound("DOTA_Item.Hand_Of_Midas")
				local iParticle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
				ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetOrigin(), true)
				
				local iParticle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
				ParticleManager:SetParticleControlEnt(iParticle2, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticle2, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_attack3", hCaster:GetOrigin(), true)
				ParticleManager:SetParticleControl(iParticle2, 15, Vector(255,202,21))
				ParticleManager:SetParticleControl(iParticle2, 16, Vector(1,0,0))
			end
		else
			local iUnreliableGoldLoss = PlayerResource:ModifyGold(hCaster:GetPlayerOwnerID(), -iDamage, false, DOTA_ModifyGold_Unspecified)
			if -iUnreliableGoldLoss < math.floor(iDamage) then
				PlayerResource:ModifyGold(hCaster:GetPlayerOwnerID(), -iUnreliableGoldLoss-iDamage, true, DOTA_ModifyGold_Unspecified)
			end
			hCaster:EmitSound("DOTA_Item.Hand_Of_Midas")
			local iParticle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
			ParticleManager:SetParticleControl(iParticle, 1, hCaster:GetOrigin()+Vector(0,0,2000))
			
			local iParticle1 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, hCaster, hCaster:GetPlayerOwner())
			ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, iDamage, 0))
			ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iDamage))+2, 100))
			ParticleManager:SetParticleControl(iParticle1, 3, Vector(255,202,21))
		end	
	else		
		if hTarget:TriggerSpellAbsorb( self ) then return end
		if RandomFloat(0, 100) > iFailChance then
			ApplyDamage({victim = hTarget, attacker = hCaster, ability = self, damage = iDamage, damage_type = self:GetAbilityDamageType()})
			hCaster:EmitSound("DOTA_Item.Hand_Of_Midas")
			local iParticle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
			
			local iParticle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(iParticle2, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticle2, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_attack3", hCaster:GetOrigin(), true)
			ParticleManager:SetParticleControl(iParticle2, 15, Vector(255,202,21))
			ParticleManager:SetParticleControl(iParticle2, 16, Vector(1,0,0))
		else
			local iUnreliableGoldLoss = PlayerResource:ModifyGold(hCaster:GetPlayerOwnerID(), -iDamage, false, DOTA_ModifyGold_Unspecified)
			if -iUnreliableGoldLoss < math.floor(iDamage) then
				PlayerResource:ModifyGold(hCaster:GetPlayerOwnerID(), -iUnreliableGoldLoss-iDamage, true, DOTA_ModifyGold_Unspecified)
			end
			hCaster:EmitSound("DOTA_Item.Hand_Of_Midas")
			local iParticle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
			ParticleManager:SetParticleControl(iParticle, 1, hCaster:GetOrigin()+Vector(0,0,2000))
			
			local iParticle1 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, hCaster, hCaster:GetPlayerOwner())
			ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, iDamage, 0))
			ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iDamage))+2, 100))
			ParticleManager:SetParticleControl(iParticle1, 3, Vector(255,202,21))
		end	
	end
end