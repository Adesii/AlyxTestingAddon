function Activate()
    print("activating Vehicle")
    update()
end
wheelPositions= {Vector(50,100,0),Vector(50,-100,0),Vector(-50,100,0),Vector(-50,-100,0)}

function find_comps()
    wheels = Entities:FindAllByName("buggy_w*")
    body = Entities:FindByName(nil,"buggy")
    print_r(wheels)
    print_r(body)
end

function update()
    if body ==nil then
        find_comps()
        update()
    else
        thisEntity:SetThink(function () vehicleUpdater() return 0.05 end,"updater",0.1)
    end
end
function vehicleUpdater()
   
end

function setturn(completeamout,something,somethingg)
    print(completeamout,something,somethingg)
    normalisedValue = ((completeamout-0.5)*100)
    body:SetAngularVelocity(0,normalisedValue,0)
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