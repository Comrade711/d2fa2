
function OnFACrit(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_minds_eye_crit_hit", {})
end

function OnMindsEyeAttacked(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ratio = keys.Ratio
	local revokedRatio = keys.RatioRevoked
	
	if caster:GetAttackTarget() ~= nil then
		if caster:GetAttackTarget():GetName() == "npc_dota_ward_base" then
			print("Attacking Ward")
			return
		end
	end

	if IsRevoked(target) then
		DoDamage(caster, target, caster:GetAgility() * revokedRatio , DAMAGE_TYPE_PURE, 0, ability, false)
	else
		DoDamage(caster, target, caster:GetAgility() * ratio , DAMAGE_TYPE_PURE, 0, ability, false)
	end
end

function OnGKStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local bonus_sight = ability:GetSpecialValueFor("bonus_sight")
	local ply = caster:GetPlayerOwner()

	SasakiCheckCombo(caster, ability)

	if caster.IsQuickdrawAcquired and not caster:HasModifier("modifier_quickdraw_cooldown") then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sasaki_quickdraw_window", {})
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_gate_keeper_self_buff", {})

	local gkdummy = CreateUnitByName("sight_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	gkdummy:SetDayTimeVisionRange(caster:GetDayTimeVisionRange() + bonus_sight)
	gkdummy:SetNightTimeVisionRange(caster:GetNightTimeVisionRange() + bonus_sight)

	local gkdummypassive = gkdummy:FindAbilityByName("dummy_unit_passive")
	gkdummypassive:SetLevel(1)

	local eyeCounter = 0

	Timers:CreateTimer(function() 
		if eyeCounter > duration then 
			DummyEnd(gkdummy) 
			return 
		end
		gkdummy:SetAbsOrigin(caster:GetAbsOrigin()) 
		eyeCounter = eyeCounter + 0.2
		return 0.2
	end)

end

-- Create Gate keeper's particles
function GKParticleStart( keys )
	local caster = keys.caster
	if caster.fa_gate_keeper_particle ~= nil then
		return
	end
	
	caster.fa_gate_keeper_particle = ParticleManager:CreateParticle( "particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( caster.fa_gate_keeper_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( caster.fa_gate_keeper_particle, 1, Vector( 100, 100, 100 ) )
end

-- Destroy Gate keeper's particles
function GKParticleDestroy( keys )
	local caster = keys.caster
	if caster.fa_gate_keeper_particle ~= nil then
		ParticleManager:DestroyParticle( caster.fa_gate_keeper_particle, false )
		ParticleManager:ReleaseParticleIndex( caster.fa_gate_keeper_particle )
		caster.fa_gate_keeper_particle = nil
	end
end

function OnHeartStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_heart_of_harmony", {})
	caster:EmitSound("Hero_Abaddon.AphoticShield.Cast")
end

function OnHeartInterrupt(keys)
	local caster = keys.caster 
	caster:RemoveModifierByName("modifier_heart_of_harmony")
	HardCleanse(caster)
end

function OnHeartDamageTaken(keys)
	-- process counter
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local damageTaken = keys.DamageTaken
	local threshold = ability:GetSpecialValueFor("threshold")
	local radius = ability:GetSpecialValueFor("radius")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local attack_count = ability:GetSpecialValueFor("attack_count")
	local damage = ability:GetSpecialValueFor("damage")
	local interval = ability:GetSpecialValueFor("interval")
	if damageTaken > threshold and caster:GetHealth() ~= 0 then
		caster:RemoveModifierByName("modifier_heart_of_harmony")	
		caster:AddNewModifier(caster, caster, "modifier_camera_follow", {duration = 1.0})
		caster:ApplyHeal(damageTaken, caster)
		if (caster:GetAbsOrigin()-target:GetAbsOrigin()):Length2D() < radius and not target:IsInvulnerable() and caster:GetTeam() ~= target:GetTeam() then
			local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
			local position = target:GetAbsOrigin() - diff*100
			FindClearSpaceForUnit(caster, position, true)		
			target:AddNewModifier(caster, target, "modifier_stunned", {Duration = stun_duration})
			giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", interval * attack_count)
			--local multiplier = GetPhysicalDamageReduction(target:GetPhysicalArmorValue()) * caster.ArmorPen / 100
			--local damage = caster:GetAttackDamage() * keys.Damage/100
			--DoDamage(caster, target, damage, DAMAGE_TYPE_PHYSICAL, 0, keys.ability, false)

			local counter = 0
			Timers:CreateTimer(function()
				if counter == attack_count or not caster:IsAlive() then return end 
				if caster.IsMindsEyeAcquired then
					DoDamage(caster, target, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR, ability, false)
				else	
					DoDamage(caster, target, damage, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
				end
				--caster:PerformAttack( target, true, true, true, true, false, false, false )
				caster:AddNewModifier(caster, caster, "modifier_camera_follow", {duration = 1.0})
				CreateSlashFx(caster, target:GetAbsOrigin() + RandomVector(500), target:GetAbsOrigin() + RandomVector(500))
				counter = counter+1
				return interval
			end)
	
			local cleanseCounter = 0
			Timers:CreateTimer(function()
				if cleanseCounter >= attack_count * 2 then return end
				HardCleanse(caster)
				cleanseCounter = cleanseCounter + 1
				return interval / 2
			end)
			target:EmitSound("FA.Omigoto")
			EmitGlobalSound("FA.Quickdraw")
		end
	end	
end

function OnWBStart(keys)

	EmitGlobalSound("FA.Windblade" )
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	local stun = ability:GetSpecialValueFor("stun")
	local knock = ability:GetSpecialValueFor("knock")
	local casterInitOrigin = caster:GetAbsOrigin() 

	if caster.IsGanryuAcquired then
		giveUnitDataDrivenModifier(caster, caster, "drag_pause", stun - 0.2)
	else
		giveUnitDataDrivenModifier(caster, caster, "drag_pause", stun)
	end

	local targets = FindUnitsInRadius(caster:GetTeam(), casterInitOrigin, nil, radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	if caster.IsGanryuAcquired then
		Timers:CreateTimer(0.1, function()
			for i=1, #targets do
				if targets[i]:IsAlive() and targets[i]:GetName() ~= "npc_dota_ward_base" then
					--local diff = (caster:GetAbsOrigin() - targets[i]:GetAbsOrigin()):Normalized()
					caster:SetAbsOrigin(targets[i]:GetAbsOrigin() - targets[i]:GetForwardVector():Normalized()*100)
					caster:PerformAttack( targets[i], true, true, true, true, false, false, false )
					FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
					break
				end
			end
		return end)
	end

	for k,v in pairs(targets) do
		--if (v:GetName() == "npc_dota_hero_bounty_hunter" and v.IsPFWAcquired) or 
		if v:GetUnitName() == "ward_familiar" then 
			-- do nothing
		else
			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
		    ParticleManager:SetParticleControl(slashIndex, 0, v:GetAbsOrigin())
		    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
		    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
		    if not v:HasModifier("modifier_wind_protection_passive") and not IsKnockbackImmune(v) then
		    	giveUnitDataDrivenModifier(caster, v, "drag_pause", stun)
				local pushback = Physics:Unit(v)
				v:PreventDI()
				v:SetPhysicsFriction(0)
				v:SetPhysicsVelocity((v:GetAbsOrigin() - casterInitOrigin):Normalized() * knock)
				v:SetNavCollisionType(PHYSICS_NAV_NOTHING)
				v:FollowNavMesh(false)
				Timers:CreateTimer(stun, function()  
					v:PreventDI(false)
					v:SetPhysicsVelocity(Vector(0,0,0))
					v:OnPhysicsFrame(nil)
					FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
				return end)
			end
		end
	end

	local risingWindFx = ParticleManager:CreateParticle("particles/custom/false_assassin/fa_thunder_clap.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	-- Destroy particle after delay
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( risingWindFx, false )
		ParticleManager:ReleaseParticleIndex( risingWindFx )
		return nil
	end)
end


function TGPlaySound(keys)
	local caster = keys.caster
	local target = keys.target
	if target:GetName() == "npc_dota_ward_base" then
		caster:Interrupt()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Target")
		return
	end

	EmitGlobalSound("FA.TGReady")

	local diff = target:GetAbsOrigin() - caster:GetAbsOrigin()
	local firstImpactIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl(firstImpactIndex, 0, caster:GetAbsOrigin() + diff/2)
    ParticleManager:SetParticleControl(firstImpactIndex, 1, Vector(600,0,150))
    ParticleManager:SetParticleControl(firstImpactIndex, 2, Vector(0.4,0,0))
	--[[local firstImpactIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl(firstImpactIndex, 0, Vector(1,0,0))
    ParticleManager:SetParticleControl(firstImpactIndex, 1, Vector(300-50,0,0))
    ParticleManager:SetParticleControl(firstImpactIndex, 2, Vector(0.5,0,0))
    ParticleManager:SetParticleControl(firstImpactIndex, 3, keys.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(firstImpactIndex, 4, Vector(0,0,0))]]
end

function OnTGStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local pause = keys.Pause
	local damage = keys.Damage
	local lasthit_damage = keys.LastDamage
	local stun_duration = keys.StunDuration
	local radius = keys.Radius

	target:TriggerSpellReflect(ability)
	if IsSpellBlocked(target) then return end -- Linken effect checker
	EmitGlobalSound("FA.Chop")

	EmitGlobalSound("FA.TG")

	giveUnitDataDrivenModifier(caster, caster, "dragged", pause)
	giveUnitDataDrivenModifier(caster, caster, "revoked", pause)
		
    Timers:CreateTimer(0.2, function()
		caster:AddNewModifier(caster, nil, "modifier_phased", {duration=pause})	
	end)

	local particle = ParticleManager:CreateParticle("particles/custom/false_assassin/tsubame_gaeshi/slashes.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin()) 

	Timers:CreateTimer(0.5, function()  
		if caster:IsAlive() and target:IsAlive() then
			local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
			caster:SetAbsOrigin(target:GetAbsOrigin() - diff*100) 
			if caster.IsGanryuAcquired then 
				--giveUnitDataDrivenModifier(caster, target, "silenced", 0.01)
				--[[DoDamage(caster, target, keys.Damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
				caster:PerformAttack( target, true, true, true, true, false, false, false )
				local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl(slashIndex, 0, target:GetAbsOrigin())
			    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
			    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))]]
				local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				for i=1, #targets do
					if targets[i]:GetName() ~= "npc_dota_ward_base" then
						DoDamage(caster, targets[i], damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, ability, false)
						local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
					    ParticleManager:SetParticleControl(slashIndex, 0, targets[i]:GetAbsOrigin())
					    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
					    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
					end
				end
			else
				DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, ability, false)
				local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl(slashIndex, 0, target:GetAbsOrigin())
			    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
			    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
			end

			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		else
			ParticleManager:DestroyParticle(particle, true)
		end
	return end)

	Timers:CreateTimer(0.7, function()  
		if caster:IsAlive() and target:IsAlive() then
			local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
			caster:SetAbsOrigin(target:GetAbsOrigin() - diff*100) 
			if caster.IsGanryuAcquired then 
				--giveUnitDataDrivenModifier(caster, target, "silenced", 0.01)
				--[[DoDamage(caster, target, keys.Damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
				caster:PerformAttack( target, true, true, true, true, false, false, false )
				local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl(slashIndex, 0, target:GetAbsOrigin())
			    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
			    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))]]
				local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				for i=1, #targets do
					if targets[i]:GetName() ~= "npc_dota_ward_base" then
						DoDamage(caster, targets[i], damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
						local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
					    ParticleManager:SetParticleControl(slashIndex, 0, targets[i]:GetAbsOrigin())
					    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
					    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
					end
				end
			else
				DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
				local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl(slashIndex, 0, target:GetAbsOrigin())
			    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
			    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
			end
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		else
			ParticleManager:DestroyParticle(particle, true)
		end
	return end)

	Timers:CreateTimer(0.9, function()  
		if caster:IsAlive() and target:IsAlive() then
			local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
			caster:SetAbsOrigin(target:GetAbsOrigin() - diff*100) 
			if target:HasModifier("modifier_instinct_active") and target:GetName() == "npc_dota_hero_legion_commander" then
				lasthit_damage = 0
			end -- if target has instinct up, block the last hit
			if caster.IsGanryuAcquired then	
				--[[DoDamage(caster, target, keys.LastDamage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
				caster:PerformAttack( target, true, true, true, true, false, false, false )
				target:AddNewModifier(caster, target, "modifier_stunned", {Duration = 1.5})
				local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl(slashIndex, 0, target:GetAbsOrigin())
			    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
			    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))]]
			    local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				for i=1, #targets do
					if targets[i]:GetName() ~= "npc_dota_ward_base" then
						DoDamage(caster, targets[i], lasthit_damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
						if IsSpellBlocked(targets[i]) and targets[i]:GetName() == "npc_dota_hero_legion_commander" then
						else
							targets[i]:AddNewModifier(caster, targets[i], "modifier_stunned", {Duration = stun_duration})
						end
						local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
					    ParticleManager:SetParticleControl(slashIndex, 0, targets[i]:GetAbsOrigin())
					    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
					    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
					end
				end
			else
				DoDamage(caster, target, lasthit_damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)
				if IsSpellBlocked(target) and target:GetName() == "npc_dota_hero_legion_commander" then
				else
					target:AddNewModifier(caster, target, "modifier_stunned", {Duration = stun_duration})
				end

				local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl(slashIndex, 0, target:GetAbsOrigin())
			    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
			    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))
			end
		else
			ParticleManager:DestroyParticle(particle, true)
		end
		local position = caster:GetAbsOrigin()
		if keys.Locator then
			local dummyPosition = keys.Locator:GetAbsOrigin()
			if not IsInSameRealm(position, dummyPosition) then
				position = dummyPosition
			end
		end
		FindClearSpaceForUnit(caster, position, true)
		giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", 0.2)
	return end)
end

function OnQuickDrawWindowCreate(keys)
	local caster = keys.caster 
	caster:SwapAbilities("sasaki_gatekeeper", "sasaki_quickdraw", false, true)
end

function OnQuickDrawWindowDestroy(keys)
	local caster = keys.caster 
	caster:SwapAbilities("sasaki_gatekeeper", "sasaki_quickdraw", true, false)
end

function OnQuickDrawWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_sasaki_quickdraw_window")
end	

function OnQuickdrawStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local speed = ability:GetSpecialValueFor("speed")
	local distance = ability:GetSpecialValueFor("distance")
	local width = ability:GetSpecialValueFor("width")
	local qdProjectile = 
	{
		Ability = ability,
        EffectName = "particles/custom/false_assassin/fa_quickdraw.vpcf",
        iMoveSpeed = speed,
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = distance,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * speed
	}

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_quickdraw_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	caster:RemoveModifierByName("modifier_sasaki_quickdraw_window")
	local projectile = ProjectileManager:CreateLinearProjectile(qdProjectile)
	giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", 0.4)
	caster:EmitSound("Hero_PhantomLancer.Doppelwalk") 
	local sin = Physics:Unit(caster)
	caster:SetPhysicsFriction(0)
	caster:SetPhysicsVelocity(caster:GetForwardVector()*speed)
	caster:SetNavCollisionType(PHYSICS_NAV_BOUNCE)

	Timers:CreateTimer("quickdraw_dash", {
		endTime = 0.5,
		callback = function()
		caster:OnPreBounce(nil)
		caster:SetBounceMultiplier(0)
		caster:PreventDI(false)
		caster:SetPhysicsVelocity(Vector(0,0,0))
		caster:RemoveModifierByName("pause_sealenabled")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	return end
	})

	caster:OnPreBounce(function(unit, normal) -- stop the pushback when unit hits wall
		Timers:RemoveTimer("quickdraw_dash")
		unit:OnPreBounce(nil)
		unit:SetBounceMultiplier(0)
		unit:PreventDI(false)
		unit:SetPhysicsVelocity(Vector(0,0,0))
		caster:RemoveModifierByName("pause_sealenabled")
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		ProjectileManager:DestroyLinearProjectile(projectile)
	end)

end

function OnQuickdrawHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target == nil then return end
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local agi_ratio = ability:GetSpecialValueFor("agi_ratio")

	local damage = base_damage + caster:GetAgility() * agi_ratio
	DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)

	local firstImpactIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl(firstImpactIndex, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(firstImpactIndex, 1, Vector(800,0,150))
    ParticleManager:SetParticleControl(firstImpactIndex, 2, Vector(0.3,0,0))
end

function OnPCStart (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fa_invis", {})
end

function OnPCAttack (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = caster:GetAttackTarget()
	local radius = ability:GetSpecialValueFor("radius")
	if target ~= nil then 
		if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= radius then 
			local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
			local position = target:GetAbsOrigin() - diff*100
			FindClearSpaceForUnit(caster, position, true)
			giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", 0.2)
			caster:RemoveModifierByName("modifier_fa_invis")
			--caster:PerformAttack( target, true, true, true, true, false, false, false )
			CreateSlashFx(caster, target:GetAbsOrigin() + RandomVector(400), target:GetAbsOrigin() + RandomVector(400))
			EmitGlobalSound("FA.Quickdraw")
		end
	end
end

function OnPCDeactivate(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_fa_invis")
end

function PCStopOrder(keys)
	--keys.caster:Stop() 
	local stopOrder = {
		UnitIndex = keys.caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_HOLD_POSITION
	}
	ExecuteOrderFromTable(stopOrder) 
end

function OnTMStart(keys)
	if not keys.caster:IsRealHero() then
		keys.ability:EndCooldown()
		return
	end
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tsubame_mai", {})
	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("sasaki_hiken_enbu")
	if masterCombo then
		masterCombo:EndCooldown()
		masterCombo:StartCooldown(keys.ability:GetCooldown(1))
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_tsubame_mai_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
		caster:RemoveModifierByName("modifier_hiken_window")
	end
	
end

function OnTMLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local slash_amount = ability:GetSpecialValueFor("slash_amount")
	

	local dummy = CreateUnitByName("godhand_res_locator", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1) 
	dummy:AddNewModifier(caster, nil, "modifier_phased", {duration=4})
	dummy:AddNewModifier(caster, nil, "modifier_kill", {duration=4})

	local tgabil = caster:FindAbilityByName("sasaki_tsubame_gaeshi")
	if caster.IsGanryuAcquired then 
		tgabil = caster:FindAbilityByName("sasaki_tsubame_gaeshi_upgrade")
	end

	keys.Damage = tgabil:GetLevelSpecialValueFor("damage", tgabil:GetLevel()-1)
	keys.LastDamage = tgabil:GetLevelSpecialValueFor("lasthit_damage", tgabil:GetLevel()-1)
	keys.StunDuration = tgabil:GetLevelSpecialValueFor("stun_duration", tgabil:GetLevel()-1)
	keys.Pause = tgabil:GetLevelSpecialValueFor("pause", tgabil:GetLevel()-1)
	keys.Radius = tgabil:GetLevelSpecialValueFor("radius", tgabil:GetLevel()-1)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tsubame_mai", {})

	local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
	caster:SetAbsOrigin(target:GetAbsOrigin() - diff*100)
	caster:AddNewModifier(caster, caster, "modifier_camera_follow", {duration = 1.0}) 
	ApplyAirborne(caster, target, 2.0)
	giveUnitDataDrivenModifier(keys.caster, keys.caster, "jump_pause", 2.8)
	caster:RemoveModifierByName("modifier_tsubame_mai")
	EmitGlobalSound("FA.Owarida")
	EmitGlobalSound("FA.Quickdraw")
	CreateSlashFx(caster, target:GetAbsOrigin()+Vector(0, 0, -300), target:GetAbsOrigin()+Vector(0,0,500))

	local slashCounter = 0
	Timers:CreateTimer(0.8, function()
		if slashCounter == 0 then 
			--caster:SetModel("models/development/invisiblebox.vmdl") 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_tsubame_mai_baseattack_reduction", {}) 
		end
		if slashCounter == slash_amount or not caster:IsAlive() then 
			caser:RemoveModifierByName("modifier_tsubame_mai_baseattack_reduction")
			--caster:SetModel("models/assassin/asn.vmdl") 
			return 
		end
		local oldLoc = caster:GetAbsOrigin()
		StartAnimation(caster, {duration = 0.2, activity=ACT_DOTA_ATTACK2, rate = 5.0})
		caster:PerformAttack( target, true, true, true, true, false, false, false )
		target:AddNewModifier(caster, target, "modifier_stunned", {duration = 0.3}) 
		local newLoc = RandomPositionAtRadius(target:GetAbsOrigin(), 400)
		caster:SetAbsOrigin(Vector(newLoc.x, newLoc.y, caster:GetAbsOrigin().z))
		caster:SetForwardVector((caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized())
		CreateSlashFx(caster, oldLoc + Vector(0,0,200), newLoc + Vector(0,0,200))
		EmitGlobalSound("FA.Quickdraw") 

		slashCounter = slashCounter + 1
		return 0.2-slashCounter*0.01
	end)

	Timers:CreateTimer(2.0, function()
		if caster:IsAlive() then
			caster:SetAbsOrigin(Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,target:GetAbsOrigin().z))
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_tsubame_mai_tg_cast_anim", {})
			EmitGlobalSound("FA.TGReady")
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP,
				Queue = false
			})
			caster:SetForwardVector((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()) 
		end
	end)

	Timers:CreateTimer(2.8, function()
		if caster:IsAlive() then
			keys.IsCounter = true
			keys.Locator = dummy
			keys.ability = tgabil
			OnTGStart(keys)
		end
	end)
end

function OnTMDamageTaken(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local threshold = ability:GetSpecialValueFor("threshold")
	local range = ability:GetSpecialValueFor("range")
	local damageTaken = keys.DamageTaken

	-- if caster is alive and damage is above threshold, do something
	if damageTaken > threshold and caster:GetHealth() ~= 0 and (caster:GetAbsOrigin()-attacker:GetAbsOrigin()):Length2D() <= range and not attacker:IsInvulnerable() and caster:GetTeam() ~= attacker:GetTeam() then
		keys.target = keys.attacker
		OnTMLanded(keys)
	end
end

function SasakiCheckCombo(caster, ability)
	if caster:GetStrength() >= 29.1 and caster:GetAgility() >= 29.1 then
		if ability == caster:FindAbilityByName("sasaki_gatekeeper") then 
			if caster.IsGanryuAcquired then
				if caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony_upgrade_3"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				elseif not caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				elseif caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				elseif not caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				end	
			else 
				if caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony_upgrade_3"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				elseif not caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				elseif caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				elseif not caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired then 
					if caster:FindAbilityByName("sasaki_heart_of_harmony"):IsCooldownReady() and caster:FindAbilityByName("sasaki_hiken_enbu"):IsCooldownReady() and not caster:HasModifier("modifier_tsubame_mai_cooldown") then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_hiken_window", {})
					end
				end	
			end
		end
	end
end

function OnHikenWindowCreate(keys)
	local caster = keys.caster 
	--if caster.IsGanryuAcquired then
		if caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_3", "sasaki_hiken_enbu_upgrade", false, true)
		elseif not caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_2", "sasaki_hiken_enbu_upgrade", false, true)			
		elseif caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_1", "sasaki_hiken_enbu_upgrade", false, true)			
		elseif not caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony", "sasaki_hiken_enbu_upgrade", false, true)
		--end
	--else
		elseif caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_3", "sasaki_hiken_enbu", false, true)
		elseif not caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_2", "sasaki_hiken_enbu", false, true)			
		elseif caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_1", "sasaki_hiken_enbu", false, true)			
		elseif not caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony", "sasaki_hiken_enbu", false, true)
		end
	--end
end

function OnHikenWindowDestroy(keys)
	local caster = keys.caster 
	--if and caster.IsGanryuAcquired then
		if caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_3", "sasaki_hiken_enbu_upgrade", true, false)
		elseif not caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_2", "sasaki_hiken_enbu_upgrade", true, false)			
		elseif caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_1", "sasaki_hiken_enbu_upgrade", true, false)			
		elseif not caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony", "sasaki_hiken_enbu_upgrade", true, false)
		--end
	--else
		elseif caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_3", "sasaki_hiken_enbu", true, false)
		elseif not caster.IsVitrificationAcquired and caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_2", "sasaki_hiken_enbu", true, false)			
		elseif caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony_upgrade_1", "sasaki_hiken_enbu", true, false)			
		elseif not caster.IsVitrificationAcquired and not caster.IsMindsEyeAcquired and not caster.IsGanryuAcquired then
			caster:SwapAbilities("sasaki_heart_of_harmony", "sasaki_hiken_enbu", true, false)
		end
	--end
end

function OnHikenWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_hiken_window")
end	

function OnGanryuAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_hiken_window") then 
		hero:RemoveModifierByName("modifier_hiken_window")
	end

	hero.IsGanryuAcquired = true
	
	hero:AddAbility("sasaki_windblade_upgrade")
	hero:FindAbilityByName("sasaki_windblade_upgrade"):SetLevel(hero:FindAbilityByName("sasaki_windblade"):GetLevel())
	hero:SwapAbilities("sasaki_windblade_upgrade", "sasaki_windblade", true, false) 
	if not hero:FindAbilityByName("sasaki_windblade"):IsCooldownReady() then 
		hero:FindAbilityByName("sasaki_windblade_upgrade"):StartCooldown(hero:FindAbilityByName("sasaki_windblade"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("sasaki_tsubame_gaeshi_upgrade")
	hero:FindAbilityByName("sasaki_tsubame_gaeshi_upgrade"):SetLevel(hero:FindAbilityByName("sasaki_tsubame_gaeshi"):GetLevel())
	hero:SwapAbilities("sasaki_tsubame_gaeshi_upgrade", "sasaki_tsubame_gaeshi", true, false) 
	if not hero:FindAbilityByName("sasaki_tsubame_gaeshi"):IsCooldownReady() then 
		hero:FindAbilityByName("sasaki_tsubame_gaeshi_upgrade"):StartCooldown(hero:FindAbilityByName("sasaki_tsubame_gaeshi"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("sasaki_hiken_enbu_upgrade")
	hero:FindAbilityByName("sasaki_hiken_enbu_upgrade"):SetLevel(1)
	if not hero:FindAbilityByName("sasaki_hiken_enbu"):IsCooldownReady() then 
		hero:FindAbilityByName("sasaki_hiken_enbu_upgrade"):StartCooldown(hero:FindAbilityByName("sasaki_hiken_enbu"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("sasaki_windblade")
	hero:RemoveAbility("sasaki_tsubame_gaeshi")
	hero:RemoveAbility("sasaki_hiken_enbu")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnQuickdrawAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsQuickdrawAcquired = true

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnVitrificationAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_hiken_window") then 
		hero:RemoveModifierByName("modifier_hiken_window")
	end

	hero.IsVitrificationAcquired = true

	if hero.IsMindsEyeAcquired then 
		hero:AddAbility("sasaki_heart_of_harmony_upgrade_3")
		hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_3"):SetLevel(hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):GetLevel())
		hero:SwapAbilities("sasaki_heart_of_harmony_upgrade_3", "sasaki_heart_of_harmony_upgrade_2", true, false) 
		if not hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):IsCooldownReady() then 
			hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_3"):StartCooldown(hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("sasaki_heart_of_harmony_upgrade_2")
	else
		hero:AddAbility("sasaki_heart_of_harmony_upgrade_1")
		hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):SetLevel(hero:FindAbilityByName("sasaki_heart_of_harmony"):GetLevel())
		hero:SwapAbilities("sasaki_heart_of_harmony_upgrade_1", "sasaki_heart_of_harmony", true, false) 
		if not hero:FindAbilityByName("sasaki_heart_of_harmony"):IsCooldownReady() then 
			hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):StartCooldown(hero:FindAbilityByName("sasaki_heart_of_harmony"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("sasaki_heart_of_harmony")
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnMindsEyeImproved(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_hiken_window") then 
		hero:RemoveModifierByName("modifier_hiken_window")
	end

	hero.IsMindsEyeAcquired = true

	hero:AddAbility("sasaki_minds_eye_upgrade")
	hero:FindAbilityByName("sasaki_minds_eye_upgrade"):SetLevel(1)
	hero:SwapAbilities("sasaki_minds_eye_upgrade", "sasaki_minds_eye", true, false) 
	hero:RemoveAbility("sasaki_minds_eye")

	if hero.IsVitrificationAcquired then 
		hero:AddAbility("sasaki_heart_of_harmony_upgrade_3")
		hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_3"):SetLevel(hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):GetLevel())
		hero:SwapAbilities("sasaki_heart_of_harmony_upgrade_3", "sasaki_heart_of_harmony_upgrade_1", true, false) 
		if not hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):IsCooldownReady() then 
			hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_3"):StartCooldown(hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_1"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("sasaki_heart_of_harmony_upgrade_1")
	else
		hero:AddAbility("sasaki_heart_of_harmony_upgrade_2")
		hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):SetLevel(hero:FindAbilityByName("sasaki_heart_of_harmony"):GetLevel())
		hero:SwapAbilities("sasaki_heart_of_harmony_upgrade_2", "sasaki_heart_of_harmony", true, false) 
		if not hero:FindAbilityByName("sasaki_heart_of_harmony"):IsCooldownReady() then 
			hero:FindAbilityByName("sasaki_heart_of_harmony_upgrade_2"):StartCooldown(hero:FindAbilityByName("sasaki_heart_of_harmony"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("sasaki_heart_of_harmony")
	end

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnPresenceConcealmentAcquired (keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsPresenceConcealmentAcquired = true
	hero:FindAbilityByName("sasaki_presence_concealment"):SetLevel(1) 
	hero:SwapAbilities("fate_empty1", "sasaki_presence_concealment", false, true) 

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end
