function Activated()
    print("finding mask")
    findEntity()
    maskfinder()
end

function findEntity()
    from=Entities:FindByName(nil,"fromTarget")
    to=Entities:FindByName(nil,"toTarget")
    ent1 = Entities:FindByName(nil,"ent1")
    player = Entities:FindByClassname(nil,"player")
    i = 1
    nonHitMasks = {}
    print_r(getmetatable(player))
end
function maskfinder()
        if from ~= nil then
                
                tracetable = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i
                }
                tracetable2 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i+1
                }
                tracetable3 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i+2
                }
                tracetable4 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i+3
                }
                tracetable5 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i-4
                }
                tracetable6 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i-1
                }
                tracetable7 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i-2
                }
                tracetable8 = {
                    startpos = from:GetAbsOrigin();
                    endpos = to:GetAbsOrigin();
                    ignore = ent1;
                    mask = i-3
                }
                TraceLine(tracetable)
                TraceLine(tracetable2)
                TraceLine(tracetable3)
                TraceLine(tracetable4)
                TraceLine(tracetable5)
                TraceLine(tracetable6)
                TraceLine(tracetable7)
                TraceLine(tracetable8)
                if tracetable.hit
                then
                    print(tostring(i))
                    print("hitSomething")
                    print(tracetable.enthit:GetClassname())
               else
                    print(i)
                    print("notHit")
                end
                if tracetable2.hit
                then
                    print(tracetable2.enthit:GetClassname())
               else
                    print(i+1)
                    print("notHit")
                end
                if tracetable3.hit
                then
               else
                    print(i+2)
                    print("notHit")
                end
                if tracetable4.hit
                then
               else
                    print(i+3)
                    print("notHit")
                end
                if tracetable5.hit
                then
               else
                    print(i)
                    print("notHit")
                end
                if tracetable6.hit
                then
               else
                    print(i)
                    print("notHit")
                end
                if tracetable7.hit
                then
               else
                    print(i)
                    print("notHit")
                end
                if tracetable8.hit
                then
                    
               else
                    print(i)
                    print("notHit")
                end
                i=i*2
        else
        findEntity()
        end
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