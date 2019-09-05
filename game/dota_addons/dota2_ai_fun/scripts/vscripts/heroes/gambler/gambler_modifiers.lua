modifier_gambler_ante_up = class({})

function modifier_gambler_ante_up:DeclareFunctions() return {MODIFIER_EVENT_ON_HERO_KILLED} end

function modifier_gambler_ante_up:OnCreated()
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_trail_circle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_gambler_ante_up:OnDestroy()
	ParticleManager:DestroyParticle(self.iParticle, true)
end


function modifier_gambler_ante_up:OnHeroKilled(keys)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local iGold = self:GetAbility():GetSpecialValueFor("cash_in_kill")
	if hCaster:HasAbility("special_bonus_unique_gambler_1") then
		iGold = iGold+hCaster:FindAbilityByName("special_bonus_unique_gambler_1"):GetSpecialValueFor("value")
	end
	if keys.attacker == hParent then
		hCaster:ModifyGold(iGold, false, DOTA_ModifyGold_Unspecified)
		keys.target:EmitSound("General.CoinsBig")
		local iParticle2 = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_reward.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(iParticle2, 1, hParent, PATTACH_POINT_FOLLOW, "follow_origin", hParent:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle2, 2, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle2, 3, hParent, PATTACH_POINT_FOLLOW, "follow_origin", hParent:GetOrigin(), true)
		local iParticle1 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, hCaster, hCaster:GetPlayerOwner())
		ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold, 0))
		ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGold))+2, 100))
		ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
	elseif keys.target == hParent then
		if keys.target:IsIllusion() then return end
		hCaster:ModifyGold(iGold/2, false, DOTA_ModifyGold_Unspecified)
		keys.target:EmitSound("General.CoinsBig")
		local iParticle2 = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_reward.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(iParticle2, 1, hParent, PATTACH_POINT_FOLLOW, "follow_origin", hParent:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle2, 2, hCaster, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle2, 3, hParent, PATTACH_POINT_FOLLOW, "follow_origin", hParent:GetOrigin(), true)
		local iParticle1 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, hCaster, hCaster:GetPlayerOwner())
		ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold/2, 0))
		ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGold/2))+2, 100))
		ParticleManager:SetParticleControl(iParticle1, 3, Vector(255,202,21))
	end
	self:Destroy()
end

modifier_gambler_lucky_stars = class({})
function modifier_gambler_lucky_stars:DeclareFunctions() return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL, MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_gambler_lucky_stars:IsHidden() return true end
function modifier_gambler_lucky_stars:OnTakeDamage(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or keys.attacker:IsIllusion() or keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then return end
	self.iGold = self.iGold or 0
	if keys.unit:IsRealHero() then
		self.iGold = self.iGold+keys.damage/keys.unit:GetMaxHealth()*100
	elseif keys.unit:IsBuilding() or keys.unit:IsAncient() then
		self.iGold = self.iGold+keys.damage/keys.unit:GetMaxHealth()*50
	elseif keys.unit:IsIllusion() then
	else
		self.iGold = self.iGold+keys.damage/keys.unit:GetMaxHealth()*10
	end
	local iGoldGain = math.floor(self.iGold)
	if iGoldGain > 0 then
		self.iGold = self.iGold-iGoldGain
		PlayerResource:ModifyGold(keys.attacker:GetPlayerOwnerID(), iGoldGain, false, DOTA_ModifyGold_Unspecified)
		local iParticle1 = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.attacker, keys.attacker:GetPlayerOwner())
		ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGoldGain, 0))
		ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGoldGain))+2, 100))
		ParticleManager:SetParticleControl(iParticle1, 3, Vector(255,202,21))
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:SetParticleControlEnt(iParticle, 1, keys.attacker, PATTACH_POINT_FOLLOW, "follow_origin", keys.attacker:GetOrigin(), true)
	end
end
function modifier_gambler_lucky_stars:GetModifierProcAttack_BonusDamage_Physical(keys)
	if keys.target:GetTeam() == self:GetParent():GetTeam() then return 0 end
	if keys.attacker:IsIllusion() or keys.attacker:PassivesDisabled() then return end
	local iChance = self:GetAbility():GetSpecialValueFor("chance")
	if keys.attacker:HasAbility("special_bonus_unique_gambler_2") then
		iChance = iChance+keys.attacker:FindAbilityByName("special_bonus_unique_gambler_2"):GetSpecialValueFor("value")
	end
	local iDamage = self:GetAbility():GetSpecialValueFor("proc")
	if RandomFloat(0, 100) < iChance then
		if keys.target:IsHero() or keys.target:IsAncient() or keys.target:IsBuilding() then
			local iParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_crit.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
			ParticleManager:SetParticleControl(iParticle, 1, Vector(0, iDamage, 4))
			ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(iDamage))+2, 100))
			ParticleManager:SetParticleControl(iParticle, 3, Vector(255, 0, 0))
			keys.target:EmitSound("Hero_TemplarAssassin.Meld.Attack")
			return iDamage			
		else
			keys.target:Kill(self:GetAbility(), keys.attacker)
			return 0
		end
	else
		return 0
	end	
end