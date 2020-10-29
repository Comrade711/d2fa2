
function OnGodHandDeath(keys)
	local caster = keys.caster
	local newRespawnPos = caster:GetOrigin()
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	local radius = ability:GetSpecialValueFor("radius")
	local damage_hp = ability:GetSpecialValueFor("damage_hp")
	local penalty_duration = ability:GetSpecialValueFor("penalty_duration")

	local dummy = CreateUnitByName("godhand_res_locator", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1) 
	dummy:AddNewModifier(caster, nil, "modifier_phased", {duration=1.0})
	dummy:AddNewModifier(caster, nil, "modifier_kill", {duration=1.1})


	--print("God Hand activated")
	Timers:CreateTimer({
		endTime = 1,
		callback = function()
		--print(caster.bIsGHReady)
		if IsTeamWiped(caster) == false and caster.GodHandStock > 0 and caster.bIsGHReady and _G.CurrentGameState == "FATE_ROUND_ONGOING" then
			caster.bIsGHReady = false
			Timers:CreateTimer(penalty_duration, function() caster.bIsGHReady = true end)
			EmitGlobalSound("Berserker.Roar") 
			local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			caster.GodHandStock = caster.GodHandStock - 1
			GameRules:SendCustomMessage("<font color='#FF0000'>----------!!!!!</font> Remaining God Hand stock : " .. caster.GodHandStock , 0, 0)
			caster:SetRespawnPosition(dummy:GetAbsOrigin())
			RemoveDebuffsForRevival(caster)
			caster:RespawnHero(false,false)
			caster:RemoveModifierByName("modifier_god_hand_stock")
			if caster.GodHandStock > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_god_hand_stock", {})
				caster:SetModifierStackCount("modifier_god_hand_stock", caster, caster.GodHandStock)
			end

			-- Apply revive damage
			local resExp = ParticleManager:CreateParticle("particles/custom/berserker/god_hand/stomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			-- DebugDrawCircle(caster:GetAbsOrigin(), Vector(255,0,0), 0.5, radius, true, 0.5)
			for k,v in pairs(targets) do
		        DoDamage(caster, v, caster:GetMaxHealth() * damage_hp / 100, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			end	

			-- Apply penalty
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_god_hand_debuff", {}) 
			-- Remove Gae Buidhe modifier
			caster:RemoveModifierByName("modifier_gae_buidhe")
			-- Reset godhand stock
			caster.ReincarnationDamageTaken = 0
			--UpdateGodhandProgress(caster)
		else
			--caster.DeathCount = (caster.DeathCount or 0) + 1
			caster:SetRespawnPosition(caster.RespawnPos)
			caster.MasterUnit:AddNewModifier(caster, nil, "modifier_death_tracker", { Deaths = caster.DeathCount })
		end
		--caster:SetRespawnPosition(Vector(7000, 2000, 320)) need to set the respawn base after reviving
	end
	})	

end

function OnReincarnationDamageTaken(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damageTaken = keys.DamageTaken
	local threshold = ability:GetSpecialValueFor("threshold")
	local damageThreshold = ability:GetSpecialValueFor("damage_sustain")

	if damageTaken > threshold then
		GainReincarnationRegenStack(caster, ability)
	end

	--[[if caster.IsGodHandAcquired ~= true then return end -- To prevent reincanationdamagetaken from incrementing when GH is not taken.

	if caster:HasModifier("modifier_heracles_berserk") then 
		caster.ReincarnationDamageTaken = caster.ReincarnationDamageTaken+damageTaken*3
	else
		caster.ReincarnationDamageTaken = caster.ReincarnationDamageTaken+damageTaken
	end
	
	if caster.ReincarnationDamageTaken > damageThreshold and caster.IsGodHandAcquired then
		caster.ReincarnationDamageTaken = 0
		caster.GodHandStock = caster.GodHandStock + 1
		caster:RemoveModifierByName("modifier_god_hand_stock")
		caster:FindAbilityByName("berserker_5th_god_hand"):ApplyDataDrivenModifier(caster, caster, "modifier_god_hand_stock", {})
		caster:SetModifierStackCount("modifier_god_hand_stock", caster, caster.GodHandStock)
	end

	UpdateGodhandProgress(caster)]]
end

function UpdateGodhandProgress(caster)
	local damageTaken = caster.ReincarnationDamageTaken
	if not caster:HasModifier("modifier_reincarnation_progress") then
		caster:FindAbilityByName("heracles_reincarnation"):ApplyDataDrivenModifier(caster, caster, "modifier_reincarnation_progress", {})
	end
	caster:SetModifierStackCount("modifier_reincarnation_progress", caster, damageTaken / 200)
end

function GainReincarnationRegenStack(caster, ability)
	local max_stack = ability:GetSpecialValueFor("max_stack")
	local modifier = ability:ApplyDataDrivenModifier(caster, caster, "modifier_reincarnation_stack", {})
	if modifier:GetStackCount() < max_stack then 
		modifier:IncrementStackCount() 
	end

	if not caster.reincarnation_particle then caster.reincarnation_particle = ParticleManager:CreateParticle("particles/custom/berserker/reincarnation/regen_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) end
	ParticleManager:SetParticleControl(caster.reincarnation_particle, 1, Vector(modifier:GetStackCount(),0,0))
end

function OnReincarnationBuffEnded(keys)
	ParticleManager:DestroyParticle(keys.caster.reincarnation_particle, false)
	keys.caster.reincarnation_particle = nil
end

function OnFissureStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_points = ability:GetCursorPosition()
	local width = ability:GetSpecialValueFor("radius")
	local range = ability:GetSpecialValueFor("range")
	local speed = ability:GetSpecialValueFor("proj_speed")
	local frontward = caster:GetForwardVector()
	local fiss = 
	{
		Ability = ability,
        EffectName = "particles/custom/berserker/fissure_strike/shockwave.vpcf",
        iMoveSpeed = speed,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = range,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        fExpireTime = GameRules:GetGameTime() + 0.5,
		bDeleteOnHit = false,
		vVelocity = frontward * speed
	}
	caster.FissureOrigin  = caster:GetAbsOrigin()
	caster.FissureTarget = target_points
	projectile = ProjectileManager:CreateLinearProjectile(fiss)
	BerCheckCombo(caster, ability)

	caster:EmitSound("Heracles_Roar_" .. math.random(1,6))
end

function OnFissureHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target == nil then return end
	local damage = ability:GetSpecialValueFor("damage")
	local knockback = ability:GetSpecialValueFor("knockback")
	local collide_duration = ability:GetSpecialValueFor("collide_duration")
	local wall_damage = ability:GetSpecialValueFor("wall_damage")
	local speed = ability:GetSpecialValueFor("proj_speed")

	DoDamage(caster, target, damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
	if not IsImmuneToSlow(target) then 
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fissure_strike_slow", {}) 
	end

	giveUnitDataDrivenModifier(caster, target, "pause_sealenabled", 0.01)

	if not IsKnockbackImmune(target) then
	    local pushTarget = Physics:Unit(target)
	    target:PreventDI()
	    target:SetPhysicsFriction(0)
		local vectorC = (caster.FissureTarget - caster.FissureOrigin) + Vector(0,0,100) --knockback in direction as fissure
		-- get the direction where target will be pushed back to
		target:SetPhysicsVelocity(vectorC:Normalized() * speed)
	    target:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
		local initialUnitOrigin = target:GetAbsOrigin()
		
		target:OnPhysicsFrame(function(unit) -- pushback distance check
			local unitOrigin = unit:GetAbsOrigin()
			local diff = unitOrigin - initialUnitOrigin
			local n_diff = diff:Normalized()
			unit:SetPhysicsVelocity(unit:GetPhysicsVelocity():Length() * n_diff) -- track the movement of target being pushed back
			if diff:Length() > knockback then -- if pushback distance is over 400, stop it
				unit:PreventDI(false)
				unit:SetPhysicsVelocity(Vector(0,0,0))
				unit:OnPhysicsFrame(nil)
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end)		
		
		target:OnPreBounce(function(unit, normal) -- stop the pushback when unit hits wall
			unit:SetBounceMultiplier(0)
			unit:PreventDI(false)
			unit:SetPhysicsVelocity(Vector(0,0,0))
			DoDamage(caster, target, wall_damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
			target:AddNewModifier(caster, target, "modifier_stunned", { Duration = collide_duration})
		end)
	end
end

function OnCourageStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local max_stack = ability:GetSpecialValueFor("max_stack")
	local nine_cdr = ability:GetSpecialValueFor("nine_cdr")

	--StartAnimation(caster, {duration = 0.1, activity=ACT_DOTA_CAST_ABILITY_2, rate = 1.5})

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if not IsFacingUnit(v, caster, 90) then
			local debuffStack = v:GetModifierStackCount("modifier_courage_enemy_debuff_stack", caster) or 0
			-- Apply armor reduction and damage reduction buff to nearby enemies
			ability:ApplyDataDrivenModifier(caster, v, "modifier_courage_enemy_debuff_stack", {}) 
			ability:ApplyDataDrivenModifier(caster, v, "modifier_courage_enemy_debuff", {}) 
			if debuffStack < max_stack then
				v:SetModifierStackCount("modifier_courage_enemy_debuff_stack", caster, debuffStack + 1)
			end
		end
	end 

	RemoveSlowEffect(caster)

	local currentStack = caster:GetModifierStackCount("modifier_courage_self_buff_stack", caster) or 0

	caster:EmitSound("Heracles_Roar_" .. math.random(1,6))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_courage_self_buff_stack", {}) 
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_courage_self_buff", {}) 
	if currentStack < max_stack then
		caster:SetModifierStackCount("modifier_courage_self_buff_stack", ability, currentStack + 1)
	end

	-- Reduce Nine Lives cooldown if applicable
	if caster.IsEternalRageAcquired then
		if caster.IsMadEnhancementAcquired then 
			ReduceCooldown(caster:FindAbilityByName("heracles_nine_lives_upgrade"), nine_cdr)
		else
			ReduceCooldown(caster:FindAbilityByName("heracles_nine_lives"), nine_cdr)
		end
	end

	if not caster.courage_particle then
		caster.courage_particle = ParticleManager:CreateParticle("particles/custom/berserker/courage/buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(caster.courage_particle, 1, Vector(currentStack + 1,1,1))
		ParticleManager:SetParticleControl(caster.courage_particle, 3, Vector(radius,1,1))
	end
end

function OnCourageBuffThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local currentStack = caster:GetModifierStackCount("modifier_courage_self_buff_stack", caster) or 0
	ParticleManager:SetParticleControl(caster.courage_particle, 1, Vector(currentStack + 1,1,1))
	ParticleManager:SetParticleControl(caster.courage_particle, 3, Vector(radius,1,1))
end

function OnCourageBuffEnded(keys)
	local caster = keys.caster
	ParticleManager:DestroyParticle(caster.courage_particle, false)
	ParticleManager:ReleaseParticleIndex( caster.courage_particle )
	caster.courage_particle = nil
end

function OnCourageBash(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local bash_damage = ability:GetSpecialValueFor("bash_damage")
	local bash_duration = ability:GetSpecialValueFor("bash_duration")
	if not caster:HasModifier("modifier_courage_bash_cooldown") then 
		DoDamage(caster, target, bash_damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_courage_bash_cooldown", {}) 
		if target:HasModifier("modifier_courage_enemy_debuff") then 
			target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})
		end
	end
end

function OnBerserkStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hplock = ability:GetSpecialValueFor("health_constant")
	local max_damage = ability:GetSpecialValueFor("max_damage")
	local radius = ability:GetSpecialValueFor("radius")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_heracles_berserk", {})
	if caster.IsEternalRageAcquired then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_eternal_rage", {})
	end
	caster.BerserkDamageTaken = 0
	BerCheckCombo(caster,ability)

	local casterHealth = caster:GetHealth()
	if casterHealth - hplock > 0 then
		local berserkDamage = math.min((casterHealth - hplock), max_damage)  
		caster:EmitSound("Hero_Centaur.HoofStomp")

		local berserkExp = ParticleManager:CreateParticle("particles/custom/berserker/berserk/eternal_rage_shockwave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(berserkExp, 1, Vector(radius,0,radius))

		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 
		for k,v in pairs(targets) do
	        DoDamage(caster, v, berserkDamage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		end
	end
end

function OnBerserkThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hplock = ability:GetSpecialValueFor("health_constant")

	if caster:HasModifier("modifier_zabaniya_curse") then 
		caster:RemoveModifierByName("modifier_zabaniya_curse")
	end

	if caster:HasModifier("modifier_gae_buidhe") then
		local stacks = caster:GetModifierStackCount("modifier_gae_buidhe", Entities:FindByClassname(nil, "npc_dota_hero_huskar"))
		if caster:GetMaxHealth() - (stacks * 10) < hplock then
			hplock = caster:GetMaxHealth() - (stacks * 10) 
		end
	end

	caster:SetHealth(hplock)
end

function OnEternalRageThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius") 
	local dmg_convert = ability:GetSpecialValueFor("dmg_convert") 
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 
	for k,v in pairs(targets) do
		DoDamage(caster, v, caster.BerserkDamageTaken * dmg_convert / 100, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end
	caster.BerserkDamageTaken = 0
	local berserkExp = ParticleManager:CreateParticle("particles/custom/berserker/berserk/eternal_rage_shockwave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(berserkExp, 1, Vector(radius,0,radius))
end

function OnBerserkTakeDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hplock = ability:GetSpecialValueFor("health_constant") 
	local mana_convert = ability:GetSpecialValueFor("mana_convert") 
	local damageTaken = keys.DamageTaken

	if caster:HasModifier("modifier_gae_buidhe") then
		local stacks = caster:GetModifierStackCount("modifier_gae_buidhe", Entities:FindByClassname(nil, "npc_dota_hero_huskar"))
		if caster:GetMaxHealth() - (stacks * 10) < hplock then
			hplock = caster:GetMaxHealth() - (stacks * 10) 
		end
	end

	if keys.DamageTaken < hplock and caster:GetHealth() <= 0 then
		caster:SetHealth(1)
	end

	if caster.IsEternalRageAcquired then 
		caster.BerserkDamageTaken = caster.BerserkDamageTaken + damageTaken
		caster:SetMana(caster:GetMana() + (damageTaken * mana_convert / 100))
		ParticleManager:CreateParticle("particles/custom/berserker/berserk/mana_conversion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
end

function OnNineCast(keys)
	local caster = keys.caster
	if caster:HasModifier("modifier_heracles_berserk") then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_use_while_Berserked")
		return 
	end
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.2})
end

function OnNineStart(keys)
	
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = ability:GetCursorPosition()
	local berserker = Physics:Unit(caster)
	local origin = caster:GetAbsOrigin()
	local distance = (targetPoint - origin):Length2D()
	local forward = (targetPoint - origin):Normalized() * distance
	local pause_time = ability:GetSpecialValueFor("pause_time") 

	caster:SetPhysicsFriction(0)
	caster:SetPhysicsVelocity(caster:GetForwardVector()*distance)
	caster:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", pause_time)
	caster:EmitSound("Hero_OgreMagi.Ignite.Cast")

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.5})

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
			OnNineLanded(caster, ability)
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

end

function OnNineLanded(caster, ability)
	local tickdmg = ability:GetSpecialValueFor("damage")
	local lasthitdmg = ability:GetSpecialValueFor("damage_lasthit")
	local total_hit = ability:GetSpecialValueFor("total_hit")
	local courageAbility = 0
	local courageDamage = 0
	local returnDelay = ability:GetSpecialValueFor("interval")
	local radius = ability:GetSpecialValueFor("radius")
	local lasthitradius = ability:GetSpecialValueFor("radius_lasthit")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local mini_stun = ability:GetSpecialValueFor("mini_stun")
	local revoke = ability:GetSpecialValueFor("revoke")
	local post_nine = ability:GetSpecialValueFor("post_nine")
	local nineCounter = 0
	local casterInitOrigin = caster:GetAbsOrigin() 

	if math.random(1,100) > 5 then
		EmitGlobalSound("Heracles_NineLives_" .. math.random(1,3))
	else
		EmitGlobalSound("Heracles_Combo_Easter_1")
	end

	StartAnimation(caster, {duration = returnDelay * total_hit, activity=ACT_DOTA_CAST_ABILITY_6, rate = 1.0})

	-- main timer
	Timers:CreateTimer(function()
		if caster:IsAlive() then -- only perform actions while caster stays alive
			local particle = ParticleManager:CreateParticle("particles/custom/berserker/nine_lives/hit.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControlForward(particle, 0, caster:GetForwardVector() * -1)
			ParticleManager:SetParticleControl(particle, 1, Vector(0,0,(nineCounter % 2) * 180))

			caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact") 

			if nineCounter == total_hit - 1 then -- if it is last strike

				caster:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")
				caster:RemoveModifierByName("pause_sealdisabled") 
				caster:AddNewModifier(caster, ability, "modifier_stunned", { Duration = post_nine })
				ScreenShake(caster:GetOrigin(), 7, 1.0, 2, 1500, 0, true)
				-- do damage to targets

				local lasthitTargets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, lasthitradius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 1, false)
				for k,v in pairs(lasthitTargets) do
					if v:GetName() ~= "npc_dota_ward_base" then

						DoDamage(caster, v, lasthitdmg, DAMAGE_TYPE_MAGICAL, 0, ability, false)

						v:AddNewModifier(caster, ability, "modifier_stunned", { Duration = stun_duration })

						if caster.IsMadEnhancementAcquired then 
							giveUnitDataDrivenModifier(caster, v, "revoked", revoke)
						end

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

				--EmitGlobalSound("Berserker.Roar")

				ParticleManager:SetParticleControl(particle, 2, Vector(1,1,lasthitradius))
				ParticleManager:SetParticleControl(particle, 3, Vector(lasthitradius / 350,1,1))
				ParticleManager:CreateParticle("particles/custom/berserker/nine_lives/last_hit.vpcf", PATTACH_ABSORIGIN, caster)

				-- DebugDrawCircle(caster:GetAbsOrigin(), Vector(255,0,0), 0.5, lasthitradius, true, 0.5)
			else
				-- if its not last hit, do regular hit stuffs

				local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
				for k,v in pairs(targets) do
					DoDamage(caster, v, tickdmg, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					v:AddNewModifier(caster, ability, "modifier_stunned", { Duration = mini_stun })
					if caster.IsMadEnhancementAcquired then 
						giveUnitDataDrivenModifier(caster, v, "revoked", revoke)
					end
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

function OnRoarStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local radius2 = ability:GetSpecialValueFor("radius2")
	local radius3 = ability:GetSpecialValueFor("radius3")
	local radius4 = ability:GetSpecialValueFor("radius4")
	local damage = ability:GetSpecialValueFor("damage")
	local damage2 = ability:GetSpecialValueFor("damage2")
	local damage3 = ability:GetSpecialValueFor("damage3")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_madmans_roar_silence", {})

	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("heracles_madmans_roar")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_madmans_roar_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	
	caster:RemoveModifierByName("modifier_heracles_madman_window")

	--apply new berserk
	if caster:HasModifier("modifier_heracles_berserk") then
		caster:RemoveModifierByName("modifier_heracles_berserk")
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_heracles_berserk", {})
	if caster.IsEternalRageAcquired then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_eternal_rage", {})	
	end

	local soundQueue = math.random(1,100)

	if soundQueue <= 25 then		
		EmitGlobalSound("Heracles_Combo_Easter_" .. math.random (2,3))
	end

	local casterloc = caster:GetAbsOrigin()
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius4
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local finaldmg = 0
	for k,v in pairs(targets) do
		local dist = (v:GetAbsOrigin() - casterloc):Length2D() 
		if dist <= radius then
			finaldmg = damage
			v:AddNewModifier(caster, v, "modifier_stunned", { Duration = stun_duration })
		    --giveUnitDataDrivenModifier(caster, v, "stunned", 3.0)
			giveUnitDataDrivenModifier(caster, v, "rb_sealdisabled", stun_duration)
		elseif dist > radius and dist <= radius2 then
			finaldmg = damage2
			if not IsImmuneToSlow(v) then 
				ability:ApplyDataDrivenModifier(caster, v, "modifier_madmans_roar_slow_strong", {}) 
			end
		elseif dist > radius2 and dist <= radius3 then
			finaldmg = damage3
			if not IsImmuneToSlow(v) then 
				ability:ApplyDataDrivenModifier(caster, v, "modifier_madmans_roar_slow_moderate", {}) 
			end
		elseif dist > radius3 and dist <= radius4 then
			finaldmg = 0
			if not IsImmuneToSlow(v) then 
				ability:ApplyDataDrivenModifier(caster, v, "modifier_madmans_roar_slow_moderate", {}) 
			end
		end

	    DoDamage(caster, v, finaldmg , DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end
	ParticleManager:CreateParticle("particles/custom/screen_face_splash.vpcf", PATTACH_EYES_FOLLOW, caster)
	ScreenShake(caster:GetOrigin(), 30, 2.0, 5.0, 10000, 0, true)

end

QUsed = false
QTime = 0

function BerCheckCombo(caster, ability)
	if caster:GetStrength() >= 24.1 and caster:GetAgility() >= 24.1 and caster:GetIntellect() >= 24.1 then
		if ability == caster:FindAbilityByName("heracles_fissure_strike") then
			QUsed = true
			QTime = GameRules:GetGameTime()
			Timers:CreateTimer({
				endTime = 4,
				callback = function()
				QUsed = false
			end
			})
		else
			if caster.IsEternalRageAcquired and caster.IsMadEnhancementAcquired then 
				if ability == caster:FindAbilityByName("heracles_berserk_upgrade_3") and caster:FindAbilityByName("heracles_courage_upgrade"):IsCooldownReady() and caster:FindAbilityByName("heracles_madmans_roar_upgrade_3"):IsCooldownReady() and not caster:HasModifier("modifier_madmans_roar_cooldown") then
					if QUsed == true then 
						local newTime =  GameRules:GetGameTime()
						local duration = 4 - (newTime - QTime)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_heracles_madman_window", {duration = duration})
					end
				end
			elseif not caster.IsEternalRageAcquired and caster.IsMadEnhancementAcquired then 
				if ability == caster:FindAbilityByName("heracles_berserk_upgrade_2") and caster:FindAbilityByName("heracles_courage"):IsCooldownReady() and caster:FindAbilityByName("heracles_madmans_roar_upgrade_2"):IsCooldownReady() and not caster:HasModifier("modifier_madmans_roar_cooldown") then
					if QUsed == true then 
						local newTime =  GameRules:GetGameTime()
						local duration = 4 - (newTime - QTime)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_heracles_madman_window", {duration = duration})
					end
				end	
			elseif caster.IsEternalRageAcquired and not caster.IsMadEnhancementAcquired then 
				if ability == caster:FindAbilityByName("heracles_berserk_upgrade_1") and caster:FindAbilityByName("heracles_courage_upgrade"):IsCooldownReady() and caster:FindAbilityByName("heracles_madmans_roar_upgrade_1"):IsCooldownReady() and not caster:HasModifier("modifier_madmans_roar_cooldown") then
					if QUsed == true then 
						local newTime =  GameRules:GetGameTime()
						local duration = 4 - (newTime - QTime)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_heracles_madman_window", {duration = duration})
					end
				end
			elseif not caster.IsEternalRageAcquired and not caster.IsMadEnhancementAcquired then 
				if ability == caster:FindAbilityByName("heracles_berserk") and caster:FindAbilityByName("heracles_courage"):IsCooldownReady() and caster:FindAbilityByName("heracles_madmans_roar"):IsCooldownReady() and not caster:HasModifier("modifier_madmans_roar_cooldown") then
					if QUsed == true then 
						local newTime =  GameRules:GetGameTime()
						local duration = 4 - (newTime - QTime)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_heracles_madman_window", {duration = duration})
					end
				end
			end
		end
	end
end

function OnMadmanWindowCreate(keys)
	local caster = keys.caster 
	if caster.IsEternalRageAcquired and caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage_upgrade", "heracles_madmans_roar_upgrade_3", false, true)
	elseif not caster.IsEternalRageAcquired and caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage", "heracles_madmans_roar_upgrade_2", false, true)			
	elseif caster.IsEternalRageAcquired and not caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage_upgrade", "heracles_madmans_roar_upgrade_1", false, true)			
	elseif not caster.IsEternalRageAcquired and not caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage", "heracles_madmans_roar", false, true)
	end
end

function OnMadmanWindowDestroy(keys)
	local caster = keys.caster 
	if caster.IsEternalRageAcquired and caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage_upgrade", "heracles_madmans_roar_upgrade_3", true, false)
	elseif not caster.IsEternalRageAcquired and caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage", "heracles_madmans_roar_upgrade_2", true, false)			
	elseif caster.IsEternalRageAcquired and not caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage_upgrade", "heracles_madmans_roar_upgrade_1", true, false)			
	elseif not caster.IsEternalRageAcquired and not caster.IsMadEnhancementAcquired then
		caster:SwapAbilities("heracles_courage", "heracles_madmans_roar", true, false)
	end
end

function OnMadmanWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_heracles_madman_window")
end

function OnEternalRageAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	
	if hero:HasModifier("modifier_heracles_madman_window") then 
		hero:RemoveModifierByName("modifier_heracles_madman_window")
	end

	hero.IsEternalRageAcquired = true

	if hero.IsMadEnhancementAcquired then 
		hero:AddAbility("heracles_berserk_upgrade_3")
		hero:FindAbilityByName("heracles_berserk_upgrade_3"):SetLevel(hero:FindAbilityByName("heracles_berserk_upgrade_2"):GetLevel())
		hero:SwapAbilities("heracles_berserk_upgrade_3", "heracles_berserk_upgrade_2", true, false) 
		if not hero:FindAbilityByName("heracles_berserk_upgrade_2"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_berserk_upgrade_3"):StartCooldown(hero:FindAbilityByName("heracles_berserk_upgrade_2"):GetCooldownTimeRemaining())
		end
		hero:AddAbility("heracles_madmans_roar_upgrade_3")
		hero:FindAbilityByName("heracles_madmans_roar_upgrade_3"):SetLevel(1)
		if not hero:FindAbilityByName("heracles_madmans_roar_upgrade_2"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_madmans_roar_upgrade_3"):StartCooldown(hero:FindAbilityByName("heracles_madmans_roar_upgrade_2"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("heracles_berserk_upgrade_2")
		hero:RemoveAbility("heracles_madmans_roar_upgrade_2")
	else
		hero:AddAbility("heracles_berserk_upgrade_1")
		hero:FindAbilityByName("heracles_berserk_upgrade_1"):SetLevel(hero:FindAbilityByName("heracles_berserk"):GetLevel())
		hero:SwapAbilities("heracles_berserk_upgrade_1", "heracles_berserk", true, false) 
		if not hero:FindAbilityByName("heracles_berserk"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_berserk_upgrade_1"):StartCooldown(hero:FindAbilityByName("heracles_berserk"):GetCooldownTimeRemaining())
		end
		hero:AddAbility("heracles_madmans_roar_upgrade_1")
		hero:FindAbilityByName("heracles_madmans_roar_upgrade_1"):SetLevel(1)
		if not hero:FindAbilityByName("heracles_madmans_roar"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_madmans_roar_upgrade_1"):StartCooldown(hero:FindAbilityByName("heracles_madmans_roar"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("heracles_berserk")
		hero:RemoveAbility("heracles_madmans_roar")
	end

	hero:AddAbility("heracles_courage_upgrade")
	hero:FindAbilityByName("heracles_courage_upgrade"):SetLevel(hero:FindAbilityByName("heracles_courage"):GetLevel())
	hero:SwapAbilities("heracles_courage_upgrade", "heracles_courage", true, false) 
	if not hero:FindAbilityByName("heracles_courage"):IsCooldownReady() then 
		hero:FindAbilityByName("heracles_courage_upgrade"):StartCooldown(hero:FindAbilityByName("heracles_courage"):GetCooldownTimeRemaining())
	end

	hero:RemoveAbility("heracles_courage")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnGodHandAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	local ability = hero:FindAbilityByName("heracles_god_hand")
	ability:SetLevel(1)
	hero.IsGodHandAcquired = true
	hero.GodHandStock = 11
	ability:ApplyDataDrivenModifier(hero, hero, "modifier_god_hand_stock", {}) 
	hero:SetModifierStackCount("modifier_god_hand_stock", hero, 11)
	hero:SwapAbilities("heracles_god_hand", "fate_empty1", true, false) 
	hero.bIsGHReady = true

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnReincarnationAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsReincarnationAcquired = true
	hero:FindAbilityByName("heracles_reincarnation"):SetLevel(1)
	hero:SwapAbilities("heracles_reincarnation", "fate_empty8", true, false) 
	hero.ReincarnationDamageTaken = 0
	--UpdateGodhandProgress(hero)
	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnMadEnhancementAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if hero:HasModifier("modifier_heracles_madman_window") then 
		hero:RemoveModifierByName("modifier_heracles_madman_window")
	end

	hero.IsMadEnhancementAcquired = true

	if hero.IsEternalRageAcquired then 
		hero:AddAbility("heracles_berserk_upgrade_3")
		hero:FindAbilityByName("heracles_berserk_upgrade_3"):SetLevel(hero:FindAbilityByName("heracles_berserk_upgrade_1"):GetLevel())
		hero:SwapAbilities("heracles_berserk_upgrade_3", "heracles_berserk_upgrade_1", true, false) 
		if not hero:FindAbilityByName("heracles_berserk_upgrade_1"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_berserk_upgrade_3"):StartCooldown(hero:FindAbilityByName("heracles_berserk_upgrade_1"):GetCooldownTimeRemaining())
		end
		hero:AddAbility("heracles_madmans_roar_upgrade_3")
		hero:FindAbilityByName("heracles_madmans_roar_upgrade_3"):SetLevel(1)
		if not hero:FindAbilityByName("heracles_madmans_roar_upgrade_1"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_madmans_roar_upgrade_3"):StartCooldown(hero:FindAbilityByName("heracles_madmans_roar_upgrade_1"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("heracles_berserk_upgrade_1")
		hero:RemoveAbility("heracles_madmans_roar_upgrade_1")
	else
		hero:AddAbility("heracles_berserk_upgrade_2")
		hero:FindAbilityByName("heracles_berserk_upgrade_2"):SetLevel(hero:FindAbilityByName("heracles_berserk"):GetLevel())
		hero:SwapAbilities("heracles_berserk_upgrade_2", "heracles_berserk", true, false) 
		if not hero:FindAbilityByName("heracles_berserk"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_berserk_upgrade_2"):StartCooldown(hero:FindAbilityByName("heracles_berserk"):GetCooldownTimeRemaining())
		end
		hero:AddAbility("heracles_madmans_roar_upgrade_2")
		hero:FindAbilityByName("heracles_madmans_roar_upgrade_2"):SetLevel(1)
		if not hero:FindAbilityByName("heracles_madmans_roar"):IsCooldownReady() then 
			hero:FindAbilityByName("heracles_madmans_roar_upgrade_2"):StartCooldown(hero:FindAbilityByName("heracles_madmans_roar"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("heracles_berserk")
		hero:RemoveAbility("heracles_madmans_roar")
	end

	hero:AddAbility("heracles_nine_lives_upgrade")
	hero:FindAbilityByName("heracles_nine_lives_upgrade"):SetLevel(hero:FindAbilityByName("heracles_nine_lives"):GetLevel())
	hero:SwapAbilities("heracles_nine_lives_upgrade", "heracles_nine_lives", true, false) 
	if not hero:FindAbilityByName("heracles_nine_lives"):IsCooldownReady() then 
		hero:FindAbilityByName("heracles_nine_lives_upgrade"):StartCooldown(hero:FindAbilityByName("heracles_nine_lives"):GetCooldownTimeRemaining())
	end
	hero:RemoveAbility("heracles_nine_lives")
	
	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end



