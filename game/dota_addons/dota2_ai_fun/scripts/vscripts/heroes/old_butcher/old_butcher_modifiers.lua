local tNecrogenesisModifiers = {'modifier_old_butcher_necrogenesis_ghoul', 'modifier_old_butcher_necrogenesis_rifleman', 'modifier_old_butcher_necrogenesis_tauren', 'modifier_old_butcher_necrogenesis_huntress'}
local OLD_BUTCHER_LAYOUT_SELECT = 1
local OLD_BUTCHER_LAYOUT_DROP = 2
local OLD_BUTCHER_CORPSE_DURATION = 15

local tSafeOrder
if IsServer() then
tSafeOrder = {
	[DOTA_UNIT_ORDER_TRAIN_ABILITY] = true, 
	[DOTA_UNIT_ORDER_PURCHASE_ITEM] = true, 
	[DOTA_UNIT_ORDER_SELL_ITEM] = true, 
	[DOTA_UNIT_ORDER_DISASSEMBLE_ITEM] = true, 
	[DOTA_UNIT_ORDER_MOVE_ITEM] = true, 
	[DOTA_UNIT_ORDER_TAUNT] = true, 
	[DOTA_UNIT_ORDER_GLYPH] = true, 
	[DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH] = true, 
	[DOTA_UNIT_ORDER_PING_ABILITY] = true, 
	[DOTA_UNIT_ORDER_RADAR] = true, 
	[DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK] = true,
	[DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO] = true
}
end

local tBaseFTF = {
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return true end,
	RemoveOnDeath = function(self) return false end,}
modifier_old_butcher_summon_check = class(tBaseFTF)

function modifier_old_butcher_summon_check:OnDestroy()
	if self:GetParent():HasModifier('modifier_kill') then
		self:GetParent().bSummon = true
	end
end

modifier_old_butcher_stitch = class({})
function modifier_old_butcher_stitch:OnCreated()
	if IsClient() then return end
	if CheckTalent(self:GetCaster(), 'special_bonus_unique_old_butcher_6') >0 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_old_butcher_avatar', {})
	end
	self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),'modifier_kill',{Duration=self:GetAbility():GetSpecialValueFor('duration')})
end
function modifier_old_butcher_stitch:IsPurgable() return false end
function modifier_old_butcher_stitch:RemoveOnDeath() return false end

modifier_old_butcher_stitch_visual = class(tBaseFTF)

function modifier_old_butcher_stitch_visual:GetStatusEffectName() return 'particles/status_fx/status_effect_doom.vpcf' end

modifier_old_butcher_carrion_beetle = class({
	IsPurgable = function(self) return false end,
	IsHidden = function(self) return true end,
	RemoveOnDeath = function(self) return false end,
})
function modifier_old_butcher_carrion_beetle:OnCreated()
	if IsClient() then return end
	if CheckTalent(self:GetCaster(), 'special_bonus_unique_old_butcher_6')>0 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_old_butcher_avatar', {})
	end
end
function modifier_old_butcher_carrion_beetle:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_old_butcher_carrion_beetle:OnDeath(keys) 
	if self:GetParent() ~= keys.unit then return end
	local hCaster = self:GetCaster()
	for i, v in ipairs(hCaster.tBeetles) do
		if keys.unit == v then
			table.remove(hCaster.tBeetles, i)
			return
		end
	end
end
modifier_old_butcher_autocast_manager = class(tBaseFTF)
function modifier_old_butcher_autocast_manager:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end
function modifier_old_butcher_autocast_manager:OnOrder(keys)
	if keys.unit ~= self:GetParent() or keys.issuer_player_index < 0 then return end
	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then 
		self.bAttackMoving = true
		self.bStop = false
		self.vTargetPos = keys.new_pos
		return
	end
	if keys.order_type == DOTA_UNIT_ORDER_CONTINUE then
		self.bStop = true
		self.bAttackMoving = false
		return
	end
	if tSafeOrder[keys.order_type] then return end
	self.bAttackMoving = false
	self.bStop = false
end

