function Activate()
    initJeff()
end
function initJeff()
    noiseGen = Entities:FindByName(nil,"YOUR NOISE ENTITY NAME HERE")
    _player = Entities:GetLocalPlayer()
    thisEntity:SetThink(searchPlayer(),"seeker",0)
end
function searchPlayer()
    tracetable = {
        startpos = thisEntity:GetAbsOrigin();
        endpos = _player:GetAbsOrigin();
        ignore = thisEntity;
    }
    TraceLine(tracetable)
    if tracetable.hit then
        EntFireByHandle(noiseGen, "NOISE Generation IO NAME HERE")
    end

    return 0.5
end