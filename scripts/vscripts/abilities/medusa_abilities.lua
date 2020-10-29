
function MysticEyeCheck(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if IsFacingUnit(v, caster, 120) then
			if caster.IsMysticEyeImproved then
				ability:ApplyDataDrivenModifier(caster,v, "modifier_mystic_eye_enemy_upgrade", {})
			else
				ability:ApplyDataDrivenModifier(caster,v, "modifier_mystic_eye_enemy", {})
			end
		end
	end
end

function OnMonstrousStrengthProc(keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local proc_damage = ability:GetSpecialValueFor("proc_damage")
	if ability:IsCooldownReady() then
		if target:HasModifier("modifier_breaker_gorgon_stone") then
			proc_damage = ability:GetSpecialValueFor("proc_damage_2")
		end

		DoDamage(caster, target, proc_damage , DAMAGE_TYPE_PHYSICAL, 0, ability, false)
	end
end

function NailPull(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local radius = keys.Radius
	local drag = ability:GetSpecialValueFor("drag_duration")
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 1, false)
	RiderCheckCombo(caster, keys.ability)
	caster:EmitSound("Rider.NailSwing")
	
	-- Create Particle
	local pullFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_nail_swing.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pullFxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pullFxIndex, 1, Vector( radius, radius, radius ) )
	-- Destroy particle
	Timers:CreateTimer( 1.5, function()
			ParticleManager:DestroyParticle( pullFxIndex, false )
			ParticleManager:ReleaseParticleIndex( pullFxIndex )
		end
	)

	for k,v in pairs(targets) do
		if v:GetName() == "npc_dota_ward_base" then goto excludetarget end
		DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
		if not IsKnockbackImmune(v) then
			v:AddNewModifier(caster, v, "modifier_stunned", { Duration = 0.033 })
			giveUnitDataDrivenModifier(caster, v, "dragged", drag)
			
			local pullTarget = Physics:Unit(v)
			v:PreventDI()
			v:SetPhysicsFriction(0)
			v:SetPhysicsVelocity((caster:GetAbsOrigin() - v:GetAbsOrigin()):Normalized() * 1000)
			v:SetNavCollisionType(PHYSICS_NAV_NOTHING)
			v:FollowNavMesh(false)

			Timers:CreateTimer(0.5, function()
				v:PreventDI(false)
				v:SetPhysicsVelocity(Vector(0,0,0))
				v:OnPhysicsFrame(nil)
				FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
			end)

			v:OnPhysicsFrame(function(unit)
				local diff = caster:GetAbsOrigin() - unit:GetAbsOrigin()
				local dir = diff:Normalized()
				unit:SetPhysicsVelocity(unit:GetPhysicsVelocity():Length() * dir)
				if diff:Length() < 50 then
					unit:PreventDI(false)
					unit:SetPhysicsVelocity(Vector(0,0,0))
					unit:OnPhysicsFrame(nil)
				end
			end)
		end
		::excludetarget::
	end
end

function OnBGStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = keys.caster:GetPlayerOwner()
	local targetPoint = ability:GetCursorPosition()
	local radius = ability:GetSpecialValueFor("radius")
	local stone_rate = ability:GetSpecialValueFor("stone_rate")
	RiderCheckCombo(caster, ability)

	caster:EmitSound("Medusa_Skill1")
    local pcGlyph = ParticleManager:CreateParticle("particles/custom/rider/rider_breaker_gorgon_mark.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pcGlyph, 0, targetPoint) 
    ParticleManager:ReleaseParticleIndex(pcGlyph)

    if caster.IsSealAcquired then
        local pcLight = ParticleManager:CreateParticle("particles/custom/rider/rider_breaker_gorgon_mark_attr.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(pcLight, 0, targetPoint) 
        ParticleManager:ReleaseParticleIndex(pcLight)
    end

	local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if not IsImmuneToSlow(v) then 
			if caster.IsSealAcquired then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_breaker_gorgon_upgrade", {}) 
			else
				ability:ApplyDataDrivenModifier(caster, v, "modifier_breaker_gorgon", {}) 
			end
		end
		local random = RandomInt(1, 100)
		if not v:IsMagicImmune() then 
			if caster.IsSealAcquired and random <= stone_rate then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_breaker_gorgon_stone", {}) 
			end
		end
	end
end

-- Show particle on start
function OnBloodfortCast( keys )
	local sparkFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_charge.vpcf", PATTACH_ABSORIGIN, keys.caster )
	ParticleManager:SetParticleControl( sparkFxIndex, 0, keys.caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( sparkFxIndex, 1, keys.caster:GetAbsOrigin() )
	Timers:CreateTimer( 2.5, function()
		ParticleManager:DestroyParticle( sparkFxIndex, false )
		ParticleManager:ReleaseParticleIndex( sparkFxIndex )
	end)
end

function OnBloodfortStart(keys)
	local caster = keys.caster
	local initCasterPoint = caster:GetAbsOrigin() 
	local radius = keys.Radius
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local seal_interval = ability:GetSpecialValueFor("seal_interval")
	local bloodfortCount = 0
	caster:EmitSound("Medusa_Skill2") 

	local dummy = CreateUnitByName("dummy_unit", initCasterPoint, false, nil, nil, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_bloodfort_aura", {})
	--[[if caster.IsSealAcquired then 
		ability:ApplyDataDrivenModifier(caster, dummy, "modifier_bloodfort_seal_aura", {})
	end]]

	-- Create Particle
	local sphereFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_spirit.vpcf", PATTACH_CUSTOMORIGIN, dummy )
	ParticleManager:SetParticleControl( sphereFxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( sphereFxIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( sphereFxIndex, 6, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( sphereFxIndex, 10, Vector( radius, radius, radius ) )

	Timers:CreateTimer( duration, function()
		ParticleManager:DestroyParticle( sphereFxIndex, false )
		ParticleManager:ReleaseParticleIndex( sphereFxIndex )
		if IsValidEntity(dummy) then
			dummy:RemoveSelf()
		end
	end) 
end

function OnBloodfortSuck(keys)
	local caster = keys.caster
	local ability = keys.ability
	local center = keys.target
	if not caster:IsAlive() then return end
	--if target == nil then return end
	local damage = ability:GetSpecialValueFor("damage")
	local absorb = ability:GetSpecialValueFor("absorb")
	local mp_absorb = ability:GetSpecialValueFor("mp_absorb")
	local radius = ability:GetSpecialValueFor("radius")
	local targets = FindUnitsInRadius(caster:GetTeam(), center:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if v:GetName() ~= "npc_dota_ward_base" and not v:IsMagicImmune() then
			if not IsImmuneToSlow(v) then 
				ability:ApplyDataDrivenModifier(caster,v, "modifier_bloodfort_slow", {}) 
			end

			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			v:SpendMana(mp_absorb, nil)
			caster:ApplyHeal(absorb, caster)
			caster:SetMana(caster:GetMana() + mp_absorb)
			if caster.IsSealAcquired then 
				local forcemove = {
					UnitIndex = v:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
					Position = center:GetAbsOrigin()
				}
				ExecuteOrderFromTable(forcemove) 
				Timers:CreateTimer(0.1, function()
					v:Stop()
				end)
				ability:ApplyDataDrivenModifier(caster,v, "modifier_bloodfort_seal", {})
			end
		end
	end
end

function OnBloodfortSeal (keys)
	local caster = keys.caster
	local ability = keys.ability
	local center = keys.target
	local target = keys.unit 
	if not caster:IsAlive() then return end
	if target == nil then return end
	if target:GetName() ~= "npc_dota_ward_base" and not target:IsMagicImmune() then

		local forcemove = {
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
			Position = center:GetAbsOrigin()
		}
		ExecuteOrderFromTable(forcemove) 
		Timers:CreateTimer(0.1, function()
			target:Stop()
		end)
		ability:ApplyDataDrivenModifier(caster,v, "modifier_bloodfort_seal", {})
	end
end

function OnBloodfortDeath(keys)
	local caster = keys.caster 
	local target = keys.target 
	target:RemoveSelf()
end

function OnBelleStart(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local targetPoint = ability:GetCursorPosition()
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local origin = caster:GetAbsOrigin()
	local initialPosition = origin
	local ascendCount = 0
	local descendCount = 0
	if (origin - targetPoint):Length2D() > 2500 or not IsInSameRealm(origin, targetPoint) then 
		caster:SetMana(caster:GetMana() + ability:GetManaCost(ability:GetLevel()-1)) 
		ability:EndCooldown()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Target_Location")
		return
	end
	local dist = (origin - targetPoint):Length2D() 
	local dmgdelay = dist * 0.000416
	
	-- Attach particle
	local belleFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_1_alternate.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( belleFxIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true )
	ParticleManager:SetParticleControlEnt( belleFxIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true )
	Timers:CreateTimer(1.3 + dmgdelay, function()
		ParticleManager:DestroyParticle( belleFxIndex, false )
		ParticleManager:ReleaseParticleIndex( belleFxIndex )
	end)
	
	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 1.3)
	Timers:CreateTimer(0.5, function()
		EmitGlobalSound("Medusa_Bellerophon") 
	end)

	local descendVec = Vector(0,0,0)
	descendVec = (targetPoint - Vector(origin.x, origin.y, 1150)):Normalized()
	Timers:CreateTimer(function()
		if ascendCount == 23 then return end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,50))
		ascendCount = ascendCount + 1
		return 0.033
	end)


	Timers:CreateTimer(1.0, function()
		local origin = caster:GetAbsOrigin()
		if (origin - targetPoint):Length2D() > 2000 then return end
		if descendCount == 9 then return end

		caster:SetAbsOrigin(Vector(origin.x + descendVec.x * dist/6 ,
									origin.y + descendVec.y * dist/6,
									origin.z - 127))
		descendCount = descendCount + 1
		return 0.033
	end)

	-- this is when Rider makes a landing 
	Timers:CreateTimer(1.3, function() 
		local origin = caster:GetAbsOrigin()
		if (origin - targetPoint):Length2D() < 2000 then 
			-- set unit's final position first before checking if IsInSameRealm
			-- to allow Belle across river etc
			-- only if it is across realms do we try to adjust position
			caster:SetAbsOrigin(targetPoint)
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
			local currentPosition = caster:GetAbsOrigin()
			if not IsInSameRealm(currentPosition, initialPosition) then
				local diffVector = currentPosition - initialPosition
				local normalisedVector = diffVector:Normalized()
				local length = diffVector:Length2D()
				local newPosition = currentPosition
				while length >= 0
					and (not IsInSameRealm(currentPosition, initialPosition)
						or GridNav:IsBlocked(currentPosition)
						or not GridNav:IsTraversable(currentPosition)
					)
				do
					currentPosition = currentPosition - normalisedVector * 10
					length = length - 10
				end
				caster:SetAbsOrigin(currentPosition)
				FindClearSpaceForUnit(caster, currentPosition, true)
			end
		else
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		end
		caster:EmitSound("Misc.Crash")
		giveUnitDataDrivenModifier(caster, caster, "jump_pause_postlock", dmgdelay + 0.3)
	end)

	-- this is when the damage actually applies(Put slam effect here)
	Timers:CreateTimer(1.35, function()		
		-- Crete particle
		local belleImpactFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_1_impact.vpcf", PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( belleImpactFxIndex, 0, targetPoint)
		ParticleManager:SetParticleControl( belleImpactFxIndex, 1, Vector( radius, radius, radius ) )
		
		Timers:CreateTimer( 1, function()
			ParticleManager:DestroyParticle( belleImpactFxIndex, false )
			ParticleManager:ReleaseParticleIndex( belleImpactFxIndex )
		end)

		local targets1 = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for p,q in pairs(targets1) do
			if not q:HasModifier("modifier_belle_hit_check") then
				DoDamage(caster, q, damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
		    	q:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
		    	ability:ApplyDataDrivenModifier(caster, q, "modifier_belle_hit_check", {})
			end
	    end

		local damage_counter = 0

		Timers:CreateTimer(function()
            if damage_counter == 3 or not caster:IsAlive() then return end
            
			local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if not v:HasModifier("modifier_belle_hit_check") then
			    	DoDamage(caster, q, damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
			    	q:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
			    	ability:ApplyDataDrivenModifier(caster, q, "modifier_belle_hit_check", {})
				end
		    end
		    damage_counter = damage_counter + 1

            return 0.03
        end)

	    ScreenShake(caster:GetOrigin(), 7, 1.0, 2, 2000, 0, true)
	end)
end

-- Particle for starting to cast belle2
function OnBelle2Cast( keys )
	local caster = keys.caster
	local chargeFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_charge.vpcf", PATTACH_ABSORIGIN, caster )
	local eyeFxIndex = ParticleManager:CreateParticle( "particles/items_fx/dust_of_appearance_true_sight.vpcf", PATTACH_ABSORIGIN, caster )
	
	Timers:CreateTimer( 2.5, function()
			ParticleManager:DestroyParticle( chargeFxIndex, false )
			ParticleManager:DestroyParticle( eyeFxIndex, false )
			ParticleManager:ReleaseParticleIndex( chargeFxIndex )
			ParticleManager:ReleaseParticleIndex( eyeFxIndex )
		end
	)
end

function OnBelle2Start(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsSealAcquired then
		caster:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):StartCooldown(caster:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):GetCooldown(caster:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):GetLevel()))
	else
		caster:FindAbilityByName("medusa_bloodfort_andromeda"):StartCooldown(caster:FindAbilityByName("medusa_bloodfort_andromeda"):GetCooldown(caster:FindAbilityByName("medusa_bloodfort_andromeda"):GetLevel()))
	end

	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("medusa_bellerophon_2")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bellerophon_2_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	if caster:HasModifier("modifier_belle_2_window") then 
		caster:RemoveModifierByName("modifier_belle_2_window")
	end
	
	local belle2 = 
	{
		Ability = ability,
        EffectName = "",
        iMoveSpeed = 99999,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = keys.Range,
        fStartRadius = keys.Width,
        fEndRadius = keys.Width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        fExpireTime = GameRules:GetGameTime() + 1.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * 99999
	}
	ParticleManager:CreateParticle("particles/custom/screen_lightblue_splash.vpcf", PATTACH_EYES_FOLLOW, caster)
	EmitGlobalSound("medusa_bellerophon_alt") 
	local projectile = ProjectileManager:CreateLinearProjectile(belle2)
	
	-- Create Particle for projectile
	local belle2FxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_2_beam_charge.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( belle2FxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( belle2FxIndex, 1, Vector( keys.Width, keys.Width, keys.Width ) )
	ParticleManager:SetParticleControl( belle2FxIndex, 2, caster:GetForwardVector() * 5000 )
	ParticleManager:SetParticleControl( belle2FxIndex, 6, Vector( 2, 0, 0 ) )
			
	Timers:CreateTimer( 0.5, function()
		ParticleManager:DestroyParticle( belle2FxIndex, false )
		ParticleManager:ReleaseParticleIndex( belle2FxIndex )
	end)

	locationDelta = caster:GetForwardVector() * keys.Range
	newLocation = caster:GetAbsOrigin() + locationDelta
	for i=1, 20 do
		if GridNav:IsBlocked(newLocation) or not GridNav:IsTraversable(newLocation) then
			--locationDelta =  caster:GetForwardVector() * (keys.Range - 100)
			newLocation = caster:GetAbsOrigin() + caster:GetForwardVector() * (20 - i) * 100
			if not IsInSameRealm(caster:GetAbsOrigin(), newLocation) then
				newLocation.y = caster:GetAbsOrigin().y
			end
		else
			break
		end
	end 
	caster:SetAbsOrigin(newLocation) 
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function OnBelle2Hit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun = ability:GetSpecialValueFor("stun")
	local ply = caster:GetPlayerOwner()
	if caster.IsRidingAcquired then 
		local agi_ratio = ability:GetSpecialValueFor("agi_ratio")
		keys.Damage = keys.Damage + (caster:GetAgility() * agi_ratio)
	end 
	DoDamage(keys.caster, keys.target, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)

	target:AddNewModifier(caster, ability, "modifier_stunned", { Duration = stun })
end

nailUsed = false
nailTime = 0

function RiderCheckCombo(caster, ability)
	if caster:GetStrength() >= 24.1 and caster:GetAgility() >= 24.1 and caster:GetIntellect() >= 24.1 then
		if ability == caster:FindAbilityByName("medusa_nail_swing") then
			nailUsed = true
			nailTime = GameRules:GetGameTime()
			Timers:CreateTimer({
				endTime = 7,
				callback = function()
				nailUsed = false
			end
			})
		else
			if caster.IsSealAcquired then
				if caster.IsRidingAcquired then
					if ability == caster:FindAbilityByName("medusa_breaker_gorgon_upgrade") and caster:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):IsCooldownReady() and caster:FindAbilityByName("medusa_bellerophon_2_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_bellerophon_2_cooldown") then
						if nailUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - nailTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_belle_2_window", {duration = duration})
						end
					end
				else
					if ability == caster:FindAbilityByName("medusa_breaker_gorgon_upgrade") and caster:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):IsCooldownReady() and caster:FindAbilityByName("medusa_bellerophon_2"):IsCooldownReady() and not caster:HasModifier("modifier_bellerophon_2_cooldown") then
						if nailUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - nailTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_belle_2_window", {duration = duration})
						end
					end
				end
			else
				if caster.IsRidingAcquired then
					if ability == caster:FindAbilityByName("medusa_breaker_gorgon") and caster:FindAbilityByName("medusa_bloodfort_andromeda"):IsCooldownReady() and caster:FindAbilityByName("medusa_bellerophon_2_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_bellerophon_2_cooldown") then
						if nailUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - nailTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_belle_2_window", {duration = duration})
						end
					end
				else
					if ability == caster:FindAbilityByName("medusa_breaker_gorgon") and caster:FindAbilityByName("medusa_bloodfort_andromeda"):IsCooldownReady() and caster:FindAbilityByName("medusa_bellerophon_2"):IsCooldownReady() and not caster:HasModifier("modifier_bellerophon_2_cooldown") then
						if nailUsed == true then 
							local newTime =  GameRules:GetGameTime()
							local duration = 5 - (newTime - nailTime)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_belle_2_window", {duration = duration})
						end
					end
				end
			end
		end
	end
end

function OnBelle2WindowCreate(keys)
	local caster = keys.caster 
	if caster.IsSealAcquired and caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda_upgrade", "medusa_bellerophon_2_upgrade", false, true)
	elseif not caster.IsSealAcquired and caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda", "medusa_bellerophon_2_upgrade", false, true)			
	elseif caster.IsSealAcquired and not caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda_upgrade", "medusa_bellerophon_2", false, true)			
	elseif not caster.IsSealAcquired and not caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda", "medusa_bellerophon_2", false, true)
	end
end

function OnBelle2WindowDestroy(keys)
	local caster = keys.caster 
	if caster.IsSealAcquired and caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda_upgrade", "medusa_bellerophon_2_upgrade", true, false)
	elseif not caster.IsSealAcquired and caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda", "medusa_bellerophon_2_upgrade", true, false)			
	elseif caster.IsSealAcquired and not caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda_upgrade", "medusa_bellerophon_2", true, false)			
	elseif not caster.IsSealAcquired and not caster.IsRidingAcquired then
		caster:SwapAbilities("medusa_bloodfort_andromeda", "medusa_bellerophon_2", true, false)
	end
end

function OnBelle2WindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_belle_2_window")
end

function OnImproveMysticEyesAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsMysticEyeImproved = true

	hero:AddAbility("medusa_mystic_eye_upgrade")
	hero:FindAbilityByName("medusa_mystic_eye_upgrade"):SetLevel(1)
	hero:SwapAbilities("medusa_mystic_eye_upgrade", "medusa_mystic_eye", true, false) 

	hero:RemoveAbility("medusa_mystic_eye")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnRidingAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero:FindAbilityByName("medusa_riding_passive"):SetLevel(1)

	hero.IsRidingAcquired = true

	if hero:HasModifier("modifier_belle_2_window") then 
		hero:RemoveModifierByName("modifier_belle_2_window")
	end

	hero:AddAbility("medusa_bellerophon_upgrade")
	hero:FindAbilityByName("medusa_bellerophon_upgrade"):SetLevel(hero:FindAbilityByName("medusa_bellerophon"):GetLevel())
	hero:SwapAbilities("medusa_bellerophon_upgrade", "medusa_bellerophon", true, false) 
	if not hero:FindAbilityByName("medusa_bellerophon"):IsCooldownReady() then 
		hero:FindAbilityByName("medusa_bellerophon_upgrade"):StartCooldown(hero:FindAbilityByName("medusa_bellerophon"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("medusa_bellerophon_2_upgrade")
	hero:FindAbilityByName("medusa_bellerophon_2_upgrade"):SetLevel(hero:FindAbilityByName("medusa_bellerophon_2"):GetLevel())
	if not hero:FindAbilityByName("medusa_bellerophon_2"):IsCooldownReady() then 
		hero:FindAbilityByName("medusa_bellerophon_2_upgrade"):StartCooldown(hero:FindAbilityByName("medusa_bellerophon_2"):GetCooldownTimeRemaining())
	end

	hero:RemoveAbility("medusa_bellerophon_2")
	hero:RemoveAbility("medusa_bellerophon")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnSealAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsSealAcquired = true

	if hero:HasModifier("modifier_belle_2_window") then 
		hero:RemoveModifierByName("modifier_belle_2_window")
	end

	hero:AddAbility("medusa_breaker_gorgon_upgrade")
	hero:FindAbilityByName("medusa_breaker_gorgon_upgrade"):SetLevel(hero:FindAbilityByName("medusa_breaker_gorgon"):GetLevel())
	hero:SwapAbilities("medusa_breaker_gorgon_upgrade", "medusa_breaker_gorgon", true, false) 
	if not hero:FindAbilityByName("medusa_breaker_gorgon"):IsCooldownReady() then 
		hero:FindAbilityByName("medusa_breaker_gorgon_upgrade"):StartCooldown(hero:FindAbilityByName("medusa_breaker_gorgon"):GetCooldownTimeRemaining())
	end

	hero:AddAbility("medusa_bloodfort_andromeda_upgrade")
	hero:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):SetLevel(hero:FindAbilityByName("medusa_bloodfort_andromeda"):GetLevel())
	hero:SwapAbilities("medusa_bloodfort_andromeda_upgrade", "medusa_bloodfort_andromeda", true, false) 
	if not hero:FindAbilityByName("medusa_bloodfort_andromeda"):IsCooldownReady() then 
		hero:FindAbilityByName("medusa_bloodfort_andromeda_upgrade"):StartCooldown(hero:FindAbilityByName("medusa_bloodfort_andromeda"):GetCooldownTimeRemaining())
	end

	hero:RemoveAbility("medusa_breaker_gorgon")
	hero:RemoveAbility("medusa_bloodfort_andromeda")

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnMonstrousStrengthAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	hero:FindAbilityByName("medusa_monstrous_strength_passive"):SetLevel(1)
	hero:SwapAbilities("medusa_monstrous_strength_passive", "fate_empty1", true, false) 
	hero.IsMonstrousStrengthAcquired = true

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end
