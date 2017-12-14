modifier_spongebob_krabby_food = class({})
function modifier_spongebob_krabby_food:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_spongebob_krabby_food:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	if self:GetCaster():HasScepter() then 
		self.iHeal = self:GetAbility():GetSpecialValueFor("heal_scepter") 
	else
		self.iHeal = self:GetAbility():GetSpecialValueFor("heal") 
	end
	local fHealthRestore = self.iHeal
	if fHealthRestore > hParent:GetMaxHealth() - hParent:GetHealth() then fHealthRestore = hParent:GetMaxHealth() - hParent:GetHealth() end
	
	if fHealthRestore > 0 then
		local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hParent)		
		ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fHealthRestore), 0))
		ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fHealthRestore)), 200))
		ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
	end
	self:GetParent():Heal(self.iHeal, self:GetCaster())
	self:StartIntervalThink(1)
end

function modifier_spongebob_krabby_food:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	
	local fHealthRestore = self.iHeal
	if fHealthRestore > hParent:GetMaxHealth() - hParent:GetHealth() then fHealthRestore = hParent:GetMaxHealth() - hParent:GetHealth() end
	
	if fHealthRestore > 0 then
		local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hParent)		
		ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fHealthRestore), 0))
		ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fHealthRestore)), 200))
		ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
	end
	self:GetParent():Heal(self.iHeal, self:GetCaster())
end

function modifier_spongebob_krabby_food:IsPurgable() return false end

function modifier_spongebob_krabby_food:GetEffectName()
	return "particles/healing_flask_modified.vpcf"
end

function modifier_spongebob_krabby_food:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_spongebob_spongify = class({})

function modifier_spongebob_spongify:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end
function modifier_spongebob_spongify:IsHidden() return true end
function modifier_spongebob_spongify:OnAttackLanded(keys)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local bGenerateIllusion
	if keys.target == hParent and not keys.target:IsIllusion() then
		bGenerateIllusion = (RandomInt(1, 100) <= self:GetAbility():GetSpecialValueFor("chance"))
	end
	if keys.attacker == hParent and not keys.attacker:IsIllusion() and keys.attacker:HasAbility("special_bonus_spongebob_3") and keys.attacker:FindAbilityByName("special_bonus_spongebob_2"):GetLevel() > 0 then
		bGenerateIllusion = (RandomInt(1, 100) <= self:GetAbility():GetSpecialValueFor("chance"))
	end
	if bGenerateIllusion then
		if hAbility:IsOwnersManaEnough() then
			local fHealthRestore = hAbility:GetSpecialValueFor("heal")
			if fHealthRestore > hParent:GetMaxHealth() - hParent:GetHealth() then fHealthRestore = hParent:GetMaxHealth() - hParent:GetHealth() end
			
			if fHealthRestore > 0 then
				local iParticle2 = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_POINT_FOLLOW, hParent)		
				ParticleManager:SetParticleControl(iParticle2, 1, Vector(0, math.floor(fHealthRestore), 0))
				ParticleManager:SetParticleControl(iParticle2, 2, Vector(1, 2+math.floor(math.log10(fHealthRestore)), 200))
				ParticleManager:SetParticleControl(iParticle2, 3, Vector(60, 255, 60))
			end
			hParent:Heal(hAbility:GetSpecialValueFor("heal"), hParent)
			hAbility:UseResources(true, true, true)
		end
		
		local hIllusion = CreateUnitByName(hParent:GetUnitName(), hParent:GetOrigin()+RandomVector(100), true, hParent, hParent, hParent:GetTeamNumber())
		hIllusion:SetPlayerID(hParent:GetPlayerID())
		hIllusion:SetControllableByPlayer(hParent:GetPlayerID(), true)
		for i = 2, hParent:GetLevel() do
			hIllusion:HeroLevelUp(false)
		end
		for i = 0, 8 do
			local hItem = hParent:GetItemInSlot(i)
			if hItem then
				hIllusion:AddItemByName(hItem:GetName()):SetCurrentCharges(hItem:GetCurrentCharges())
			end
		end
		
		hIllusion:AddNewModifier(hCaster, hAbility, "modifier_illusion", { duration = hAbility:GetSpecialValueFor("duration"), outgoing_damage = hAbility:GetSpecialValueFor("illusion_outgoing_damage"), incoming_damage = hAbility:GetSpecialValueFor("illusion_incoming_damage") })
		hIllusion:MakeIllusion()
		if hParent:GetAttackTarget() then
			ExecuteOrderFromTable({
				UnitIndex = hIllusion:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = hParent:GetAttackTarget():entindex()
			})
		else
			ExecuteOrderFromTable({
				UnitIndex = hIllusion:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hParent:GetOrigin()
			})
		end
	end
end


















