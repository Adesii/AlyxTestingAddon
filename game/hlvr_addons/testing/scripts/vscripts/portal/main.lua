function Activated()
    print("Welcome to Aperture Science")
    --findPortals()
    --update()
end


function update()
    if BluePortal == nil then
        findPortals()
        else
        adjustCamera()
        end
end

function findPortals()



BluePortal = Entities:FindByName(nil,"blueportal")
RedPortal = Entities:FindByName(nil,"redportal")

RedCamera = Entities:FindByName(nil,"redcamera")
BlueCamera = Entities:FindByName(nil,"bluecamera")

head = Entities:GetLocalPlayer()

adjustCamera()
end

function adjustCamera()
    
    local playeroffset = RedPortal:TransformPointWorldToEntity(head:EyePosition())
    --playeroffset.x = (playeroffset.x /4)+100
    local playerpos = BluePortal:TransformPointWorldToEntity(head:EyePosition())
    local playerPosWithoux = BluePortal:TransformPointEntityToWorld(Vector(0,playerpos.y,playerpos.z))
    playerpos = head:EyePosition()
    
    if playeroffset.x > 400 then
        playeroffset.x = 400
    end
    playeroffset.z = -(playeroffset.z-10)
    playeroffset.y = playeroffset.y/2
    camPos = RedPortal:TransformPointEntityToWorld(-playeroffset)
    
    RedCamera:SetOrigin(camPos)
    debugoverlay:Sphere(camPos,5,0,0,255,255,true,1)
    local c =VectorDistance(playerpos,Vector(BluePortal:GetOrigin().x,BluePortal:GetOrigin().y,head:EyePosition().z))
    
    debugoverlay:Line(playerpos,Vector(BluePortal:GetOrigin().x,BluePortal:GetOrigin().y,head:EyePosition().z),0,0,255,255,false,0.1)
    debugoverlay:Line(playerPosWithoux,Vector(BluePortal:GetOrigin().x,BluePortal:GetOrigin().y,head:EyePosition().z),0,0,255,255,false,0.1)
    local alpha = (playerPosWithoux.y)/c
    local angle = alpha--math.asin(alpha)

    print(alpha)
    --local angDiff = AngleDiff(BluePortal:GetAnglesAsVector().y,RedPortal:GetAnglesAsVector().y)+40
    --local newCamDirection = angDiff*head:GetForwardVector()
    --newAngle = newCamDirection--head:EyeAngles()
    RedCamera:SetLocalAngles(0,Rad2Deg(angle),-90)
    newFOV = Lerp(playeroffset.x/500,125,0)
    EntFireByHandle(nil,RedCamera,"changeFOV",""..newFOV)



end