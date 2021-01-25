xscale = 500
yscale = 500
zscale = 500

amount = 3

function Activate()
    print("init Rendering System")
    initRenderer()
end


function initRenderer()
    require("utils.deepprint")
    
    _DeepPrintMetaTable(CDebugOverlayScriptHelper,"")
    initPos()
    generateEndpostion()
    DrawPlane()
    --drawSphereOutOfTris()
end

function initPos()
    for x = 0, amount do
        pos[x] = {}
        for y = 0, amount do
            pos[x][y] = {}
           for z = 0, amount do
            pos[x][y][z] =Vector(noise(x/3,y/3,z/3)*xscale,noise(x/30,y/6,z/2)*yscale,noise(x/24,y/8,z/45)*zscale)
           end
        end
    end
end
stuff = nil
pos = {}
lastpos = Vector(0,0,0)
function DrawPlane()
    DebugDrawClear()
    for x = 0, amount do
        for y = 0, amount do
           for z = 0, amount do
                if  pos[x][y][z] == nil or VectorDistance(pos[x][y][z],stuff[x][y][z]) < 50 then
                    print(VectorDistance(pos[x][y][z],stuff[x][y][z]))
                    generateNewPostion(x,y,z)
                end
                pos[x][y][z] = LerpVectors(pos[x][y][z],stuff[x][y][z],2*FrameTime())
                debugoverlay:Line(lastpos,pos[x][y][z],0,y*100,z*100,255,false,1)
                lastpos = pos[x][y][z]
                
            end
        end
    end
end
function generateNewPostion(x,y,z)
    time = Time()
    stuff[x][y][z]  = Vector(noise(math.random(10,200)+time,math.random(10,200)+time,math.random(10,200)+time)*xscale,noise(math.random(10,200)+time,math.random(10,200)+time,math.random(10,200)+time)*yscale,noise(math.random(10,200)+time,math.random(10,200)+time,math.random(10,200)+time)*zscale+500)
end
function generateEndpostion()
        endposition = {}
        for x = 0, amount do
            endposition[x] = {}
            for y = 0, amount do
                endposition[x][y] = {}
               for z = 0, amount do
                    time = Time()
                    endposition[x][y][z] = Vector(noise(math.random(10,200)+time,math.random(10,200)+time,math.random(10,200)+time)*xscale,noise(math.random(10,200)+time,math.random(10,200)+time,math.random(10,200)+time)*yscale,noise(math.random(10,200)+time,math.random(10,200)+time,math.random(10,200)+time)*zscale)
                    stuff = endposition
                end
            end
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

function noise(x, y, z) 
    local X = math.floor(x % 255)
    local Y = math.floor(y % 255)
    local Z = math.floor(z % 255)
    
    x = x - math.floor(x)
    y = y - math.floor(y)
    z = z - math.floor(z)
    local u = fade(x)
    local v = fade(y)
    local w = fade(z)
  
    A   = p[X  ]+Y
    AA  = p[A]+Z
    AB  = p[A+1]+Z
    B   = p[X+1]+Y
    BA  = p[B]+Z
    BB  = p[B+1]+Z
  
    return lerp(w, lerp(v, lerp(u, grad(p[AA  ], x  , y  , z   ), 
                                   grad(p[BA  ], x-1, y  , z   )), 
                           lerp(u, grad(p[AB  ], x  , y-1, z   ), 
                                   grad(p[BB  ], x-1, y-1, z   ))),
                   lerp(v, lerp(u, grad(p[AA+1], x  , y  , z-1 ),  
                                   grad(p[BA+1], x-1, y  , z-1 )),
                           lerp(u, grad(p[AB+1], x  , y-1, z-1 ),
                                   grad(p[BB+1], x-1, y-1, z-1 )))
    )
  end
  
  
  function fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
  end
  
  
  function lerp(t,a,b)
    return a + t * (b - a)
  end
  
  
  function grad(hash,x,y,z)
    local h = hash % 16
    local u 
    local v 
  
    if (h<8) then u = x else u = y end
    if (h<4) then v = y elseif (h==12 or h==14) then v=x else v=z end
    local r
  
    if ((h%2) == 0) then r=u else r=-u end
    if ((h%4) == 0) then r=r+v else r=r-v end
    return r
  end
  
  
  p = {}
  local permutation = {151,160,137,91,90,15,
    131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,10,200,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
  }
  
  for i=0,255 do
    p[i] = permutation[i+1]
    p[256+i] = permutation[i+1]
  end