function formless_unus(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  local targetAbility = target:GetAbilityByIndex(0)
  if targetAbility ~= nil and caster ~= target then
    local targetAbilityName = targetAbility:GetAbilityName()
    caster:AddAbility(targetAbilityName)
    caster:SwapAbilities(ability:GetAbilityName(), targetAbilityName, false, true)
    caster:FindAbilityByName(targetAbilityName):SetLevel(originalLevel)
  end
end

function formless_duos(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  local targetAbility = target:GetAbilityByIndex(1)
  if targetAbility ~= nil and caster ~= target then
    local targetAbilityName = targetAbility:GetAbilityName()
    caster:AddAbility(targetAbilityName)
    caster:SwapAbilities(ability:GetAbilityName(), targetAbilityName, false, true)
    caster:FindAbilityByName(targetAbilityName):SetLevel(originalLevel)
  end
end

function formless_tertius(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  local targetAbility = target:GetAbilityByIndex(2)
  if targetAbility ~= nil and caster ~= target then
    local targetAbilityName = targetAbility:GetAbilityName()
    caster:AddAbility(targetAbilityName)
    caster:SwapAbilities(ability:GetAbilityName(), targetAbilityName, false, true)
    caster:FindAbilityByName(targetAbilityName):SetLevel(originalLevel)
  end
end

function formless_denique(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  for i = target:GetAbilityCount(), 0, -1 do  
    local targetAbility = target:GetAbilityByIndex(i)
    if targetAbility ~= nil and caster ~= target and targetAbility:GetAbilityType() == 1 then
      local targetAbilityName = targetAbility:GetAbilityName()
      caster:AddAbility(targetAbilityName)
      caster:SwapAbilities(ability:GetAbilityName(), targetAbilityName, false, true)
      caster:FindAbilityByName(targetAbilityName):SetLevel(originalLevel)
      return
    end
  end
end

function formless_unus_forget(keys)
  local caster = keys.caster
  local currentAbilityName = caster:GetAbilityByIndex(0):GetName()
  local currentAbilityLevel = caster:GetAbilityByIndex(0):GetLevel()
  if currentAbilityName ~= "formless_unus" then
    caster:SwapAbilities(currentAbilityName, "formless_unus", false, true)
    caster:RemoveAbility(currentAbilityName)
    caster:FindAbilityByName("formless_unus"):SetLevel(currentAbilityLevel)
  else
    local ability = keys.ability
    ability:EndCooldown()
  end
end

function formless_duos_forget(keys)
  local caster = keys.caster
  local currentAbilityName = caster:GetAbilityByIndex(1):GetName()
  local currentAbilityLevel = caster:GetAbilityByIndex(1):GetLevel()
  if currentAbilityName ~= "formless_duos" then
    caster:SwapAbilities(currentAbilityName, "formless_duos", false, true)
    caster:RemoveAbility(currentAbilityName)
    caster:FindAbilityByName("formless_duos"):SetLevel(currentAbilityLevel)
  else
    local ability = keys.ability
    ability:EndCooldown()
  end
end

function formless_tertius_forget(keys)
  local caster = keys.caster
  local currentAbilityName = caster:GetAbilityByIndex(2):GetName()
  local currentAbilityLevel = caster:GetAbilityByIndex(2):GetLevel()
  if currentAbilityName ~= "formless_tertius" then
    caster:SwapAbilities(currentAbilityName, "formless_tertius", false, true)
    caster:RemoveAbility(currentAbilityName)
    caster:FindAbilityByName("formless_tertius"):SetLevel(currentAbilityLevel)
  else
    local ability = keys.ability
    ability:EndCooldown()
  end
end

function formless_denique_forget(keys)
  local caster = keys.caster
  local currentAbilityName = caster:GetAbilityByIndex(5):GetName()
  local currentAbilityLevel = caster:GetAbilityByIndex(5):GetLevel()
  if currentAbilityName ~= "formless_denique" then
    caster:SwapAbilities(currentAbilityName, "formless_denique", false, true)
    caster:RemoveAbility(currentAbilityName)
    caster:FindAbilityByName("formless_denique"):SetLevel(currentAbilityLevel)
  else
    local ability = keys.ability
    ability:EndCooldown()
  end
end


function formless_show_unus_forget_on_unus_levelup(keys)
  local caster = keys.caster
  local ability = keys.ability
  if ability:GetLevel() == 1 then
    local forget = caster:FindAbilityByName("formless_unus_forget")
    forget:SetLevel(1)
    forget:SetHidden(false)
  end
end

function formless_show_duos_forget_on_duos_levelup(keys)
  local caster = keys.caster
  local ability = keys.ability
  if ability:GetLevel() == 1 then
    local forget = caster:FindAbilityByName("formless_duos_forget")
    forget:SetLevel(1)
    forget:SetHidden(false)
  end
end

function formless_show_tertius_forget_on_tertius_levelup(keys)
  local caster = keys.caster
  local ability = keys.ability
  if ability:GetLevel() == 1 then
    local forget = caster:FindAbilityByName("formless_tertius_forget")
    forget:SetLevel(1)
    forget:SetHidden(false)
  end
end

function formless_show_denique_forget_on_denique_levelup(keys)
  local caster = keys.caster
  local ability = keys.ability
  if ability:GetLevel() == 1 then
    local forget = caster:FindAbilityByName("formless_denique_forget")
    forget:SetLevel(1)
    forget:SetHidden(false)
  end
end
