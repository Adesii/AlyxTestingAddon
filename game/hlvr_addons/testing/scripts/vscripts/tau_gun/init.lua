function Activate()

    print("Tau Gun ready")
    init()
end

fireBullet = require("tau_gun.fire_bullet")
ropeParticle = "TauParticle"

chargeTime = 0
isCharging = false

isplayingOvercharging = false
isplayingSpinup = false

--what to multiply the Chargetime by to determine damage
DamageMultiplier = 10

isActivatedTau = true

cooldown = 0
function Precache(context)
    context:AddResource("particles/tau_trail.vpcf")
end
function init()

    findEntities()
    thisEntity:SetThink(thinkTau,"tuaThinker",0.5)

end

function findEntities()
    player = Entities:GetLocalPlayer()
    if player then
        HMDAvatar = player:GetHMDAvatar()
        LeftHand = HMDAvatar:GetVRHand(0)
        RightHand = HMDAvatar:GetVRHand(1)
        fireHoleAttachment = thisEntity:ScriptLookupAttachment("gunEnd")
        leftHandleAttachment = thisEntity:ScriptLookupAttachment("triggerLeft")

        spinThingFireBullet = thisEntity:ScriptLookupAttachment("spinAttachment")
        return true
    end
    return false
end

function activateTauGun()
    isActivatedTau = true
end
function deactivateTauGun()
    isActivatedTau = false
end
function thinkTau()
 if isActivatedTau then
    if findEntities() then
    if player and handsOnTrigger() and cooldown < 1  then
            if not isCharging() then
                isplayingSpinup = false
                StopSoundEvent("tau.spinup",thisEntity)
                isplayingOvercharging = false
                StopSoundEvent("tau.overcharging",thisEntity)
                -- here you can change the ChargeTimes and what type of shot is fired YOU need to change it in the chargeTau Function too if you want to adjust the Rumble effect
                if chargeTime>0.025 and chargeTime<1 then
                    fireTau("small")
                elseif chargeTime>1 and chargeTime< 3 then
                    fireTau("medium")
                elseif chargeTime>3 and chargeTime<10 then
                    fireTau("large")
                end
                chargeTime = 0
            else
                if chargeTime>6 and not isplayingOvercharging then
                    StartSoundEvent("tau.overcharging",thisEntity)
                    isplayingOvercharging = true
                end
                if chargeTime>10 then
                    selfDamage()
                end
                chargeTau()
            end
        else
            isplayingOvercharging = false
                StopSoundEvent("tau.overcharging",thisEntity)
                isplayingSpinup = false
                StopSoundEvent("tau.spinup",thisEntity)
            if cooldown>0.9 then
                cooldown = cooldown - (1*FrameTime())
            end
        end
end
end
    return FrameTime()
end
function selfDamage()
    StartSoundEvent("tau.exploded",thisEntity)
    cooldown = 4
end
function isCharging()
    if player:GetAnalogActionPositionForHand(1,1).x>0.8 then
       return true
    end
    return false
end
function chargeTau()
    chargeTime = chargeTime +(1*FrameTime())
    if chargeTime<1 then
        LeftHand:FireHapticPulse(0)
        RightHand:FireHapticPulse(0)

        fireBullet({
            position = thisEntity:GetAttachmentOrigin(spinThingFireBullet),
            direction = thisEntity:GetAttachmentForward(spinThingFireBullet),
            damage = 0,
            spread = 0,
            force = 25,
            muzzleEffectDisabled = true,
            tracerEffectDisabled = true,
            impactEffectDisabled = true,
            ignoreEntity = player
        })
    elseif chargeTime>1 and chargeTime< 3 then
        if not isplayingSpinup then
            StartSoundEvent("tau.spinup",thisEntity)
            isplayingSpinup = true
        end
        LeftHand:FireHapticPulse(1)
        RightHand:FireHapticPulse(1)
        fireBullet({
            position = thisEntity:GetAttachmentOrigin(spinThingFireBullet),
            direction = thisEntity:GetAttachmentForward(spinThingFireBullet),
            damage = 0,
            spread = 0,
            force = 45,
            muzzleEffectDisabled = true,
            tracerEffectDisabled = true,
            impactEffectDisabled = true,
            ignoreEntity = player
        })
    elseif chargeTime>3 and chargeTime<10 then
        LeftHand:FireHapticPulse(2)
        RightHand:FireHapticPulse(2)
        fireBullet({
            position = thisEntity:GetAttachmentOrigin(spinThingFireBullet),
            direction = thisEntity:GetAttachmentForward(spinThingFireBullet),
            damage = 0,
            spread = 0,
            force = 65,
            muzzleEffectDisabled = true,
            tracerEffectDisabled = true,
            impactEffectDisabled = true,
            ignoreEntity = player
        })
    end
