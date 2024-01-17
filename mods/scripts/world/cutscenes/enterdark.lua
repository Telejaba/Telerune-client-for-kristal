return function(cutscene)

    local kris = cutscene:getCharacter("telejaba_lw")

    cutscene:detachCamera()
    cutscene:detachFollowers()

    cutscene:slideTo(kris,  1055 - 30, 280, 0.25)
    cutscene:panTo(1020, 245, 0.25)
    cutscene:wait(0.25)

    kris.visible = false

    local kris_x,  kris_y  = kris :localToScreenPos(0, 0)

    local transition = DarkTransition(280, {skiprunback = false})
    transition.layer = 99999

    transition.kris_x = kris_x / 2
    transition.kris_y = kris_y / 2

    transition.kris_only = true

    Game.world:addChild(transition)

    local waiting = true
    transition.end_callback = function()
        waiting = false
    end

    local wait_func = function() return not waiting end
    cutscene:wait(wait_func)

    local kx, ky = transition.kris_sprite:localToScreenPos(transition.kris_width / 2, 0)
    -- Hardcoded offsets for now...
    Game.world.player:setScreenPos(kx - 2, transition.final_y - 2)
    Game.world.player.visible = true
    Game.world.player:setFacing("down")

    cutscene:attachCamera()
    cutscene:attachFollowers()

    --Gamestate.switch(Kristal.States["DarkTransition"], "map", {
    --    kris_x  = kris_x/2,
    --    kris_y  = kris_y/2,
    --    susie_x = susie_x/2,
    --    susie_y = susie_y/2
    --})
end