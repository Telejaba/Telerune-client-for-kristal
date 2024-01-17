local ChapterSelect, super = Class(Object)

function ChapterSelect:init(width, height)
	super.init(self, 0, 0, width, height)

    Input.clear("confirm")

    self.state = "SELECT" --SELECT, CONFIRM

    self.sc_scale_x = 1

    self.layer = 100
    self.alpha = 0
    self.screenshot = nil

    self.parallax_x = 0
	self.parallax_y = 0

    self.selected_index = 1
    self.selected_confirm = 1

    self.text_y = 30
    self.lines_y = 60
    self.icon_y = 24
    self.timer = 0

    self.can_click = true
    self.can_use = false

    self.heart = Sprite("player/heart")
    self.heart.visible = true
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(1, 1)
    self.heart:setColor(1, 0, 0)
    self.heart.layer = 100
    self.heart.alpha = 0
    self:addChild(self.heart)

    self.heart_target_x = 49
    self.heart_target_y = 47
    self.heart:setPosition(self.heart_target_x, self.heart_target_y)

    self.lines = {}

    self.font = Assets.getFont("main")

    self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.rectangle:setColor(0, 0, 0, 1)
	self:addChild(self.rectangle)

    self.chapters = {
        {
            chapter = "Chapter 1",
            title = "Beggining (Telejaba)",
            sound = "roland 169 ahh",
            modid = "telerune-1",
            locked = false,
        }, 
        {
            chapter = "Chapter 2",
            title = "Rookie",
            sound = "AUDIO_APPEARANCE",
            modid = "example",
            locked = true,
        },
        {
            chapter = "Chapter 3",
            title = "BlueBoldIsHead59",
            sound = "AUDIO_APPEARANCE",
            modid = "example",
            locked = true,
        },
        {
            chapter = "Chapter 4",
            title = "RRLLMM",
            sound = "AUDIO_APPEARANCE",
            modid = "example",
            locked = true,
        },
        {
            chapter = "Chapter 5",
            title = "OlegISS & Psych",
            sound = "AUDIO_APPEARANCE",
            modid = "example",
            locked = true,
        },
        {
            chapter = "Chapter 6",
            title = "poll dicide",
            sound = "AUDIO_APPEARANCE",
            modid = "example",
            locked = true,
        },
        {
            chapter = "Chapter 7",
            title = "Grand Final",
            sound = "AUDIO_APPEARANCE",
            modid = "example",
            locked = true,
        },
    }

    self.options = {
        {
            accept = "Play",
            refuse = "Do Not",
        },
    }
end

------// Functions for loading each Chapter //------

function ChapterSelect:loadChapter(index)
    Game.world.music:stop()
    Assets.playSound(self.chapters[index].sound)
    local screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
    self.screenshot = Sprite(screenshot, 0, 0)
    self.screenshot:setScaleOrigin(0.5, 0)
    self.screenshot.scale_x = 1
    self.screenshot.scale_y = 1
    self.screenshot:setOrigin(0, 0)
    self.screenshot.layer = 200
    self:addChild(self.screenshot)
    self:fadeTo(0, 0.1)
    Game.lock_movement = true
    self.rectangle2 = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.rectangle2:setColor(0, 0, 0, 1)
    self.rectangle2.layer = 100
    self:addChild(self.rectangle2)
    Game.world.timer:tween(1, self.screenshot, { scale_x = 0.1, scale_y = 0.7 })
    self.screenshot:fadeOutAndRemove()
    if index == 1 then
        self:loadChapter1()
    elseif index == 2 then
        self:loadChapter2(true)
    end
end

function ChapterSelect:loadChapter1()
    Game.chapter = 1
    Game.world.timer:after(2.25, function()
        if Mod:hasNoSaveFiles(self.chapters[self.selected_index].modid) then
            self:swapIntoMod(self.chapters[self.selected_index].modid, 1)
        else
            Game.world:startCutscene(function(cutscene)
                self.state = "CHAPTER1_CUTSCENE"
                self.can_click = true
                Game.legend = Game.stage:addChild(LegendHandler())
                Game.legend.layer = 500
                cutscene:wait(function() if Game.legend then return Game.legend:isOver() end end)
                self.can_click = false
                if Game.legend then Game.legend:remove() end
                self.state = "DELTARUNE_LOGO"
                Game.deltarune_logo = Game.stage:addChild(DELTARUNE())
                Game.deltarune_logo.layer = 1500
                cutscene:wait(function() if Game.deltarune_logo then return Game.deltarune_logo:isOver() end end)
                if Game.deltarune_logo and Game.deltarune_logo.skipped == false then
                    cutscene:wait(10)
                end
                Game.fader:fadeOut(self.returnToMenu, { speed = 1, music = 10 / 30 })
                Game.state = "EXIT"
            end)
        end
    end)
