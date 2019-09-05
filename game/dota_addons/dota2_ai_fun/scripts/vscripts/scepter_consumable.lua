item_ultimate_scepter = class({})
function item_ultimate_scepter:OnSpellStart()
	if not self:GetCaster():HasModifier('modifier_item_ultimate_scepter_consumed') then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_item_ultimate_scepter_consumed', {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_item_ultimate_scepter', {})
		self:GetCaster():RemoveItem(self)
		self:GetCaster():EmitSound('Hero_Alchemist.Scepter.Cast')
	end
end

function item_ultimate_scepter:GetIntrinsicModifierName()
	return 'modifier_item_ultimate_scepter'
end