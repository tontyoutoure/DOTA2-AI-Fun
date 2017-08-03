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

function modifier_ramza_chemist_items_phoenix_down:ReincarnateTime()
	if IsClient() then return 3 end
	local hParent = self:GetParent()
	Timers:CreateTimer(3+0.04, function ()
		iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, hParent)
		hParent:EmitSound("Hero_Phoenix.SuperNova.Explode")	
		self:Destroy()
	end)
	CreateModifierThinker(hParent, nil, "modifier_ramza_chemist_items_phoenix_down_thinker", {Duration = 3}, hParent:GetOrigin(), hParent:GetTeamNumber() ,false)
	return 3
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