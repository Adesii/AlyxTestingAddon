local function RandomFloat(min, max)
	return min + (max - min) * math.random()
end

local identifier = UniqueString()
local identifierIndex = 0

--[[ table FireBullet(table options) - Fires a bullet, returns trace that was used
All effects must be precached, even if using default values
Options table, most are optional:
  Vector position             - Where the bullet fires from
  Vector direction            - Direction the bullet goes
  handle attackerEntity       - Entity that acts as the attacker of the bullet, usually the player or the character the bullet is fired by
  handle inflictorEntity      - Entity that acts as the inflictor of the bullet, usually the physical entity the bullet is fired from
  float damage                - How much damage the bullet does
  float force                 - How much damage force the bullet has, if a physics entity is hit by the bullet it will be pushed by this much force
  float spread                - How much bullet spread to randomly add                                                          - default: 0
  float range                 - Maximum distance the bullet can go                                                              - default: 99999
  handle ignoreEntity         - Entity the bullet can go through, usually the player or the character the bullet is fired by    - default: nil
  int damageType              - Damage type to use                                                                              - default: DMG_BULLET
  string muzzleCoreEffect     - Core effect to use for the bullet muzzle, make sure to precache the effect                      - default: "particles/weapon_fx/muzzleflash_pistol_core.vpcf"
  string muzzleEffect         - Effect to use for the bullet muzzle, make sure to precache the effect                           - default: "particles/weapon_fx/muzzleflash_pistol_small.vpcf"
  string tracerEffect         - Effect to use for the bullet tracer, make sure to precache the effect                           - default: "particles/tracer_fx/pistol_tracer.vpcf"
  handle parentEntity         - Entity to parent effects to                                                                     - default: nil
  int mask                    - Mask for the damage trace                                                                       - default: 4097
  int shatterglassLimit       - Max amount of func_shatterglass the bullet can shatter and go through                           - default: 20
  float effectRemoveDelay     - Delay in seconds before removing the effect entities                                            - default: 2
  bool muzzleEffectDisabled   - Disable the muzzle effect                                                                       - default: false
  bool tracerEffectDisabled   - Disable the tracer effect                                                                       - default: false
  bool impactEffectDisabled   - Disable the impact effect                                                                       - default: false
  float debugDrawLine         - If above 0, will draw a line of the bullet trace for that amount of seconds                     - default: 0
Exampe where bullets are fired from a prop_physics with a weapon model:
local FireBullet = require("fire_bullet")
local weaponProp = Entities:FindByName(nil, "weapon_prop")
local player = Entities:GetLocalPlayer()
FireBullet({
	--TransformPointEntityToWorld is used to get an offset position from the weaponProp
	position = weaponProp:TransformPointEntityToWorld(Vector(10, 0, 4)),
	direction = weaponProp:GetForwardVector(),
	attackerEntity = player,
	inflictorEntity = weaponProp,
	damage = 8,
	spread = 0.1,
	force = 600,
	ignoreEntity = player,
	parentEntity = weaponProp
})
]]
local function FireBullet(options)
	local direction = options.direction
	local spread = options.spread or 0
	local range = options.range or 99999
	local damageType = options.damageType or DMG_BULLET
	local muzzleCoreEffect = options.muzzleEffect or "particles/weapon_fx/muzzleflash_pistol_core.vpcf"
	local muzzleEffect = options.muzzleEffect or "particles/weapon_fx/muzzleflash_pistol_small.vpcf"
	local tracerEffect = options.tracerEffect or "particles/tracer_fx/pistol_tracer.vpcf"
	local mask = options.mask or 4096
	local shatterglassLimit = options.shatterglassLimit or 10
	local effectRemoveDelay = options.effectRemoveDelay or 2
	local muzzleCoreEffectDisabled = options.muzzleCoreEffectDisabled or false
	local muzzleEffectDisabled = options.muzzleEffectDisabled or false
	local tracerEffectDisabled = options.tracerEffectDisabled or false
	local impactEffectDisabled = options.impactEffectDisabled or false
	local debugDrawLine = options.debugDrawLine or 0
	
	identifierIndex = identifierIndex + 1
	--Prefix to be used for all entities created by this
	local prefix = identifierIndex .. identifier
	
	--Add spread
	if spread > 0 then
		local spreadX = RandomFloat(-spread, spread)
		local spreadYMax = math.sqrt((spread ^ 2) - (spreadX ^ 2))
		local spreadY =  RandomFloat(-spreadYMax, spreadYMax)
		local directionAngle = VectorToAngles(direction)
		
		direction = AnglesToVector(RotateOrientation(directionAngle, QAngle(spreadX, spreadY, directionAngle.z)))
	end
	
	local endPosition = options.position + (direction * range)
	
	--Trace used for effects
	local effectTrace = {
		startpos = options.position,
		endpos = endPosition,
		mask = 0,
		ignore = options.ignoreEntity
	}
	
	TraceLine(effectTrace)
	
	local directionAngle = VectorToAngles(direction)
	
	--info_target at end of the effectTrace
	local bulletEndTargetName = prefix .. "bullet_end_target"
	local bulletEndTarget = SpawnEntityFromTableSynchronous("info_target", {
		classname = "info_target",
		targetname = bulletEndTargetName,
		origin = effectTrace.pos,
		angles = VectorToAngles(effectTrace.normal)
	})
	
	EntFireByHandle(bulletEndTarget, bulletEndTarget, "Kill", "", effectRemoveDelay)
	
	if not muzzleCoreEffectDisabled then
		--muzzle_core_particle_system for muzzle core effect
		local muzzleCoreParticleSystem = SpawnEntityFromTableSynchronous("info_particle_system", {
			classname = "info_particle_system",
			targetname = prefix .. "muzzle_core_particle_system",
			origin = effectTrace.startpos,
			angles = directionAngle,
			effect_name = muzzleCoreEffect,
			start_active = 1
		})
		
		if options.parentEntity then
			muzzleCoreParticleSystem:SetParent(options.parentEntity, "")
		end
		
		EntFireByHandle(muzzleCoreParticleSystem, muzzleCoreParticleSystem, "Kill", "", effectRemoveDelay)
	end
	
	if not muzzleEffectDisabled then
		--info_particle_system for muzzle effect
		local muzzleParticleSystem = SpawnEntityFromTableSynchronous("info_particle_system", {
			classname = "info_particle_system",
			targetname = prefix .. "muzzle_particle_system",
			origin = effectTrace.startpos,
			angles = directionAngle,
			effect_name = muzzleEffect,
			start_active = 1
		})
		
		if options.parentEntity then
			muzzleParticleSystem:SetParent(options.parentEntity, "")
		end
		
		EntFireByHandle(muzzleParticleSystem, muzzleParticleSystem, "Kill", "", effectRemoveDelay)
	end
	
	if not tracerEffectDisabled then
		--info_particle_system for tracer effect
		local tracerParticleSystem = SpawnEntityFromTableSynchronous("info_particle_system", {
			classname = "info_particle_system",
			targetname = prefix .. "tracer_particle_system",
			origin = effectTrace.startpos,
			angles = directionAngle,
			effect_name = tracerEffect,
			start_active = 1,
			cpoint1 = bulletEndTargetName
		})
		
		EntFireByHandle(tracerParticleSystem, tracerParticleSystem, "Kill", "", effectRemoveDelay)
	end
	
	if not impactEffectDisabled and effectTrace.hit then
		--env_gunfire for impact effects, this is spawned at the end of effectTrace and the tracer effect from this is not used
		local bulletGunfire = SpawnEntityFromTableSynchronous("env_gunfire", {
			classname = "env_gunfire",
			targetname = prefix .. "bullet_gunfire",
			origin = effectTrace.pos - direction,
			angles = directionAngle,
			target = bulletEndTargetName,
			minburstsize = 1,
			maxburstsize = 1,
			minburstdelay = 1,
			maxburstdelay = 1,
			rateoffire = 0,
			spread = 0,
			bias = 1,
			collisions = 1,
			shootsound = "",
			tracertype = ""
		})
		
		EntFireByHandle(bulletGunfire, bulletGunfire, "Kill", "", 0.01)
	end
	
	local rangeLeft = 0
	local loops = 0
	local damageIgnoreEntity = options.ignoreEntity
	
	repeat
		local damageTrace = {
			startpos = options.position + direction * rangeLeft,
			endpos = endPosition,
			mask = mask,
			ignore = damageIgnoreEntity
		}
		
		TraceLine(damageTrace)
		
		if damageTrace.hit and damageTrace.enthit then
			--Deal damage
			local damageInfo = CreateDamageInfo(options.inflictorEntity, options.attackerEntity, direction * options.force, damageTrace.pos, options.damage, damageType)
			damageTrace.enthit:TakeDamage(damageInfo)
			DestroyDamageInfo(damageInfo)
			
			if debugDrawLine > 0 then
				DebugDrawCircle(damageTrace.startpos, Vector(255, 0, 0), 255, 1, false, debugDrawLine)
				DebugDrawCircle(damageTrace.pos, Vector(255, 0, 0), 255, 1, false, debugDrawLine)
			end
		end
		
		rangeLeft = rangeLeft + damageTrace.fraction * range
		loops = loops + 1
		damageIgnoreEntity = damageTrace.enthit
	--Keep looping if shatterglass_shard (func_shatterglass) is hit
	until (effectTrace.fraction * range) - rangeLeft <= 1 or (not damageTrace.hit and not damageTrace.enthit) or (damageTrace.enthit and damageTrace.enthit:GetClassname() ~= "shatterglass_shard") or loops >= shatterglassLimit
	
	if debugDrawLine > 0 then
		DebugDrawLine(effectTrace.startpos, effectTrace.pos, 255, 0, 0, false, debugDrawLine)
	end
	
	return effectTrace
end

return FireBullet
