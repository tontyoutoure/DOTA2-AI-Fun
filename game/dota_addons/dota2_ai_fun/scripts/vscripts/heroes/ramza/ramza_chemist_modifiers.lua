modifier_ramza_chemist_items_phoenix_down = class({})

function modifier_ramza_chemist_items_phoenix_down:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION
	}
end

function modifier_ramza_chemist_items_phoenix_down:GetTexture() return "phoenix_icarus_dive" end
function modifier_ramza_chemist_items_phoenix_down:IsBuff() return true end
function modifier_ramza_chemist_items_phoenix_down:IsPurgable() return false end
function modifier_ramza_chemist_items_phoenix_down:RemoveOnDeath() return false end

function modifier_ramza_chemist_items_phoenix_down:OnCreated() 
	if IsClient() then return end
	self.fReincarnateTime = self:GetAbility():GetSpecialValueFor("reincarnate_time")
end

function modifier_ramza_chemist_items_phoenix_down:ReincarnateTime()
	if IsClient() then return -1 end
	print("Reincarnate by phoenix down")
	local hParent = self:GetParent()
	Timers:CreateTimer(self.fReincarnateTime+0.04, function ()
		iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, hParent)
		hParent:EmitSound("Hero_Phoenix.SuperNova.Explode")
		self:Destroy()
	end)
	CreateModifierThinker(hParent, nil, "modifier_ramza_chemist_items_phoenix_down_thinker", {Duration = self.fReincarnateTime}, hParent:GetOrigin(), hParent:GetTeamNumber() ,false)
	hParent.fReincarnateTime = self.fReincarnateTime
	return self.fReincarnateTime
end

modifier_ramza_chemist_items_phoenix_down_thinker = class({})

function modifier_ramza_chemist_items_phoenix_down_thinker:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	hParent:EmitSound("Hero_Phoenix.SuperNova.Begin")	
	hParent:EmitSound("Hero_Phoenix.SuperNova.Cast")
	self.iParticle=ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN, hParent)
end

function modifier_ramza_chemist_items_phoenix_down_thinker:OnDestroy()
	if IsClient() then return end
	StopSoundOn("Hero_Phoenix.SuperNova.Cast", self:GetParent())
end