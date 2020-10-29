function FarSightVision(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	local radius = keys.ability:GetSpecialValueFor("radius")
	local targetLoc = keys.target_points[1]

	local visiondummy = SpawnVisionDummy(caster, targetLoc, radius, keys.Duration, false)
	
	if caster.IsEagleEyeAcquired then 
		SpawnVisionDummy(caster, targetLoc, radius, keys.Duration, true)
	end

	if caster.IsHruntingAcquired and not caster:HasModifier("modifier_hrunting_cooldown") then 
		if caster.IsEagleEyeAcquired then 
			if caster:FindAbilityByName("archer_hrunting_upgrade"):IsCooldownReady() then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_archer_hrunting_window", {})
			end
		else
			if caster:FindAbilityByName("archer_hrunting"):IsCooldownReady() then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_archer_hrunting_window", {})
			end
		end
	end
	
	local circleFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_clairvoyance_circle.vpcf", PATTACH_CUSTOMORIGIN, visiondummy )
	ParticleManager:SetParticleControl( circleFxIndex, 0, visiondummy:GetAbsOrigin() )
	ParticleManager:SetParticleControl( circleFxIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( circleFxIndex, 2, Vector( 8, 0, 0 ) )
	ParticleManager:SetParticleControl( circleFxIndex, 3, Vector( 100, 255, 255 ) )
	
	local dustFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_clairvoyance_dust.vpcf", PATTACH_CUSTOMORIGIN, visiondummy )
	ParticleManager:SetParticleControl( dustFxIndex, 0, visiondummy:GetAbsOrigin() )
	ParticleManager:SetParticleControl( dustFxIndex, 1, Vector( radius, radius, radius ) )
	
	visiondummy.circle_fx = circleFxIndex
	visiondummy.dust_fx = dustFxIndex
	ParticleManager:SetParticleControl( dustFxIndex, 1, Vector( radius, radius, radius ) )
			
	-- Destroy particle after delay
	Timers:CreateTimer( keys.Duration, function()
			ParticleManager:DestroyParticle( circleFxIndex, false )
			ParticleManager:DestroyParticle( dustFxIndex, false )
			ParticleManager:ReleaseParticleIndex( circleFxIndex )
			ParticleManager:ReleaseParticleIndex( dustFxIndex )
			return nil
		end
	)

    LoopOverPlayers(function(player, playerID, playerHero)
    	--print("looping through " .. playerHero:GetName())
        if playerHero:GetTeamNumber() ~= caster:GetTeamNumber() and player and playerHero then
        	AddFOWViewer(playerHero:GetTeamNumber(), targetLoc, 50, 0.5, false)
        	
        end
    end)
	-- Particles
	--visiondummy:EmitSound("Hero_KeeperOfTheLight.BlindingLight") 
	Timers:CreateTimer(0.033, function()
		EmitSoundOnLocationWithCaster(targetLoc, "Hero_KeeperOfTheLight.BlindingLight", visiondummy)
	end)		
end

function OnHruntingWindow(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsEagleEyeAcquired then
		caster:SwapAbilities("archer_clairvoyance_upgrade", "archer_hrunting_upgrade", false, true) 
	else
		caster:SwapAbilities("archer_clairvoyance", "archer_hrunting", false, true) 
	end
end

function OnHruntingWindowDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsEagleEyeAcquired then
		caster:SwapAbilities("archer_clairvoyance_upgrade", "archer_hrunting_upgrade", true, false) 
	else
		caster:SwapAbilities("archer_clairvoyance", "archer_hrunting", true, false) 
	end
end

function OnHruntingWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_archer_hrunting_window")
end

function OnHruntingFilter (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if target:GetName() == "npc_dota_ward_base" then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Target")
	end
end

function OnHruntCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local ply = caster:GetPlayerOwner()

	ability:EndCooldown()
	-- Show hrunting cast
	if caster.hrunting_particle ~= nil then
		ParticleManager:DestroyParticle( caster.hrunting_particle, false )
		ParticleManager:ReleaseParticleIndex( caster.hrunting_particle )
	end
	Timers:CreateTimer(4.0, function() 
		if caster.hrunting_particle ~= nil then
			ParticleManager:DestroyParticle( caster.hrunting_particle, false )
			ParticleManager:ReleaseParticleIndex( caster.hrunting_particle )
		end
		return
	end)
	caster.hrunting_particle = ParticleManager:CreateParticle( "particles/econ/events/ti4/teleport_end_ti4.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( caster.hrunting_particle, 2, Vector( 255, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(caster.hrunting_particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster.hrunting_particle, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	caster.hruntingCrosshead = ParticleManager:CreateParticleForTeam("particles/custom/archer/archer_broken_phantasm/archer_broken_phantasm_crosshead.vpcf", PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeamNumber())
	if keys.target:IsHero() then
		Say(ply, "Hrunting targets " .. FindName(keys.target:GetName()) .. ".", true)
	end
end

function OnHruntStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	ParticleManager:DestroyParticle(caster.hruntingCrosshead, true)
	if not caster:CanEntityBeSeenByMyTeam(target) or not IsInSameRealm(caster:GetAbsOrigin(), target:GetAbsOrigin()) then 
		
		return 
	end
	local base_damage = ability:GetSpecialValueFor("damage")
	local mana_used = ability:GetSpecialValueFor("mana_used")
	ability:StartCooldown(ability:GetCooldown(1))
	EmitGlobalSound("Emiya_Hrunt" .. math.random(1,2))
	caster:RemoveModifierByName("modifier_archer_hrunting_window")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hrunting_cooldown", {})
	caster.HruntDamage =  base_damage + (caster:GetMana() * mana_used / 100)

	caster:SetMana(caster:GetMana() * (100 - mana_used) / 100 ) 
	caster.hrunting_bounce = 0
	
	local info = {
		Target = keys.target,
		Source = keys.caster, 
		Ability = keys.ability,
		EffectName = "particles/custom/archer/archer_hrunting_orb.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = 3000,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bDodgeable = false
	}

	ProjectileManager:CreateTrackingProjectile(info) 
	-- give vision for enemy
	if IsValidEntity(target) then
		SpawnVisionDummy(target, caster:GetAbsOrigin(), 500, 3, false)
	end
	--EmitGlobalSound("Archer.Hrunting_Fireoff")
	--caster:EmitSound("Emiya_Hrunt2")
	if keys.target:IsHero() then
		Say(ply, "Hrunting fired at " .. FindName(keys.target:GetName()) .. ".", true)
	end
end

function OnHruntInterrupted(keys)
	local caster = keys.caster
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	ParticleManager:DestroyParticle( caster.hrunting_particle, false )
	ParticleManager:ReleaseParticleIndex( caster.hrunting_particle )
	ParticleManager:DestroyParticle(caster.hruntingCrosshead, true)
	Say(ply, "Hrunting failed.", true)
end

function OnHruntHit(keys)
	if IsSpellBlocked(keys.target) then return end -- Linken effect checker
	keys.target:EmitSound("Archer.HruntHit")
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun = ability:GetSpecialValueFor("stun_duration")
	-- Create Particle
	local explosionParticleIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_hrunting_area.vpcf", PATTACH_CUSTOMORIGIN, keys.target )
	ParticleManager:SetParticleControl( explosionParticleIndex, 0, keys.target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( explosionParticleIndex, 1, Vector( 200, 200, 0 ) )
	
	-- Destroy Particle
	Timers:CreateTimer( 1.0, function()
		ParticleManager:DestroyParticle( explosionParticleIndex, false )
		ParticleManager:ReleaseParticleIndex( explosionParticleIndex )
		return nil
	end)

	if not keys.target:IsMagicImmune() then
		keys.target:AddNewModifier(caster, keys.target, "modifier_stunned", {Duration = stun})
	end
	
	
	local bounce_damage = ability:GetSpecialValueFor("bounce_damage")
	if caster.hrunting_bounce == 0 then
		DoDamage(caster, target, caster.HruntDamage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
	elseif caster.hrunting_bounce == 1 then
		DoDamage(caster, target, caster.HruntDamage * bounce_damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	elseif caster.hrunting_bounce == 2 then
		DoDamage(caster, target, caster.HruntDamage * bounce_damage * bounce_damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end
	local max_bounce = ability:GetSpecialValueFor("max_bounce")
	local radius = ability:GetSpecialValueFor("radius")
	if caster.hrunting_bounce <= max_bounce then
        local hBounceTarget = nil

        local tTargets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
        for i=1, #tTargets do
            if tTargets[i] ~= target then
                hBounceTarget = tTargets[i]
                break
            end
        end

        if hBounceTarget ~= nil then
			FireProjectile(hBounceTarget, target, ability)
			caster.hrunting_bounce = caster.hrunting_bounce + 1

        end
    end	
end

function FireProjectile(hTarget, hSource, ability)

    local tProjectile = {
        Target = hTarget,
        Source = hSource,
        Ability = ability,
        EffectName = "particles/custom/archer/archer_hrunting_orb.vpcf",
        iMoveSpeed = 3000,
        vSourceLoc = hSource:GetAbsOrigin(),
        bDodgeable = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    }

    ProjectileManager:CreateTrackingProjectile(tProjectile)
end

function OnRhoStart(keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	--[[if target:HasModifier("modifier_rho_aias") then 
		caster:Stop()
		ability:EndCooldown()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Target Already Has Rho Aias")
		if caster.IsImproveProjectionAcquired then 
			caster:SetMana(caster:GetMana() + ability:GetManaCost(1) - 100)
		else
			caster:SetMana(caster:GetMana() + ability:GetManaCost(1))
		end
		return
	end]]
	caster.rhoTarget = target 
	caster.rhoTarget.rhoShieldAmount = keys.ShieldAmount

	ability:ApplyDataDrivenModifier(caster, caster.rhoTarget, "modifier_rho_aias", {})
	caster.rhoTarget:SetModifierStackCount("modifier_rho_aias", caster, keys.ShieldAmount/10)
	local soundQueue = math.random(1,2)

	if soundQueue == 1 then
		caster:EmitSound("Archer.RhoAias" ) 
	else
		caster:EmitSound("Emiya_Rho_Aias_Alt")
	end
	caster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
end

function OnRhoCreate (keys)
	local caster = keys.caster
	-- Attach particle for shield facing the forward vector
	caster.rhoShieldParticleIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_rhoaias_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.rhoTarget )
end

function OnRhoThink (keys)
	local caster = keys.caster
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 0, caster.rhoTarget:GetAbsOrigin() )
			
	local origin = caster.rhoTarget:GetAbsOrigin()
	local forwardVec = caster.rhoTarget:GetForwardVector()
	local rightVec = caster.rhoTarget:GetRightVector()
			
	-- Hard coded value, these values have to be adjusted manually for core and end point of each petal
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 1, Vector( origin.x + 150 * forwardVec.x, origin.y + 150 * forwardVec.y, origin.z + 225 ) ) -- petal_core, center of petals
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 2, Vector( origin.x - 30 * forwardVec.x, origin.y - 30 * forwardVec.y, origin.z + 375 ) ) -- petal_a
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 3, Vector( origin.x + 150 * forwardVec.x, origin.y + 150 * forwardVec.y, origin.z ) ) -- petal_d
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 4, Vector( origin.x + 150 * rightVec.x, origin.y + 150 * rightVec.y, origin.z + 300 ) ) -- petal_b
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 5, Vector( origin.x - 150 * rightVec.x, origin.y - 150 * rightVec.y, origin.z + 300 ) ) -- petal_c
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 6, Vector( origin.x + 150 * rightVec.x + 60 * forwardVec.x, origin.y + 150 * rightVec.y + 60 * forwardVec.y, origin.z + 25 ) ) -- petal_e
	ParticleManager:SetParticleControl( caster.rhoShieldParticleIndex, 7, Vector( origin.x - 150 * rightVec.x + 60 * forwardVec.x, origin.y - 150 * rightVec.y + 60 * forwardVec.y, origin.z + 25 ) ) -- petal_f
end

function OnRhoDestroy (keys)
	local caster = keys.caster 
	ParticleManager:DestroyParticle( caster.rhoShieldParticleIndex, false )
	ParticleManager:ReleaseParticleIndex( caster.rhoShieldParticleIndex )
end

function OnRhoDamaged(keys)
	local caster = keys.caster 
	local currentHealth = caster.rhoTarget:GetHealth() 

	-- Create particles
	local onHitParticleIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit_sphere.vpcf", PATTACH_CUSTOMORIGIN, keys.unit )
	ParticleManager:SetParticleControl( onHitParticleIndex, 2, keys.unit:GetAbsOrigin() )
	
	Timers:CreateTimer( 0.5, function()
			ParticleManager:DestroyParticle( onHitParticleIndex, false )
			ParticleManager:ReleaseParticleIndex( onHitParticleIndex )
		end
	)

	caster.rhoTarget.rhoShieldAmount = caster.rhoTarget.rhoShieldAmount - keys.DamageTaken
	if caster.rhoTarget.rhoShieldAmount <= 0 then
		if currentHealth + caster.rhoTarget.rhoShieldAmount <= 0 then
			--print("lethal")
		else
			--print("rho broken, but not lethal")
			caster.rhoTarget:RemoveModifierByName("modifier_rho_aias")
			caster.rhoTarget:SetHealth(currentHealth + keys.DamageTaken + caster.rhoTarget.rhoShieldAmount)
			caster.rhoTarget.rhoShieldAmount = 0
		end
	else
		--print("rho not broken, remaining shield : " .. rhoTarget.rhoShieldAmount)
		caster.rhoTarget:SetHealth(currentHealth + keys.DamageTaken)
		caster.rhoTarget:SetModifierStackCount("modifier_rho_aias", caster, caster.rhoTarget.rhoShieldAmount/10)
	end
end

function MartinBonusHp (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local int = caster:GetIntellect()
	local stacks = math.floor(int)
	if caster:HasModifier("modifier_shroud_of_martin_hp") then 
		caster:SetModifierStackCount("modifier_shroud_of_martin_hp", caster, stacks)
	end
end

function KanshouByakuyaStart (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_destination = ability:GetCursorPosition()

	local ply = caster:GetPlayerOwner()
	local forward = (target_destination - caster:GetAbsOrigin()):Normalized()
	local origin = caster:GetAbsOrigin()
	local num_blade = ability:GetSpecialValueFor("num_blade")

	local forwardVec = caster:GetForwardVector()
	local leftVec = Vector(-forwardVec.y, forwardVec.x, 0)
	local rightVec = Vector(forwardVec.y, -forwardVec.x, 0)

	-- Defaults the crossing point to 600 range in front of where Emiya is facing
	if (math.abs(target_destination.x - origin.x) < 500) and (math.abs(target_destination.y - origin.y) < 500) then
		target_destination = target_destination - (caster:GetAbsOrigin() - target_destination):Normalized() * 500
	end

	local lsword_origin = origin + leftVec * 75	
	local left_forward = (Vector(target_destination.x, target_destination.y, 0) - lsword_origin):Normalized()
	left_forward.z = origin.z
	local rsword_origin = origin + rightVec * 75	
	local right_forward = (Vector(target_destination.x, target_destination.y, 0) - rsword_origin):Normalized()	
	right_forward.z = origin.z

	local sound = math.random(1,10)

	if sound < 5 then
		caster:EmitSound("emiya_kanshou_byakuya_" .. math.random(1,2))
	end

	if caster.IsOveredgeAcquired then
		local kb_stack = caster:GetModifierStackCount("modifier_kanshou_byakuya", caster) or 0
		local max_stack = ability:GetSpecialValueFor("max_stack")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kanshou_byakuya", {})
		if kb_stack >= max_stack then 
			caster:SetModifierStackCount("modifier_kanshou_byakuya", caster, max_stack)
		else
			caster:SetModifierStackCount("modifier_kanshou_byakuya", caster, kb_stack + 1)
		end
	end

	--Left Sword
	local timeL = 0.05
	for i = 1, num_blade/2 do		
		Timers:CreateTimer(timeL, function()
			KBFireSword(lsword_origin, left_forward , ability,caster)
			local projectileDurationL = 900 / 1350
			local dmyLLoc = lsword_origin 
			local dummyL = CreateUnitByName("dummy_unit", dmyLLoc, false, caster, caster, caster:GetTeamNumber())
			dummyL:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
			dummyL:SetForwardVector(left_forward)

			--local fxIndex1 = ParticleManager:CreateParticle( "particles/custom/archer/emiya_kb_swords.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummyL )
			local fxIndex1 = ParticleManager:CreateParticle( "particles/custom/archer/archer_byakuya.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummyL )
			ParticleManager:SetParticleControl( fxIndex1, 0, dummyL:GetAbsOrigin() )

			Timers:CreateTimer(function()
				if IsValidEntity(dummyL) then
					dmyLLoc = dmyLLoc + (1350 * 0.05) * Vector(left_forward.x, left_forward.y, 0)
					dummyL:SetAbsOrigin(GetGroundPosition(dmyLLoc, nil))
					return 0.05
				else
					return nil
				end
			end)		

			Timers:CreateTimer(projectileDurationL, function()
				ParticleManager:DestroyParticle( fxIndex1, false )
				ParticleManager:ReleaseParticleIndex( fxIndex1 )			
				Timers:CreateTimer(0.05, function()
					dummyL:RemoveSelf()
					return nil
				end)

				return nil
			end)
		end)
		timeL = timeL + 0.4		
	end

	-- Right Sword
	local timeR = 0.25
	for j = 1, num_blade/2 do		
		Timers:CreateTimer(timeR, function()
			KBFireSword(rsword_origin, right_forward , ability,caster)
			local projectileDurationR = 900 / 1350
			local dmyRLoc = rsword_origin 
			local dummyR = CreateUnitByName("dummy_unit", dmyRLoc, false, caster, caster, caster:GetTeamNumber())
			dummyR:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
			dummyR:SetForwardVector(right_forward)	

			local fxIndex2 = ParticleManager:CreateParticle( "particles/custom/archer/archer_kanshou.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummyR )
			ParticleManager:SetParticleControl( fxIndex2, 0, dummyR:GetAbsOrigin() )

			Timers:CreateTimer(function()
				if IsValidEntity(dummyR) then
					dmyRLoc = GetGroundPosition(dmyRLoc + (1350 * 0.05) * Vector(right_forward.x, right_forward.y, 0), nil)								
					dummyR:SetAbsOrigin(dmyRLoc)
					return 0.05
				else
					return nil
				end
			end)
			
			Timers:CreateTimer(projectileDurationR, function()
				ParticleManager:DestroyParticle( fxIndex2, false )
				ParticleManager:ReleaseParticleIndex( fxIndex2 )
				Timers:CreateTimer(0.05, function()
					dummyR:RemoveSelf()
					return nil
				end)
				return nil
			end)
		end)

		timeR = timeR + 0.4		
	end

end

function KBFireSword(origin, forwardVec,ability,caster)
	local aoe = ability:GetSpecialValueFor("sword_aoe")
	local range = ability:GetSpecialValueFor("range")	

	forwardVec = GetGroundPosition(forwardVec, nil)

    local projectileTable = {
		Ability = ability,
		--EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
		iMoveSpeed = 1350,
		vSpawnOrigin = origin,
		fDistance = range,
		Source = caster,
		fStartRadius = aoe,
        fEndRadius = aoe,
		bHasFrontialCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		fExpireTime = GameRules:GetGameTime() + 3,
		bDeleteOnHit = false,
		vVelocity = forwardVec * 1350,
		
	}

    local projectile = ProjectileManager:CreateLinearProjectile(projectileTable)

    caster:EmitSound("Hero_Luna.Attack")
end

function OnKBHit(keys)
	local target = keys.target
	if target == nil then return end

	--for k,v in pairs(tData) do print(k,v) end

	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local KBHitFx = ParticleManager:CreateParticle("particles/econ/courier/courier_mechjaw/mechjaw_death_sparks.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(KBHitFx, 0, target:GetAbsOrigin()) 
	-- Destroy particle after delay
	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle( KBHitFx, false )
		ParticleManager:ReleaseParticleIndex( KBHitFx )
	end)

	target:EmitSound("Hero_Juggernaut.OmniSlash.Damage")
	DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
end

function OnBPUpgrade (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if caster.IsHruntingAcquired then 
		if caster.IsEagleEyeAcquired then
			caster:FindAbilityByName("archer_hrunting_upgrade"):SetLevel(ability:GetLevel())
		else
			caster:FindAbilityByName("archer_hrunting"):SetLevel(ability:GetLevel())
		end
	end
end

function OnBPCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	ability:EndCooldown()
	caster:GiveMana(ability:GetManaCost(1))

	caster.BPparticle = ParticleManager:CreateParticleForTeam("particles/custom/archer/archer_broken_phantasm/archer_broken_phantasm_crosshead.vpcf", PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeamNumber())

	ParticleManager:SetParticleControl( caster.BPparticle, 0, target:GetAbsOrigin() + Vector(0,0,100)) 
	ParticleManager:SetParticleControl( caster.BPparticle, 1, target:GetAbsOrigin() + Vector(0,0,100)) 
	if keys.target:IsHero() then
		Say(ply, "Broken Phantasm targets " .. FindName(keys.target:GetName()) .. ".", true)
	end
end

function OnBPStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	ParticleManager:DestroyParticle(caster.BPparticle, true)
	if not caster:CanEntityBeSeenByMyTeam(target) or caster:GetRangeToUnit(target) > 4500 or caster:GetMana() < ability:GetManaCost(1) or not IsInSameRealm(caster:GetAbsOrigin(), target:GetAbsOrigin()) then 
		Say(ply, "Broken Phantasm failed.", true)
		return 
	end

	ability:StartCooldown(ability:GetCooldown(1))
	caster:SetMana(caster:GetMana() - ability:GetManaCost(1))
	local info = {
		Target = keys.target,
		Source = keys.caster, 
		Ability = keys.ability,
		EffectName = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = 3000,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bDodgeable = true
	}
	ProjectileManager:CreateTrackingProjectile(info) 
	caster:EmitSound("Emiya_Caladbolg_" .. math.random(1,2))
	-- give vision for enemy
	if IsValidEntity(target) then
		SpawnVisionDummy(target, caster:GetAbsOrigin(), 500, 2, false)
	end
	
	if keys.target:IsHero() then
		Say(ply, "Broken Phantasm fired at " .. FindName(keys.target:GetName()) .. ".", true)
	end
end

function OnBPInterrupted(keys)
	local caster = keys.caster
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	ParticleManager:DestroyParticle(caster.BPparticle, true)
	Say(ply, "Broken Phantasm failed.", true)
end

function OnBPHit(keys)
	if IsSpellBlocked(keys.target) then return end -- Linken effect checker
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	keys.target:EmitSound("Misc.Crash")
	local total_damage = ability:GetSpecialValueFor("total_damage")
	local splash_damage = ability:GetSpecialValueFor("splash_damage")

	DoDamage(caster, target, total_damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)

	local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, keys.Radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if v ~= target then
        	DoDamage(caster, v, splash_damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
        end
    end


    local BpHitFx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(BpHitFx, 3, target:GetAbsOrigin())
	--ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin()) -- target location
	Timers:CreateTimer( 2, function()
		ParticleManager:DestroyParticle( BpHitFx, false )
		ParticleManager:ReleaseParticleIndex( BpHitFx )
	end)

	if not target:IsMagicImmune() then
		target:AddNewModifier(caster, target, "modifier_stunned", {Duration = keys.StunDuration})
	end
end

function OnCraneWingStart (keys)
	local caster = keys.caster 
	local ability = keys.ability
	local targetPoint = keys.target_points[1]
	local dist = (caster:GetAbsOrigin() - targetPoint):Length2D() * 10/6
	local castRange = keys.castRange
	local damage = ability:GetSpecialValueFor("damage")

	-- When you exit the ubw on the last moment, dist is going to be a pretty high number, since the targetPoint is on ubw but you are outside it
	-- If it's, then we can't use it like that. Either cancel Overedge, or use a default one.
	-- 2000 is a fixedNumber, just to check if dist is not valid. Over 2000 is surely wrong. (Max is close to 900)
	if dist > 2000 then
		dist = 600 --Default one
	end

	if GridNav:IsBlocked(targetPoint) or not GridNav:IsTraversable(targetPoint) then
		keys.ability:EndCooldown() 
		caster:GiveMana(ability:GetManaCost(ability:GetLevel())) 
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Travel")
		return 
	end 
	caster:RemoveModifierByName("modifier_crane_wing_window")
	caster:RemoveModifierByName("modifier_crane_wing_stack")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_crane_cooldown", {})
	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 0.59)
    local archer = Physics:Unit(caster)
    caster:PreventDI()
    caster:SetPhysicsFriction(0)
    caster:SetPhysicsVelocity(Vector(caster:GetForwardVector().x * dist, caster:GetForwardVector().y * dist, 850))
    caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
    caster:FollowNavMesh(false)	
    caster:SetAutoUnstuck(false)
    caster:SetPhysicsAcceleration(Vector(0,0,-2666))

    local soundQueue = math.random(1,3)

	local soundQueue = math.random(2,3)

	caster:EmitSound("Hero_PhantomLancer.Doppelwalk") 
	caster:EmitSound("Emiya_Crane" .. soundQueue)

	StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.8})

	local stacks = 0

	if caster.IsOveredgeAcquired then
		if caster:HasModifier("modifier_kanshou_byakuya") then
			stacks = caster:GetModifierStackCount("modifier_kanshou_byakuya", keys.ability)
			FireExtraSwords(caster,stacks,targetPoint, keys.Radius)
			caster:RemoveModifierByName("modifier_kanshou_byakuya") 
		end
	end

	Timers:CreateTimer({
		endTime = 0.6,
		callback = function()
		caster:EmitSound("Hero_Centaur.DoubleEdge") 
		caster:PreventDI(false)
		caster:SetPhysicsVelocity(Vector(0,0,0))
		caster:SetAutoUnstuck(true)
       	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

	-- Create particles
		-- Variable for cross slash
		local origin = caster:GetAbsOrigin()
		local forwardVec = caster:GetForwardVector()
		local rightVec = caster:GetRightVector()
		local backPoint1 = origin - keys.Radius * forwardVec + keys.Radius * rightVec
		local backPoint2 = origin - keys.Radius * forwardVec - keys.Radius * rightVec
		local frontPoint1 = origin + keys.Radius * forwardVec - keys.Radius * rightVec
		local frontPoint2 = origin + keys.Radius * forwardVec + keys.Radius * rightVec
		backPoint1.z = backPoint1.z + 250
		backPoint2.z = backPoint2.z + 250

	-- Variable for vertical slash
		--[[local origin = caster:GetAbsOrigin()
		local forwardVec = caster:GetForwardVector()
		local rightVec = caster:GetRightVector()
		local backPoint1 = origin - 200 * forwardVec + 150 * rightVec
		local backPoint2 = origin - 200 * forwardVec - 150 * rightVec
		local frontPoint1 = origin + 200 * forwardVec + 50 * rightVec
		local frontPoint2 = origin + 200 * forwardVec - 50 * rightVec
		backPoint1.z = backPoint1.z + 250
		backPoint2.z = backPoint2.z + 250]]
		
	-- Cross slash
		local slash1ParticleIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_overedge_slash.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( slash1ParticleIndex, 2, backPoint1 )
		ParticleManager:SetParticleControl( slash1ParticleIndex, 3, frontPoint1 )
	
		local slash2ParticleIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_overedge_slash.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( slash2ParticleIndex, 2, backPoint2 )
		ParticleManager:SetParticleControl( slash2ParticleIndex, 3, frontPoint2 )
		
	-- Stomp
		local stompParticleIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( stompParticleIndex, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( stompParticleIndex, 1, Vector( keys.Radius, keys.Radius, keys.Radius ) )
		
	-- Destroy particle
		Timers:CreateTimer( 1.0, function()
			ParticleManager:DestroyParticle( slash1ParticleIndex, false )
			ParticleManager:DestroyParticle( slash2ParticleIndex, false )
			ParticleManager:DestroyParticle( stompParticleIndex, false )
			ParticleManager:ReleaseParticleIndex( slash1ParticleIndex )
			ParticleManager:ReleaseParticleIndex( slash2ParticleIndex )
			ParticleManager:ReleaseParticleIndex( stompParticleIndex )
		end)
		
        local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
	       	DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	    end
	end})
end

function FireExtraSwords(caster,charge,targetPoint, radius)

	local targetCandidates = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	local kbAbility = caster:FindAbilityByName("archer_kanshou_byakuya_upgrade")

	if #targetCandidates >= 1 then
		local target = targetCandidates[1]

		for i = 1, charge do
			targetPoint = targetPoint + RandomVector(500)
			local dummy = CreateUnitByName("dummy_unit", targetPoint, false, caster, caster, caster:GetTeamNumber())
			dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)

			Timers:CreateTimer(2, function()
				dummy:RemoveSelf()
			end)

			local projectileSpeed = (targetPoint - target:GetAbsOrigin()):Length2D() / 0.55
			local info = {
				Target = target, 
				Source = dummy,
				Ability = kbAbility,
				EffectName = "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf",
				vSpawnOrigin = dummy:GetAbsOrigin(),
				iMoveSpeed = projectileSpeed,
				bDodgeable = true,
			}
			ProjectileManager:CreateTrackingProjectile(info) 
		end
	end
end

function OnTLCWHit (keys)
	local caster = keys.caster 
	local target = keys.target 
	local ability = keys.ability 
	local KBAbility = caster:FindAbilityByName("archer_kanshou_byakuya_upgrade")
	local damage = KBAbility:GetSpecialValueFor("damage")
	local stun = KBAbility:GetSpecialValueFor("stun")

	local KBHitFx = ParticleManager:CreateParticle("particles/econ/courier/courier_mechjaw/mechjaw_death_sparks.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(KBHitFx, 0, target:GetAbsOrigin()) 
	-- Destroy particle after delay
	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle( KBHitFx, false )
		ParticleManager:ReleaseParticleIndex( KBHitFx )
	end)

	DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	target:EmitSound("Hero_Juggernaut.OmniSlash.Damage")
	if not target:IsMagicImmune() then 
		target:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun})
	end
end

function OnUBWChant (keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilities = {}
	if caster.ubw_chant == nil then 
		caster.ubw_chant = 0
	end
	caster.ubw_chant = caster.ubw_chant + 1
	local ubw_stacks = caster:GetModifierStackCount("modifier_UBW_chant", caster) or 0
	local cd_reduce = ability:GetSpecialValueFor("cooldown_set")
	for i = 0,2 do
		abilities[i] = caster:GetAbilityByIndex(i)
		local abilities_cooldown = abilities[i]:GetCooldownTimeRemaining()
		if not abilities[i]:IsCooldownReady() then
			if abilities_cooldown > cd_reduce then 
				abilities[i]:EndCooldown()
				abilities[i]:StartCooldown(abilities_cooldown - cd_reduce)
			else
				abilities[i]:EndCooldown()
				abilities[i]:StartCooldown(1.0)
			end
		end
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_UBW_chant", {})
	caster:SetModifierStackCount("modifier_UBW_chant", caster, ubw_stacks + 1)

	OnUBWChantCheck(caster, ubw_stacks)

	if ubw_stacks == 5 then
		if caster.IsImproveProjectionAcquired then
			caster:SwapAbilities("archer_unlimited_bladeworks_chant_upgrade", "archer_unlimited_bladeworks_upgrade", false, true)
			caster:FindAbilityByName("archer_unlimited_bladeworks_upgrade"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		else
			caster:SwapAbilities("archer_unlimited_bladeworks_chant", "archer_unlimited_bladeworks", false, true)
			caster:FindAbilityByName("archer_unlimited_bladeworks"):StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end

	if ubw_stacks >= 6 then
		caster:RemoveModifierByName("modifier_UBW_chant")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ubw_choronosphere_aura", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ubw_chronosphere_self", {})
		StartUBW (ability, caster)
	end
end

function OnUBWChantDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.ubw_chant >= 6 then
		if caster.IsImproveProjectionAcquired then
			caster:SwapAbilities("archer_unlimited_bladeworks_chant_upgrade", "archer_unlimited_bladeworks_upgrade", true, false)
		else
			caster:SwapAbilities("archer_unlimited_bladeworks_chant", "archer_unlimited_bladeworks", true, false)
		end
	end
	caster.ubw_chant = 0
end

function OnUBWChantCheck (caster,ubw_stacks)

	if ubw_stacks == 0 then
		print("ubw1")
		EmitGlobalSound("emiya_ubw1")
	elseif ubw_stacks == 1 then
		print("ubw2")
		EmitGlobalSound("emiya_ubw2")
	elseif ubw_stacks == 2 then
		print("ubw3")
		EmitGlobalSound("emiya_ubw3")	
	elseif ubw_stacks == 3 then
		print("ubw4")
		EmitGlobalSound("emiya_ubw4")
	elseif ubw_stacks == 4 then
		print("ubw5")
		EmitGlobalSound("emiya_ubw5")
	elseif ubw_stacks == 5 then
		print("ubw6")
		EmitGlobalSound("emiya_ubw6")
	elseif ubw_stacks == 6 then
		print("ubw7")
		EmitGlobalSound("emiya_ubw7")
	end
end

function ChronoStop( keys )
	local target = keys.target 
	local caster = keys.caster
	if caster:IsAlive() then
        local stopOrder = {
           	UnitIndex = target:entindex(), 
           	OrderType = DOTA_UNIT_ORDER_STOP
       	}

        ExecuteOrderFromTable(stopOrder) 
    end
end

function StartUBW (ability, caster)
	local aoe = ability:GetSpecialValueFor("radius")
	local casterLocation = caster:GetAbsOrigin()
	local castDelay = ability:GetSpecialValueFor("form_delay")

	--[[local targets = FindUnitsInRadius(caster:GetTeamNumber(), casterLocation, nil, aoe - 500, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    for q,w in pairs(targets) do
		if caster:IsAlive() then

        	--giveUnitDataDrivenModifier(caster, w, "pause_sealdisabled", castDelay)
        	local stopOrder = {
            	UnitIndex = w:entindex(), 
            	OrderType = DOTA_UNIT_ORDER_STOP
       	 	}

        	ExecuteOrderFromTable(stopOrder) 
        	ability:ApplyDataDrivenModifier(caster, w, "modifier_ubw_chronosphere",{})
    	end
    end]]

    --giveUnitDataDrivenModifier(caster, caster, "pause", castDelay)
    StartAnimation(caster, {duration=castDelay, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.5})

    Timers:CreateTimer({
        endTime = castDelay,
        callback = function()
        if caster:IsAlive() then
        	--[[--ไม่เข้า ubw
			if target:GetName() == "" then return end]]
            local newLocation = caster:GetAbsOrigin()
            --[[caster.UBWLocator = CreateUnitByName("ping_sign2", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
            caster.UBWLocator:FindAbilityByName("ping_sign_passive"):SetLevel(1)
            caster.UBWLocator:AddNewModifier(caster, caster, "modifier_kill", {duration = 15})
            caster.UBWLocator:SetAbsOrigin(caster:GetAbsOrigin())]]

            EnterUBW(ability, caster)
            caster:RemoveModifierByName("modifier_archer_hrunting_window")
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_unlimited_bladeworks", {})
            ArcherCheckCombo(caster, ability)
            print("enter ubw?")

            local entranceFlashParticle = ParticleManager:CreateParticle("particles/custom/archer/ubw/entrance_flash.vpcf", PATTACH_ABSORIGIN, caster)
            ParticleManager:SetParticleControl(entranceFlashParticle, 0, newLocation)
            ParticleManager:CreateParticle("particles/custom/archer/ubw/exit_flash.vpcf", PATTACH_ABSORIGIN, caster)
        end
    end
    })

    for i=2, 3 do
        local dummy = CreateUnitByName("dummy_unit", casterLocation, false, caster, caster, i)
        dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
        dummy:SetAbsOrigin(ubwCenter)
        AddFOWViewer(i, ubwCenter, 1600, 3, false)

        local particle = ParticleManager:CreateParticleForTeam("particles/custom/archer/ubw/firering.vpcf", PATTACH_ABSORIGIN, dummy, i)
        ParticleManager:SetParticleControl(particle, 6, casterLocation)
        local particleRadius = 0
        Timers:CreateTimer(0, function()
            if particleRadius < aoe then
                particleRadius = particleRadius + aoe * 0.03 / 2
                ParticleManager:SetParticleControl(particle, 1, Vector(particleRadius,0,0))
                return 0.03
            end
        end)
    end
end

function EnterUBW(ability, caster)
	local ubw_duration = ability:GetSpecialValueFor("ubw_duration")
    CreateUITimer("Unlimited Blade Works", ubw_duration, "ubw_timer")
    
    local radius = ability:GetSpecialValueFor("radius")

    local ubwdummyLoc1 = ubwCenter + Vector(600,-600, 1000)
    local ubwdummyLoc2 = ubwCenter + Vector(600,600, 1000)
    local ubwdummyLoc3 = ubwCenter + Vector(-600,600, 1000)
    local ubwdummyLoc4 = ubwCenter + Vector(-600,-600, 1000)

    -- swap Archer's skillset with UBW ones
    
    

    -- Find eligible UBW targets
    ubwTargets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    caster.IsUBWDominant = true
    
    -- Remove any dummy or hero in jump
    i = 1
    while i <= #ubwTargets do

        if IsValidEntity(ubwTargets[i]) and not ubwTargets[i]:IsNull() then
            ProjectileManager:ProjectileDodge(ubwTargets[i]) -- Disjoint particles
            if ubwTargets[i]:HasModifier("jump_pause") 
                or string.match(ubwTargets[i]:GetUnitName(),"dummy") 
                or ubwTargets[i]:HasModifier("spawn_invulnerable") 
                and ubwTargets[i] ~= caster then 
                table.remove(ubwTargets, i)
                i = i - 1
            end
        end
        i = i + 1
    end
    caster.IsUBWActive = true
     -- Add sword shooting dummies
    local ubwdummy1 = CreateUnitByName("dummy_unit", ubwdummyLoc1, false, caster, caster, caster:GetTeamNumber())
    local ubwdummy2 = CreateUnitByName("dummy_unit", ubwdummyLoc2, false, caster, caster, caster:GetTeamNumber())
    local ubwdummy3 = CreateUnitByName("dummy_unit", ubwdummyLoc3, false, caster, caster, caster:GetTeamNumber())
    local ubwdummy4 = CreateUnitByName("dummy_unit", ubwdummyLoc4, false, caster, caster, caster:GetTeamNumber())
    ubwdummies = {ubwdummy1, ubwdummy2, ubwdummy3, ubwdummy4}
    
    ubwdummy1:SetAbsOrigin(ubwdummyLoc1)
    ubwdummy2:SetAbsOrigin(ubwdummyLoc2)
    ubwdummy3:SetAbsOrigin(ubwdummyLoc3)
    ubwdummy4:SetAbsOrigin(ubwdummyLoc4)    
    
    for i=1, #ubwdummies do
        ubwdummies[i]:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
        ubwdummies[i]:SetDayTimeVisionRange(1000)
        ubwdummies[i]:SetNightTimeVisionRange(1000)
        ubwdummies[i]:AddNewModifier(caster, caster, "modifier_item_ward_true_sight", {true_sight_range = 1000})
    end

    -- Automated weapon shots
    if caster.IsImproveProjectionAcquired then
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_unlimited_bladeworks_auto_blade", {})
    end
    if not caster.IsUBWDominant then return end 

    ubwTargetLoc = {}
    local diff = nil
    local ubwTargetPos = nil
    ubwCasterPos = caster:GetAbsOrigin()
    
    --breakpoint
    -- record location of units and move them into UBW(center location : 6000, -4000, 200)
    for i=1, #ubwTargets do
        if IsValidEntity(ubwTargets[i]) then
            if ubwTargets[i]:GetName() ~= "npc_dota_ward_base" then

                if ubwTargets[i]:GetName() == "npc_dota_hero_bounty_hunter" or ubwTargets[i]:GetName() == "npc_dota_hero_riki" then
                    ability:ApplyDataDrivenModifier(caster, ubwTargets[i], "modifier_inside_marble", {})
                end

                ubwTargetPos = ubwTargets[i]:GetAbsOrigin()
                ubwTargetLoc[i] = ubwTargetPos
                diff = (ubwCasterPos - ubwTargetPos) -- rescale difference to UBW size(1200)
                ubwTargets[i]:SetAbsOrigin(ubwCenter - diff)
                ubwTargets[i]:Stop()
                FindClearSpaceForUnit(ubwTargets[i], ubwTargets[i]:GetAbsOrigin(), true)
                Timers:CreateTimer(0.1, function() 
                    if caster:IsAlive() and IsValidEntity(ubwTargets[i]) then
                        ubwTargets[i]:AddNewModifier(ubwTargets[i], ubwTargets[i], "modifier_camera_follow", {duration = 1.0})
                    end
                end)
            end
        end
    end    
end

function EndUBW(caster, ability)   

    CreateUITimer("Unlimited Blade Works", 0, "ubw_timer")
    caster:RemoveModifierByName("modifier_unlimited_bladeworks_auto_blade")
    --[[if not caster.UBWLocator:IsNull() and IsValidEntity(caster.UBWLocator) then
        caster.UBWLocator:RemoveSelf()
    end]]

    for i=1, #ubwdummies do
        if not ubwdummies[i]:IsNull() and IsValidEntity(ubwdummies[i]) then 
            ubwdummies[i]:ForceKill(true) 
        end
    end

    local units = FindUnitsInRadius(caster:GetTeam(), ubwCenter, nil, 1200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

    i = 1
    while i <= #units do
        if IsValidEntity(units[i]) and not units[i]:IsNull() then
            if string.match(units[i]:GetUnitName(),"dummy") then 
                table.remove(units, i)
                i = i - 1
            end
        end
        i = i + 1
    end

    for i=1, #units do
        --print("removing units in UBW")
        if IsValidEntity(units[i]) and not units[i]:IsNull() then


            if units[i]:GetName() == "npc_dota_hero_bounty_hunter" or units[i]:GetName() == "npc_dota_hero_riki" then
                units[i]:RemoveModifierByName("modifier_inside_marble")
            end

            ProjectileManager:ProjectileDodge(units[i])
            --[[if units[i]:GetName() == "npc_dota_hero_chen" and units[i]:HasModifier("modifier_army_of_the_king_death_checker") then
                units[i]:RemoveModifierByName("modifier_army_of_the_king_death_checker")
            end]]
            local IsUnitGeneratedInUBW = true
            if ubwTargets ~= nil then
                for j=1, #ubwTargets do
                    if not ubwTargets[j]:IsNull() and IsValidEntity(ubwTargets[j]) then 
                        if units[i] == ubwTargets[j] then
                            if ubwTargetLoc[j] ~= nil then
                                units[i]:SetAbsOrigin(ubwTargetLoc[j]) 
                                units[i]:Stop()
                            end
                            FindClearSpaceForUnit(units[i], units[i]:GetAbsOrigin(), true)
                            Timers:CreateTimer(0.1, function() 
                                units[i]:AddNewModifier(units[i], units[i], "modifier_camera_follow", {duration = 1.0})
                            end)
                            IsUnitGeneratedInUBW = false
                            break 
                        end
                    end
                end 
            end
            if IsUnitGeneratedInUBW then
                diff = ubwCenter - units[i]:GetAbsOrigin()
                if ubwCasterPos ~= nil then
                    units[i]:SetAbsOrigin(ubwCasterPos - diff)
                    units[i]:Stop()
                end
                FindClearSpaceForUnit(units[i], units[i]:GetAbsOrigin(), true) 
                Timers:CreateTimer(0.1, function() 
                    if not units[i]:IsNull() and IsValidEntity(units[i]) then
                        units[i]:AddNewModifier(units[i], units[i], "modifier_camera_follow", {duration = 1.0})
                    end
                end)
            end 
        end
    end

    ubwTargets = nil
    ubwTargetLoc = nil

    Timers:RemoveTimer("ubw_timer")
end

function OnAutoBlade(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local base_damage = ability:GetSpecialValueFor("sword_base_damage")
	local sword_int_ratio = ability:GetSpecialValueFor("sword_int_ratio")
	local weaponTargets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    
    if #weaponTargets == 0 then 
    	return
    end

    local targetIndex = RandomInt(1, #weaponTargets)
    local swordTarget = weaponTargets[targetIndex]

    if IsValidEntity(weaponTargets[targetIndex]) then
        local swordOrigin = caster:GetAbsOrigin() + Vector(0,0,500) + RandomVector(1000)
        local swordVector = (weaponTargets[targetIndex]:GetAbsOrigin() - swordOrigin):Normalized()

        local swordFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_sword_barrage_model.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( swordFxIndex, 0, swordOrigin )
        ParticleManager:SetParticleControl( swordFxIndex, 1, swordVector * 5000 )
        
        Timers:CreateTimer(0.1, function()
            if swordTarget:IsAlive() and not swordTarget:HasModifier("modifier_lancer_protection_from_arrows_active") then
                DoDamage(caster, swordTarget, base_damage + caster:GetIntellect() * sword_int_ratio, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
            end
            ParticleManager:DestroyParticle(swordFxIndex, false )
            ParticleManager:ReleaseParticleIndex( swordFxIndex )
        end)
    end
end

function OnUBWCreate(keys)
	local caster = keys.caster 
	if caster.IsImproveProjectionAcquired then 
		if caster.IsOveredgeAcquired then
			caster:SwapAbilities("archer_kanshou_byakuya_upgrade", "archer_sword_barrage_retreat_shot_upgrade", false, true)
			caster:SwapAbilities("archer_crane_wing_upgrade", "archer_gae_bolg_upgrade", false, true)
		else
			caster:SwapAbilities("archer_kanshou_byakuya", "archer_sword_barrage_retreat_shot_upgrade", false, true)
			caster:SwapAbilities("archer_crane_wing", "archer_gae_bolg_upgrade", false, true)
		end
		if caster.IsEagleEyeAcquired then
			caster:SwapAbilities("archer_broken_phantasm_upgrade", "archer_sword_barrage_confine_upgrade", false, true)
			caster:SwapAbilities("archer_clairvoyance_upgrade", "archer_sword_barrage_upgrade", false, true)
		else
			caster:SwapAbilities("archer_broken_phantasm", "archer_sword_barrage_confine_upgrade", false, true)
			caster:SwapAbilities("archer_clairvoyance", "archer_sword_barrage_upgrade", false, true)
		end
		caster:SwapAbilities("archer_unlimited_bladeworks_chant_upgrade", "archer_nine_lives_upgrade", false, true)
	else
		if caster.IsOveredgeAcquired then
			caster:SwapAbilities("archer_kanshou_byakuya_upgrade", "archer_sword_barrage_retreat_shot", false, true)
			caster:SwapAbilities("archer_crane_wing_upgrade", "archer_gae_bolg", false, true)
		else
			caster:SwapAbilities("archer_kanshou_byakuya", "archer_sword_barrage_retreat_shot", false, true)
			caster:SwapAbilities("archer_crane_wing", "archer_gae_bolg", false, true)
		end
		if caster.IsEagleEyeAcquired then
			caster:SwapAbilities("archer_broken_phantasm_upgrade", "archer_sword_barrage_confine", false, true)
			caster:SwapAbilities("archer_clairvoyance_upgrade", "archer_sword_barrage", false, true)
		else
			caster:SwapAbilities("archer_broken_phantasm", "archer_sword_barrage_confine", false, true)
			caster:SwapAbilities("archer_clairvoyance", "archer_sword_barrage", false, true)
		end
		caster:SwapAbilities("archer_unlimited_bladeworks_chant", "archer_nine_lives", false, true)
	end
end

function OnUBWDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsImproveProjectionAcquired then 
		if caster.IsOveredgeAcquired then
			caster:SwapAbilities("archer_kanshou_byakuya_upgrade", "archer_sword_barrage_retreat_shot_upgrade", true, false)
			caster:SwapAbilities("archer_crane_wing_upgrade", "archer_gae_bolg_upgrade", true, false)
		else
			caster:SwapAbilities("archer_kanshou_byakuya", "archer_sword_barrage_retreat_shot_upgrade", true, false)
			caster:SwapAbilities("archer_crane_wing", "archer_gae_bolg_upgrade", true, false)
		end
		if caster.IsEagleEyeAcquired then
			caster:SwapAbilities("archer_broken_phantasm_upgrade", "archer_sword_barrage_confine_upgrade", true, false)
			caster:SwapAbilities("archer_clairvoyance_upgrade", "archer_sword_barrage_upgrade", true, false)
		else
			caster:SwapAbilities("archer_broken_phantasm", "archer_sword_barrage_confine_upgrade", true, false)
			caster:SwapAbilities("archer_clairvoyance", "archer_sword_barrage_upgrade", true, false)
		end
		caster:SwapAbilities("archer_unlimited_bladeworks_chant_upgrade", "archer_nine_lives_upgrade", true, false)
	else
		if caster.IsOveredgeAcquired then
			caster:SwapAbilities("archer_kanshou_byakuya_upgrade", "archer_sword_barrage_retreat_shot", true, false)
			caster:SwapAbilities("archer_crane_wing_upgrade", "archer_gae_bolg", true, false)
		else
			caster:SwapAbilities("archer_kanshou_byakuya", "archer_sword_barrage_retreat_shot", true, false)
			caster:SwapAbilities("archer_crane_wing", "archer_gae_bolg", true, false)
		end
		if caster.IsEagleEyeAcquired then
			caster:SwapAbilities("archer_broken_phantasm_upgrade", "archer_sword_barrage_confine", true, false)
			caster:SwapAbilities("archer_clairvoyance_upgrade", "archer_sword_barrage", true, false)
		else
			caster:SwapAbilities("archer_broken_phantasm", "archer_sword_barrage_confine", true, false)
			caster:SwapAbilities("archer_clairvoyance", "archer_sword_barrage", true, false)
		end
		caster:SwapAbilities("archer_unlimited_bladeworks_chant", "archer_nine_lives", true, false)
	end
	caster:RemoveModifierByName("modifier_unlimited_bladeworks_auto_blade")
	caster.IsUBWActive = false
	EndUBW(caster, ability)
end

function OnArcherDead(keys)
	local caster = keys.caster
	local ability = keys.ability
    caster:RemoveModifierByName("modifier_unlimited_bladeworks")
end

function OnUBWUpgrade(keys)
    local caster = keys.caster
    local ability = keys.ability
    if caster.IsImproveProjectionAcquired then 
    	local ubwupgrade = caster:FindAbilityByName("archer_unlimited_bladeworks_chant_upgrade")
	    caster:FindAbilityByName("archer_sword_barrage_retreat_shot_upgrade"):SetLevel(ubwupgrade:GetLevel())    
	    caster:FindAbilityByName("archer_sword_barrage_confine_upgrade"):SetLevel(ubwupgrade:GetLevel())
	    caster:FindAbilityByName("archer_gae_bolg_upgrade"):SetLevel(ubwupgrade:GetLevel())
	    caster:FindAbilityByName("archer_sword_barrage_upgrade"):SetLevel(ubwupgrade:GetLevel())
	    caster:FindAbilityByName("archer_nine_lives_upgrade"):SetLevel(ubwupgrade:GetLevel())
	else
		local ubw = caster:FindAbilityByName("archer_unlimited_bladeworks_chant")
		caster:FindAbilityByName("archer_sword_barrage_retreat_shot"):SetLevel(ubw:GetLevel())    
	    caster:FindAbilityByName("archer_sword_barrage_confine"):SetLevel(ubw:GetLevel())
	    caster:FindAbilityByName("archer_gae_bolg"):SetLevel(ubw:GetLevel())
	    caster:FindAbilityByName("archer_sword_barrage"):SetLevel(ubw:GetLevel())
	    caster:FindAbilityByName("archer_nine_lives"):SetLevel(ubw:GetLevel())
	end
end

function OnUBWBarrageRetreat(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local retreatDist = ability:GetSpecialValueFor("retreat_distance")
	local forwardVec = caster:GetForwardVector()
	local range = ability:GetSpecialValueFor("range")
	local sword_count = ability:GetSpecialValueFor("sword_count")
	local interval = range/sword_count
	local casterPos = caster:GetAbsOrigin()
	local counter  = 1
	local archer = Physics:Unit(caster)
	local root = 0

	ProjectileManager:ProjectileDodge(caster)

	caster:PreventDI()
	caster:SetPhysicsFriction(0)
	caster:SetPhysicsVelocity(-forwardVec * retreatDist * 4/2 + Vector(0,0,750))
	caster:SetPhysicsAcceleration(Vector(0,0,-2000))
	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	caster:FollowNavMesh(false)

  	Timers:CreateTimer(0.5, function()
		caster:PreventDI(false)
		caster:SetPhysicsVelocity(Vector(0,0,0))
		caster:OnPhysicsFrame(nil)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	end)

	giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", 0.2)

	caster:EmitSound("Archer.NineFinish")

	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=1.0})
	rotateCounter = 1

	if caster.IsImproveProjectionAcquired then
		damage = damage + caster:GetAgility()
	end
	
	Timers:CreateTimer(function()
		if rotateCounter == 9 then return end
		caster:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,45*rotateCounter,0), forwardVec))
		rotateCounter = rotateCounter + 1
		return 0.03
	end)

	Timers:CreateTimer(function()
		if counter > sword_count then return end
		local targetPoint = casterPos + forwardVec * interval * counter
		local swordOrigin = casterPos - forwardVec * retreatDist + RandomVector(250) + Vector(0,0,500)
		local swordVector = (targetPoint - swordOrigin):Normalized()
		
		local swordFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_sword_barrage_model.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( swordFxIndex, 0, swordOrigin )
		ParticleManager:SetParticleControl( swordFxIndex, 1, swordVector*3000 )

		Timers:CreateTimer(0.25, function()
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), targetPoint, caster, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
			for k,v in pairs(targets) do
				if caster.IsImproveProjectionAcquired and not v:HasModifier("modifier_retreat_root_cooldown") then 
					root = ability:GetSpecialValueFor("root")
					giveUnitDataDrivenModifier(caster, v, "rooted", root)
					ability:ApplyDataDrivenModifier(caster, v, "modifier_retreat_root_cooldown", {})
				end

				if caster.IsImproveProjectionAcquired then
					DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				else
					DoDamage(caster, v, damage, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
				end

				--giveUnitDataDrivenModifier(caster, v, "stunned", 0.1)
				v:AddNewModifier(caster, v, "modifier_stunned", { Duration = 0.1 })
				
			end
			-- Particles on impact
			local explosionFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( explosionFxIndex, 0, targetPoint )
			
			local impactFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_sword_barrage_impact_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( impactFxIndex, 0, targetPoint )
			ParticleManager:SetParticleControl( impactFxIndex, 1, Vector(200,200,200))
		end)
		counter = counter+1
		return 0.1
	end)
end

function OnUBWBarrageStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = keys.target_points[1]
	local radius = keys.Radius
	local ply = caster:GetPlayerOwner()
	local duration = 0
	local interval = ability:GetSpecialValueFor("blade_rof")
	local m_duration = ability:GetSpecialValueFor("duration")
	
	--[[if caster.IsProjectionImproved then 
		keys.Damage = keys.Damage + (caster:GetStrength() + caster:GetIntellect())*2
	end	]]

	--ability:ApplyDataDrivenModifier(caster, caster, "modifier_sword_barrage", {})
	-- Vector
	local forwardVec = ( targetPoint - caster:GetAbsOrigin() ):Normalized()

	--[[if caster.IsProjectionImproved then
		keys.Damage = keys.Damage + 35
	end]]
	
	Timers:CreateTimer( function()
		if caster:IsAlive() then
			if duration >= m_duration then 
				return
			else
				duration = duration + interval
				local swordVector = Vector(RandomFloat(-radius, radius), RandomFloat(-radius, radius), 0)
				
				-- Create sword particles
				-- Main variables
				local delay = 0.5				-- Delay before damage
				local speed = 3000				-- Movespeed of the sword
				
				-- Side variables
				local distance = delay * speed
				local height = distance * math.tan( 30 / 180 * math.pi )
				local spawn_location = ( targetPoint + swordVector ) - ( distance * forwardVec )
				spawn_location = spawn_location + Vector( 0, 0, height )
				local target_location = targetPoint + swordVector
				local newForwardVec = ( target_location - spawn_location ):Normalized()
				target_location = target_location + 100 * newForwardVec
				
				local swordFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_sword_barrage_model.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( swordFxIndex, 0, spawn_location )
				ParticleManager:SetParticleControl( swordFxIndex, 1, newForwardVec * speed )
				
				-- Delay
				Timers:CreateTimer( delay, function()
					-- Destroy particles
					ParticleManager:DestroyParticle( swordFxIndex, false )
					ParticleManager:ReleaseParticleIndex( swordFxIndex )
						
					-- Delay damage
					local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint + swordVector, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 
					for k,v in pairs(targets) do
						if caster.IsImproveProjectionAcquired then
							DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
						else
							DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_PHYSICAL, 0, ability, false)	
						end
						if not v:IsMagicImmune() then
							v:AddNewModifier(caster, v, "modifier_stunned", {Duration = 0.01})
						end
					end
						
					-- Particles on impact
					local explosionFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster )
					ParticleManager:SetParticleControl( explosionFxIndex, 0, targetPoint + swordVector )
						
					local impactFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_sword_barrage_impact_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
					ParticleManager:SetParticleControl( impactFxIndex, 0, targetPoint + swordVector )
					ParticleManager:SetParticleControl( impactFxIndex, 1, Vector(300, 300, 300))
						
					-- Destroy Particle
					Timers:CreateTimer( 0.5, function()
						ParticleManager:DestroyParticle( explosionFxIndex, false )
						ParticleManager:DestroyParticle( impactFxIndex, false )
						ParticleManager:ReleaseParticleIndex( explosionFxIndex )
						ParticleManager:ReleaseParticleIndex( impactFxIndex )
					end)	
					return nil
				end)
				return interval
			end
		end
    end)

	caster:EmitSound("Archer.UBWAmbient")

	if math.random(1,2) == 1 then
		caster:EmitSound("Archer.Bladeoff")
	else
		caster:EmitSound("Archer.Yuke")
	end
end

function OnUBWBarrageConfineStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = keys.target_points[1]
	local radius = keys.Radius
	local delay = keys.Delay
	local ply = caster:GetPlayerOwner()
	local duration = ability:GetSpecialValueFor("trap_duration")

	Timers:CreateTimer(delay-0.2, function() --this is for playing the particle
		EmitGlobalSound("FA.Quickdraw")
		for i=1,8 do
			local swoosh = ParticleManager:CreateParticleForTeam("particles/custom/archer/ubw/confine_ring_trail.vpcf", PATTACH_CUSTOMORIGIN, nil, caster:GetTeamNumber())
	   		ParticleManager:SetParticleControl( swoosh, 0, Vector(targetPoint.x + math.cos(i*0.8) * (radius-30), targetPoint.y + math.sin(i*0.8) * (radius-30), targetPoint.z + 400))
	    	--ParticleManager:SetParticleControl( caster.barrageMarker, 1, Vector(0,0,300))
	    	Timers:CreateTimer( 0.2, function()
	        	ParticleManager:DestroyParticle( swoosh, false )
	        	ParticleManager:ReleaseParticleIndex( swoosh )
	    	end)
		end
	end)

	Timers:CreateTimer(delay, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sword_barrage_confine", {})
		for i=1,8 do
			local confineDummy = CreateUnitByName("ubw_sword_confine_dummy", Vector(targetPoint.x + math.cos(i*0.8) * (radius-30), targetPoint.y + math.sin(i*0.8) * (radius-30), 5000)  , false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
			confineDummy:FindAbilityByName("dummy_visible_unit_passive_no_fly"):SetLevel(1)
			confineDummy:SetForwardVector(Vector(0,0,-1))

			confineDummy:SetAbsOrigin(confineDummy:GetAbsOrigin() - Vector(0,0,-100)) 
			Timers:CreateTimer(keys.TrapDuration, function()
				if confineDummy:IsNull() == false then
					confineDummy:RemoveSelf()
				end
			end)
		end
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
	        DoDamage(caster, v, keys.Damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	        v:AddNewModifier(caster, v, "modifier_stunned", {duration = 0.1})
	        --v:EmitSound("FA.Quickdraw")
	        ability:ApplyDataDrivenModifier(caster, v, "modifier_sword_barrage_confine_armor", {})
	        if caster.IsImproveProjectionAcquired then 
				giveUnitDataDrivenModifier(caster, v, "locked",duration)
				ability:ApplyDataDrivenModifier(caster, v, "modifier_sword_barrage_confine_mr", {})
			end
	    end
	end)
end

function OnBarrageConfineArmor(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local ratio = ability:GetSpecialValueFor("armor_reduce")
	local armor = target:GetPhysicalArmorValue()
	if armor > 1 then 
		target:SetModifierStackCount("modifier_sword_barrage_confine_armor", caster, math.floor(armor * ratio / 100))
	end
end

function OnBarrageConfineMR(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local ratio = ability:GetSpecialValueFor("mr_reduce")
	local mr = target:GetMagicalArmorValue()
	if mr > 1 then
		target:SetModifierStackCount("modifier_sword_barrage_confine_mr", caster, math.floor(mr * ratio / 100))
	end
end

function OnNineCast(keys)
	local caster = keys.caster
	local casterName = caster:GetName()
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_RUN, rate=0.2})
end

function OnNineStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = ability:GetCursorPosition()
	local berserker = Physics:Unit(caster)
	local origin = caster:GetAbsOrigin()
	local distance = (targetPoint - origin):Length2D()
	local forward = (targetPoint - origin):Normalized() * distance

	caster:SetPhysicsFriction(0)
	caster:SetPhysicsVelocity(caster:GetForwardVector()*distance)
	caster:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
	giveUnitDataDrivenModifier(caster, caster, "drag_pause", 2.0)
	caster:EmitSound("Hero_OgreMagi.Ignite.Cast")

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_RUN, rate=0.8})

	function DoNineLanded(caster)
		caster:OnPreBounce(nil)
		caster:OnPhysicsFrame(nil)
		caster:SetBounceMultiplier(0)
		caster:PreventDI(false)
		caster:SetPhysicsVelocity(Vector(0,0,0))
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		Timers:RemoveTimer(caster.NineTimer)
		caster.NineTimer = nil
		if caster:IsAlive() then
			OnNineLanded(caster, keys.ability)
			return 
		end
		return
	end

	caster.NineTimer = Timers:CreateTimer(1.0, function()
		DoNineLanded(caster)
	end)

	caster:OnPhysicsFrame(function(unit)
		if CheckDummyCollide(unit) then
			DoNineLanded(unit)
		end
	end)

	caster:OnPreBounce(function(unit, normal) -- stop the pushback when unit hits wall
		DoNineLanded(unit)
	end)

	caster:EmitSound("Archer.NineLives")

end

-- add pause
function OnNineLanded(caster, ability)
	local tickdmg = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local lasthitdmg = ability:GetLevelSpecialValueFor("damage_lasthit", ability:GetLevel() - 1)
	local returnDelay = 0.1
	local radius = ability:GetSpecialValueFor("radius")
	local lasthitradius = ability:GetSpecialValueFor("radius_lasthit")
	local total_hit = ability:GetSpecialValueFor("total_hit")
	local stun = ability:GetSpecialValueFor("stun_duration")
	local nineCounter = 0
	local casterInitOrigin = caster:GetAbsOrigin() 

	-- main timer
	Timers:CreateTimer(function()
		if caster:IsAlive() then -- only perform actions while caster stays alive
			local particle = ParticleManager:CreateParticle("particles/custom/berserker/nine_lives/hit.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControlForward(particle, 0, caster:GetForwardVector() * -1)
			ParticleManager:SetParticleControl(particle, 1, Vector(0,0,(nineCounter % 2) * 180))

			StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=3.0}) 

			caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact") 

			if nineCounter == total_hit - 1 then -- if it is last strike

				caster:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")
				caster:RemoveModifierByName("pause") 
				ScreenShake(caster:GetOrigin(), 7, 1.0, 2, 1500, 0, true)
				-- do damage to targets
				local damage = lasthitdmg 
				--[[if caster:HasModifier("modifier_courage_damage_stack_indicator") then
					damage = damage + courageDamage/2
					DeductCourageDamageStack(caster)
				end ]]
				local lasthitTargets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, lasthitradius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 1, false)
				for k,v in pairs(lasthitTargets) do
					if v:GetName() ~= "npc_dota_ward_base" then
						--[[if caster.IsImproveProjectionAcquired then 
							DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
						else]]
							DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
						--end
						v:AddNewModifier(caster, v, "modifier_stunned", { Duration = stun })
						--giveUnitDataDrivenModifier(caster, v, "stunned", 1.5)

						--[[if caster:GetName() ~= "npc_dota_hero_ember_spirit" then
							giveUnitDataDrivenModifier(caster, v, "revoked", 0.5)
						end]]
						-- push enemies back
						if not IsKnockbackImmune(v) then
							local pushback = Physics:Unit(v)
							v:PreventDI()
							v:SetPhysicsFriction(0)
							v:SetPhysicsVelocity((v:GetAbsOrigin() - casterInitOrigin):Normalized() * 300)
							v:SetNavCollisionType(PHYSICS_NAV_NOTHING)
							v:FollowNavMesh(false)
							Timers:CreateTimer(0.5, function()  
								v:PreventDI(false)
								v:SetPhysicsVelocity(Vector(0,0,0))
								v:OnPhysicsFrame(nil)
								FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
							end)
						end
					end
				end

				caster:EmitSound("Archer.NineFinish") 

				ParticleManager:SetParticleControl(particle, 2, Vector(1,1,lasthitradius))
				ParticleManager:SetParticleControl(particle, 3, Vector(lasthitradius / 350,1,1))
				ParticleManager:CreateParticle("particles/custom/berserker/nine_lives/last_hit.vpcf", PATTACH_ABSORIGIN, caster)

				-- DebugDrawCircle(caster:GetAbsOrigin(), Vector(255,0,0), 0.5, lasthitradius, true, 0.5)
			else
				-- if its not last hit, do regular hit stuffs

				local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
				for k,v in pairs(targets) do
					--[[if caster.IsProjectionImproved then 
						DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					else]]
						DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					--end
					v:AddNewModifier(caster, v, "modifier_stunned", { Duration = 0.5 })
					--giveUnitDataDrivenModifier(caster, v, "stunned", 0.5)
					--[[if caster:GetName() ~= "npc_dota_hero_ember_spirit" then
						print("9 revoke")
						giveUnitDataDrivenModifier(caster, v, "revoked", 0.5)
					end]]
				end

				ParticleManager:SetParticleControl(particle, 2, Vector(1,1,radius))
				ParticleManager:SetParticleControl(particle, 3, Vector(radius / 350,1,1))
				-- DebugDrawCircle(caster:GetAbsOrigin(), Vector(255,0,0), 0.5, radius, true, 0.5)

				nineCounter = nineCounter + 1
				return returnDelay
			end

		end 
	end)
end

function OnEmiyaGBAOEStart(keys)

	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = ability:GetCursorPosition()
	local radius = keys.Radius
	local projectileSpeed = 1900
	local ply = caster:GetPlayerOwner()
	local ascendCount = 0
	local descendCount = 0
	if (caster:GetAbsOrigin() - targetPoint):Length2D() > 2500 then 
		caster:SetMana(caster:GetMana()+keys.ability:GetManaCost(keys.ability:GetLevel()-1)) 
		keys.ability:EndCooldown() 
		return
	end

	caster:EmitSound("emiya_gae_bolg")

	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 0.8)
	Timers:CreateTimer(0.8, function()
		giveUnitDataDrivenModifier(caster, caster, "jump_pause_postdelay", 0.15)
	end)
	Timers:CreateTimer(0.95, function()
		giveUnitDataDrivenModifier(caster, caster, "jump_pause_postlock", 0.2)
	end)
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.6})

	Timers:CreateTimer('egb_throw', {
		endTime = 0.45,
		callback = function()
		local projectileOrigin = caster:GetAbsOrigin() + Vector(0,0,300)
		local projectile = CreateUnitByName("dummy_unit", projectileOrigin, false, caster, caster, caster:GetTeamNumber())
		projectile:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
		projectile:SetAbsOrigin(projectileOrigin)


		local particle_name = "particles/custom/lancer/lancer_gae_bolg_projectile.vpcf"
		local throw_particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, projectile)
		ParticleManager:SetParticleControl(throw_particle, 1, (targetPoint - projectileOrigin):Normalized() * projectileSpeed)

		local travelTime = (targetPoint - projectileOrigin):Length() / projectileSpeed
		Timers:CreateTimer(travelTime, function()
			ParticleManager:DestroyParticle(throw_particle, false)
			OnEmiyaGBAOEHit(caster, ability, targetPoint, projectile)
		end)
	end})

	Timers:CreateTimer('egb_ascend', {
		endTime = 0,
		callback = function()
	   	if ascendCount == 15 then return end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,50))
		ascendCount = ascendCount + 1;
		return 0.033
	end
	})

	Timers:CreateTimer("egb_descend", {
	    endTime = 0.3,
	    callback = function()
	    	if descendCount == 15 then return end
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,-50))
			descendCount = descendCount + 1;
	      	return 0.033
	    end
	})