end
function fireTau(type)
    tracetable = {
        startpos = thisEntity:GetAttachmentOrigin(fireHoleAttachment);
        endpos = thisEntity:TransformPointEntityToWorld(thisEntity:GetAttachmentForward(fireHoleAttachment)*10000);
        ignore = thisEntity;
    }
    TraceLine(tracetable)
    if tracetable.hit then
        if type == "small" then
            --debugoverlay:Line(tracetable.startpos,tracetable.pos,255,0,0,255,false,2)
            recursivveHit(chargeTime*DamageMultiplier,tracetable)
            StartSoundEvent("tau.singleShot",thisEntity)

        end
        if type == "medium" then
            --debugoverlay:Line(tracetable.startpos,tracetable.pos,0,255,0,255,false,2)
            recursivveHit(chargeTime*DamageMultiplier,tracetable)
            StartSoundEvent("tau.singleHeavyShot",thisEntity)

        end
        if type == "large" then
            --debugoverlay:Line(tracetable.startpos,tracetable.pos,0,0,255,255,false,2)
            recursivveHit(chargeTime*DamageMultiplier,tracetable)
            StartSoundEvent("tau.singleHeavyShot",thisEntity)

        end
    else    
        --debugoverlay:Line(tracetable.startpos,tracetable.endpos,255,255,255,255,false,2)
    end
end

function recursivveHit(dmg,tracetable)
    fireBullet({
        position = thisEntity:GetAttachmentOrigin(fireHoleAttachment),
        direction = thisEntity:GetAttachmentForward(fireHoleAttachment),
        damage = dmg,
        spread = 0,
        force = dmg*100,
        tracerEffect = "particles/tau_trail.vpcf",
        ignoreEntity = player,
        parentEntity = thisEntity,
        damagetype = 1024,
        impactEffectDisabled = true
    })
    tracetable.endpos = tracetable.pos+((thisEntity:GetAttachmentForward(fireHoleAttachment) - (2*(thisEntity:GetAttachmentForward(fireHoleAttachment):Dot(tracetable.normal:Normalized()))*tracetable.normal:Normalized()))*1000)
    tracetable.startpos = tracetable.pos
    --debugoverlay:Line(tracetable.startpos,tracetable.endpos,0,255,0,255,false,10)
    print(tracetable.enthit:GetClassname())
    TraceLine(tracetable)
    local degAng = tracetable.normal:Normalized():Dot(thisEntity:GetAttachmentForward(fireHoleAttachment):Normalized())
    degAng = Rad2Deg(math.acos(degAng))
    print(degAng)
    if tracetable.hit and degAng>45 then
        print( )
        local hitpos=fireBullet({
            position = tracetable.startpos,
            direction = tracetable.endpos:Normalized(),
            damage = dmg,
            spread = 0,
            force = dmg*10,
            ignoreEntity = player,
            parentEntity = thisEntity,
            tracerEffect = "particles/tau_trail.vpcf",
            damagetype = 1024,
            impactEffectDisabled = true
        })
        local endPos = tracetable.endpos:Normalized()
        tracetable.endpos = tracetable.pos+((tracetable.endpos:Normalized() - (2*(tracetable.endpos:Normalized():Dot(tracetable.normal:Normalized()))*tracetable.normal:Normalized()))*1000)
        tracetable.startpos = tracetable.pos
        tracetable.hit = false
        TraceLine(tracetable)
        degAng = tracetable.normal:Normalized():Dot(endPos)
        degAng = Rad2Deg(math.acos(degAng))
        if tracetable.hit and degAng>45 then
            fireBullet({
                position = hitpos.pos,
                direction = tracetable.endpos:Normalized(),
                damage = dmg,
                spread = 0,
                force = dmg,
                ignoreEntity = player,
                parentEntity = thisEntity,
                tracerEffect = "particles/tau_trail.vpcf",
                damagetype = 1024,
                impactEffectDisabled = true
            })
        end
    end

end
function handsOnTrigger()
    if VectorDistance(LeftHand:GetOrigin(),thisEntity:GetAttachmentOrigin(leftHandleAttachment))<5 then
        --debugoverlay:Sphere(LeftHand:GetOrigin(),0.25,0,255,0,255,false,0.25)
        return true
    end
    --debugoverlay:Sphere(LeftHand:GetOrigin(),0.25,255,0,0,255,false,0.25)
    return false
end