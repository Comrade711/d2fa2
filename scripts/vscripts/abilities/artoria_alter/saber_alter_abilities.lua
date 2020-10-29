
function OnDerangeStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	
	DSCheckCombo(keys.caster, keys.ability)
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_derange", {} )

	if caster.IsManaBlastAcquired then
		--[[
			Fix a bug where user can have more than 7 charges and add VFX
		]]
		local maximum_charges = keys.ability:GetSpecialValueFor("maximum_charges")
		
		-- Check the amount of next charge
		local next_charge = RandomInt(1, 3)

		-- Check if the charges will become over capacity
		if not caster.ManaBlastCount then caster.ManaBlastCount = 0 end	-- This might be because I was debugging it to double check nil value

		if caster.ManaBlastCount + next_charge > maximum_charges then
			if caster.ManaBlastCount == maximum_charges then
				next_charge = 0
			else
				next_charge = caster.ManaBlastCount + next_charge - maximum_charges
			end
			caster.ManaBlastCount = maximum_charges
		else
			caster.ManaBlastCount = caster.ManaBlastCount + next_charge
		end
		
		-- Adding modifiers
		for i = 1, next_charge do
			keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_derange_mana_catalyst_VFX", {} )
		end
		
		-- Update the charge
		caster:SetModifierStackCount( "modifier_derange_counter", caster, caster.ManaBlastCount )
	end

	caster:EmitSound("Saber_Alter.Derange")
	caster:EmitSound("saber_alter_other_01")
end

function OnDerangeAttackStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	ability:ApplyDataDrivenModifier( caster, target, "modifier_armor_reduction", {} )
end

function OnDerangeDeath(keys)
	local caster = keys.caster
	caster.ManaBlastCount = 0
	caster:SetModifierStackCount( "modifier_derange_counter", caster, caster.ManaBlastCount )
end

function OnDarklightProc(keys)
	DoDamage(keys.caster, keys.target, 400 , DAMAGE_TYPE_PHYSICAL, 0, keys.ability, false)
end

function OnUFStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	local UFCount = 0
	local bonusDamage = 0
	local bonus_str = ability:GetSpecialValueFor("bonus_str")
	local bonus_int = ability:GetSpecialValueFor("bonus_int")

	if caster.IsFerocityImproved then
		bonusDamage = caster:GetStrength()*bonus_str + caster:GetIntellect()*bonus_int
	end

	caster:EmitSound("saber_alter_other_03") 

	DSCheckCombo(caster, ability)
	Timers:CreateTimer(function()
		if UFCount == 5 or not caster:IsAlive() then return end
		caster:EmitSound("Saber_Alter.Unleashed") 
		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, keys.Radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
	         DoDamage(caster, v, v:GetHealth() * keys.Damage / 100 + bonusDamage, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
	         v:AddNewModifier(caster, v, "modifier_stunned", {Duration = 0.1})
	    end
		UFCount = UFCount + 1;
		return 0.5
		end
	)

	ability:ApplyDataDrivenModifier( caster, caster, "modifier_unleashed_ferocity_caster_VFX_controller", {} )
end

function OnUFCreateVfx(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_unleashed_ferocity_caster_VFX", {} )
end

function OnDarklightCrit(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_darklight_crit_hit", {} )
end

function OnMBStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	local stunDuration = ability:GetSpecialValueFor("stun")
	local bonus_int = ability:GetSpecialValueFor("bonus_int")
	local bonus_mana = ability:GetSpecialValueFor("bonus_mana")
	local bonus_cost = ability:GetSpecialValueFor("bonus_cost")

	if caster.IsManaShroudImproved == true then 
		keys.Damage = keys.Damage + bonus_int * caster:GetIntellect()
	end


	if caster.IsManaBlastAcquired then
		keys.Damage = keys.Damage + (caster:GetMana() * bonus_mana/100)
		caster:SpendMana(caster:GetMana() * bonus_cost/100, ability)
	end

	caster:EmitSound("Saber_Alter.ManaBurst") 
	caster:EmitSound("saber_alter_attack_03")
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, keys.Radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	
	local info = {
		Target = nil,
		Source = caster, 
		Ability = keys.ability,
		EffectName = "particles/items2_fx/skadi_projectile.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = 500
	}
	
	if caster.IsManaBlastAcquired and #targets ~= 0 then
		-- Force remove all particles
		while caster:HasModifier( "modifier_derange_mana_catalyst_VFX" ) do
			caster:RemoveModifierByName( "modifier_derange_mana_catalyst_VFX" )
		end
		
		while caster.ManaBlastCount ~= 0 do
			info.Target = targets[math.random(#targets)]
			ProjectileManager:CreateTrackingProjectile(info) 
			caster.ManaBlastCount = caster.ManaBlastCount - 1
		end
		
		-- Update the charge
		caster:SetModifierStackCount( "modifier_derange_counter", caster, caster.ManaBlastCount )
	end

	-- 1.24c particle fix
	-- Slight fix to make the particle size respect the actual AoE after obtaining SA
	local mbParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(mbParticle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(mbParticle, 1, Vector(keys.Radius, 0, 0))
	ParticleManager:SetParticleControl(mbParticle, 2, Vector(1.0, 0, 0))

	for k,v in pairs(targets) do
	    DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
	    v:AddNewModifier(caster, v, "modifier_stunned", {Duration = stunDuration})
	end

	ability:ApplyDataDrivenModifier( caster, caster, "modifier_mana_burst_VFX", {} )
end

function OnManaBlastHit(keys)
	local caster = keys.caster
	local ability = keys.ability
	local derange_dmg = ability:GetSpecialValueFor("derange_dmg")
	DoDamage(keys.caster, keys.target, derange_dmg , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
end

function OnMMBStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.Radius
	local ply = caster:GetPlayerOwner()
	local mana_ratio = ability:GetSpecialValueFor("mana_ratio")
	local inner_range = ability:GetSpecialValueFor("inner_range")
	local low = ability:GetSpecialValueFor("low")
	local medium_range = ability:GetSpecialValueFor("medium_range")
	local moderate = ability:GetSpecialValueFor("moderate")

	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("saber_alter_max_mana_burst")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	if caster:HasModifier("modifier_max_mana_burst_window") then 
		caster:RemoveModifierByName("modifier_max_mana_burst_window")
	end
	caster:GetAbilityByIndex(1):StartCooldown(15.0)

	local inner_targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, inner_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local moderate_targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, medium_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local outer_targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	EmitGlobalSound("Saber_Alter.MMB" ) 
	EmitGlobalSound("saber_alter_other_04")
	EmitGlobalSound("Saber_Alter.MMBAfter") 
	local BlueSplashFx = ParticleManager:CreateParticle("particles/custom/screen_blue_splash.vpcf", PATTACH_EYES_FOLLOW, caster)
	ScreenShake(caster:GetOrigin(), 15, 2.0, 2, 10000, 0, true)
	-- Destroy particle
	Timers:CreateTimer( 3.0, function()
		ParticleManager:DestroyParticle( BlueSplashFx, false )
	end)

	local dmg = caster:GetMaxMana() * mana_ratio / 100

	for k,v in pairs(inner_targets) do
	    DoDamage(caster, v, dmg , DAMAGE_TYPE_MAGICAL, 0, keys.ability)
	    ability:ApplyDataDrivenModifier(caster, v, "modifier_max_mana_burst_buffer", {})
	end

	for a,b in pairs(moderate_targets) do
		if not b:HasModifier("modifier_max_mana_burst_buffer") then
		    DoDamage(caster, b, dmg * moderate / 100 , DAMAGE_TYPE_MAGICAL, 0, keys.ability)
		    ability:ApplyDataDrivenModifier(caster, b, "modifier_max_mana_burst_buffer", {})
		end
	end

	for c,d in pairs(outer_targets) do
		if not d:HasModifier("modifier_max_mana_burst_buffer") then
		    DoDamage(caster, d, dmg * low / 100 , DAMAGE_TYPE_MAGICAL, 0, keys.ability)
		    ability:ApplyDataDrivenModifier(caster, d, "modifier_max_mana_burst_buffer", {})
		end
	end

	ability:ApplyDataDrivenModifier( caster, caster, "modifier_max_mana_burst_VFX", {} )
end

vortigernCount = 0
function OnVortigernStart(keys)
	--ArsenalReturnMana(keys.caster)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	local forward = ( keys.target_points[1] - caster:GetAbsOrigin() ):Normalized() -- caster:GetForwardVector() 
	local angle = 120
	local increment_factor = 30
	local origin = caster:GetAbsOrigin()
	local destination = origin + forward
	local radius = ability:GetSpecialValueFor("radius")

	if (math.abs(destination.x - origin.x) < 0.01) and (math.abs(destination.y - origin.y) < 0.01) then
		destination = caster:GetForwardVector() + caster:GetAbsOrigin()
	end
	
	giveUnitDataDrivenModifier(keys.caster, keys.caster, "pause_sealdisabled", 0.70) -- Beam interval * 9 + 0.44
	EmitGlobalSound("Saber_Alter.Vortigern")

	local vortigernBeam =
	{
		Ability = keys.ability,
		EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
		iMoveSpeed = 3000,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = radius,
		Source = caster,
		fStartRadius = 75,
        fEndRadius = 120,
		bHasFrontialCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		fExpireTime = GameRules:GetGameTime() + 0.4,
		bDeleteOnHit = false,
		vVelocity = 0,
	}

	if caster.IsFerocityImproved then
		local stacks = caster:GetModifierStackCount("modifier_vortigern_ferocity_base", caster)
		if stacks > 1 then
			ability:EndCooldown()
			caster:SetModifierStackCount("modifier_vortigern_ferocity_base", caster, stacks - 1)
		elseif stacks == 1 then
			caster:SetModifierStackCount("modifier_vortigern_ferocity_base", caster, stacks - 1)
		end
		if not caster:HasModifier("modifier_vortigern_ferocity_progress") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_vortigern_ferocity_progress", {})
		end
		caster:SetModifierStackCount("modifier_vortigern_ferocity_progress", caster, stacks - 1)
		caster:RemoveModifierByName("modifier_vortigern_ferocity_show")
	end

	
	--[[local casterAngle = QAngle(0, 120 ,0)
	Timers:CreateTimer(function() 
			if vortigernCount == 10 then vortigernCount = 0 return end -- finish spell
			vortigernBeam.vVelocity = RotatePosition(caster:GetAbsOrigin(), casterAngle, forward * 3000) 
			local projectile = ProjectileManager:CreateLinearProjectile(vortigernBeam)
			casterAngle.y = casterAngle.y - 24;
			print(casterAngle.y)
			vortigernCount = vortigernCount + 1; 
			
			return 0.040 
		end
	)]]
	
	-- Base variables


	vortigernCount = 0
	Timers:CreateTimer( function()
			-- Finish spell, need to include the last angle as well
			-- Note that the projectile limit is currently at 9, to increment this, need to create either dummy or thinker to store them
			if vortigernCount == 9 then return end
			
			-- Start rotating
			local theta = ( angle - vortigernCount * increment_factor ) * math.pi / 180
			local px = math.cos( theta ) * ( destination.x - origin.x ) - math.sin( theta ) * ( destination.y - origin.y ) + origin.x
			local py = math.sin( theta ) * ( destination.x - origin.x ) + math.cos( theta ) * ( destination.y - origin.y ) + origin.y

			local new_forward = ( Vector( px, py, origin.z ) - origin ):Normalized()
			vortigernBeam.vVelocity = new_forward * 3000
			vortigernBeam.fExpireTime = GameRules:GetGameTime() + 0.4
			
			-- Fire the projectile
			local projectile = ProjectileManager:CreateLinearProjectile( vortigernBeam )
			vortigernCount = vortigernCount + 1
			
			-- Create particles
			local fxIndex1 = ParticleManager:CreateParticle( "particles/custom/saber_alter/saber_alter_vortigern_line.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( fxIndex1, 0, caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( fxIndex1, 1, vortigernBeam.vVelocity )
			ParticleManager:SetParticleControl( fxIndex1, 2, Vector( 0.2, 0.2, 0.2 ) )
			
			Timers:CreateTimer( 0.2, function()
					ParticleManager:DestroyParticle( fxIndex1, false )
					ParticleManager:ReleaseParticleIndex( fxIndex1 )
					return nil
				end
			)
			
			return 0.06
		end
	)
end

function OnVortigernStackGain(keys)
	local caster = keys.caster 
	local ability = keys.ability
	local stacks = caster:GetModifierStackCount("modifier_vortigern_ferocity_base", caster)
	if stacks < 2 then
		caster:SetModifierStackCount("modifier_vortigern_ferocity_base", caster, stacks + 1)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_vortigern_ferocity_progress", {})
		caster:SetModifierStackCount("modifier_vortigern_ferocity_progress", caster, stacks + 1)
	else
		caster:SetModifierStackCount("modifier_vortigern_ferocity_base", caster, 3)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_vortigern_ferocity_show", {})
		caster:SetModifierStackCount("modifier_vortigern_ferocity_show", caster, 3)
	end
end	

function OnVortigernHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	local damage = keys.Damage
	local StunDuration = keys.StunDuration
	local vortSwingDamage = 5
	local low_end = keys.ability:GetSpecialValueFor("low_end")

	damage = damage * (low_end + vortigernCount * vortSwingDamage) / 100

	--[[if caster.IsFerocityImproved then 
		if caster:HasModifier("modifier_vortigern_ferocity") then
			damage = damage * 0.66
		end		
	end]]
	
	StunDuration = StunDuration * (low_end + vortigernCount * 5)/100
	if target.IsVortigernHit ~= true then
		target.IsVortigernHit = true
		Timers:CreateTimer(0.54, function() target.IsVortigernHit = false return end)
		DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
		target:AddNewModifier(caster, caster, "modifier_stunned", {Duration = StunDuration})
		print(damage)
		
	end

end

--[[ function OnVortigernStart(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local casterVec = caster:GetForwardVector()
	local targetVec = Vector(0,0,0)
	local damage = keys.Damage
	giveUnitDataDrivenModifier(keys.caster, keys.caster, "pause_sealdisabled", 0.4)
	if caster.IsFerocityImproved then 
		damage = damage + 100
		keys.StunDuration = keys.StunDuration + 0.3
	end

	local angle = 0
	EmitGlobalSound("Saber_Alter.Vortigern")

	local vortigerndmg = {
		attacker = caster,
		victim = nil,
		damage = 0,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = 0,
		ability = ability
	}

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, keys.Radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
        targetVec = v:GetAbsOrigin() - caster:GetAbsOrigin() 
        degree = CalculateAngle(casterVec, targetVec)*180/math.pi -- degree from caster to target
        -- Starts at 120(85% damage), ends at -120(120% damage)
        if degree <= 120 and degree >= -120 then
        	local multiplier = 0.85 + (120 - degree)/(240/0.35)
        	DoDamage(caster, v, damage * multiplier , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
        	--print(degree .. " " .. multiplier)
        	v:AddNewModifier(caster, target, "modifier_stunned", {duration = keys.StunDuration})
        end
    end
end]]

function OnDexVfxControllerStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "dark_excalibur_vfx_phase_1", {})
	ability:ApplyDataDrivenModifier(caster, caster, "dark_excalibur_vfx_phase_3", {})
end

function OnDexVfxPhase2Start(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "dark_excalibur_vfx_phase_2", {})
end


function OnDexStart(keys)
	local caster = keys.caster
	local ability = keys.ability 
	giveUnitDataDrivenModifier(keys.caster, keys.caster, "pause_sealdisabled", 4.75)
	keys.Range = keys.Range - keys.Width -- We need this to take end radius of projectile into account
	print(keys.Range)
	EmitGlobalSound("Saber.Caliburn")
	EmitGlobalSound("Excalibur_Morgan_Precast")
	ability:ApplyDataDrivenModifier(caster, caster, "dark_excalibur_VFX_controller", {})
	local dex = 
	{
		Ability = keys.ability,
        EffectName = "",
        iMoveSpeed = keys.Speed,
        vSpawnOrigin = nil,
        fDistance = keys.Range,
        fStartRadius = keys.Width,
        fEndRadius = keys.Width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * keys.Speed
	}	

	Timers:CreateTimer(1.0, function() 
		if caster:IsAlive() then
			EmitGlobalSound("Excalibur_Morgan")
		end
	end)

	Timers:CreateTimer(2.75, function()
		if caster:IsAlive() then
			--EmitGlobalSound("Saber.Excalibur_Ready")
			dex.vSpawnOrigin = caster:GetAbsOrigin() 
			dex.vVelocity = caster:GetForwardVector() * keys.Speed
			projectile = ProjectileManager:CreateLinearProjectile(dex)
			ScreenShake(caster:GetOrigin(), 7, 2.0, 2, 10000, 0, true)
		end
	end)

	Timers:CreateTimer(2.75, function()
		if caster:IsAlive() then
			-- Create Particle for projectile
			local casterFacing = caster:GetForwardVector()
			local dummy = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
			dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
			dummy:SetForwardVector(casterFacing)
			Timers:CreateTimer( function()
					if IsValidEntity(dummy) then
						local newLoc = dummy:GetAbsOrigin() + keys.Speed * 0.03 * casterFacing
						dummy:SetAbsOrigin(GetGroundPosition(newLoc,dummy))
						-- DebugDrawCircle(newLoc, Vector(255,0,0), 0.5, keys.StartRadius, true, 0.15)
						return 0.03
					else
						return nil
					end
				end
			)
			
			local excalFxIndex = ParticleManager:CreateParticle("particles/custom/saber_alter/excalibur/shockwave.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, dummy )

			Timers:CreateTimer( 1.5, function()
					ParticleManager:DestroyParticle( excalFxIndex, false )
					ParticleManager:ReleaseParticleIndex( excalFxIndex )
					Timers:CreateTimer( 0.5, function()
							dummy:RemoveSelf()
							return nil
						end
					)
					return nil
				end
			)
			return 
		end
	end)
end

function OnDexHit(keys)
	local caster = keys.caster
	local target = keys.target
	if target == nil then return end
	DoDamage(keys.caster, keys.target, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
end

	--[[
	local vortigernBeam =
	{
		Ability = keys.ability,
		EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
		iMoveSpeed = 10000,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = keys.Radius,
		Source = caster,
		fStartRadius = 10,
        fEndRadius = 50,
		bHasFrontialCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		fExpireTime = GameRules:GetGameTime() + 0.4,
		bDeleteOnHit = false,
		vVelocity = 0.0,
	}

	local casterAngle = QAngle(0,120,0)
	EmitGlobalSound("Saber_Alter.Vortigern")
	Timers:CreateTimer(function() 
			vortigernBeam.vVelocity = RotatePosition(Vector(0,0,0), casterAngle, caster:GetForwardVector()) * 10000
			projectile = ProjectileManager:CreateLinearProjectile(vortigernBeam)
			casterAngle.y = casterAngle.y - 6.66;
			vortigernCount = vortigernCount + 1; 
			if vortigernCount == 36 then vortigernCount = 0 return end -- finish spell
			
			return .01 -- tick every 0.01
		end
	)
end]]

DUsed = false
DTime = GameRules:GetGameTime()
UFTime = 0
	
function DSCheckCombo(caster, ability)
	if caster:GetStrength() >= 24.1 and caster:GetAgility() >= 24.1 and caster:GetIntellect() >= 24.1 then
		if ability:GetAbilityName() == "saber_alter_derange" or ability:GetAbilityName() == "saber_alter_derange_upgrade" then
			DUsed = true
			DTime = GameRules:GetGameTime()
			Timers:CreateTimer({
				endTime = 5,
				callback = function()
				DUsed = false
			end
			})
		else
			if caster.IsFerocityImproved then 
				if caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity_upgrade" and caster:FindAbilityByName("saber_alter_mana_burst_upgrade_3"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				elseif not caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity_upgrade" and caster:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				elseif caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity_upgrade" and caster:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				elseif not caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity_upgrade" and caster:FindAbilityByName("saber_alter_mana_burst"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				end
			else
				if caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity" and caster:FindAbilityByName("saber_alter_mana_burst_upgrade_3"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				elseif not caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity" and caster:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				elseif caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity" and caster:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				elseif not caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
					if ability:GetAbilityName() == "saber_alter_unleashed_ferocity" and caster:FindAbilityByName("saber_alter_mana_burst"):IsCooldownReady() and caster:FindAbilityByName("saber_alter_max_mana_burst"):IsCooldownReady() and not caster:HasModifier("modifier_max_mana_burst_cooldown") then
						if DUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - DTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_max_mana_burst_window", {duration = duration})
						end
					end
				end
			end
		end
	end
end

function OnMMBWindow(keys)
	local caster = keys.caster 
	if caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_3", "saber_alter_max_mana_burst_upgrade", false, true)
	elseif not caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_1", "saber_alter_max_mana_burst", false, true)			
	elseif caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_2", "saber_alter_max_mana_burst_upgrade", false, true)			
	elseif not caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_3", "saber_alter_max_mana_burst", false, true)
	end
end

function OnMMBWindowDestroy(keys)
	local caster = keys.caster 
	if caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_3", "saber_alter_max_mana_burst_upgrade", true, false)
	elseif not caster.IsManaBlastAcquired and caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_1", "saber_alter_max_mana_burst", true, false)			
	elseif caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_2", "saber_alter_max_mana_burst_upgrade", true, false)			
	elseif not caster.IsManaBlastAcquired and not caster.IsManaShroudImproved then
		caster:SwapAbilities("saber_alter_mana_burst_upgrade_3", "saber_alter_max_mana_burst", true, false)
	end
end

function OnMMBWindowDied(keys)
	local caster = keys.caster 
	caster:RemoveModifierByName("modifier_max_mana_burst_window")
end

function OnImproveManaShroundAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_max_mana_burst_window") then 
		hero:RemoveModifierByName("modifier_max_mana_burst_window")
	end

	hero.IsManaShroudImproved = true

	hero:AddAbility("saber_alter_mana_shroud_upgrade")
	hero:FindAbilityByName("saber_alter_mana_shroud_upgrade"):SetLevel(1)
	hero:SwapAbilities("saber_alter_mana_shroud_upgrade", "saber_alter_mana_shroud", true, false) 

	hero:RemoveAbility("saber_alter_mana_shroud")
	hero:RemoveModifierByName("modifier_mana_shroud")
	if hero.IsManaBlastAcquired then 
		hero:AddAbility("saber_alter_mana_burst_upgrade_3")
		hero:FindAbilityByName("saber_alter_mana_burst_upgrade_3"):SetLevel(hero:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):GetLevel())
		hero:SwapAbilities("saber_alter_mana_burst_upgrade_3", "saber_alter_mana_burst_upgrade_2", true, false) 
		if not hero:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):IsCooldownReady() then 
			hero:FindAbilityByName("saber_alter_mana_burst_upgrade_3"):StartCooldown(hero:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("saber_alter_mana_burst_upgrade_2")
	else
		hero:AddAbility("saber_alter_mana_burst_upgrade_1")
		hero:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):SetLevel(hero:FindAbilityByName("saber_alter_mana_burst"):GetLevel())
		hero:SwapAbilities("saber_alter_mana_burst_upgrade_1", "saber_alter_mana_burst", true, false) 
		if not hero:FindAbilityByName("saber_alter_mana_burst"):IsCooldownReady() then 
			hero:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):StartCooldown(hero:FindAbilityByName("saber_alter_mana_burst"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("saber_alter_mana_burst")
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

-- needs particle
function OnManaBlastAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_max_mana_burst_window") then 
		hero:RemoveModifierByName("modifier_max_mana_burst_window")
	end

	hero.IsManaBlastAcquired = true
	hero.ManaBlastCount = 0

	hero:AddAbility("saber_alter_max_mana_burst_upgrade")
	hero:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):SetLevel(1)
	if not hero:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):IsCooldownReady() then 
		hero:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):StartCooldown(hero:FindAbilityByName("saber_alter_max_mana_burst_upgrade"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("saber_alter_max_mana_burst")
	hero:AddAbility("saber_alter_derange_upgrade")
	hero:FindAbilityByName("saber_alter_derange_upgrade"):SetLevel(hero:FindAbilityByName("saber_alter_derange"):GetLevel())
	hero:SwapAbilities("saber_alter_derange_upgrade", "saber_alter_derange", true, false) 
	if not hero:FindAbilityByName("saber_alter_derange"):IsCooldownReady() then 
		hero:FindAbilityByName("saber_alter_derange_upgrade"):StartCooldown(hero:FindAbilityByName("saber_alter_derange"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("saber_alter_derange")
	if hero.IsManaShroudImproved then 
		hero:AddAbility("saber_alter_mana_burst_upgrade_3")
		hero:FindAbilityByName("saber_alter_mana_burst_upgrade_3"):SetLevel(hero:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):GetLevel())
		hero:SwapAbilities("saber_alter_mana_burst_upgrade_3", "saber_alter_mana_burst_upgrade_1", true, false) 
		if not hero:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):IsCooldownReady() then 
			hero:FindAbilityByName("saber_alter_mana_burst_upgrade_3"):StartCooldown(hero:FindAbilityByName("saber_alter_mana_burst_upgrade_1"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("saber_alter_mana_burst_upgrade_1")
	else
		hero:AddAbility("saber_alter_mana_burst_upgrade_2")
		hero:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):SetLevel(hero:FindAbilityByName("saber_alter_mana_burst"):GetLevel())
		hero:SwapAbilities("saber_alter_mana_burst_upgrade_2", "saber_alter_mana_burst", true, false) 
		if not hero:FindAbilityByName("saber_alter_mana_burst"):IsCooldownReady() then 
			hero:FindAbilityByName("saber_alter_mana_burst_upgrade_2"):StartCooldown(hero:FindAbilityByName("saber_alter_mana_burst"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("saber_alter_mana_burst")
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnImproveFerocityAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsFerocityImproved = true
	hero:AddAbility("saber_alter_unleashed_ferocity_upgrade")
	hero:FindAbilityByName("saber_alter_unleashed_ferocity_upgrade"):SetLevel(1)
	hero:SwapAbilities("saber_alter_unleashed_ferocity_upgrade", "saber_alter_unleashed_ferocity", true, false) 
	if not hero:FindAbilityByName("saber_alter_unleashed_ferocity"):IsCooldownReady() then 
		hero:FindAbilityByName("saber_alter_unleashed_ferocity_upgrade"):StartCooldown(hero:FindAbilityByName("saber_alter_unleashed_ferocity"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("saber_alter_unleashed_ferocity")

	hero:AddAbility("saber_alter_vortigern_upgrade")
	hero:FindAbilityByName("saber_alter_vortigern_upgrade"):SetLevel(hero:FindAbilityByName("saber_alter_vortigern"):GetLevel())
	hero:SwapAbilities("saber_alter_vortigern_upgrade", "saber_alter_vortigern", true, false) 
	if not hero:FindAbilityByName("saber_alter_vortigern"):IsCooldownReady() then 
		hero:FindAbilityByName("saber_alter_vortigern_upgrade"):StartCooldown(hero:FindAbilityByName("saber_alter_vortigern"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("saber_alter_vortigern")
	hero:SetModifierStackCount("modifier_vortigern_ferocity_base", hero, 3)
	hero:SetModifierStackCount("modifier_vortigern_ferocity_show", hero, 3)

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnDarklightAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero:FindAbilityByName("saber_alter_darklight_passive"):SetLevel(1)
	hero.IsDarklightAcquired = true
	hero:AddAbility("saber_alter_excalibur_upgrade")
	hero:FindAbilityByName("saber_alter_excalibur_upgrade"):SetLevel(1)
	hero:SwapAbilities("saber_alter_excalibur_upgrade", "saber_alter_excalibur", true, false) 
	if not hero:FindAbilityByName("saber_alter_excalibur"):IsCooldownReady() then 
		hero:FindAbilityByName("saber_alter_excalibur_upgrade"):StartCooldown(hero:FindAbilityByName("saber_alter_excalibur"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("saber_alter_excalibur")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end