function modifier_old_butcher_autocast_manager:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end
function modifier_old_butcher_autocast_manager:OnIntervalThink()
	if IsClient() or self:GetParent():IsIllusion() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsFullyCastable() and hAbility:CastFilterResult() == UF_SUCCESS and hAbility:GetAutoCastState() and not hAbility:IsInAbilityPhase() and self.bAttackMoving then
		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), OrderType=DOTA_UNIT_ORDER_STOP})
		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), Queue = 1, OrderType=DOTA_UNIT_ORDER_CAST_NO_TARGET, AbilityIndex=hAbility:entindex()})
		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), Queue = 2, OrderType=DOTA_UNIT_ORDER_ATTACK_MOVE, Position=self.vTargetPos})
	end
	if hAbility:IsFullyCastable() and hAbility:CastFilterResult() == UF_SUCCESS and hAbility:GetAutoCastState() and not hAbility:IsInAbilityPhase() and self.bStop then

		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), Queue = 1, OrderType=DOTA_UNIT_ORDER_CAST_NO_TARGET, AbilityIndex=hAbility:entindex()})

	end
end
modifier_old_butcher_carrion_beetle_burrow = class({})
function modifier_old_butcher_carrion_beetle_burrow:IsPurgable() return false end
function modifier_old_butcher_carrion_beetle_burrow:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE, MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_PROPERTY_DISABLE_AUTOATTACK} end
function modifier_old_butcher_carrion_beetle_burrow:GetModifierModelChange()
	return 'models/heroes/nerubian_assassin/mound.vmdl'
end
function modifier_old_butcher_carrion_beetle_burrow:GetModifierAttackRangeBonus()
	return -500
end
function modifier_old_butcher_carrion_beetle_burrow:GetDisableAutoAttack() return 1 end
function modifier_old_butcher_carrion_beetle_burrow:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_ROOTED] = true} end
function modifier_old_butcher_carrion_beetle_burrow:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
	self.iParticle = ParticleManager:CreateParticle('particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end
function modifier_old_butcher_carrion_beetle_burrow:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end


modifier_old_butcher_necrogenesis_talent_manager = class(tBaseFTF)
function modifier_old_butcher_necrogenesis_talent_manager:OnCreated()
	self:GetAbility().hModifierTalent = self
	self.fRate = 1
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end
function modifier_old_butcher_necrogenesis_talent_manager:OnIntervalThink()
	if IsServer() and CheckTalent(self:GetCaster(), 'special_bonus_unique_old_butcher_2') > 0 then 
		self:SetStackCount(CheckTalent(self:GetCaster(), 'special_bonus_unique_old_butcher_2')*100-100) 
	end
end

modifier_old_butcher_necrogenesis = class(tBaseFTF)

function modifier_old_butcher_necrogenesis:OnCreated()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	hAbility.hModifier = self
	self:SetStackCount(1)
	if IsClient() then return end
	hParent:AddNewModifier(hParent, hAbility, 'modifier_old_butcher_necrogenesis_talent_manager', nil)
	self:GetAbility():UseResources(true, true, true)
	for i = 1,4 do
		hParent:AddNewModifier(hParent, hAbility, tNecrogenesisModifiers[i], {})
	end
	self:StartIntervalThink(self:GetAbility():GetCooldownTimeRemaining())
end

function modifier_old_butcher_necrogenesis:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local iTotalCount = 0
	local iMaxCount = hAbility:GetSpecialValueFor('max_count')
	if CheckTalent(self:GetCaster(), 'special_bonus_unique_old_butcher_2') > 0 then
		iMaxCount = iMaxCount*CheckTalent(self:GetCaster(), 'special_bonus_unique_old_butcher_2')
	end
	for i = 1,4 do
		iTotalCount = iTotalCount + hParent:FindModifierByName(tNecrogenesisModifiers[i]):GetStackCount() 
	end
	if hParent:PassivesDisabled() or iTotalCount >= iMaxCount then
		self:StartIntervalThink(0.04)
		return
	end
	hParent:FindModifierByName(tNecrogenesisModifiers[self:GetStackCount()]):IncrementStackCount()
	hAbility:UseResources(true, true, true)
	self:StartIntervalThink(hAbility:GetCooldownTimeRemaining())
end

local tNecrogenesisModifierBaseClass = {
	IsHidden = function (self) if self:GetStackCount() > 0 then return false else return true end end, 
	IsPurgable = function (self) return false end, 
	RemoveOnDeath = function (self) return false end,
	DeclareFunctions = function (self) return {MODIFIER_PROPERTY_TOOLTIP} end,
	OnTooltip = function (self) return self:GetStackCount() end}

modifier_old_butcher_necrogenesis_ghoul = class(tNecrogenesisModifierBaseClass)
modifier_old_butcher_necrogenesis_ghoul.GetTexture = function (self) return 'old_butcher_ghoul' end
	
modifier_old_butcher_necrogenesis_rifleman = class(tNecrogenesisModifierBaseClass)
modifier_old_butcher_necrogenesis_rifleman.GetTexture = function (self) return 'old_butcher_rifleman' end
	
modifier_old_butcher_necrogenesis_tauren = class(tNecrogenesisModifierBaseClass)
modifier_old_butcher_necrogenesis_tauren.GetTexture = function (self) return 'old_butcher_tauren' end
	
modifier_old_butcher_necrogenesis_huntress = class(tNecrogenesisModifierBaseClass)
modifier_old_butcher_necrogenesis_huntress.GetTexture = function (self) return 'old_butcher_huntress' end

modifier_old_butcher_rifleman_long_rifles = class(tBaseFTF)
function modifier_old_butcher_rifleman_long_rifles:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end
function modifier_old_butcher_rifleman_long_rifles:GetModifierAttackRangeBonus() 
	if self:GetParent():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor('bonus_attack_range') end
end

modifier_old_butcher_ghoul_ghoul_frenzy = class(tBaseFTF)
function modifier_old_butcher_ghoul_ghoul_frenzy:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_old_butcher_ghoul_ghoul_frenzy:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor('bonus_attack_speed') end
end
function modifier_old_butcher_ghoul_ghoul_frenzy:GetModifierMoveSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor('bonus_move_speed') end
end

local function CheckForPseudoRNGChance(hModifier)
	local iChance = hModifier:GetAbility():GetSpecialValueFor("chance")
	if iChance == 0 then return false end
	if hModifier:GetParent():HasAbility("special_bonus_unique_old_stealth_assassin_3")then 
		iChance = iChance+hModifier:GetParent():FindAbilityByName("special_bonus_unique_old_stealth_assassin_3"):GetSpecialValueFor("value")
	end
	if not hModifier.iChance or hModifier.iChance ~= iChance then
		hModifier.iChance = iChance
		hModifier.hRNG = PseudoRNG.create(iChance/100)		
	end
	return true
end

modifier_old_butcher_tauren_pulverize = class(tBaseFTF)
function modifier_old_butcher_tauren_pulverize:DeclareFunctions() return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED,} end