end

function OnEmiyaGBAOEHit(caster, ability, targetPoint, projectile)
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")

	Timers:CreateTimer(0.15, function()
		local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius
	            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	        ApplyAirborne(caster, v, 0.25)
	    end
	    projectile:SetAbsOrigin(targetPoint)
	    local fire = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rainofchaos_start_breakout_fallback_mid.vpcf", PATTACH_ABSORIGIN, projectile)
		local crack = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cracks.vpcf", PATTACH_ABSORIGIN, projectile)
		local explodeFx1 = ParticleManager:CreateParticle("particles/custom/lancer/lancer_gae_bolg_hit.vpcf", PATTACH_ABSORIGIN, projectile )
		ParticleManager:SetParticleControl( fire, 0, projectile:GetAbsOrigin())
		ParticleManager:SetParticleControl( crack, 0, projectile:GetAbsOrigin())
		ParticleManager:SetParticleControl( explodeFx1, 0, projectile:GetAbsOrigin())
		ScreenShake(caster:GetOrigin(), 7, 1.0, 2, 2000, 0, true)
		caster:EmitSound("Misc.Crash")
	    Timers:CreateTimer( 3.0, function()
			ParticleManager:DestroyParticle( crack, false )
			ParticleManager:DestroyParticle( fire, false )
			ParticleManager:DestroyParticle( explodeFx1, false )
		end)
	end)
