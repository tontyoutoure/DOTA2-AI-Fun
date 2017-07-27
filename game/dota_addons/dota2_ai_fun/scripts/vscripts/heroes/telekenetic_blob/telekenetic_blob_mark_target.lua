function ResetLastTargetOnDestory(keys)
	local ability = keys.ability
	ability.lastCastTaget = nil
end

function SetLastTargetOnCreate(keys)
	local ability = keys.ability
	local newTarget = keys.target
	if ability.lastCastTaget ~= nil then
		local oldTarget = ability.lastCastTaget
		if oldTarget:HasModifier("modifier_telekenetic_blob_mark_target") and oldTarget ~= newTarget then
			oldTarget:RemoveModifierByName("modifier_telekenetic_blob_mark_target")
		end
	end
	ability.lastCastTaget = newTarget
end