function modifier_old_butcher_tauren_pulverize:OnCreated()
	if IsClient() then return end
	CheckForPseudoRNGChance(self)
end

function modifier_old_butcher_tauren_pulverize:OnAttackStart(keys)
	if self:GetParent() ~= keys.attacker then return end
	if not CheckForPseudoRNGChance(self) then return end
	self.bPulverize = false
	if keys.target:GetTeam()~=keys.attacker:GetTeam() and not keys.target:IsBuilding() and self.hRNG:Next() then
		self.bPulverize = true
		if keys.attacker:GetModelName() == "models/heroes/earthshaker/earthshaker.vmdl" then
			StartAnimation(keys.attacker, {duration = (0.467)/1.7/keys.attacker:GetAttacksPerSecond(), activity=ACT_DOTA_CAST_ABILITY_1, rate=(0.69)/(0.467)*(keys.attacker:GetAttacksPerSecond()*1.7)*1})
		end
		self.hAttackingTarget = keys.target
	end
end


function modifier_old_butcher_tauren_pulverize:OnOrder(keys)
	if keys.unit ~= self:GetParent() or keys.unit:GetModelName() ~= "models/heroes/earthshaker/earthshaker.vmdl" then return end
	if tSafeOrder[keys.order_type] then return end
	if (keys.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and (not keys.ability or bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE)==0))
	or (keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.target ~= self.hAttackingTarget) then
		EndAnimation(keys.unit)
	end
end

function modifier_old_butcher_tauren_pulverize:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker then return end
	if self.bPulverize then
		keys.attacker:EmitSound("Hero_EarthShaker.Totem.Immortal")
		keys.attacker:EmitSound("Hero_EarthShaker.Totem.TI6.Layer")
		
		local iParticle = ParticleManager:CreateParticle("particles/old_butcher/earthshaker_totem_ti6_cast.vpcf", PATTACH_ABSORIGIN, keys.target)
	--	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, hAbility:GetSpecialValueFor('half_damage_radius'), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i, v in pairs(tTargets) do
			local tDamageTable = {attacker = keys.attacker, victim = v, damage_type = DAMAGE_TYPE_PHYSICAL, ability = hAbility}
			if (v:GetOrigin() - keys.target:GetOrigin()):Length2D() > hAbility:GetSpecialValueFor('full_damage_radius') then
				tDamageTable.damage = hAbility:GetSpecialValueFor('half_damage')
			else
				tDamageTable.damage = hAbility:GetSpecialValueFor('full_damage')
			end
			ApplyDamage(tDamageTable)
		end
	end
