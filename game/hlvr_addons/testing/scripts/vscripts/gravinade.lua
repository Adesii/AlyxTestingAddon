local gravRadius = 400
local flyingDirection = Vector(0, 0, 200)
local myEnts = {}
local Timer = 0.0
local maxTime = 10

local gravity = 21.075
local tickrate = 0.05

function Activate ()
    print("gravinades successfully loaded")
end


function TriggerGravinade()
    print('GRAV TIME')
    Detonate()
  if myEnts ~= nil or #myEnts > 0 then -- we have some entities lets make them all jump
    for i = 1 , #myEnts do
        Jump(myEnts[i])
    end 
    floater(myEnts)
  end
end

function floater(ents)
    print("floter")
    Timer = 0
    tickrate = 0.05
    thisEntity:SetThink(function() keepAfloat(ents) return tickrate end,"floatThink",0.53)
  end

function keepAfloat(ents)
    if Timer < maxTime then
      for key,value in pairs(ents)do 
        if type(value) ~= "[none]" or value ~=nil or value:GetModelName() ~=nil then
          try{
            function ()
              value:ApplyAbsVelocityImpulse(Vector(0,0,gravity))
            end,
            catch{
              function ()
                print("objectNotFound")
              end
            }
          }
        end
      end
      Timer = Timer + 0.25
    else
      tickrate = 0
    end
  end

function Jump (gravinade)
    gravinade:ApplyAbsVelocityImpulse(flyingDirection)
end


function Detonate ()
    print(tostring(thisEntity:GetAbsOrigin()))
    myEnts = Entities:FindAllByClassnameWithin("prop_physics" , thisEntity:GetAbsOrigin() , gravRadius)
    otherEnts = Entities:FindAllByClassnameWithin("prop_ragdoll", thisEntity:GetAbsOrigin(),gravRadius)
    vlua.extend(myEnts,otherEnts) 

end


function catch(what)
  return what[1]
end

function try(what)
  status, result = pcall(what[1])
  if not status then
     what[2](result)
  end
  return result
end