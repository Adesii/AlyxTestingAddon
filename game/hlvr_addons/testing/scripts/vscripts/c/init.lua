local ffilib_hint = 666ULL
local ffilib = require("ffi")
 
local ffi_new = ffilib.new
local ffi_cast = ffilib.cast
local ffi_typeof = ffilib.typeof
local ffi_sizeof = ffilib.sizeof
local ffi_alignof = ffilib.alignof
local ffi_istype = ffilib.istype
local ffi_fill = ffilib.fill
local ffi_cdef = ffilib.cdef
local ffi_abi = ffilib.abi
local ffi_metatype = ffilib.metatype
local ffi_copy = ffilib.copy
local ffi_load = ffilib.load
local ffi_arch = ffilib.arch
local ffi_string = ffilib.string
local ffi_gc = ffilib.gc
local ffi_os = ffilib.os
local Cspace = ffilib.C
local ffi_offsetof = ffilib.offsetof
 
local libc = nil
if ffi_os == "Windows" then
    libc = ffi_load("msvcrt")
else
    libc = ffi_load("c")
 
end
ffi_cdef[[
typedef struct {float x; float y; float z;}vvector3_t;
 
typedef vvector3_t* vvecptr_t;
 
]]
 
 
local vvector3_t = ffi_typeof("vvector3_t")
local vvecptr_t = ffi_typeof("vvecptr_t")
function killplayer()
    local testvector = Vector(666.0, 200.0, 10.0)
    print_r(getmetatable(Cspace))
    local asffi = ffi_cast(vvecptr_t, testvector)
    Msg(tostring(asffi.z) .. "\n")
 
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