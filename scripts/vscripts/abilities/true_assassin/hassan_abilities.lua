
function OnPCBroked(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:RemoveModifierByName("modifier_ta_invis")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis_checker", {}) 
end

function OnPCActived(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis", {}) 
end

function OnPCRespawn(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis_checker", {}) 
end

function OnPCAbilityUsed(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	caster.LastActionTime = GameRules:GetGameTime() 
	caster:RemoveModifierByName("modifier_ta_invis")
	Timers:CreateTimer(keys.CastDelay, function() 
		if GameRules:GetGameTime() >= caster.LastActionTime + keys.CastDelay then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis", {}) 
			if not caster.IsPCImproved then PCStopOrder(keys) return end
		end
	end)
end

function OnPCAttacked(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	caster.LastActionTime = GameRules:GetGameTime() 

	caster:RemoveModifierByName("modifier_ta_invis")
	Timers:CreateTimer(keys.CastDelay, function() 
		if GameRules:GetGameTime() >= caster.LastActionTime + keys.CastDelay then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis", {}) 
			if not caster.IsPCImproved then PCStopOrder(keys) return end
		end
	end)
end

function OnPCMoved(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	if caster.IsPCImproved then return end
	caster.LastActionTime = GameRules:GetGameTime() 

	caster:RemoveModifierByName("modifier_ta_invis")
	Timers:CreateTimer(keys.CastDelay, function() 
		if GameRules:GetGameTime() >= caster.LastActionTime + keys.CastDelay then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis", {}) 
			if not caster.IsPCImproved then PCStopOrder(keys) return end
		end
	end)
end

function OnPCRespawn1(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	caster.LastActionTime = GameRules:GetGameTime() 
	caster:RemoveModifierByName("modifier_ta_invis")
	Timers:CreateTimer(keys.CastDelay, function() 
		if GameRules:GetGameTime() >= caster.LastActionTime + keys.CastDelay then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis", {}) 
			if not caster.IsPCImproved then PCStopOrder(keys) return end
		end
	end)
end

function OnPCDamageTaken(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	caster.LastActionTime = GameRules:GetGameTime() 
	caster:RemoveModifierByName("modifier_ta_invis")
	Timers:CreateTimer(keys.CastDelay, function() 
		if GameRules:GetGameTime() >= caster.LastActionTime + keys.CastDelay then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_invis", {}) 
			if not caster.IsPCImproved then PCStopOrder(keys) return end
		end
	end)
end

function PCStopOrder(keys)
	--keys.caster:Stop() 
	local stopOrder = {
		UnitIndex = keys.caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_HOLD_POSITION
	}
	ExecuteOrderFromTable(stopOrder) 
end

function OnDirkStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local stacks = caster:GetModifierStackCount("modifier_dirk_daggers_base", caster) or 0 
	local speed = ability:GetSpecialValueFor("speed")

	if target:GetName() == "npc_dota_ward_base" then 
		ability:EndCooldown()
		caster:GiveMana(ability:GetManaCost(1))
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Target")
		return
	end
	if stacks == 0 then 
		ability:EndCooldown()
		caster:GiveMana(ability:GetManaCost(1))
		SendErrorMessage(caster:GetPlayerOwnerID(), "#No_Daggers_Available")
		return
	elseif stacks > 1 then 
		ability:EndCooldown()
		caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, stacks - 1)
		caster:RemoveModifierByName("modifier_dirk_daggers_show")
		if not caster:HasModifier("modifier_dirk_daggers_progress") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dirk_daggers_progress", {})
		end
		caster:SetModifierStackCount("modifier_dirk_daggers_progress", caster, stacks - 1)
	elseif stacks == 1 then 
		caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, stacks - 1)
		caster:SetModifierStackCount("modifier_dirk_daggers_progress", caster, stacks - 1)
		ability:EndCooldown()
		ability:StartCooldown(caster:FindModifierByName("modifier_dirk_daggers_progress"):GetRemainingTime())
	end

	local info = {
		Target = target,
		Source = caster, 
		Ability = ability,
		EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = speed
	}
	ProjectileManager:CreateTrackingProjectile(info) 
end 

function OnDirkHit(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local venom_stacks = target:GetModifierStackCount("modifier_dirk_poison", caster) or 0 
	local damage = ability:GetSpecialValueFor("damage")

	if IsSpellBlocked(target) or target:IsMagicImmune() then return end

    if not IsImmuneToSlow(target) then
    	ability:ApplyDataDrivenModifier(caster, target, "modifier_dirk_poison_slow", {}) 
    end

    target:EmitSound("Hero_PhantomAssassin.Dagger.Target")

	DoDamage(caster, target, damage, DAMAGE_TYPE_PHYSICAL, 0, ability, false)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_dirk_poison", {}) 
	target:SetModifierStackCount("modifier_dirk_poison", caster, venom_stacks + 1)
end 

function OnDirkPoisonTick(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local venom_stacks = target:GetModifierStackCount("modifier_dirk_poison", caster)
	local dps = ability:GetSpecialValueFor("poison_dot")

	if not target:IsMagicImmune() then 
		DoDamage(caster, target, dps * venom_stacks, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end
end

function OnDaggerCreate(keys)
	local caster = keys.caster 
	local ability = keys.ability
	local max_daggers = ability:GetSpecialValueFor("max_daggers")
	caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, max_daggers)
	caster:SetModifierStackCount("modifier_dirk_daggers_show", caster, max_daggers)
end

function OnDaggerGain(keys)
	local caster = keys.caster 
	local ability = keys.ability
	local stacks = caster:GetModifierStackCount("modifier_dirk_daggers_base", caster)
	local max_daggers = ability:GetSpecialValueFor("max_daggers")
	if stacks < max_daggers - 1 then
		caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, stacks + 1)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dirk_daggers_progress", {})
		caster:SetModifierStackCount("modifier_dirk_daggers_progress", caster, stacks + 1)
	else
		caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, max_daggers)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dirk_daggers_show", {})
		caster:SetModifierStackCount("modifier_dirk_daggers_show", caster, max_daggers)
	end
end	

function OnWindProtectionThink(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local max_mr = ability:GetSpecialValueFor("bonus_mr")
	local max_debuff = ability:GetSpecialValueFor("penalty_mr")
	local mr_change = ability:GetSpecialValueFor("mr_change")
	caster.bIsVisibleToEnemy = false
	local max_stacks = max_mr / mr_change
	local max_debuff_stacks = max_debuff / mr_change

	LoopOverPlayers(function(player, playerID, playerHero)
		-- if enemy hero can see astolfo, set visibility to true
		if playerHero:GetTeamNumber() ~= caster:GetTeamNumber() then
			if playerHero:CanEntityBeSeenByMyTeam(caster) then
				caster.bIsVisibleToEnemy = true
				return
			end
		end
	end)

	if caster.bIsVisibleToEnemy == true then
		--print("revealed")
		caster:RemoveModifierByName("modifier_wind_protection_bonus")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_protection_penalty", {})
		local debuff_stacks = caster:GetModifierStackCount("modifier_wind_protection_penalty", caster) or 0 
		if stacks >= max_debuff_stacks - 1 then 
			caster:SetModifierStackCount("modifier_wind_protection_penalty", caster, max_debuff_stacks)
		else
			caster:SetModifierStackCount("modifier_wind_protection_penalty", caster, debuff_stacks + 1)
		end
	elseif caster.bIsVisibleToEnemy == false then
		if not caster:HasModifier("modifier_wind_protection_bonus") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_protection_bonus", {})
		end

		local stacks = caster:GetModifierStackCount("modifier_wind_protection_bonus", caster) or 0 
		if stacks >= max_stacks - 1 then 
			caster:SetModifierStackCount("modifier_wind_protection_bonus", caster, max_stacks)
		else
			caster:SetModifierStackCount("modifier_wind_protection_bonus", caster, stacks + 1)
		end
	end
end

function OnAmbushStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local fade_delay = ability:GetSpecialValueFor("fade_delay")
	
	if caster.IsPCImproved then
		local detect_range = ability:GetSpecialValueFor("detect_range")
		local detect_duration = ability:GetSpecialValueFor("detect_duration")
		local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, detect_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for i=1, #units do
			print(units[i]:GetUnitName())
			if units[i]:GetUnitName() == "ward_familiar" then
				local visiondummy = CreateUnitByName("sight_dummy_unit", units[i]:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
				visiondummy:SetDayTimeVisionRange(500)
				visiondummy:SetNightTimeVisionRange(500)
				AddFOWViewer(caster:GetTeamNumber(), visiondummy:GetAbsOrigin(), 500, detect_duration, false)
				visiondummy:AddNewModifier(caster, caster, "modifier_item_ward_true_sight", {true_sight_range = 100}) 
				local unseen = visiondummy:FindAbilityByName("dummy_unit_passive")
				unseen:SetLevel(1)
				Timers:CreateTimer(detect_duration, function()
					if IsValidEntity(visiondummy) and not visiondummy:IsNull() then
						visiondummy:RemoveSelf()
					end 
				end)
				break
			end
		end 
	end

	if caster.IsWeakeningVenomAcquired then 
		local daggers = caster:GetModifierStackCount("modifier_dirk_daggers_base", caster) or 0
		local max_daggers = caster:FindAbilityByName("hassan_dirk_upgrade"):GetSpecialValueFor("max_daggers")
		local recover_dagger = ability:GetSpecialValueFor("recover_dagger")
		if daggers + recover_dagger >= max_daggers then 
			caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, max_daggers)
			caster:RemoveModifierByName("modifier_dirk_daggers_progress")
			caster:FindAbilityByName("hassan_dirk_upgrade"):ApplyDataDrivenModifier(caster, caster, "modifier_dirk_daggers_show", {})
			caster:SetModifierStackCount("modifier_dirk_daggers_show", caster, max_daggers)
		else
			caster:SetModifierStackCount("modifier_dirk_daggers_base", caster, daggers + recover_dagger)
			caster:SetModifierStackCount("modifier_dirk_daggers_progress", caster, daggers + recover_dagger)
			caster:FindAbilityByName("hassan_dirk_upgrade"):EndCooldown()
		end
	end

	Timers:CreateTimer(fade_delay, function()
		if caster:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ambush", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_first_hit", {})
		end
	end)

	TACheckCombo(caster, ability)
end

function OnAmbushBroken(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_ambush")
end

function OnFirstHitStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:RemoveModifierByName("modifier_ambush")
	caster:RemoveModifierByName("modifier_first_hit")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_thrown", {}) 
end

function OnFirstHitLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if IsSpellBlocked(target) then caster:RemoveModifierByName("modifier_thrown") return end -- Linken effect checker

	if target:GetName() == "npc_dota_ward_base" then
		DoDamage(caster, target, 2, DAMAGE_TYPE_PURE, 0, ability, false)
	else
		DoDamage(caster, target, keys.Damage, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
	end
	caster:EmitSound("Hero_TemplarAssassin.Meld.Attack")
	caster:RemoveModifierByName("modifier_thrown")
	caster:RemoveModifierByName("modifier_ambush")
end

function OnAbilityCast(keys)
	Timers:CreateTimer({
		endTime = 0.033,
		callback = function()
		keys.caster:RemoveModifierByName("modifier_ambush")
	end})
	keys.caster:RemoveModifierByName("modifier_first_hit")
end

function OnSelfModStart (keys)
	local caster = keys.caster
	local ability = keys.ability
	local str = math.floor(caster:GetStrength())
	local agi = math.floor(caster:GetAgility())
	local int = math.floor(caster:GetIntellect()) 
	local heal_amount = ability:GetSpecialValueFor("heal_amount")

	caster:Heal(heal_amount, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod", {})

	if str > agi and str > int then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod_str", {})
	elseif agi > str and agi > int then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod_agi", {})
	elseif int > str and int > agi then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod_int", {})
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod_all", {})
	end

	if caster.IsShaytanArmAcquired then 
		local mod_str_cooldown = ability:GetSpecialValueFor("mod_str_cooldown")
		local mod_int_heal = ability:GetSpecialValueFor("mod_int_heal")
		local mod_agi_dmg = ability:GetSpecialValueFor("mod_agi_dmg")
		local radius = ability:GetSpecialValueFor("mod_int_heal_aoe")
		local zaba = caster:FindAbilityByName("hassan_zabaniya")
		if caster.IsShadowStrikeAcquired then 
			zaba = caster:FindAbilityByName("hassan_zabaniya_upgrade")
		end
		if str > agi and str > int then 
			if not zaba:IsCooldownReady() then 
				local cooldown = zaba:GetCooldownTimeRemaining()
				if cooldown > mod_str_cooldown * str then 
					zaba:EndCooldown()
					zaba:StartCooldown(cooldown - (mod_str_cooldown * str))
				else
					zaba:EndCooldown()
				end
			end
		elseif agi > str and agi > int then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod_agi_dmg", {})
			caster:SetModifierStackCount("modifier_ta_self_mod_agi_dmg", caster, mod_agi_dmg * agi)
		elseif int > str and int > agi then 
			local allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for k,v in pairs(allies) do 
				v:Heal(mod_int_heal * int, caster)
			end
		else
			if not zaba:IsCooldownReady() then 
				local cooldown = zaba:GetCooldownTimeRemaining()
				if cooldown > mod_str_cooldown * str / 2 then 
					zaba:EndCooldown()
					zaba:StartCooldown(cooldown - (mod_str_cooldown * str / 2))
				else
					zaba:EndCooldown()
				end
			end
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ta_self_mod_agi_dmg", {})
			caster:SetModifierStackCount("modifier_ta_self_mod_agi_dmg", caster, mod_agi_dmg * agi / 2)
			local allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for k,v in pairs(allies) do 
				v:Heal(mod_int_heal * int / 2, caster)
			end
		end
	end
end

function OnSelfModCD(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsShaytanArmAcquired then
		caster:FindAbilityByName("hassan_self_modification_upgrade"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		caster:FindAbilityByName("hassan_self_modification_upgrade_str"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		caster:FindAbilityByName("hassan_self_modification_upgrade_int"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
	else
		caster:FindAbilityByName("hassan_self_modification"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		caster:FindAbilityByName("hassan_self_modification_str"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		caster:FindAbilityByName("hassan_self_modification_agi"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		caster:FindAbilityByName("hassan_self_modification_int"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
	end
end

function OnSelfModRegen(keys)
	local caster = keys.caster
	local ability = keys.ability
	local heal = ability:GetSpecialValueFor("heal_over_time")

	caster:Heal(heal, caster)
end

function OnSelfModUpgrade (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if caster.IsShaytanArmAcquired then
		if ability:GetAbilityName() == "hassan_self_modification_upgrade" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_str"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_str"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_int"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_int"):SetLevel(ability:GetLevel())
			end
		elseif ability:GetAbilityName() == "hassan_self_modification_upgrade_str" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_int"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_int"):SetLevel(ability:GetLevel())
			end
		elseif ability:GetAbilityName() == "hassan_self_modification_upgrade_agi" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_str"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_str"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_int"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_int"):SetLevel(ability:GetLevel())
			end
		elseif ability:GetAbilityName() == "hassan_self_modification_upgrade_int" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_upgrade_str"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_upgrade_str"):SetLevel(ability:GetLevel())
			end
		end
	else
		if ability:GetAbilityName() == "hassan_self_modification" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_str"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_str"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_agi"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_agi"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_int"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_int"):SetLevel(ability:GetLevel())
			end
		elseif ability:GetAbilityName() == "hassan_self_modification_str" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_agi"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_agi"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_int"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_int"):SetLevel(ability:GetLevel())
			end
		elseif ability:GetAbilityName() == "hassan_self_modification_agi" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_str"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_str"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_int"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_int"):SetLevel(ability:GetLevel())
			end
		elseif ability:GetAbilityName() == "hassan_self_modification_int" then 
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_agi"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_agi"):SetLevel(ability:GetLevel())
			end
			if ability:GetLevel() ~= caster:FindAbilityByName("hassan_self_modification_str"):GetLevel() then
				caster:FindAbilityByName("hassan_self_modification_str"):SetLevel(ability:GetLevel())
			end
		end
	end
end

function OnSelfModSwap(keys)
	local caster = keys.caster
	local ability = keys.ability
	local str = math.floor(caster:GetStrength())
	local agi = math.floor(caster:GetAgility())
	local int = math.floor(caster:GetIntellect()) 

	if caster.IsShaytanArmAcquired then
		if str > agi and str > int then 
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_upgrade_str" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_upgrade_str"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_upgrade_str", false, true)
			end
		elseif agi > str and agi > int then 
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_upgrade_agi" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_upgrade_agi"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_upgrade_agi", false, true)
			end
		elseif int > str and int > agi then 
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_upgrade_int" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_upgrade_int"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_upgrade_int", false, true)
			end
		else
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_upgrade" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_upgrade"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_upgrade", false, true)
			end
		end
	else
		if str > agi and str > int then 
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_str" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_str"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_str", false, true)
			end
		elseif agi > str and agi > int then 
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_agi" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_agi"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_agi", false, true)
			end
		elseif int > str and int > agi then 
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification_int" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification_int"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification_int", false, true)
			end
		else
			if caster:GetAbilityByIndex(1):GetAbilityName() == "hassan_self_modification" then 
				return 
			else
				if not caster:GetAbilityByIndex(1):IsCooldownReady() then 
					--caster:FindAbilityByName("hassan_self_modification"):StartCooldown(caster:GetAbilityByIndex(1):GetCooldownTimeRemaining())
				end
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "hassan_self_modification", false, true)
			end
		end
	end
end

function OnStealAbilityStart(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	caster.bIsVisibleToEnemy = false
	LoopOverPlayers(function(player, playerID, playerHero)
		-- if enemy hero can see astolfo, set visibility to true
		if playerHero:GetTeamNumber() ~= caster:GetTeamNumber() then
			if playerHero:CanEntityBeSeenByMyTeam(caster) then
				caster.bIsVisibleToEnemy = true
				return
			end
		end
	end)
end

function OnSnatchStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target 
	local damage = ability:GetSpecialValueFor("damage")
	local curse_damage = ability:GetSpecialValueFor("curse_damage")
	local bonus_str = 0 
	local bonus_agi = 0
	local bonus_int = 0
	if IsSpellBlocked(keys.target) then return end -- Linken effect checker
	local str = math.floor(caster:GetStrength())
	local agi = math.floor(caster:GetAgility())
	local int = math.floor(caster:GetIntellect()) 

	-- Blood splat
	local splat = ParticleManager:CreateParticle("particles/generic_gameplay/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, target)	
		
	DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)

	if caster.IsShaytanArmAcquired then 
		local snatch_str_dmg = ability:GetSpecialValueFor("snatch_str_dmg")
		local snatch_agi_dmg = ability:GetSpecialValueFor("snatch_agi_dmg")
		local snatch_int_dmg = ability:GetSpecialValueFor("snatch_int_dmg")
		if str > agi and str > int then 
			bonus_str = str * snatch_str_dmg
			DoDamage(caster, target, bonus_str, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
		elseif agi > str and agi > int then 
			bonus_agi = agi * snatch_agi_dmg
			DoDamage(caster, target, bonus_agi, DAMAGE_TYPE_PURE, 0, ability, false)
		elseif int > str and int > agi then 
			bonus_int = int * snatch_int_dmg
			DoDamage(caster, target, bonus_int, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		else
			bonus_str = str * snatch_str_dmg
			bonus_agi = agi * snatch_agi_dmg
			bonus_int = int * snatch_int_dmg
			DoDamage(caster, target, bonus_str, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
			DoDamage(caster, target, bonus_agi, DAMAGE_TYPE_PURE, 0, ability, false)
			DoDamage(caster, target, bonus_int, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		end
	end

	if caster.IsShadowStrikeAcquired then 
		if target:HasModifier("modifier_zaba_curse") then 
			DoDamage(caster, target, curse_damage, DAMAGE_TYPE_PURE, 0, ability, false)
		end
	end
end

function OnZabCastStart(keys)
	local caster = keys.caster
	local target = keys.target
	local smokeFx = ParticleManager:CreateParticleForTeam("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", PATTACH_CUSTOMORIGIN, target, caster:GetTeamNumber())
	ParticleManager:SetParticleControl(smokeFx, 0, caster:GetAbsOrigin())
	caster.LastActionTime = GameRules:GetGameTime()  -- Zab cast should be classified as an action that resets 2s timer for Presence Concealment.
	caster.bIsVisibleToEnemy = false
	LoopOverPlayers(function(player, playerID, playerHero)
		-- if enemy hero can see astolfo, set visibility to true
		if playerHero:GetTeamNumber() ~= caster:GetTeamNumber() then
			if playerHero:CanEntityBeSeenByMyTeam(caster) then
				caster.bIsVisibleToEnemy = true
				return
			end
		end
	end)
end

function OnZabStart(keys)
	local caster = keys.caster
	local target = keys.target
	local projectileSpeed = 950

	if caster.IsShadowStrikeAcquired then
		projectileSpeed = 750
	end


	local info = {
		Target = keys.target,
		Source = caster, 
		Ability = keys.ability,
		EffectName = "particles/custom/ta/zabaniya_projectile.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = projectileSpeed
	}

	--print(caster.bIsVisibleToEnemy)
	--if (caster:HasModifier("modifier_ambush") or not caster.bIsVisibleToEnemy) then caster.IsShadowStrikeActivated = true end
	--if caster:HasModifier("modifier_ambush") then caster.IsShadowStrikeActivated = true end

	ProjectileManager:CreateTrackingProjectile(info) 
	Timers:CreateTimer({
		endTime = 0.033,
		callback = function()
		local smokeFx = ParticleManager:CreateParticle("particles/custom/ta/zabaniya_ulti_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(smokeFx, 0, caster:GetAbsOrigin())
		local smokeFx2 = ParticleManager:CreateParticle("particles/custom/ta/zabaniya_ulti_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(smokeFx2, 0, target:GetAbsOrigin())
		local smokeFx3 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(smokeFx3, 0, target:GetAbsOrigin())

		-- Destroy particle after delay
		Timers:CreateTimer( 2.0, function()
				ParticleManager:DestroyParticle( smokeFx, false )
				ParticleManager:ReleaseParticleIndex( smokeFx )
				ParticleManager:DestroyParticle( smokeFx2, false )
				ParticleManager:ReleaseParticleIndex( smokeFx2 )
				ParticleManager:DestroyParticle( smokeFx3, false )
				ParticleManager:ReleaseParticleIndex( smokeFx3 )
				return nil
		end)

		EmitGlobalSound("TA.Zabaniya") 
		target:EmitSound("TA.Darkness") 
	end
	})
end

function OnZabHit(keys)
	if IsSpellBlocked(keys.target) then return end -- Linken effect checker
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetSpecialValueFor("damage")
	local mana_burn = ability:GetSpecialValueFor("mana_burn")

	local blood = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(blood, 4, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(blood, 1, target , 0, "attach_hitloc", target:GetAbsOrigin(), false)

	local shadowFx = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(shadowFx, 0, target:GetAbsOrigin())
	local smokeFx3 = ParticleManager:CreateParticle("particles/custom/ta/zabaniya_fiendsgrip_hands.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(smokeFx3, 0, target:GetAbsOrigin())

	-- Destroy particle after delay
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( blood, false )
		ParticleManager:ReleaseParticleIndex( blood )
		ParticleManager:DestroyParticle( shadowFx, false )
		ParticleManager:ReleaseParticleIndex( shadowFx )
		return nil
	end)
	
	DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	target:SetMana(target:GetMana() - mana_burn)
	caster:GiveMana(mana_burn / 2)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_zaba_curse", {})

end

function OnZabCurseCreate(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability 
	target.ZabaLockedHealth = target:GetHealth()
end

function OnZabCurseThink(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability 
	local currentHealth = target:GetHealth()
	if target.ZabaLockedHealth < currentHealth then 
		target:SetHealth(target.ZabaLockedHealth)
	else
		target.ZabaLockedHealth = currentHealth
	end
end

function OnZabCurseDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability 
	target.ZabaLockedHealth = nil 
end

function OnTADeath(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	target:RemoveModifierByName("modifier_zaba_curse")
end 

function OnDIStart(keys)
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local search_radius = ability:GetSpecialValueFor("search_radius")
	local DICount = 0
	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("hassan_combo")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	caster:RemoveModifierByName("modifier_delusional_illusion_window")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_show", {})
	--caster:EmitSound("TA.Darkness")
	EmitGlobalSound("Hassan_Combo")

	Timers:CreateTimer(function()
		if DICount > duration or not caster:IsAlive() then return end 
		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, search_radius
	            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if v.IsDIOnCooldown ~= true then 
				--print("Target " .. v:GetName() .. " detected")
				--for ilu = 0, 2 do
				
				--end
				CreateDIDummies(caster, v)
			end
		end
		DICount = DICount + 0.33
		return 0.33
	end)
end

function CreateDIDummies(caster, target)
	target.IsDIOnCooldown = true

	local origin = target:GetAbsOrigin() + RandomVector(650) 
	local illusion = CreateUnitByName("ta_combo_dummy", origin, false, caster, caster, caster:GetTeamNumber()) 
	local illusionskill = illusion:FindAbilityByName("true_assassin_combo_zab") 
	illusionskill:SetLevel(1)
	illusion:SetForwardVector(target:GetAbsOrigin() - illusion:GetAbsOrigin())
	illusion:CastAbilityOnTarget(target, illusionskill, 1)
	StartAnimation(illusion, {duration = 5, activity = ACT_DOTA_ATTACK, rate = 1}) --maybe take this out

	local origin = target:GetAbsOrigin() + RandomVector(550) 
	local illusion2 = CreateUnitByName("ta_combo_dummy_2", origin, false, caster, caster, caster:GetTeamNumber()) 
	local illusionskill2 = illusion2:FindAbilityByName("true_assassin_combo_zab") 
	illusionskill2:SetLevel(1)
	illusion2:SetForwardVector(target:GetAbsOrigin() - illusion2:GetAbsOrigin())
	illusion2:CastAbilityOnTarget(target, illusionskill2, 1)
	StartAnimation(illusion2, {duration = 5, activity = ACT_DOTA_ATTACK, rate = 1}) --maybe take this out

	local origin = target:GetAbsOrigin() + RandomVector(450) 
	local illusion3 = CreateUnitByName("ta_combo_dummy_3", origin, false, caster, caster, caster:GetTeamNumber()) 
	local illusionskill3 = illusion3:FindAbilityByName("true_assassin_combo_zab") 
	illusionskill3:SetLevel(1)
	illusion3:SetForwardVector(target:GetAbsOrigin() - illusion3:GetAbsOrigin())
	illusion3:CastAbilityOnTarget(target, illusionskill3, 1)
	StartAnimation(illusion3, {duration = 5, activity = ACT_DOTA_ATTACK, rate = 2}) --maybe take this out

	Timers:CreateTimer(3.0, function() 
		illusion:RemoveSelf()
		illusion2:RemoveSelf()
		illusion3:RemoveSelf()
		target.IsDIOnCooldown = false 
		return 
	end)
end

function OnDIZabStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	local ability = keys.ability

	local speed = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()

	local info = {
		Target = target,
		Source = caster, 
		Ability = keys.ability,
		EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
		vSpawnOrigin = caster,
		iMoveSpeed = 700
	}
	ProjectileManager:CreateTrackingProjectile(info) 
	--local particle = ParticleManager:CreateParticle("particles/custom/ta/zabaniya_fiendsgrip_hands_combo.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	--ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- target effect location
	--ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()) -- circle effect location
	local smokeFx = ParticleManager:CreateParticle("particles/custom/ta/zabaniya_ulti_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(smokeFx, 0, caster:GetAbsOrigin())
	--local smokeFx2 = ParticleManager:CreateParticle("particles/custom/ta/zabaniya_ulti_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	--ParticleManager:SetParticleControl(smokeFx2, 0, target:GetAbsOrigin())
	local smokeFx3 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(smokeFx3, 0, caster:GetAbsOrigin())
	
	EmitGlobalSound("TA.Darkness") 
	caster:EmitSound("Hero_PhantomAssassin.Dagger.Cast") 

	-- Destroy particle after delay
	Timers:CreateTimer( 2.0, function()
			--ParticleManager:DestroyParticle( particle, false )
			--ParticleManager:ReleaseParticleIndex( particle )
			ParticleManager:DestroyParticle( smokeFx, false )
			ParticleManager:ReleaseParticleIndex( smokeFx )
			--ParticleManager:DestroyParticle( smokeFx2, false )
			--ParticleManager:ReleaseParticleIndex( smokeFx2 )
			ParticleManager:DestroyParticle( smokeFx3, false )
			ParticleManager:ReleaseParticleIndex( smokeFx3 )
			return nil
	end)
end

function OnDIZabHit(keys)
	print("Projectile hit")
	local caster = keys.caster
	local ply = keys.caster:GetPlayerOwner()
	local hero = ply:GetAssignedHero()
	local zaba = hero:FindAbilityByName("hassan_combo")
	if hero.IsShadowStrikeAcquired then 
		zaba = hero:FindAbilityByName("hassan_combo_upgrade")
	end
	local damage = zaba:GetSpecialValueFor("damage")

	keys.target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	DoDamage(hero, keys.target, damage, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
end

function TACheckCombo(caster, ability)
	if caster:GetStrength() >= 24.1 and caster:GetAgility() >= 24.1 and caster:GetIntellect() >= 24.1 then
		if caster.IsShadowStrikeAcquired then
			if caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush_upgrade_3") and caster:FindAbilityByName("hassan_combo_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			elseif not caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush_upgrade_2") and caster:FindAbilityByName("hassan_combo_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			elseif caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush_upgrade_1") and caster:FindAbilityByName("hassan_combo_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			elseif not caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush") and caster:FindAbilityByName("hassan_combo_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			end
		else
			if caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush_upgrade_3") and caster:FindAbilityByName("hassan_combo"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			elseif not caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush_upgrade_2") and caster:FindAbilityByName("hassan_combo"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			elseif caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush_upgrade_1") and caster:FindAbilityByName("hassan_combo"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			elseif not caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
				if ability == caster:FindAbilityByName("hassan_ambush") and caster:FindAbilityByName("hassan_combo"):IsCooldownReady() and not caster:HasModifier("modifier_delusional_illusion_cooldown") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_delusional_illusion_window", {})
				end
			end
		end
	end
end

function OnDelusionWindowCreate(keys)
	local caster = keys.caster 
	if caster.IsShadowStrikeAcquired then
		if caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_3", "hassan_combo_upgrade", false, true)
		elseif not caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_2", "hassan_combo_upgrade", false, true)			
		elseif caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_1", "hassan_combo_upgrade", false, true)			
		elseif not caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush", "hassan_combo_upgrade", false, true)
		end
	else
		if caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_3", "hassan_combo", false, true)
		elseif not caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_2", "hassan_combo", false, true)			
		elseif caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_1", "hassan_combo", false, true)			
		elseif not caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush", "hassan_combo", false, true)
		end
	end
end

function OnDelusionWindowDestroy(keys)
	local caster = keys.caster 
	if caster.IsShadowStrikeAcquired then
		if caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_3", "hassan_combo_upgrade", true, false)
		elseif not caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_2", "hassan_combo_upgrade", true, false)			
		elseif caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_1", "hassan_combo_upgrade", true, false)			
		elseif not caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush", "hassan_combo_upgrade", true, false)
		end
	else
		if caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_3", "hassan_combo", true, false)
		elseif not caster.IsPCImproved and caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_2", "hassan_combo", true, false)			
		elseif caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush_upgrade_1", "hassan_combo", true, false)			
		elseif not caster.IsPCImproved and not caster.IsWeakeningVenomAcquired then
			caster:SwapAbilities("hassan_ambush", "hassan_combo", true, false)
		end
	end
end

function OnDelusionWindowDied(keys)
	local caster = keys.caster 
	caster:RemoveModifierByName("modifier_delusional_illusion_window")
end

function OnImprovePresenceConcealmentAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_delusional_illusion_window") then 
		hero:RemoveModifierByName("modifier_delusional_illusion_window")
	end

	hero.IsPCImproved = true

	hero:AddAbility("hassan_presence_concealment_upgrade")
	hero:FindAbilityByName("hassan_presence_concealment_upgrade"):SetLevel(1)
	hero:SwapAbilities("hassan_presence_concealment_upgrade", "hassan_presence_concealment", true, false)
	hero:RemoveAbility("hassan_presence_concealment") 
	hero:RemoveModifierByName("modifier_ta_invis_passive")

	if hero.IsWeakeningVenomAcquired then 
		hero:AddAbility("hassan_ambush_upgrade_3")
		hero:FindAbilityByName("hassan_ambush_upgrade_3"):SetLevel(hero:FindAbilityByName("hassan_ambush_upgrade_2"):GetLevel())
		hero:SwapAbilities("hassan_ambush_upgrade_3", "hassan_ambush_upgrade_2", true, false) 
		if not hero:FindAbilityByName("hassan_ambush_upgrade_2"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_ambush_upgrade_3"):StartCooldown(hero:FindAbilityByName("hassan_ambush_upgrade_2"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_ambush_upgrade_2")
	else
		hero:AddAbility("hassan_ambush_upgrade_1")
		hero:FindAbilityByName("hassan_ambush_upgrade_1"):SetLevel(hero:FindAbilityByName("hassan_ambush"):GetLevel())
		hero:SwapAbilities("hassan_ambush_upgrade_1", "hassan_ambush", true, false) 
		if not hero:FindAbilityByName("hassan_ambush"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_ambush_upgrade_1"):StartCooldown(hero:FindAbilityByName("hassan_ambush"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_ambush")
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnProtectionFromWindAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local ability = keys.ability
	hero.IsPFWAcquired = true
	hero:FindAbilityByName("hassan_protection_from_wind"):SetLevel(1) 	

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnWeakeningVenomAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local ability = keys.ability
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_delusional_illusion_window") then 
		hero:RemoveModifierByName("modifier_delusional_illusion_window")
	end

	hero.IsWeakeningVenomAcquired = true

	hero:AddAbility("hassan_dirk_upgrade")
	hero:FindAbilityByName("hassan_dirk_upgrade"):SetLevel(1)
	hero:SwapAbilities("hassan_dirk_upgrade", "hassan_dirk", true, false) 
	hero:RemoveAbility("hassan_dirk")

	local stacks = hero:GetModifierStackCount("modifier_dirk_daggers_base", hero)
	hero:RemoveModifierByName("modifier_dirk_daggers_show")
	hero:RemoveModifierByName("modifier_dirk_daggers_progress")
	hero:FindAbilityByName("hassan_dirk_upgrade"):ApplyDataDrivenModifier(hero, hero, "modifier_dirk_daggers_progress", {})
	hero:SetModifierStackCount("modifier_dirk_daggers_base", hero, stacks)
	hero:SetModifierStackCount("modifier_dirk_daggers_progress", hero, stacks)
	
	
	
	if hero.IsPCImproved then 
		hero:AddAbility("hassan_ambush_upgrade_3")
		hero:FindAbilityByName("hassan_ambush_upgrade_3"):SetLevel(hero:FindAbilityByName("hassan_ambush_upgrade_1"):GetLevel())
		hero:SwapAbilities("hassan_ambush_upgrade_3", "hassan_ambush_upgrade_1", true, false) 
		if not hero:FindAbilityByName("hassan_ambush_upgrade_1"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_ambush_upgrade_3"):StartCooldown(hero:FindAbilityByName("hassan_ambush_upgrade_1"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_ambush_upgrade_1")
	else
		hero:AddAbility("hassan_ambush_upgrade_2")
		hero:FindAbilityByName("hassan_ambush_upgrade_2"):SetLevel(hero:FindAbilityByName("hassan_ambush"):GetLevel())
		hero:SwapAbilities("hassan_ambush_upgrade_2", "hassan_ambush", true, false) 
		if not hero:FindAbilityByName("hassan_ambush"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_ambush_upgrade_2"):StartCooldown(hero:FindAbilityByName("hassan_ambush"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_ambush")
	end


	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnShaytanArmAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local ability = keys.ability
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	hero.IsShaytanArmAcquired = true

	local str = math.floor(hero:GetStrength())
	local agi = math.floor(hero:GetAgility())
	local int = math.floor(hero:GetIntellect()) 

	hero:AddAbility("hassan_self_modification_upgrade")
	hero:FindAbilityByName("hassan_self_modification_upgrade"):SetLevel(hero:FindAbilityByName("hassan_self_modification"):GetLevel())
	hero:AddAbility("hassan_self_modification_upgrade_int")
	hero:FindAbilityByName("hassan_self_modification_upgrade_int"):SetLevel(hero:FindAbilityByName("hassan_self_modification"):GetLevel())
	hero:AddAbility("hassan_self_modification_upgrade_agi")
	hero:FindAbilityByName("hassan_self_modification_upgrade_agi"):SetLevel(hero:FindAbilityByName("hassan_self_modification"):GetLevel())
	hero:AddAbility("hassan_self_modification_upgrade_str")
	hero:FindAbilityByName("hassan_self_modification_upgrade_str"):SetLevel(hero:FindAbilityByName("hassan_self_modification"):GetLevel())
	
	if str > agi and str > int then 
		hero:SwapAbilities("hassan_self_modification_upgrade_str", "hassan_self_modification_str", true, false) 
	elseif agi > str and agi > int then 
		hero:SwapAbilities("hassan_self_modification_upgrade_agi", "hassan_self_modification_agi", true, false) 
	elseif int > str and int > agi then 
		hero:SwapAbilities("hassan_self_modification_upgrade_int", "hassan_self_modification_int", true, false) 
	else
		hero:SwapAbilities("hassan_self_modification_upgrade", "hassan_self_modification", true, false) 
	end

	
	if not hero:FindAbilityByName("hassan_self_modification"):IsCooldownReady() then 
		hero:FindAbilityByName("hassan_self_modification_upgrade"):StartCooldown(hero:FindAbilityByName("hassan_self_modification"):GetCooldownTimeRemaining())
		hero:FindAbilityByName("hassan_self_modification_upgrade_int"):StartCooldown(hero:FindAbilityByName("hassan_self_modification"):GetCooldownTimeRemaining())
		hero:FindAbilityByName("hassan_self_modification_upgrade_agi"):StartCooldown(hero:FindAbilityByName("hassan_self_modification"):GetCooldownTimeRemaining())
		hero:FindAbilityByName("hassan_self_modification_upgrade_str"):StartCooldown(hero:FindAbilityByName("hassan_self_modification"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("hassan_self_modification")
	hero:RemoveAbility("hassan_self_modification_int")
	hero:RemoveAbility("hassan_self_modification_str")
	hero:RemoveAbility("hassan_self_modification_agi")

	if hero.IsShadowStrikeAcquired then 
		hero:AddAbility("hassan_snatch_strike_upgrade_3")
		hero:FindAbilityByName("hassan_snatch_strike_upgrade_3"):SetLevel(hero:FindAbilityByName("hassan_snatch_strike_upgrade_1"):GetLevel())
		hero:SwapAbilities("hassan_snatch_strike_upgrade_3", "hassan_snatch_strike_upgrade_1", true, false) 
		if not hero:FindAbilityByName("hassan_snatch_strike_upgrade_1"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_snatch_strike_upgrade_3"):StartCooldown(hero:FindAbilityByName("hassan_snatch_strike_upgrade_1"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_snatch_strike_upgrade_1")
	else
		hero:AddAbility("hassan_snatch_strike_upgrade_2")
		hero:FindAbilityByName("hassan_snatch_strike_upgrade_2"):SetLevel(hero:FindAbilityByName("hassan_snatch_strike"):GetLevel())
		hero:SwapAbilities("hassan_snatch_strike_upgrade_2", "hassan_snatch_strike", true, false) 
		if not hero:FindAbilityByName("hassan_snatch_strike"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_snatch_strike_upgrade_2"):StartCooldown(hero:FindAbilityByName("hassan_snatch_strike"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_snatch_strike")
	end

	
	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnShadowStrikeAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_delusional_illusion_window") then 
		hero:RemoveModifierByName("modifier_delusional_illusion_window")
	end

	hero.IsShadowStrikeAcquired = true

	hero:AddAbility("hassan_zabaniya_upgrade")
	hero:FindAbilityByName("hassan_zabaniya_upgrade"):SetLevel(hero:FindAbilityByName("hassan_zabaniya"):GetLevel())
	hero:SwapAbilities("hassan_zabaniya_upgrade", "hassan_zabaniya", true, false) 
	if not hero:FindAbilityByName("hassan_zabaniya"):IsCooldownReady() then 
		hero:FindAbilityByName("hassan_zabaniya_upgrade"):StartCooldown(hero:FindAbilityByName("hassan_zabaniya"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("hassan_zabaniya")

	hero:AddAbility("hassan_combo_upgrade")
	hero:FindAbilityByName("hassan_combo_upgrade"):SetLevel(1)
	if not hero:FindAbilityByName("hassan_combo"):IsCooldownReady() then 
		hero:FindAbilityByName("hassan_combo_upgrade"):StartCooldown(hero:FindAbilityByName("hassan_combo"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("hassan_combo")

	if hero.IsShaytanArmAcquired then 
		hero:AddAbility("hassan_snatch_strike_upgrade_3")
		hero:FindAbilityByName("hassan_snatch_strike_upgrade_3"):SetLevel(hero:FindAbilityByName("hassan_snatch_strike_upgrade_2"):GetLevel())
		hero:SwapAbilities("hassan_snatch_strike_upgrade_3", "hassan_snatch_strike_upgrade_2", true, false) 
		if not hero:FindAbilityByName("hassan_snatch_strike_upgrade_2"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_snatch_strike_upgrade_3"):StartCooldown(hero:FindAbilityByName("hassan_snatch_strike_upgrade_2"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_snatch_strike_upgrade_2")
	else
		hero:AddAbility("hassan_snatch_strike_upgrade_1")
		hero:FindAbilityByName("hassan_snatch_strike_upgrade_1"):SetLevel(hero:FindAbilityByName("hassan_snatch_strike"):GetLevel())
		hero:SwapAbilities("hassan_snatch_strike_upgrade_1", "hassan_snatch_strike", true, false) 
		if not hero:FindAbilityByName("hassan_snatch_strike"):IsCooldownReady() then 
			hero:FindAbilityByName("hassan_snatch_strike_upgrade_1"):StartCooldown(hero:FindAbilityByName("hassan_snatch_strike"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("hassan_snatch_strike")
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end
	

