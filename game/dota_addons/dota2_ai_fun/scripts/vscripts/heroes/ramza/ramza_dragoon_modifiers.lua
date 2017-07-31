modifier_ramza_dragoon_dragonheart = class({})

function modifier_ramza_dragoon_dragonheart:DeclareFunctions()
	return {MODIFIER_PROPERTY_REINCARNATION}
end

function modifier_ramza_dragoon_dragonheart:OnCreated()
	local hAbility = self:GetAbility()
	self.iReincarnateTime = hAbility:GetSpecialValueFor("reincarnate_time")
	self.iCooldown = hAbility:GetCooldown(0)
end


function modifier_ramza_dragoon_dragonheart:ReincarnateTime()
	local bIsCooldownReady
	local hParent = self:GetParent()
	if hParent:HasAbility("ramza_dragoon_dragonheart") 
		then bIsCooldownReady = hParent:FindAbilityByName("ramza_dragoon_dragonheart"):IsCooldownReady()
		if bIsCooldownReady then
			hParent:FindAbilityByName("ramza_dragoon_dragonheart"):UseResources()
			return self.iReincarnateTime
		else
			return -1
		end
	else
		bIsCooldownReady = hParent:AddAbility("ramza_dragoon_dragonheart"):IsCooldownReady()
		if bIsCooldownReady then
			hParent:FindAbilityByName("ramza_dragoon_dragonheart"):UseResources()			
			hParent:RemoveAbility("ramza_dragoon_dragonheart")
			return self.iReincarnateTime
		else
			hParent:RemoveAbility("ramza_dragoon_dragonheart")
			return -1
		end
	end

end

modifier_ramza_dragoon_jump = class({})

function modifier_ramza_dragoon_jump:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MUTED] = true,		
	}
end


function modifier_ramza_dragoon_jump:OnCreated()
	if IsClient() then return end	
	self:ApplyVerticalMotionController()
	self:ApplyHorizontalMotionController()
end

function modifier_ramza_dragoon_jump:OnDestroy()
	if IsClient() then return end
	hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	hParent:RemoveVerticalMotionController(self)
	hParent:SetOrigin(GetGroundPosition(hParent:GetOrigin()))
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
end

function modifier_ramza_dragoon_jump:UpdateHorizontalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vHorizantalSpeed)
end

function modifier_ramza_dragoon_jump:UpdateVerticalMotion(me, dt)
	me:SetOrigin(me:GetOrigin()+dt*self.vVerticalSpeed+dt*dt*vVerticalAcceleration/2)
	vVerticalSpeed = vVerticalSpeed+dt*vVerticalAcceleration
end