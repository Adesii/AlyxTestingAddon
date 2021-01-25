weapons = {
    pistol = {maxlevel = false,level = 0,deathcount = 0,level1=5,level2=10,level3=15,level4=20},
    shot = {maxlevel = false,level = 0,deathcount = 0,level1=1,level2=2,level3=3,level4=4},
    smg = {maxlevel = false,level = 0,deathcount = 0,level1=5,level2=10,level3=15}
}
currentEquipped = "nothing"
function Activated()
    print("WeaponUpgradeSystem Found")
    initSystem()
end


function initSystem()
    require("UpgradeSystem.objectFinder")
    findObjects()
end

function weaponSwitched(item)
    weaponname=item["item"]
    if weaponname == "hlvr_weapon_shotgun"then
        currentEquipped = "shot"
    elseif weaponname == "hlvr_weapon_energygun" then
        currentEquipped = "pistol"
    elseif weaponname == "hlvr_weapon_rapidfire" then
        currentEquipped = "smg"
    else
        currentEquipped ="nothing"
    end
end


function update()
    updateText()
end



function updateText()
    if currentEquipped == "nothing" or weapons[currentEquipped]["maxlevel"] == true  then
        EntFireByHandle(self,text,"Disable")
    else
        text:SetMessage(tostring(weapons[currentEquipped]["deathcount"]).."/"..tostring(weapons[currentEquipped]["level"..tostring(weapons[currentEquipped]["level"]+1)]))
        EntFireByHandle(self,text,"Enable")
    end
    
end

function addDeathCount()
    if currentEquipped == "nothing" then
        print("killed with nothing.....")
    else
        print("killed with"..currentEquipped)
        weapons[currentEquipped]["deathcount"] =weapons[currentEquipped]["deathcount"] + 1
    end
    if weapons[currentEquipped]["deathcount"] >= weapons[currentEquipped]["level1"] then
        if weapons[currentEquipped]["level"] >= 1 then
            if weapons[currentEquipped]["deathcount"] >= weapons[currentEquipped]["level2"] then
                if weapons[currentEquipped]["level"] >= 2 then
                    if weapons[currentEquipped]["deathcount"] >= weapons[currentEquipped]["level3"] then
                        if weapons[currentEquipped]["level"] >= 3 then
                            
                            if not currentEquipped  =="smg" and weapons[currentEquipped]["deathcount"] >= weapons[currentEquipped]["level4"] then
                                if weapons[currentEquipped]["level"] >= 4 then
                                    weapons[currentEquipped]["maxlevel"] = true
                                else
                                    upgradeWeapon()
                                end
                            elseif currentEquipped  =="smg" then
                                weapons[currentEquipped]["maxlevel"] = true
                            end
                        else
                            upgradeWeapon()
                        end
                    end
                else
                    upgradeWeapon()
                end
            end

        else
            upgradeWeapon()
        end
    end
end

function upgradeWeapon()
    weapons[currentEquipped]["level"] = weapons[currentEquipped]["level"]+1
    print("upgraded:"..currentEquipped)
    print("using this equip:"..tostring(currentEquipped.."Equip"..tostring(weapons[currentEquipped]["level"])))
    print("using Handle:".."WS_"..currentEquipped.."Equip"..tostring(weapons[currentEquipped]["level"]))
    EntFireByHandle(self,Entities:FindByName(nil,"WS_"..currentEquipped.."Equip"..tostring(weapons[currentEquipped]["level"])),"EquipNow")
end
function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function ready()
    EntFireByHandle(selfScript,timer,"Enable")
    print(ListenToGameEvent("weapon_switch",weaponSwitched,self))
    HMDAvatar = playerE:GetHMDAvatar()
    LeftHand = HMDAvatar:GetVRHand(0)
    RightHand = HMDAvatar:GetVRHand(1)


    text:SetParent(RightHand,"flashlight")
    text:SetLocalOrigin(Vector(0,0,0))
    text:SetLocalAngles(-55,180,90)
end