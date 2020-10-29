modifier_attributes_hp_regen_adjustment = class({})

function modifier_attributes_hp_regen_adjustment:GetAttributes()
  return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_attributes_hp_regen_adjustment:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  }
  return funcs
end


function modifier_attributes_hp_regen_adjustment:GetModifierConstantHealthRegen()
  if IsServer() then
    local parent = self:GetParent()
    local current_regen = parent:GetBaseHealthRegen()-- + parent:GetStrength() * 0.25
    local difference = 0

    if parent:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
      difference = current_regen * (parent:GetStrength() * 0.0069)
    else
      difference = current_regen * (parent:GetStrength() * 0.0055)
    end

    --print("Current regen: " .. current_regen)
    --print("Difference: " .. difference)

    self:SetStackCount(difference * 100)
  end
  
  return self:GetStackCount() / -100
end


function modifier_attributes_hp_regen_adjustment:IsHidden()
  return true
end

function modifier_attributes_hp_regen_adjustment:IsDebuff()
  return false
end

function modifier_attributes_hp_regen_adjustment:RemoveOnDeath()
  return false
end
