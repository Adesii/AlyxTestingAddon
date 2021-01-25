function findObjects()
    print("searching objects")
    playerE= Entities:GetLocalPlayer()
    selfScript = Entities:FindByName(nil,"WS_script")
    timer = Entities:FindByName(nil,"WS_UpdateTimer")
    text = Entities:FindByName(nil,"WS_LevelMeter")
--[[
    equips = {
        PistolEquip1 = Entities:FindByName(nil,"WS_pistolEquip1"),
        PistolEquip2 = Entities:FindByName(nil,"WS_pistolEquip2"),
        PistolEquip3 = Entities:FindByName(nil,"WS_pistolEquip3"),
        PistolEquip4 = Entities:FindByName(nil,"WS_pistolEquip4"),

        SMGEquip1 =Entities:FindByName(nil,"WS_smgEquip1"),
        SMGEquip2 =Entities:FindByName(nil,"WS_smgEquip2"),
        SMGEquip3 =Entities:FindByName(nil,"WS_smgEquip3"),

        ShotEquip1 = Entities:FindByName(nil,"WS_shotEquip1"),
        ShotEquip2 = Entities:FindByName(nil,"WS_shotEquip2"),
        ShotEquip3 = Entities:FindByName(nil,"WS_shotEquip3"),
        ShotEquip4 = Entities:FindByName(nil,"WS_shotEquip4")
    }
]]
    if playerE == nil or selfScript == nil then
    
    EntFireByHandle(selfScript,selfScript,"CallScriptFunction","findObjects",0.25)
    else
        print("ObjectsFound")
        EntFireByHandle(selfScript,selfScript,"CallScriptFunction","ready",0.25)
    end
end