end
modifier_old_butcher_carrion_beetle_burrow_attack = class(tBaseFTF)
function modifier_old_butcher_carrion_beetle_burrow_attack:DeclareFunctions() return {MODIFIER_EVENT_ON_ORDER} end
function modifier_old_butcher_carrion_beetle_burrow_attack:OnOrder(keys)
	if keys.unit ~= self:GetParent() then return end
	if keys.order_type == DOTA_UNIT_ORDER_STOP then
		self.bStop = true
		self.hTarget = nil
	elseif keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		if key.target:IsItem() or keys.target:GetTeam() == self:GetParent():GetTeam() then
			self.bStop = false
			self.hTarget = nil
		else
			self.bStop = false
			self.hTarget = keys.target
		end
	elseif keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
		self.bStop = false
	end

end
function modifier_old_butcher_carrion_beetle_burrow_attack:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end
function modifier_old_butcher_carrion_beetle_burrow_attack:OnIntervalThink()
	if IsClient() then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local iRange = hAbility:GetSpecialValueFor('range')
	local iRadius = hAbility:GetSpecialValueFor('radius')
	local sEffectName
	if hAbility:IsHidden() or not hAbility:IsCooldownReady() or self.bStop then return end
	if not self.hTarget then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetOrigin(), nil, iRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #tTargets > 0 then
			self.hTarget = tTargets[1]
		end
	end
	if self.hTarget and not self.hTarget:IsNull() then
		if (self.hTarget:GetOrigin() - hParent:GetOrigin()):Length2D() > iRange or not self.hTarget:IsAlive() or self.hTarget:IsAttackImmune() then
			self.hTarget = nil
			return
		end
		if hParent:GetUnitName() == 'npc_dota_old_butcher_carrion_beetle_2' then
			sEffectName = 'particles/econ/items/nyx_assassin/nyx_assassin_ti6/nyx_assassin_impale_ti6.vpcf'
		elseif hParent:GetUnitName() == 'npc_dota_old_butcher_carrion_beetle_3' then
			sEffectName = 'particles/econ/items/nyx_assassin/nyx_assassin_ti6_witness/nyx_assassin_impale_ti6_witness.vpcf'
		else
			sEffectName = 'particles/econ/items/nyx_assassin/nyx_assassin_ti6/nyx_assassin_impale_ti6_gold.vpcf'
		end
		StartSoundEventFromPosition('Hero_NyxAssassin.Impale', hParent:GetOrigin())
		ProjectileManager:CreateLinearProjectile({
			Ability = hAbility,
        	EffectName = sEffectName,
        	vSpawnOrigin = hParent:GetAbsOrigin(),
        	fDistance = iRange,
        	fStartRadius = iRadius,
        	fEndRadius = iRadius,
        	Source = hParent,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = (self.hTarget:GetOrigin() - hParent:GetOrigin()):Normalized() * hAbility:GetSpecialValueFor('speed'),
			bProvidesVision = false
		})
		hAbility:UseResources(true, true, true)
	end
end	

modifier_old_butcher_carrion_fly_evade = class(tBaseFTF)
function modifier_old_butcher_carrion_fly_evade:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT, MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_DEATH} end
function modifier_old_butcher_carrion_fly_evade:GetModifierEvasion_Constant() 
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then return 0 end
	return self:GetAbility():GetSpecialValueFor('value')
end
function modifier_old_butcher_carrion_fly_evade:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker then return end
	keys.attacker:EmitSound('Hero_Weaver.ProjectileImpact')
end
function modifier_old_butcher_carrion_fly_evade:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hHero = hParent:GetPlayerOwner():GetAssignedHero()
	hHero.tFlies = hHero.tFlies or {}
	hHero.tFlies[hParent:entindex()] = hParent
	if CheckTalent(hHero, 'special_bonus_unique_old_butcher_6') > 0 then
		hParent:AddNewModifier(hHero, self:GetAbility(), 'modifier_old_butcher_avatar', {})
	end
end
function modifier_old_butcher_carrion_fly_evade:OnDeath(keys)
	if keys.unit ~= self:GetParent() then return end
	keys.unit:GetPlayerOwner():GetAssignedHero().tFlies[keys.unit:entindex()] = nil
end

