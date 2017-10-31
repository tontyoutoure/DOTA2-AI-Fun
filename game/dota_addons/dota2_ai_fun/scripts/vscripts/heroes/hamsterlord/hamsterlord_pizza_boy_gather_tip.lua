function hamsterlord_pizza_boy_gather_tip( keys )
	local caster = keys.caster
	local playerId = caster:hero:GetOwner():GetPlayerID()

	if(target:GetMaxMana() > 0) then
		local manaDrained = ability:GetSpecialValueFor("mana_drained")	
		if target:GetMana() < manaDrained then
			manaDrained = target:GetMana()
		end	
		caster:GiveMana(manaDrained)
		target:ReduceMana(manaDrained)
		target:EmitSound("Hero_Antimage.ManaBreak")
	end
end