end

function ArcherCheckCombo(caster, ability)
	if caster:GetStrength() >= 24.1 and caster:GetAgility() >= 24.1 and caster:GetIntellect() >= 24.1 then
		if caster.IsImproveProjectionAcquired then 
			if ability == caster:FindAbilityByName("archer_unlimited_bladeworks") and caster:FindAbilityByName("archer_arrow_rain"):IsCooldownReady() and not caster:HasModifier("modifier_arrow_rain_cooldown") then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_arrow_rain_window", {})
			end
		else
			if ability == caster:FindAbilityByName("archer_unlimited_bladeworks_upgrade") and caster:FindAbilityByName("archer_arrow_rain"):IsCooldownReady() and not caster:HasModifier("modifier_arrow_rain_cooldown") then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_arrow_rain_window", {})
			end
		end
	end
end

function OnArrowRainWindow(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsImproveProjectionAcquired then
		caster:SwapAbilities("archer_gae_bolg_upgrade", "archer_arrow_rain", false, true) 
	else
		caster:SwapAbilities("archer_gae_bolg", "archer_arrow_rain", false, true) 
	end
end

function OnArrowRainWindowDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsImproveProjectionAcquired then
		caster:SwapAbilities("archer_gae_bolg_upgrade", "archer_arrow_rain", true, false) 
	else
		caster:SwapAbilities("archer_gae_bolg", "archer_arrow_rain", true, false) 
	end
end

function OnArrowRainWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_arrow_rain_window")
end

-- combo
function OnRainStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	if not caster.IsUBWActive then return end

	if caster.IsOveredgeAcquired then 
		caster:FindAbilityByName("archer_crane_wing_upgrade"):StartCooldown(caster:FindAbilityByName("archer_crane_wing_upgrade"):GetCooldown(caster:FindAbilityByName("archer_crane_wing_upgrade"):GetLevel()))
	else
		caster:FindAbilityByName("archer_crane_wing"):StartCooldown(caster:FindAbilityByName("archer_crane_wing"):GetCooldown(caster:FindAbilityByName("archer_crane_wing"):GetLevel()))
	end

	local ascendCount = 0
	local descendCount = 0
	local radius = 1000
	local groundVector = caster:GetAbsOrigin()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arrow_rain_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName(keys.ability:GetAbilityName())
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	if caster:HasModifier("modifier_arrow_rain_window") then 
		caster:RemoveModifierByName("modifier_arrow_rain_window")
	end

	caster:EmitSound("Archer.Combo") 
	local info = {
		Target = nil,
		Source = caster, 
		Ability = keys.ability,
		EffectName = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = 3000
	}

	local BrownSplashFx = ParticleManager:CreateParticle("particles/custom/screen_brown_splash.vpcf", PATTACH_EYES_FOLLOW, caster)
	Timers:CreateTimer( 4.0, function()
		ParticleManager:DestroyParticle( BrownSplashFx, false )
		ParticleManager:ReleaseParticleIndex( BrownSplashFx )
	end)
	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 4.5)

	Timers:CreateTimer('rain_ascend', {
		endTime = 0,
		callback = function()
	   	if ascendCount == 20 then return end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,40))
		ascendCount = ascendCount + 1;
		return 0.01
	end
	})

	-- Barrage attack
	local barrageCount = 0
	Timers:CreateTimer( 0.3, function()
		if barrageCount == 100 or not caster:IsAlive() then return end
		local arrowVector = Vector( RandomFloat( -radius, radius ), RandomFloat( -radius, radius ), 0 )
		caster:EmitSound("Hero_DrowRanger.FrostArrows")
		-- Create Arrow particles
		-- Main variables
		local speed = 3000				-- Movespeed of the arrow

		-- Side variables
		--local groundVector = caster:GetAbsOrigin() - Vector(0,0,800)
		local spawn_location = caster:GetAbsOrigin()
		local target_location = groundVector + arrowVector
		local forwardVec = ( target_location - caster:GetAbsOrigin() ):Normalized()
		local delay = ( target_location - caster:GetAbsOrigin() ):Length2D() / speed
		local distance = delay * speed
		
		local arrowFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_arrow_rain_model.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( arrowFxIndex, 0, spawn_location )
		ParticleManager:SetParticleControl( arrowFxIndex, 1, forwardVec * speed )
		
		-- Delay Damage
		Timers:CreateTimer( delay, function()
				-- Destroy arrow
				ParticleManager:DestroyParticle( arrowFxIndex, false )
				ParticleManager:ReleaseParticleIndex( arrowFxIndex )
				
				-- Delay damage
				local targets = FindUnitsInRadius(caster:GetTeam(), groundVector + arrowVector, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 
				for k,v in pairs(targets) do
					if not v:HasModifier("modifier_lancer_protection_from_arrows_active") then
						DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
					end
				end
				
				-- Particles on impact
				local explosionFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( explosionFxIndex, 0, groundVector + arrowVector + Vector(0,0,200))
				
				local impactFxIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_sword_barrage_impact_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( impactFxIndex, 0, groundVector + arrowVector + Vector(0,0,200))
				ParticleManager:SetParticleControl( impactFxIndex, 1, Vector(300, 300, 300))
				
				-- Destroy Particle
				Timers:CreateTimer( 0.5, function()
						ParticleManager:DestroyParticle( explosionFxIndex, false )
						ParticleManager:DestroyParticle( impactFxIndex, false )
						ParticleManager:ReleaseParticleIndex( explosionFxIndex )
						ParticleManager:ReleaseParticleIndex( impactFxIndex )
						return nil
					end
				)
				return nil
			end
		)
		
	    barrageCount = barrageCount + 1
		return 0.03
    end)

	-- BP Attack
	local bpCount = 0 
	Timers:CreateTimer(2.8, function()
		if bpCount == 5 or not caster:IsAlive() then return end
		local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		info.Target = units[math.random(#units)]
		if info.Target ~= nil then 
			ProjectileManager:CreateTrackingProjectile(info) 
		end
		bpCount = bpCount + 1
		return 0.2
    end)

	Timers:CreateTimer('rain_descend', {
		endTime = 3.8,
		callback = function()
	   	if descendCount == 20 then return end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,-40))
		descendCount = descendCount + 1;
		return 0.01
	end
	})
end

ARROWRAIN_BP_DAMAGE_RATE = 0.66

function OnArrowRainBPHit(keys)
	if IsSpellBlocked(keys.target) then return end -- Linken effect checker
	local caster = keys.caster
	local ability = caster:FindAbilityByName("archer_broken_phantasm")
	local targetdmg = ability:GetLevelSpecialValueFor("target_damage", ability:GetLevel()-1)
	local splashdmg = ability:GetLevelSpecialValueFor("splash_damage", ability:GetLevel()-1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel())
	local stunDuration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel()-1)

	if not keys.target:HasModifier("modifier_lancer_protection_from_arrows_active") then
		DoDamage(caster, keys.target, targetdmg , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
	end
	
	local targets = FindUnitsInRadius(caster:GetTeam(), keys.target:GetOrigin(), nil, radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
         DoDamage(caster, v, splashdmg, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
    end
    local ArrowExplosionFx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
    ParticleManager:SetParticleControl(ArrowExplosionFx, 3, keys.target:GetAbsOrigin())
	-- Destroy Particle
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( ArrowExplosionFx, false )
		ParticleManager:ReleaseParticleIndex( ArrowExplosionFx )
		return nil
	end)
	keys.target:AddNewModifier(caster, keys.target, "modifier_stunned", {Duration = stunDuration})
end


function OnEagleEyeAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	
	if hero:HasModifier("modifier_archer_hrunting_window") then 
		hero:RemoveModifierByName("modifier_archer_hrunting_window")
	end

	if hero:IsChanneling() then 
		caster:SetMana(caster:GetMana() + keys.ability:GetManaCost(keys.ability:GetLevel()))
		keys.ability:EndCooldown()
		return
	end

	hero.IsEagleEyeAcquired = true
	
	hero:AddAbility("archer_clairvoyance_upgrade")
	hero:FindAbilityByName("archer_clairvoyance_upgrade"):SetLevel(1)
	if not hero:FindAbilityByName("archer_clairvoyance"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_clairvoyance_upgrade"):StartCooldown(hero:FindAbilityByName("archer_clairvoyance"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_broken_phantasm_upgrade")
	hero:FindAbilityByName("archer_broken_phantasm_upgrade"):SetLevel(hero:FindAbilityByName("archer_broken_phantasm"):GetLevel())
	if not hero:FindAbilityByName("archer_broken_phantasm"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_broken_phantasm_upgrade"):StartCooldown(hero:FindAbilityByName("archer_broken_phantasm"):GetCooldownTimeRemaining())
	end

	if hero.IsHruntingAcquired then 
		hero:AddAbility("archer_hrunting_upgrade")
		hero:FindAbilityByName("archer_hrunting_upgrade"):SetLevel(hero:FindAbilityByName("archer_hrunting"):GetLevel())
		if not hero:FindAbilityByName("archer_hrunting"):IsCooldownReady() then 
			hero:FindAbilityByName("archer_hrunting_upgrade"):StartCooldown(hero:FindAbilityByName("archer_hrunting"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("archer_hrunting")
	end

	if hero:HasModifier("modifier_unlimited_bladeworks") then 
		hero:FindAbilityByName("archer_clairvoyance_upgrade"):SetHidden(true)
	else
		hero:SwapAbilities("archer_clairvoyance_upgrade", "archer_clairvoyance", true, false) 
		hero:SwapAbilities("archer_broken_phantasm_upgrade", "archer_broken_phantasm", true, false) 
	end

	hero:RemoveAbility("archer_clairvoyance")
	hero:RemoveAbility("archer_broken_phantasm")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnHruntingAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsHruntingAcquired = true

	if hero.IsEagleEyeAcquired then 
		hero:AddAbility("archer_hrunting_upgrade")
		hero:FindAbilityByName("archer_hrunting_upgrade"):SetLevel(hero:FindAbilityByName("archer_broken_phantasm_upgrade"):GetLevel())
		hero:RemoveAbility("archer_hrunting")
	else
		hero:FindAbilityByName("archer_hrunting"):SetLevel(hero:FindAbilityByName("archer_broken_phantasm"):GetLevel())
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnShroudOfMartinAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsShroudOfMartinAcquired = true
	hero:FindAbilityByName("archer_shroud_of_martin"):SetLevel(1)
	hero:FindAbilityByName("archer_rho_aias"):SetLevel(1)
	hero:SwapAbilities("archer_rho_aias", "fate_empty1", true, false) 

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnImproveProjectionAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsImproveProjectionAcquired = true

	if hero:HasModifier("modifier_arrow_rain_window") then 
		hero:RemoveModifierByName("modifier_arrow_rain_window")
	end

	hero:AddAbility("archer_unlimited_bladeworks_upgrade")
	hero:FindAbilityByName("archer_unlimited_bladeworks_upgrade"):SetLevel(1)
	if not hero:FindAbilityByName("archer_unlimited_bladeworks"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_unlimited_bladeworks_upgrade"):StartCooldown(hero:FindAbilityByName("archer_unlimited_bladeworks"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_sword_barrage_retreat_shot_upgrade")
	hero:FindAbilityByName("archer_sword_barrage_retreat_shot_upgrade"):SetLevel(hero:FindAbilityByName("archer_sword_barrage_retreat_shot"):GetLevel())
	if not hero:FindAbilityByName("archer_sword_barrage_retreat_shot"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_sword_barrage_retreat_shot_upgrade"):StartCooldown(hero:FindAbilityByName("archer_sword_barrage_retreat_shot"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_sword_barrage_confine_upgrade")
	hero:FindAbilityByName("archer_sword_barrage_confine_upgrade"):SetLevel(hero:FindAbilityByName("archer_sword_barrage_confine"):GetLevel())
	if not hero:FindAbilityByName("archer_sword_barrage_confine"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_sword_barrage_confine_upgrade"):StartCooldown(hero:FindAbilityByName("archer_sword_barrage_confine"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_gae_bolg_upgrade")
	hero:FindAbilityByName("archer_gae_bolg_upgrade"):SetLevel(hero:FindAbilityByName("archer_gae_bolg"):GetLevel())
	if not hero:FindAbilityByName("archer_gae_bolg"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_gae_bolg_upgrade"):StartCooldown(hero:FindAbilityByName("archer_gae_bolg"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_sword_barrage_upgrade")
	hero:FindAbilityByName("archer_sword_barrage_upgrade"):SetLevel(hero:FindAbilityByName("archer_sword_barrage"):GetLevel())
	if not hero:FindAbilityByName("archer_sword_barrage"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_sword_barrage_upgrade"):StartCooldown(hero:FindAbilityByName("archer_sword_barrage"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_nine_lives_upgrade")
	hero:FindAbilityByName("archer_nine_lives_upgrade"):SetLevel(hero:FindAbilityByName("archer_nine_lives"):GetLevel())
	if not hero:FindAbilityByName("archer_nine_lives"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_nine_lives_upgrade"):StartCooldown(hero:FindAbilityByName("archer_nine_lives"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_unlimited_bladeworks_chant_upgrade")
	hero:FindAbilityByName("archer_unlimited_bladeworks_chant_upgrade"):SetLevel(hero:FindAbilityByName("archer_unlimited_bladeworks_chant"):GetLevel())
	if not hero:FindAbilityByName("archer_unlimited_bladeworks_chant"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_unlimited_bladeworks_chant_upgrade"):StartCooldown(hero:FindAbilityByName("archer_unlimited_bladeworks_chant"):GetCooldownTimeRemaining())
	end

	if hero:HasModifier("modifier_unlimited_bladeworks") then 
		hero:SwapAbilities("archer_sword_barrage_retreat_shot_upgrade", "archer_sword_barrage_retreat_shot", true, false) 
		hero:SwapAbilities("archer_sword_barrage_confine_upgrade", "archer_sword_barrage_confine", true, false) 
		hero:SwapAbilities("archer_gae_bolg_upgrade", "archer_gae_bolg", true, false) 
		hero:SwapAbilities("archer_sword_barrage_upgrade", "archer_sword_barrage", true, false) 
		hero:SwapAbilities("archer_nine_lives_upgrade", "archer_nine_lives", true, false) 
		hero:FindAbilityByName("archer_unlimited_bladeworks_chant_upgrade"):SetHidden(true)
	else
		if hero.ubw_chant == nil then 
			hero.ubw_chant = 0 
		end
		if hero.ubw_chant == 6 then
			hero:SwapAbilities("archer_unlimited_bladeworks_upgrade", "archer_unlimited_bladeworks", true, false) 
		elseif hero.ubw_chant < 6 then
			hero:SwapAbilities("archer_unlimited_bladeworks_chant_upgrade", "archer_unlimited_bladeworks_chant", true, false) 
		end
	end

	hero:RemoveAbility("archer_sword_barrage_retreat_shot")
	hero:RemoveAbility("archer_sword_barrage_confine")
	hero:RemoveAbility("archer_gae_bolg")
	hero:RemoveAbility("archer_sword_barrage")
	hero:RemoveAbility("archer_nine_lives")
	hero:RemoveAbility("archer_unlimited_bladeworks_chant")
	hero:RemoveAbility("archer_unlimited_bladeworks")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnOveredgeAcquired(keys)
	local caster = keys.caster
	local pid = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(pid)

	hero.IsOveredgeAcquired = true

	hero:AddAbility("archer_kanshou_byakuya_upgrade")
	hero:FindAbilityByName("archer_kanshou_byakuya_upgrade"):SetLevel(hero:FindAbilityByName("archer_kanshou_byakuya"):GetLevel())
	if not hero:FindAbilityByName("archer_kanshou_byakuya"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_kanshou_byakuya_upgrade"):StartCooldown(hero:FindAbilityByName("archer_kanshou_byakuya"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("archer_crane_wing_upgrade")
	hero:FindAbilityByName("archer_crane_wing_upgrade"):SetLevel(hero:FindAbilityByName("archer_crane_wing"):GetLevel())
	if not hero:FindAbilityByName("archer_crane_wing"):IsCooldownReady() then 
		hero:FindAbilityByName("archer_crane_wing_upgrade"):StartCooldown(hero:FindAbilityByName("archer_crane_wing"):GetCooldownTimeRemaining())
	end

	if hero:HasModifier("modifier_unlimited_bladeworks") then 
		hero:FindAbilityByName("archer_kanshou_byakuya_upgrade"):SetHidden(true)
		hero:FindAbilityByName("archer_crane_wing_upgrade"):SetHidden(true)
	else
		hero:SwapAbilities("archer_kanshou_byakuya_upgrade", "archer_kanshou_byakuya", true, false) 
		hero:SwapAbilities("archer_crane_wing_upgrade", "archer_crane_wing", true, false) 
	end

	hero:RemoveAbility("archer_kanshou_byakuya")
	hero:RemoveAbility("archer_crane_wing")
	
	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

