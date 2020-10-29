modifier_attributes_mp_regen_adjustment = class({})

function modifier_attributes_mp_regen_adjustment:GetAttributes()
  return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_attributes_mp_regen_adjustment:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
  }
  return funcs
end


function modifier_attributes_mp_regen_adjustment:GetModifierConstantManaRegen()
  if IsServer() then
    local parent = self:GetParent()
    local current_regen = parent:GetBaseManaRegen()-- + parent:GetIntellect() * 0.15

    if parent:GetManaRegenMultiplier() > 1.1 then
      local difference = current_regen / (parent:GetManaRegenMultiplier())

      self:SetStackCount(math.max((difference * 100), 1))
    else
      self:SetStackCount(1)
    end   
  end
  
  return self:GetStackCount() / -100
end

function modifier_attributes_mp_regen_adjustment:IsHidden()
  return true
end

function modifier_attributes_mp_regen_adjustment:IsDebuff()
  return false
end

function modifier_attributes_mp_regen_adjustment:RemoveOnDeath()
  return false
end
