function MagicDragonInit(hHero)
	if hHero:IsIllusion() then
		MagicDragonTransform[hHero:GetOwner():GetAssignedHero().iDragonForm](hHero)
	elseif not hHero.bSpawned then
		require("heroes/magic_dragon/magic_dragon_transform")	
		MagicDragonTransform[MAGIC_DRAGON_GREEN_DRAGON_FORM](hHero)		
		hHero.bSpawned = true;
	end
end