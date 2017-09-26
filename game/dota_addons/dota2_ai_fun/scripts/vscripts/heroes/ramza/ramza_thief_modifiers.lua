modifier_ramza_thief_gil_snapper = class({})

function modifier_ramza_thief_gil_snapper:IsPurgable() return false end
function modifier_ramza_thief_gil_snapper:IsHidden() return true end
function modifier_ramza_thief_gil_snapper:RemoveOnDeath() return false end

function modifier_ramza_thief_gil_snapper:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_ramza_thief_gil_snapper:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	iGold = math.floor(keys.damage/10)
	PlayerResource:ModifyGold(keys.unit:GetOwner():GetPlayerID(), iGold, false, DOTA_ModifyGold_Unspecified)
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.unit)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGold))+2, 100))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
	
	local iParticle2 = ParticleManager:CreateParticle("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
	ParticleManager:SetParticleControl(iParticle2, 0, keys.unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticle2, 1, keys.unit:GetAbsOrigin())
end