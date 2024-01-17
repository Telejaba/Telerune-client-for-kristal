return {
    image = function (cutscene)
        local telejaba = cutscene:getCharacter("telejaba_lw")
        local kris = cutscene:getCharacter("kris_lw")
        local bluebold = cutscene:getCharacter("blueboldishead_lw")
        local door = cutscene:getEvent("halldoor")

        cutscene:text("* You already decided to go to OlegISS' room but...", nil, nil)
        cutscene:text("* (Knock, knock)", nil, nil)

        cutscene:showNametag("Telejaba", {top = true, right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* Who is that?", "neutral", "telejaba")
        cutscene:hideNametag()
        cutscene:wait(cutscene:walkTo(telejaba, 400, 230, 1))

        cutscene:showNametag("Telejaba", {right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* (Looks into peephole)\n* Who is there?", "confused", "telejaba")

        cutscene:showNametag("BlueBoldIsHead59", {right = false, color = {0.25, 0.5, 1, 1}})
        cutscene:text("* Hi, Telejaba, it's me.", "neutral", "blueboldishead")

        cutscene:showNametag("Telejaba", {right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* Holy shit, is it OrangeBoldIsHead34 the Walmart Bag??!?!11!?", "surprised", "telejaba")

        cutscene:showNametag("BlueBoldIsHead59", {right = false, color = {0.25, 0.5, 1, 1}})
        cutscene:text("* Nuh uh, it is BlueBoldIsHead59 the Toad.", "neutral", "blueboldishead")

        cutscene:showNametag("Telejaba", {right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* Shut up, who cares", "blyat", "telejaba")

        cutscene:hideNametag()
        cutscene:setSprite(door, "hall_door_open")
        cutscene:wait(0.5)
        -- fade the screen to black
        cutscene:wait(cutscene:fadeOut(0.25))
        cutscene:wait(cutscene:walkTo(telejaba, 421, 270, 0.45))
        cutscene:wait(cutscene:walkTo(telejaba, 420, 270, 0.1))
        cutscene:wait(cutscene:walkTo(bluebold, 359, 270, 0.1))
        cutscene:wait(cutscene:walkTo(bluebold, 360, 270, 0.1))
        cutscene:setSprite(door, "hall_door_closed")
        -- fade the screen back in
        cutscene:wait(cutscene:fadeIn(0.5))

        cutscene:showNametag("Telejaba", {right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* Hi Blue, long time no see.", "smile", "telejaba")

        cutscene:showNametag("BlueBoldIsHead59", {right = false, color = {0.25, 0.5, 1, 1}})
        cutscene:text("* Same thing Tele.", "smile", "blueboldishead")        
        cutscene:text("* ...", "smile", "blueboldishead")
        cutscene:text("* So what we are gonna do now?", "smile", "blueboldishead")
        
        cutscene:showNametag("Telejaba", {right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* Hmmm... How about telling why did you came here?", "confused", "telejaba")
        
        cutscene:showNametag("BlueBoldIsHead59", {right = false, color = {0.25, 0.5, 1, 1}})
        cutscene:text("* Oh yeah, bowser is bitchass motherfucker.", "smile", "blueboldishead")
        cutscene:text("* So im going to move living here.", "smile", "blueboldishead")

        cutscene:showNametag("Telejaba", {right = false, color = {1, 0.55, 0, 1}})
        cutscene:text("* Okay, we have one more bed in a closet iirc.", "smile", "telejaba")
        cutscene:text("* But before...", "smile", "telejaba")
        cutscene:text("* WE HAVE TO CELEBRATE IT WITH PICKLES!", "heisenburbur", "telejaba")

        cutscene:showNametag("BlueBoldIsHead59", {right = false, color = {0.25, 0.5, 1, 1}})
        cutscene:text("* LETS FUCKIN GOOO!!!!!", "smile", "blueboldishead")
        cutscene:hideNametag()
        cutscene:wait(cutscene:walkTo(bluebold, 400, 229, 0.3))
        cutscene:wait(cutscene:walkTo(bluebold, 400, 230, 0.1))
        cutscene:wait(cutscene:walkTo(telejaba, 400, 279, 0.3))
        cutscene:wait(cutscene:walkTo(telejaba, 400, 280, 0.1))
        bluebold:convertToFollower()
        Game:addPartyMember("bluebold")
        cutscene:alignFollowers("down")

        cutscene:hideNametag()
    end,
        bigshot = function (cutscene)
            local telejaba = cutscene:getCharacter("telejaba_lw")
            cutscene:text("* YOU, [Little Sponge]", nil, "spamtonneo")
            cutscene:text("* TELL ME WHERE THE [[FUCK]] ARE WE!1!!", nil, "spamtonneo")
            cutscene:text("* IF YOU WONT TElL THEN ILL SEND YOU TO [HEAVEN]!!!1!1!", nil, "spamtonneo")
            cutscene:text("* Anyways i wiLl hav3 m3rcy if you win me in [[FRIDAY NIGHT FARTIN]].", nil, "spamtonneo")
            Game.stage:addChild(GuitarHero(400, 80))
            cutscene:wait(140.0)
            Game.stage:removeChild(GuitarHero)
        end,
}