modifier_old_butcher_carrion_fly_scepter = class(tBaseFTF)
function modifier_old_butcher_carrion_fly_scepter:DeclareFunctions() return {MODIFIER_PROPERTY_IS_SCEPTER} end
function modifier_old_butcher_carrion_fly_scepter:GetModifierScepter() return 1 end

modifier_old_butcher_carrion_fly_errosion = class(tBaseFTF)
function modifier_old_butcher_carrion_fly_errosion:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED} 
end
function modifier_old_butcher_carrion_fly_errosion:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker or keys.attacker:PassivesDisabled() or keys.target:IsBuilding() or keys.target:GetTeam() == keys.attacker:GetTeam() then return end
	local hAbility = self:GetAbility()

	keys.target:AddNewModifier(keys.attacker, hAbility, "modifier_old_butcher_carrion_fly_errosion_debuff", {Duration = CalculateStatusResist(keys.target)*hAbility:GetSpecialValueFor('duration')})
end
modifier_old_butcher_carrion_fly_errosion_debuff = class({})
function modifier_old_butcher_carrion_fly_errosion_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function modifier_old_butcher_carrion_fly_errosion_debuff:OnCreated()
	self:SetStackCount(1)
	if IsClient() then return end
	local hParent = self:GetParent()
	self.iParticle1 = ParticleManager:CreateParticle('particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_constant.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle1 , 0, hHero, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
	self.iParticle2 = ParticleManager:CreateParticle('particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_constant.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle2 , 0, hHero, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
	self.iParticle3 = ParticleManager:CreateParticle('particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_constant.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle3 , 0, hHero, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
	self.iParticle4 = ParticleManager:CreateParticle('particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_constant.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle4 , 0, hHero, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
end

function modifier_old_butcher_carrion_fly_errosion_debuff:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle1, true)
	ParticleManager:DestroyParticle(self.iParticle2, true)
	ParticleManager:DestroyParticle(self.iParticle3, true)
	ParticleManager:DestroyParticle(self.iParticle4, true)
end
function modifier_old_butcher_carrion_fly_errosion_debuff:OnRefresh()
	self:IncrementStackCount()
end
function modifier_old_butcher_carrion_fly_errosion_debuff:GetModifierIncomingDamage_Percentage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor('damage_percentage')
end

modifier_old_butcher_carrion_flies_autocast_manager = class(tBaseFTF)

function modifier_old_butcher_carrion_flies_autocast_manager:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end
function modifier_old_butcher_carrion_flies_autocast_manager:OnOrder(keys)
	if keys.unit ~= self:GetParent() or keys.issuer_player_index < 0 then return end
	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then 
		self.bAttackMoving = true
		self.bStop = false
		self.vTargetPos = keys.new_pos
		return
	end
	if keys.order_type == DOTA_UNIT_ORDER_CONTINUE then
		self.bStop = true
		self.bAttackMoving = false
		return
	end
	if tSafeOrder[keys.order_type] then return end
	self.bAttackMoving = false
	self.bStop = false
end

function modifier_old_butcher_carrion_flies_autocast_manager:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end
function modifier_old_butcher_carrion_flies_autocast_manager:OnIntervalThink()
	if IsClient() or self:GetParent():IsIllusion() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsFullyCastable() and hAbility:CastFilterResult() == UF_SUCCESS and hAbility:GetAutoCastState() and not hAbility:IsInAbilityPhase() and self.bAttackMoving then
		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), OrderType=DOTA_UNIT_ORDER_STOP})
		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), Queue = 1, OrderType=DOTA_UNIT_ORDER_CAST_NO_TARGET, AbilityIndex=hAbility:entindex()})
		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), Queue = 2, OrderType=DOTA_UNIT_ORDER_ATTACK_MOVE, Position=self.vTargetPos})
	end
	if hAbility:IsFullyCastable() and hAbility:CastFilterResult() == UF_SUCCESS and hAbility:GetAutoCastState() and not hAbility:IsInAbilityPhase() and self.bStop then

		ExecuteOrderFromTable({UnitIndex=hParent:entindex(), Queue = 1, OrderType=DOTA_UNIT_ORDER_CAST_NO_TARGET, AbilityIndex=hAbility:entindex()})

	end
end

modifier_old_butcher_avatar = class(tBaseFTF)
function modifier_old_butcher_avatar:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end
function modifier_old_butcher_avatar:GetStatusEffectName() return "particles/status_fx/status_effect_avatar.vpcf" end
function modifier_old_butcher_avatar:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_old_butcher_avatar:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end