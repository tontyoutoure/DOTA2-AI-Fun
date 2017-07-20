function formless_copy_skill(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  local targetAbility = target:GetAbilityByIndex(keys.abilityIndexToCopy)
  if targetAbility ~= nil and caster ~= target then
    local targetAbilityName = targetAbility:GetAbilityName()
    caster:AddAbility(targetAbilityName)
    caster:SwapAbilities(ability:GetAbilityName(), targetAbilityName, false, true)
    caster:FindAbilityByName(targetAbilityName):SetLevel(originalLevel)
  end
end

function formless_unus(keys)
  keys.abilityIndexToCopy = 0
  formless_copy_skill(keys)
end

function formless_duos(keys)
  keys.abilityIndexToCopy = 1
  formless_copy_skill(keys)
end

function formless_tertius(keys)
  keys.abilityIndexToCopy = 2
  formless_copy_skill(keys)
end

function formless_denique(keys)
  keys.abilityIndexToCopy = 3
  local target = keys.target
  for i = target:GetAbilityCount(), 0, -1 do  
	local ability = target:GetAbilityByIndex(i)
    if ability ~= nil and ability:GetAbilityType() == 1 then
      keys.abilityIndexToCopy = i
	  formless_copy_skill(keys)
      return
    end
  end
end