end

function ChapterSelect:loadChapter2(load_debug)
    Game.chapter = 2
    Game.world.timer:after(2.25, function()
        if Mod.debug and load_debug then
            self.can_use = false
            Assets.playSound("voice/sans")
            Game.lock_movement = false
            Game.DEBUG_MENU = DEBUG_MENU()
            Game.DEBUG_MENU.can_use = true
            Game.stage:addChild(Game.DEBUG_MENU)
        else
            Game.lock_movement = true
            if Mod:hasNoSaveFiles(self.chapters[self.selected_index].modid) then
                Game.world:startCutscene(function(cutscene)
                    self.state = "CHAPTER2_CUTSCENE"
                    self.can_click = false
                    cutscene:wait(3)
    
                    local logoparts = {}
                    local function createLogoPart(id)
                        if not id then return end
                        local part = Sprite("IMAGE_LOGO/IMAGE_LOGO_SEPARATE_" .. id, 320, 240 - 44)
                        part:setOrigin(0.5, 0.5)
                        part:setScale(2)
                        part:play(0.25, true)
                        part.layer = 500
                        self:addChild(part)
                        Assets.playSound("noise", 0.8, (0.5 + Utils.round(Utils.random(1), 0.2)))
                        table.insert(logoparts, part)
                    end
                    createLogoPart(0)
                    cutscene:wait(0.28)
                    createLogoPart(8)
                    cutscene:wait(0.28)
                    createLogoPart(1)
                    cutscene:wait(0.28)
                    createLogoPart(7)
                    cutscene:wait(0.28)
                    createLogoPart(2)
                    cutscene:wait(0.28)
                    createLogoPart(6)
                    cutscene:wait(0.28)
                    createLogoPart(3)
                    cutscene:wait(0.28)
                    createLogoPart(5)
                    cutscene:wait(0.28)
                    createLogoPart(4)
                    cutscene:wait(1.25)
                    Assets.playSound("snd_queen_laugh_title")
                    local part = Sprite("IMAGE_LOGO/IMAGE_LOGO_CHAPTERNUMBER_2", 320, (240 + 32 + 44) - 44)
                    part:setOrigin(0.5, 0.5)
                    part:setScale(2)
                    part:play(0.25, true)
                    part.layer = 500
                    self:addChild(part)
                    cutscene:wait(4)
                    Game.fader:fadeOut(self.returnToMenu, { speed = 0, music = 10 / 30 })
                    Game.state = "EXIT"
                end)
            else
                Game.world:startCutscene(function(cutscene)
                    self.state = "CHAPTER2_CUTSCENE"
                    self.can_click = true
                    cutscene:wait(1)
    
                    local queen = Sprite("intro/chapter_2/queen_wireframe_rotate", 320, -106)
                    queen:play(0.075, true)
                    queen.alpha = 0
                    queen:setOrigin(0.5, 0.5)
                    queen:setScale(2)
                    queen.layer = 500
                    Game.stage:addChild(queen)
                    Game.world.timer:tween(0.5, queen, { alpha = 1 })
                    Game.world.timer:tween(1, queen, { y = 240 }, 'out-elastic')                       --quint
                    cutscene:wait(0.89)
                    queen:stop()
                    queen:setFrame(4)
                    cutscene:wait(0.75)
                    Assets.playSound("snd_queen_bitcrushlaugh")
                    queen:set("intro/chapter_2/queen_wireframe_laugh")
                    queen:play(0.075, true)
                    cutscene:wait(1.75)
                    queen:set("intro/chapter_2/queen_wireframe_explode")
                    queen:play(0.075, true)
                    cutscene:wait(cutscene:playSound("snd_explosion_mmx3"))
                    Game.world.timer:tween(0.5, queen, { alpha = 0 })
                    cutscene:wait(1)
                    Game.fader:fadeOut(self.returnToMenu, { speed = 0, music = 10 / 30 })
                    Game.state = "EXIT"
                end)
            end
        end
    end)
end
----------------------------------------------------

function ChapterSelect:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    return 1, 1, 0, self.alpha
end

function ChapterSelect:drawRectangle(x, y, w, h)
    love.graphics.setColor(0.16862745098,0.16862745098,0.16862745098, self.alpha)
    love.graphics.rectangle("fill", 2, y - 1.35, SCREEN_WIDTH, h - 2)
end

function ChapterSelect:close()
    Game.world.menu = nil
    self:remove()
end

function ChapterSelect:draw()
    super:draw(self)

    -- Draw the lines
    self.lines = {
        self:drawRectangle(0, self.lines_y+(60*0), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*1), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*2), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*3), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*4), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*5), self.width, self.height),
    }

    for i = 1, (#self.chapters + 1) do
        love.graphics.setColor(1, 1, 1, self.alpha)
            
        if self.selected_index == i then
            love.graphics.setColor(self:getDrawColor())
        end
        --chapters
        if i <= #self.chapters then
            local icon = Assets.getTexture("chselect/ch"..i)
            if self.chapters[i].locked == true then
                love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
            end
            Draw.draw(icon, 547, self.icon_y+(60*(i-1)), 0, 2, 2)
            if self.chapters[i].locked == true then
                love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
            end
            love.graphics.print(self.chapters[i].chapter, 79, self.text_y+(60*(i-1)))
            if self.state == "SELECT" or self.state ~= "CHAPTER"..i and ((self.selected_index ~= i and self.selected_index)) then
                if self.chapters[i].locked == true then
                    love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
                end
                love.graphics.printf(self.chapters[i].title, -140, self.text_y+(60*(i-1)), 1000, "center", 0)
            elseif self.state == "CHAPTER"..i then
                love.graphics.setColor(1, 1, 1, self.alpha)
                if self.selected_confirm == 1 then
                    love.graphics.setColor(self:getDrawColor())
                end
                love.graphics.print(self.options[1].accept, 250, self.text_y+(60*(self.selected_index-1)))
                love.graphics.setColor(1, 1, 1, self.alpha)
                if self.selected_confirm == 2 then
                    love.graphics.setColor(self:getDrawColor())
                end
                love.graphics.print(self.options[1].refuse, 430, self.text_y+(60*(self.selected_index-1)))
            end
        end
        
        love.graphics.print("Quit", 298, self.text_y+(60*6.84))
        self.heart.alpha = self.alpha
    end
end

--- Exits the current mod and returns to the Kristal menu.
function ChapterSelect.returnToMenu()
    local modid = Mod:getCurrentModId()
    -- Go to empty state
    Gamestate.switch({})
    -- Clear the mod
    Kristal.clearModState()
    -- Reload mods and return to memu
    Kristal.loadAssets("", "mods", "", function ()
        love.window.setTitle(Kristal.getDesiredWindowTitle())
        local MENU = Kristal.States["MainMenu"]
        Gamestate.switch(MENU)
        MENU:setState("MODSELECT")
        local selected
        for i,v in pairs(MENU.mod_list.list.mods) do
            if v.id == modid then
                selected = v
            end
        end
        local mod = selected and selected.mod
        MENU.selected_mod = mod
        MENU.selected_mod_button = selected
        MENU.file_select.mod = mod
        MENU:setState("FILESELECT")
    end)

    Kristal.DebugSystem:refresh()
    -- End input if it's open
    if not Kristal.Console.is_open then
        TextInput.endInput()
    end
end

function ChapterSelect:swapIntoMod(mod_id, save_id, save_name, after)
    assert(Kristal.Mods.data[mod_id], "No mod \""..tostring(mod_id).."\"")
    Gamestate.switch({})
    Kristal.clearModState()
    Kristal.loadAssets("","mods","", function()
        Kristal.loadMod(mod_id, save_id, save_name, after)
    end)
    Gamestate.switch(Kristal.States["Game"])
end

function ChapterSelect:update()
    super.update(self)
    self.timer = self.timer+DTMULT
    self.text_y = Utils.ease(10, 30, self.timer/32, "out-cubic")
    self.lines_y = Utils.ease(82, 80, self.timer/32, "out-cubic")
    self.icon_y = Utils.ease(10, 24, self.timer/32, "out-cubic")

    if self.can_use then
        for i, chapter in ipairs(self.chapters) do
            if Input.pressed("confirm", false) then
                Input.clear("confirm")
                if self.state == "SELECT" then
                    if self.can_click == true then
                        if self.selected_index == 8 then
                            Assets.playSound("ui_cancel_small")
                            Game.world:closeMenu()
                        else
                            Assets.playSound("ui_select")
                            self.state = "CHAPTER"..self.selected_index
                        end
                        Game.world.timer:after(0.75, function()
                            self.can_click = true
                        end)
                    end
                elseif self.state == "CHAPTER"..self.selected_index then
                    if self.can_click == true then
                        if self.selected_confirm == 1 then
                            Assets.playSound("ui_select")
                            if self.selected_index == 1 then
                                self:loadChapter(1)
                            elseif self.selected_index == 2 then
                                self:loadChapter(2)
                            end
                        elseif self.selected_confirm == 2 then
                            Assets.playSound("ui_select")
                            self.selected_confirm = 1
                            self.state = "SELECT"
                            Game.world.timer:after(0.75, function()
                                self.can_click = true
                            end)
                        end
                    end
                elseif self.state == "CHAPTER1_CUTSCENE" then
                    if Game.legend then
                        self.can_click = false
                        local leg = Game.legend
                        Game.legend.music:fade(0)
                        Game.legend = nil
                        local rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                        rectangle:setColor(0, 0, 0, 1)
                        rectangle.layer = 1000
                        rectangle.alpha = 0
                        Game.stage:addChild(rectangle)
                        Game.world.timer:tween(0.5, rectangle, {alpha = 1})
                        Game.world.timer:after(0.75, function()
                            leg:remove()
                            self.can_click = true
                            self.state = "DELTARUNE_LOGO"
                            Game.deltarune_logo = Game.stage:addChild(DELTARUNE())
                            Game.deltarune_logo.layer = 1500
                            if Game.world.cutscene then Game.world.cutscene:endCutscene() end
                            Game.world:startCutscene(function(cutscene)
                                cutscene:wait(function() if Game.deltarune_logo then return Game.deltarune_logo:isOver() end end)
                                if Game.deltarune_logo and Game.deltarune_logo.skipped == false then
                                    cutscene:wait(10)
                                end
                                Game.fader:fadeOut(self.returnToMenu, {speed = 1, music = 10/30})
                                Game.state = "EXIT"
                            end)
                        end)
                    end
                elseif self.state == "DELTARUNE_LOGO" then
                    if Game.deltarune_logo then
                        local log = Game.deltarune_logo
                        Game.deltarune_logo.skipped = true
                        Game.deltarune_logo = nil
                        Game.world.timer:after(3.25, function()
                            log:remove()
                            Game.fader:fadeOut(self.returnToMenu, {speed = 1, music = 10/30})
                            Game.state = "EXIT"
                        end)
                    end
                end
                self.can_click = false
            end
        end
        if self.state == "SELECT" then
            --move up
            if Game.lock_movement == false then
                if Input.pressed("up", false) then
                    Assets.playSound("ui_move")
                    if self.selected_index > 1 then
                        self.selected_index = self.selected_index - 1
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                    end
                end
                --move down
                if Input.pressed("down", false) then
                    Assets.playSound("ui_move")
                    if self.selected_index < #self.chapters+1 then
                        self.selected_index = self.selected_index + 1
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                    end
                end
            end
        end
        for i = 1, (#self.chapters + 1) do
            if self.state == "CHAPTER"..i then
                --move left
                if Game.lock_movement == false then
                    if Input.pressed("left", true) then
                        Assets.playSound("ui_move")
                        self.selected_confirm = self.selected_confirm - 1
                    end
                    --move right
                    if Input.pressed("right", true) then
                        Assets.playSound("ui_move")
                        self.selected_confirm = self.selected_confirm + 1
                    end
                end
            end
            --soul positions
            if self.state == "SELECT" then
                if self.selected_index == i then
                    if i > #self.chapters then
                        self.heart:setPosition(274, 457)
                        self.heart:setColor(1, 0, 0)
                    else
                        self.heart:setPosition(self.heart_target_x, (17 + 60 * (i - 1))+self.text_y)
                        self.heart:setColor(1, 0, 0)
                    end
                end
            elseif self.state == "CHAPTER" .. i then
                if self.selected_confirm == 1 then
                    self.heart:setPosition(230, 47 + 60 * (self.selected_index - 1))
                    self.heart:setColor(1, 0, 0)
                end
                if self.selected_confirm == 2 then
                    self.heart:setPosition(410, 47 + 60 * (self.selected_index - 1))
                    self.heart:setColor(1, 0, 0)
                end
                if self.selected_confirm > 1 then
                    self.selected_confirm = 2
                end
                if self.selected_confirm < 2 then
                    self.selected_confirm = 1
                end
            end
        end
    end
end

function ChapterSelect:onAddToStage()
    if Game.world.music.current ~= Mod.selection_music then
        Game.world.music:play(Mod.selection_music)
    end
    self:fadeTo(1, 0.5)
end

return ChapterSelect