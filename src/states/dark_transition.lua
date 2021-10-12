local darktransition = {}

darktransition.SPRITE_DEPENDENCIES = {
    "party/kris/world/light/up_*",
    "party/kris/dark_transition",
    "party/susie/world/light/up_*",
    "party/susie/dark_transition"
}

function darktransition:camerax() return 0 end
function darktransition:cameray() return 0 end

function darktransition:scr_dark_marker(...) return end -- TODO: stub
function darktransition:instance_create(...) return end -- TODO: stub

function darktransition:drawAnimStrip(sprite, subimg, x, y, alpha)
    love.graphics.setColor(1, 1, 1, alpha)

    --local index = #sprite > 1 and ((math.floor(subimg) % (#sprite)) + 1) or 1
    local index = math.floor(subimg) % (#sprite)

    love.graphics.draw(sprite[index + 1], x, y)
end

function darktransition:drawScaledSprite(sprite, x, y, xscale, yscale, rot, color, alpha)
    local color = utils.copy(color)
    color[4] = alpha
    love.graphics.setColor(color)
    love.graphics.draw(sprite, x, y, rot, xscale * 4, yscale * 4, sprite:getWidth()/2, sprite:getHeight()/2)
end

function darktransition:drawScissor(sprite, subimg, left, top, width, height, x, y)
    love.graphics.push()

    local scissor_x = ((math.floor(x) >= 0) and math.floor(x) or 0)
    local scissor_y = ((math.floor(y) >= 0) and math.floor(y) or 0)
    love.graphics.setScissor(scissor_x, scissor_y, math.floor(width), math.floor(height))

    local index = math.floor(subimg) % (#sprite)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(sprite[index + 1], x - left, y - top)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.pop()
end

function darktransition:enter(preview)
    self.prior_state = preview
    self.stage = Object()

    self.stage_scaled = Object()
    self.stage_scaled:setScale(2)
    self.stage:addChild(self.stage_scaled)

    self.darkzone = false
    self.plot = 9

    self.finaly = 60
    self.skiprunback = true

    self.depth = 100
    self.con = 8
    self.timer = 0
    self.index = 0
    self.sus_v = 0
    self.sus_f = 0
    self.kris_x = (134 + self:camerax())
    self.kris_y = (94  + self:cameray())
    self.sus_x  = (162 + self:camerax())
    self.sus_y  = (86  + self:cameray())
    self.sus_draw = 1
    self.sus_sprite = 0
    self.sus_index = 0
    self.kris_only = 0
    self.finaly = 140
    self.linecon = false
    self.linetimer = 0
    self.rect_draw = 0
    self.fake_screenshake = 0
    self.fake_shakeamount = 0
    self.rx1 = 138
    self.ry1 = 64
    self.rx2 = 182
    self.ry2 = 118
    self.quick_mode = true
    self.soundtimer = 0
    self.soundcon = 0
    self.linesfxtimer = 0
    self.nextroom = 69
    self.skiprunback = false
    self.megablack = false
    if (self.plot == 9) then
        self.nextroom = 70
    end

    -- ADDED BY ALLY:
    self.darkzone = false
    self.plot = 9

    -- CONFIG
    self.quick_mode = false
    self.skiprunback = true
    self.finaly = 120


    self.snd_dtrans_square = love.audio.newSource("assets/sounds/snd_dtrans_square.ogg", "static")

    self.spr_doorblack = kristal.assets.getTexture("kristal/doorblack")

    -- Sprite stuff
    self.use_sus_index = false

    self.kris_sprite_holder = Object(self.kris_x, self.kris_y)
    self.kris_sprite = Sprite(nil, 0, 0)
    self.kris_sprite_2 = Sprite(nil, 0, 0)
    self.kris_sprite_3 = Sprite(nil, 0, 0)

    self.sus_sprite_holder = Object(self.sus_x, self.sus_y)
    self.sus_sprite = Sprite(nil, 0, 0)
    self.sus_sprite_2 = Sprite(nil, 0, 0)
    self.sus_sprite_3 = Sprite(nil, 0, 0)

    self.kris_sprite.visible = false
    self.kris_sprite_2.visible = false
    self.kris_sprite_3.visible = false
    
    self.sus_sprite.visible = false
    self.sus_sprite_2.visible = false
    self.sus_sprite_3.visible = false

    self.kris_sprite_holder:addChild(self.kris_sprite)
    self.kris_sprite_holder:addChild(self.kris_sprite_2)
    self.kris_sprite_holder:addChild(self.kris_sprite_3)
    self.stage_scaled:addChild(self.kris_sprite_holder)

    self.sus_sprite_holder:addChild(self.sus_sprite)
    self.sus_sprite_holder:addChild(self.sus_sprite_2)
    self.sus_sprite_holder:addChild(self.sus_sprite_3)
    self.stage_scaled:addChild(self.sus_sprite_holder)

    self.spr_susieu = kristal.assets.getFrames("party/susie/world/light/up")
    self.spr_krisu = kristal.assets.getFrames("party/kris/world/light/up")

    self.spr_susie_lw_fall_u = kristal.assets.getFrames("party/susie/dark_transition/forward")
    self.spr_krisu_fall_lw = kristal.assets.getFrames("party/kris/dark_transition/forward")

    self.spr_susieu_run = kristal.assets.getFrames("party/susie/dark_transition/run")
    self.spr_krisu_run = kristal.assets.getFrames("party/kris/dark_transition/run")

    self.spr_susie_lw_fall_turn = kristal.assets.getFrames("party/susie/dark_transition/turn")
    self.spr_kris_fall_turnaround = kristal.assets.getFrames("party/kris/dark_transition/turn")

    self.spr_susie_lw_fall_d = kristal.assets.getFrames("party/susie/dark_transition/light")
    self.spr_kris_fall_d_lw = kristal.assets.getFrames("party/kris/dark_transition/light")

    self.spr_susie_dw_fall_d = kristal.assets.getFrames("party/susie/dark_transition/dark")
    self.spr_kris_fall_d_dw = kristal.assets.getFrames("party/kris/dark_transition/dark")

    self.spr_susie_white_fall_d = kristal.assets.getFrames("party/susie/dark_transition/white")
    self.spr_kris_fall_d_white = kristal.assets.getFrames("party/kris/dark_transition/white")

    self.spr_susie_dw_fall_smear = kristal.assets.getFrames("party/susie/dark_transition/smear")
    self.spr_kris_fall_smear = kristal.assets.getFrames("party/kris/dark_transition/smear")

    self.spr_susie_dw_fall_ball = kristal.assets.getFrames("party/susie/dark_transition/ball")
    self.spr_kris_fall_ball = kristal.assets.getFrames("party/kris/dark_transition/ball")

    self.spr_susie_dw_landed = kristal.assets.getFrames("party/susie/dark_transition/landed")
    self.spr_kris_dw_landed = kristal.assets.getFrames("party/kris/dark_transition/landed")

    self.canvas = love.graphics.newCanvas(320,240)
    -- No filtering
    self.canvas:setFilter("nearest", "nearest")

    -- Some nice hacks for deltatime support, since toby is very weird with cutscenes.
    self.do_once = false
    self.do_once2 = false
    self.do_once3 = false
    self.do_once4 = false
    self.do_once5 = false
    self.do_once6 = false
    self.do_once7 = false
    self.do_once8 = false
    self.do_once9 = false
    self.do_once10 = false
    self.do_once11 = false
    self.do_once12 = false

    self.drone_get_louder = false
    self.dronesfx_volume = 0

    self.dz = 1
end

function darktransition:update(dt)
    if self.con < 18 then
        self.prior_state:update(dt) -- Update the last state we were in
    end
    self.stage:update(dt)

    -- Process audio fading
    if self.drone_get_louder then
        self.dronesfx_volume = self.dronesfx_volume + (dt / 4)
        if self.dronesfx_volume > 0.5 then
            self.dronesfx_volume = 0.5
            self.drone_get_louder = false
        end
        self.dronesfx:setVolume(self.dronesfx_volume)
    end
    if self.soundcon == 4 then
        -- self.dronesfx needs to fade out from 0.5 to 0, taking 1 second
        if self.dronesfx_volume < 0 then
            self.dronesfx:stop()
        else
            self.dronesfx_volume = self.dronesfx_volume - (dt / 2)
            self.dronesfx:setVolume(self.dronesfx_volume)
        end
    end

    if self.linecon then
        self.linetimer = self.linetimer + 1 * (dt * 30)
        if (self.linetimer >= 1) then
            local xrand  = math.random() * (math.pi / 2)
            local xrand2 = math.random() * (math.pi / 2)
            --instance_create(((70 -  (math.sin(xrand)  * 70)) + self:camerax()), (-10 + self:cameray()), obj_dw_transition_line)
            --instance_create(((250 + (math.sin(xrand2) * 70)) + self:camerax()), (-16 + self:cameray()), obj_dw_transition_line)

            local x =  (( 70 - (math.sin(xrand)  * 70)) + self:camerax())
            local x2 = ((250 + (math.sin(xrand2) * 70)) + self:camerax())

            self.stage_scaled:addChild(DarkTransitionLine(x))
            self.stage_scaled:addChild(DarkTransitionLine(x2))

            self.linetimer = 0
        end
        self.linesfxtimer = self.linesfxtimer + (1 * (dt * 30))
        if (self.linesfxtimer >= 4) then
            self.linesfxtimer = 0

            local sidenoise = love.audio.newSource("assets/sounds/snd_dtrans_twinkle.ogg", "static")
            sidenoise:setPitch(0.6 + (math.random() * 0.6))
            sidenoise:setVolume(0.3)
            sidenoise:play()

        end
    end
    if (self.sus_f ~= 0) then
        if (self.sus_v > 0) then
            self.sus_v = self.sus_v - self.sus_f * (dt * 30)
            if (self.sus_v < 0) then
                self.sus_v = 0
            end
        end
        if (self.sus_v < 0) then
            self.sus_v = self.sus_v + self.sus_f * (dt * 30)
            if (self.sus_v > 0) then
                self.sus_v = 0
            end
        end
    end
    if (self.sus_v ~= 0) then
        self.sus_y = self.sus_y + self.sus_v * (dt * 30)
        self.kris_y = self.kris_y + self.sus_v * (dt * 30)
    end
    if (self.fake_screenshake == 1) then
        if (self.fake_shakeamount ~= 0) then
            if (self.fake_shakeamount > 0) then
                self.fake_shakeamount = self.fake_shakeamount - 1 * (dt * 30)
            end
            if (self.fake_shakeamount < 0) then
                self.fake_shakeamount = self.fake_shakeamount + 1 * (dt * 30)
            end
            if (math.floor(self.timer % (1 * dt * 30)) == 0) then
                self.fake_shakeamount = self.fake_shakeamount * -1
            end
            -- because of deltatime multiplying messing up some calcs, we have to do this:
            if (self.fake_shakeamount > -0.1) and (self.fake_shakeamount < 0.1) then
                self.fake_shakeamount = 0
            end
        else
            self.fake_screenshake = 0
        end
    end
end

function darktransition:draw()
    love.graphics.clear()
    if self.con < 18 then
        self.prior_state:draw() -- Draw the last state we were in
    end

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    if self.megablack then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        love.graphics.setColor(1, 1, 1)
    end

    self.index = self.index + 1 * (DT * 30)
    if (self.rect_draw == 1) then
        self.rs = self.rs + 1 * (DT * 30)
        for i = 1, self.rect_amount do
            self.rsize[i] = self.rsize[i] + (0.25 * (DT * 30))
            if (self.quick_mode) then
                self.rsize[i] = self.rsize[i] + (0.25 * (DT * 30))
            end
            if (self.rsize[i] > 0) then
                self.r_darkest = (5 - (self.rsize[i] * 0.8))
                if (self.rs < 20) then
                    self.r_darkest = self.r_darkest * (self.rs / 20)
                end
                if (self.r_darkest < 0) then
                    self.r_darkest = 0
                end
                if (self.r_darkest > 1) then
                    self.r_darkest = 1
                end
                --self.r_color = merge_color(c_black, c_white, self.r_darkest)
                self.r_color = {self.r_darkest, self.r_darkest, self.r_darkest, 1}

                --self:drawAnimStrip(self.spr_doorblack, 0, (self.rx + self:camerax()), (self.ry + self:cameray()), (self.rw * self.rsize[i]), (self.rh * self.rsize[i]), self.rsize[i], self.r_color, 1)

                self:drawScaledSprite(self.spr_doorblack, (self.rx + self:camerax()), (self.ry + self:cameray()), (self.rw * self.rsize[i]), (self.rh * self.rsize[i]), -math.rad(self.rsize[i]), self.r_color, 1)
            end
        end
    end
    if (self.con == 8) then
        --mus_volume(global.currentsong[1], 0, 30)
        --with (obj_mainchara)
        --    cutscene = true
        --with (obj_kris_headobj)
        --{
        --    follow = 0
        --    depth = (obj_dw_transition.depth - 10)
        --end

        -- sprite code --
        self.use_sus_index = true
        self.kris_sprite.visible = true
        self.sus_sprite.visible = true
        self.kris_sprite:setAnimation(self.spr_krisu)
        self.sus_sprite:setAnimation(self.spr_susieu)
        -----------------

        self.sus_draw = 1
        --self.sus_sprite = self.spr_susieu
        self.sus_index = 0
        --self.kris_sprite = self.spr_krisu
        self.kris_index = 0
        self.sus_v = 1.2
        if (self.quick_mode) then
            self.sus_v = 2
        end
        self.timer = 0
        self.con = 9
        self.doorblack = 0
    end
    if (self.con == 9) then
        self.timer = self.timer + 1 * (DT * 30)
        if (self.quick_mode or self.skiprunback) then
            if (self.timer < 40) then
                --snd_free_all()
                if (not self.skiprunback) then
                    --snd_play(snd_locker)
                    local sound = love.audio.newSource("assets/sounds/snd_locker.wav", "static")
                    sound:play()

                    self.doorblack = 1
                end
                self.sus_v = 6
                self.sus_f = 0.4
                self.timer = 45
                self.do_once = true -- skip it !!!!
                self.kris_x = self.kris_x - 4 * (DT * 30)
                --self.sus_sprite = self.spr_susieu_run
                --self.kris_sprite = self.spr_krisu_run

                -- sprite code --
                self.kris_sprite:setAnimation(self.spr_krisu_run)
                self.sus_sprite:setAnimation(self.spr_susieu_run)
                -----------------
            end
        end
        if (self.timer < 30) then
            self.sus_index = self.sus_index + 0.2 * (DT * 30)
        end
        if (math.floor(self.timer) >= 30) and not self.do_once then

            --snd_free_all()
            self.do_once = true
            local sound = love.audio.newSource("assets/sounds/snd_locker.wav", "static")
            sound:play()
            --with (obj_darkdoor)
            --    instance_destroy()
            self.doorblack = 1
            self.sus_index = 0
            self.sus_v = 0
            self.kris_x = self.kris_x - 4 * (DT * 30)
            --self.sus_sprite = self.spr_susieu_run
            --self.kris_sprite = self.spr_krisu_run

            -- sprite code --
            self.kris_sprite:setAnimation(self.spr_krisu_run)
            self.sus_sprite:setAnimation(self.spr_susieu_run)
            -----------------
        end
        if (math.floor(self.timer) >= 60) and not self.do_once2 then
            self.do_once2 = true
            --self.sus_sprite = self.spr_susieu_run
            --self.kris_sprite = self.spr_krisu_run
            self.sus_v = -5
            self.sus_f = 0

            -- sprite code --
            self.kris_sprite:setAnimation(self.spr_krisu_run)
            self.sus_sprite:setAnimation(self.spr_susieu_run)
            -----------------
        end
        if (self.timer > 60 and self.timer < 68) then
            self.kris_y = self.kris_y - 1 * (DT * 30)
            self.sus_index = self.sus_index + 0.25 * (DT * 30)
        end
        if (math.floor(self.timer) >= 68) and not self.do_once3 then
            self.do_once3 = true
            self.sus_f = 0.15
            self.sus_v = -4
            self.sus_y = self.sus_y - 2 * (DT * 30)
            self.sus_x = self.sus_x - 2 * (DT * 30)
            --self.sus_sprite = self.spr_susie_lw_fall_u
            --self.kris_sprite = self.spr_krisu_fall_lw
            self.con = 15
            self.soundtimer = 0

            -- sprite code --
            self.kris_sprite:setAnimation(self.spr_krisu_fall_lw)
            self.sus_sprite:setAnimation(self.spr_susie_lw_fall_u)
            -----------------
        end
        if (self.doorblack == 1) then
            love.graphics.setColor(0, 0, 0, 1)
            local x1 = (self.rx1 + self:camerax())
            local y1 = (self.ry1 + self:cameray())
            local x2 = (self.rx2 + self:camerax())
            local y2 = (self.ry2 + self:cameray())
            local w = x2 - x1
            local h = y2 - y1
            love.graphics.rectangle("fill", x1, y1, w, h)
            --self:draw_rectangle((self.rx1 + self:camerax()), (self.ry1 + self:cameray()), (self.rx2 + self:camerax()), (self.ry2 + self:cameray()), false)
        end
    end
    if (self.con == 15) then
        self.rs = 0
        self.rh = ((self.ry2 - self.ry1) / 100)
        self.rw = ((self.rx2 - self.rx1) / 100)
        self.rx = ((self.rx1 + self.rx2) / 2)
        self.ry = ((self.ry1 + self.ry2) / 2)
        self.rsize = {}
        for i = 1, 8 do
            self.rsize[i] = (1 + ((i - 1) * -2))
        end
        self.rect_amount = 6
        self.rect_draw = 1
        self.timer = 0
        if (self.quick_mode) then
            self.rect_amount = 3
        end
        self.con = 16
        self.soundtimer = 3
        self.rectsound = 0
    end
    if (self.con == 16) then
        self.soundthreshold = 6
        if (self.quick_mode) then
            self.soundthreshold = 3
        end
        self.soundtimer = self.soundtimer + 1 * (DT * 30)
        if ((self.soundtimer >= self.soundthreshold) and (self.rectsound < self.rect_amount)) then
            self.soundtimer = 0
            self.snd_dtrans_square:stop()
            self.snd_dtrans_square:setVolume(0.5)
            self.snd_dtrans_square:play()
            self.rectsound = self.rectsound + 1
        end
        self.sus_index = self.sus_index + 0.25 * (DT * 30)
        if (self.sus_v >= 0) then
            self.sus_f = 0
            self.sus_v = self.sus_v + 0.005 * (DT * 30)
        end
        self.timer = self.timer + 1 * (DT * 30)
        self.threshold = 80
        if (self.quick_mode) then
            self.threshold = 30
        end
        if (self.timer >= self.threshold) then
            self.timer = 0
            self.con = 17
            self.sus_index = 0
        end
    end
    if (self.con == 17) then
        --__background_set((0 << 0), 0, c_black)
        self.draw_rect = 0
        self.linecon = true
        self.sus_x_current = self.sus_x
        self.kris_x_current = self.kris_x
        --self.sus_sprite = self.spr_susie_lw_fall_turn
        --self.kris_sprite = self.spr_kris_fall_turnaround
        self.con = 18
        self.soundcon = 1
        self.radius = 60
        
        -- sprite code --
        self.kris_sprite:setAnimation(self.spr_kris_fall_turnaround)
        self.sus_sprite:setAnimation(self.spr_susie_lw_fall_turn)
        -----------------
    end
    if (self.soundcon == 1) then
        self.dronesfx = love.audio.newSource("assets/sounds/snd_dtrans_drone.ogg", "stream")
        --snd_volume(self.dronesfx, 0, 0)
        self.dronesfx:setVolume(0)
        --self.dronesfx_volume = 0.5

        self.drone_get_louder = true

        -- Volume starts at 0 and goes to 0.5 over 60 deltarune frames (2 seconds)
        -- This is handled at the top of update

        --snd_volume(self.dronesfx, 0.5, 60)

        self.dronesfx:setPitch(0.1)
        self.dronesfx:play()

        self.dronetimer = 0
        self.soundcon = 2
    end
    if (self.soundcon == 2) then
        self.dronetimer = self.dronetimer + 1 * (DT * 30)
        if (self.quick_mode) then
            self.dronetimer = self.dronetimer + 1 * (DT * 30)
        end
        self.dronepitch = (self.dronetimer / 80)
        if (self.dronepitch >= 1) then
            self.dronepitch = 1
            self.soundcon = 3
        end
        self.dronesfx:setPitch(self.dronepitch)
    end
    if (self.con == 18) then
        self.timer = self.timer + 1 * (DT * 30)
        if (self.quick_mode) then
            self.timer = self.timer + 1 * (DT * 30)
        end
        self.sus_index = ((self.timer / 36) * 5)
        self.sus_x = (self.sus_x_current - (math.sin(math.rad((self.timer * 2.5))) * self.radius))
        if (self.kris_only == 0) then
            self.kris_x = (self.kris_x_current + (math.sin(math.rad((self.timer * 2.5))) * self.radius))
        end
        if (self.timer >= 35) then
            --self.sus_sprite = self.spr_susie_lw_fall_d
            --self.kris_sprite = self.spr_kris_fall_d_lw
            self.sus_index = 0
            self.con = 19
            self.timer = 0

            -- sprite code --
            self.kris_sprite:setAnimation(self.spr_kris_fall_d_lw)
            self.sus_sprite:setAnimation(self.spr_susie_lw_fall_d)
            -----------------
        end
    end
    if (self.con == 19) then
        self.sus_index = self.sus_index + 0.2 * (DT * 30)
        self.timer = self.timer + 1 * (DT * 30)
        if (self.quick_mode) then
            self.timer = 8
        end
        if (self.timer >= 8) then
            self.con = 30
            self.timer = 0
            self.sus_draw = 0

            -- sprite code --
            self.use_sus_index = false
            self.kris_sprite:setAnimation(self.spr_kris_fall_d_lw)
            self.sus_sprite:setAnimation(self.spr_susie_lw_fall_d)
            -----------------
        end
    end
    if (self.con == 30) then
        -- sprite code --
        self.kris_sprite:setFrame(math.floor(self.index / 4) + 1)
        self.sus_sprite:setFrame(math.floor(self.index / 4) + 1)
        -----------------
        --[[if (self.kris_only == 0) then
            self:drawAnimStrip(self.spr_susie_lw_fall_d, (self.index / 4), self.sus_x, self.sus_y, 1)
        end
        self:drawAnimStrip(self.spr_kris_fall_d_lw, (self.index / 4), self.kris_x, self.kris_y, 1)]]
        self.timer = self.timer + 1 * (DT * 30)
        if (self.quick_mode) then
            self.timer = self.timer + 1 * (DT * 30)
        end
        if (self.timer >= 15) then
            self.con = 31
            self.timer = 0
            self.sus_width = self.spr_susie_dw_fall_d[1]:getWidth()
            self.sus_height = self.spr_susie_dw_fall_d[1]:getHeight()
            self.sus_top = self.sus_height
            self.kris_width = self.spr_kris_fall_d_dw[1]:getWidth()
            self.kris_height = self.spr_kris_fall_d_dw[1]:getHeight()
            self.kris_top = self.kris_height

            -- sprite code --
            self.kris_sprite_2:setAnimation(self.spr_kris_fall_d_white)
            self.kris_sprite_3:setAnimation(self.spr_kris_fall_d_dw)
            self.sus_sprite_2:setAnimation(self.spr_susie_white_fall_d)
            self.sus_sprite_3:setAnimation(self.spr_susie_dw_fall_d)

            self.kris_sprite.cutout_bottom = 0
            self.kris_sprite_2.cutout_top = self.kris_top
            self.kris_sprite_3.cutout_top = self.kris_top
            self.sus_sprite.cutout_bottom = 0
            self.sus_sprite_2.cutout_top = self.sus_top
            self.sus_sprite_3.cutout_top = self.sus_top

            self.kris_sprite_2.visible = true
            self.kris_sprite_3.visible = true
            self.sus_sprite_2.visible = true
            self.sus_sprite_3.visible = true
            -----------------
        end
    end
    if (self.con == 31) then
        self.timer = self.timer + 1 * (DT * 30)
        -- sprite code --
        self.kris_sprite:setFrame(math.floor(self.index / 4) + 1)
        self.kris_sprite_2:setFrame(math.floor(self.index / 4) + 1)
        self.kris_sprite_3:setFrame(math.floor(self.index / 4) + 1)

        self.sus_sprite:setFrame(math.floor(self.index / 4) + 1)
        self.sus_sprite_2:setFrame(math.floor(self.index / 4) + 1)
        self.sus_sprite_3:setFrame(math.floor(self.index / 4) + 1)

        if self.kris_top == 0 then
            self.kris_sprite_2.visible = false
        end
        if self.sus_top == 0 then
            self.sus_sprite_2.visible = false
        end

        self.kris_sprite.cutout_bottom = self.kris_height - self.kris_top
        self.kris_sprite_2.cutout_top = self.kris_top
        self.kris_sprite_2.cutout_bottom = self.kris_height - self.kris_top - 1
        self.kris_sprite_3.cutout_top = self.kris_top + 1

        self.sus_sprite.cutout_bottom = self.sus_height - self.sus_top
        self.sus_sprite_2.cutout_top = self.sus_top
        self.sus_sprite_2.cutout_bottom = self.sus_height - self.sus_top - 1
        self.sus_sprite_3.cutout_top = self.sus_top + 1
        -----------------
        --[[if (self.kris_only == 0) then
            self:drawScissor(self.spr_susie_lw_fall_d, (self.index / 4), 0, 0, self.sus_width, self.sus_top, self.sus_x, self.sus_y)
        end
        self:drawScissor(self.spr_kris_fall_d_lw, (self.index / 4), 0, 0, self.kris_width, self.kris_top, self.kris_x, self.kris_y)
        if (self.kris_only == 0) then
            self:drawScissor(self.spr_susie_dw_fall_d, (self.index / 4), 0, self.sus_top, self.sus_width, (self.sus_height+1 - self.sus_top), self.sus_x, (self.sus_y + self.sus_top))
        end
        self:drawScissor(self.spr_kris_fall_d_dw, (self.index / 4), 0, self.kris_top, self.kris_width, (self.kris_height+1 - self.kris_top), self.kris_x, (self.kris_y + self.kris_top))]]
        if (math.floor(self.timer) == 15) then
            --with (obj_kris_headobj)
            --    breakcon = 1
            --[[if (room == room_library) then
                snd_play(snd_sparkle_glock)
                for (i = 0; i < 1; i++) then
                    sparkle[i] = scr_marker((kris_x + 15), (kris_y + 15), spr_sparestar_anim)
                    sparkle[i].image_speed = 0.5
                    sparkle[i].hspeed = random_range(-3, 3)
                    sparkle[i].friction = 0.05
                    sparkle[i].gravity = -0.1
                end
                scr_keyitemremove(9)
            end]]
            --[[if (global.plot >= 200 && global.flag[387] == 0) then
                snd_play(snd_sparkle_glock)
                var total_recruits = (scr_get_total_recruits(2) + 1)
                for (i = 0; i < total_recruits; i++) then
                    sparkle[i] = scr_marker((kris_x + 15), (kris_y + 15), spr_sparestar_anim)
                    sparkle[i].image_speed = 0.5
                    sparkle[i].hspeed = random_range(-3, 3)
                    sparkle[i].friction = 0.05
                    sparkle[i].gravity = -0.1
                end
            end]]
        end
        if (self.timer >= 4) then
            if (self.sus_top > 2) then
                self.sus_top = self.sus_top - 0.5 * (DT * 30)
                if (self.quick_mode) then
                    self.sus_top = self.sus_top - 1.5 * (DT * 30)
                end
            else
                self.sus_top = 0
            end
            if (self.sus_top >= 2 and self.kris_only == 0) then

                local x = ((self.sus_x + 3) + math.random((self.sus_width - 6)))
                local y = (self.sus_y + self.sus_top)

                self.stage_scaled:addChild(DarkTransitionParticle(x, y))


                --self:drawScissor(self.spr_susie_white_fall_d, (self.index / 4), 0, self.sus_top, self.sus_width, 1, self.sus_x, (self.sus_y + self.sus_top))
            end
            if (self.kris_top > 5) then
                self.kris_top = self.kris_top - 0.5 * (DT * 30)
                if (self.quick_mode) then
                    self.kris_top = self.kris_top - 1.5 * (DT * 30)
                end
            else
                self.kris_top = 0
            end
            if (self.kris_top >= 2) then
                local x = ((self.kris_x + 3) + math.random((self.kris_width - 6)))
                local y = (self.kris_y + self.kris_top)

                self.stage_scaled:addChild(DarkTransitionParticle(x, y))

                --self:drawScissor(self.spr_kris_fall_d_white, (self.index / 4), 0, self.kris_top, self.kris_width, 1, self.kris_x, (self.kris_y + self.kris_top))
            end
        end
        self.threshold = 130
        if (self.quick_mode) then
            self.threshold = 40
        end
        if (self.timer >= self.threshold) then
            if (self.quick_mode) then
                self.linecon = false
            end
            self.sus_y  = utils.round(self.sus_y)
            self.sus_x  = utils.round(self.sus_x)
            self.kris_y = utils.round(self.kris_y)
            self.kris_x = utils.round(self.kris_x)
            self.timer = 0
            self.sus_v = -0.2
            self.sus_f = 0.01
            self.con = 32

            -- sprite code --
            self.kris_sprite:setAnimation(self.spr_kris_fall_smear)
            self.sus_sprite:setAnimation(self.spr_susie_dw_fall_smear)

            self.kris_sprite:setFrame(1)
            self.sus_sprite:setFrame(1)

            self.kris_sprite_2.visible = false
            self.kris_sprite_3.visible = false

            self.sus_sprite_2.visible = false
            self.sus_sprite_3.visible = false

            self.kris_sprite:setCutout()
            self.kris_sprite_2:setCutout()
            self.kris_sprite_3:setCutout()

            self.sus_sprite:setCutout()
            self.sus_sprite_2:setCutout()
            self.sus_sprite_3:setCutout()
            -----------------
        end
    end
    if (self.con == 32) then
        if (math.floor(self.timer) == 0) then
            --self.megablack = self:scr_dark_marker(-10, -10, self.spr_whitepixel) -- TODO
            --with (self.megablack) then
            --    depth = 150
            --    image_alpha = 1
            --    y = -999
            --    image_xscale = 999
            --    image_yscale = 999
            --    image_blend = c_black
            --    persistent = true
            --end
        end
        if (math.floor(self.timer) == 2) then
            --self.megablack.y = 0
        end
        self.megablack = true
        self.timer = self.timer + 1 * (DT * 30)
        if (self.timer >= 0 and self.timer < 8) then
            self.sus_v = self.sus_v - 0.5 * (DT * 30)
            --[[if (self.kris_only == 0) then
                self:drawAnimStrip(self.spr_susie_dw_fall_smear, 0, self.sus_x, self.sus_y, 1)
            end
            self:drawAnimStrip(self.spr_kris_fall_smear, 0, self.kris_x, self.kris_y, 1)]]

            -- sprite code --
            self.kris_sprite:setFrame(1)
            self.sus_sprite:setFrame(1)
            -----------------
        end
        if (self.timer >= 8 and self.timer < 12) then
            self.sus_v = self.sus_v + 1 * (DT * 30)
            self.sus_f = 0
            --[[if (self.kris_only == 0) then
                self:drawAnimStrip(self.spr_susie_dw_fall_smear, 1, self.sus_x, self.sus_y, 1)
            end
            self:drawAnimStrip(self.spr_kris_fall_smear, 1, self.kris_x, self.kris_y, 1)]]

            -- sprite code --
            self.kris_sprite:setFrame(2)
            self.sus_sprite:setFrame(2)
            -----------------
        end
        if (self.timer >= 12 and self.timer <= 14) then
            self.sus_v = self.sus_v + 4 * (DT * 30)
            --[[if (self.kris_only == 0) then
                self:drawAnimStrip(self.spr_susie_dw_fall_smear, 2, self.sus_x, self.sus_y, 1)
            end
            self:drawAnimStrip(self.spr_kris_fall_smear, 2, self.kris_x, self.kris_y, 1)]]

            -- sprite code --
            self.kris_sprite:setFrame(3)
            self.sus_sprite:setFrame(3)
            -----------------
        end
        if (self.timer >= 14) then
            self.soundcon = 4

            -- self.dronesfx needs to fade out to 0, taking 30 deltarune frames (1 second)
            --snd_volume(self.dronesfx, 0, 30)

            -- This fade is handled at the top of the update function, when `self.soundcon` is 4.

            self.sus_v = 13
            self.sus_f = 0
            self.timer = 0
            self.con = 33
            self.rect_draw = 0

            -- sprite code --
            self.kris_sprite:setAnimation(self.spr_kris_fall_ball)
            self.kris_sprite_2:setAnimation(self.spr_kris_fall_ball)
            self.kris_sprite_3:setAnimation(self.spr_kris_fall_ball)

            self.sus_sprite:setAnimation(self.spr_susie_dw_fall_ball)
            self.sus_sprite_2:setAnimation(self.spr_susie_dw_fall_ball)
            self.sus_sprite_3:setAnimation(self.spr_susie_dw_fall_ball)

            self.kris_sprite_2.visible = true
            self.kris_sprite_3.visible = true

            self.sus_sprite_2.visible = true
            self.sus_sprite_3.visible = true

            self.kris_sprite.color = {1, 1, 1, 1}
            self.kris_sprite_2.color = {1, 1, 1, 0.5}
            self.kris_sprite_3.color = {1, 1, 1, 0.25}

            self.sus_sprite.color = {1, 1, 1, 1}
            self.sus_sprite_2.color = {1, 1, 1, 0.5}
            self.sus_sprite_3.color = {1, 1, 1, 0.25}
            -----------------
        end
    end
    if (self.con == 33) then
        self.timer = self.timer + 1 * (DT * 30)
        if (self.quick_mode and (self.timer < 31)) then
            self.timer = 31
            self.do_once4 = true -- skip timer == 14
            self.do_once5 = true -- skip timer == 30
        end
        --[[if (self.kris_only == 0) then
            self:drawAnimStrip(self.spr_susie_dw_fall_ball, (self.timer / 2), self.sus_x, (self.sus_y - (self.sus_v * 2)), 0.25)
            self:drawAnimStrip(self.spr_susie_dw_fall_ball, (self.timer / 2), self.sus_x, (self.sus_y -  self.sus_v), 0.5)
            self:drawAnimStrip(self.spr_susie_dw_fall_ball, (self.timer / 2), self.sus_x,  self.sus_y, 1)
        end
        self:drawAnimStrip(self.spr_kris_fall_ball, (self.timer / 2), self.kris_x, (self.kris_y - (self.sus_v * 2)), 0.25)
        self:drawAnimStrip(self.spr_kris_fall_ball, (self.timer / 2), self.kris_x, (self.kris_y -  self.sus_v), 0.5)
        self:drawAnimStrip(self.spr_kris_fall_ball, (self.timer / 2), self.kris_x,  self.kris_y, 1)]]
        -- sprite code --
        self.kris_sprite:setFrame(math.floor(self.timer / 2) + 1)
        self.kris_sprite_2:setFrame(math.floor(self.timer / 2) + 1)
        self.kris_sprite_3:setFrame(math.floor(self.timer / 2) + 1)

        self.sus_sprite:setFrame(math.floor(self.timer / 2) + 1)
        self.sus_sprite_2:setFrame(math.floor(self.timer / 2) + 1)
        self.sus_sprite_3:setFrame(math.floor(self.timer / 2) + 1)

        self.sus_sprite_2.y = -self.sus_v
        self.sus_sprite_3.y = -self.sus_v * 2

        self.kris_sprite_2.y = -self.sus_v
        self.kris_sprite_3.y = -self.sus_v * 2
        -----------------
        if (math.floor(self.timer) >= 14) and not self.do_once4 then
            self.do_once4 = true
            self.linecon = false
        end
        if (math.floor(self.timer) >= 30) and not self.do_once5 then
            self.do_once5 = true
            self.sus_y = -20
            self.kris_y = -14
        end
        if (self.timer > 30) then
            --print((math.floor(self.timer)))
            --print(not self.do_once7)
            --print("---")

            -- Goodbye accuracy :(
            -- Because we have a configurable self.finaly, we should play the sound when they reach that

            --[[if (self.skiprunback and (math.floor(self.timer) >= 36) and not self.do_once6) then
                self.do_once6 = true
                local sound = love.audio.newSource("assets/sounds/snd_dtrans_flip.ogg", "static")
                sound:play()
            end
            if (math.floor(self.timer) >= 39) and (not self.do_once7) then
                self.do_once7 = true
                local sound = love.audio.newSource("assets/sounds/snd_dtrans_flip.ogg", "static")
                sound:play()
            end]]--
            if (self.sus_y >= (self.finaly - 8)) then
                -- Since our finaly is configurable, play the sound here
                local sound = love.audio.newSource("assets/sounds/snd_dtrans_flip.ogg", "static")
                sound:play()
                self.con = 34
                self.timer = 0
                self.sus_v = 0
                self.kris_y = (self.finaly + 6)
                self.sus_y = self.finaly
                self.getup_index = 0
                self.fake_screenshake = 1
                self.fake_shakeamount = 8
                self.remkrisx = (self.kris_x - self:camerax())
                self.remkrisy = (self.kris_y - self:cameray())
                self.remsusx  = (self.sus_x  - self:camerax())
                self.remsusy  = (self.sus_y  - self:cameray())

                -- sprite code --
                self.kris_sprite:setAnimation(self.spr_kris_dw_landed)
                self.sus_sprite:setAnimation(self.spr_susie_dw_landed)

                self.kris_sprite_2.visible = false
                self.kris_sprite_3.visible = false

                self.sus_sprite_2.visible = false
                self.sus_sprite_3.visible = false
                -----------------
            end
        end
    end

    if (self.con == 34) then
        self.dronesfx:stop()
        self.timer = self.timer + 1 * (DT * 30)
        if (self.quick_mode and self.timer < 15) then
            self.timer = 15
        end
        if (self.timer > 1) then
            --[[if (self.kris_only == 0) then
                self:drawAnimStrip(self.spr_susie_dw_landed, self.getup_index, ((self.sus_x * self.dz) + self.fake_shakeamount), (self.sus_y * self.dz), 1)
            end
            self:drawAnimStrip(self.spr_kris_dw_landed, self.getup_index, ((self.kris_x * self.dz) + self.fake_shakeamount), (self.kris_y * self.dz), 1)]]
            -- sprite code --
            self.kris_sprite:setFrame(math.floor(self.getup_index) + 1)
            self.sus_sprite:setFrame(math.floor(self.getup_index) + 1)

            self.kris_sprite_2.visible = false
            self.kris_sprite_3.visible = false

            self.sus_sprite_2.visible = false
            self.sus_sprite_3.visible = false
            -----------------
        end
        if ((math.floor(self.timer) >= 26) and not self.do_once8) then
            self.do_once8 = true
            self.kris_x = self.remkrisx
            self.kris_y = self.remkrisy
            self.sus_x  = self.remsusx
            self.sus_y  = self.remsusy
            --if (global.flag[302] == 1)
            --    global.flag[302] = 2
            --scr_become_dark()
            --dz = (global.darkzone + 1)
            --room_goto(nextroom)
        end
        if ((math.floor(self.timer) >= 27) and not self.do_once9) then
            self.do_once9 = true
            local sound = love.audio.newSource("assets/sounds/snd_him_quick.ogg", "static")
            sound:play()
            --with (obj_mainchara) then
            --    x = -999
            --    cutscene = true
            --    visible = false
            --end
            --with (obj_caterpillarchara) then
            --    x = -999
            --    visible = false
            --end
            --if (global.chapter == 2) then
            --    if (global.plot == 9) then
            --        obj_mainchara.y = kris_y
            --        kris_y = kris_y + 200
            --        cameray_set((cameray() + 400))
            --    end
            --end
        end
        if (self.timer >= 30 and self.timer < 60) then
            -- TODO: fade
            --with (megablack)
            --    image_alpha = image_alpha - 0.05
            --if (quick_mode) then
            --    with (megablack)
            --        image_alpha = image_alpha - 0.05
            --end
        end
        if ((math.floor(self.timer) >= 50) and not self.do_once10) then
            self.do_once10 = true
            self.getup_index = 1
        end
        if ((math.floor(self.timer) >= 53) and not self.do_once11) then
            self.do_once11 = true
            self.getup_index = 2
        end
        if ((math.floor(self.timer) >= 55) and not self.do_once12) then
            self.do_once12 = true
            --with (megablack)
            --    instance_destroy()
            --persistent = false
            --global.interact = 0
            --global.facing = 0
            --obj_mainchara.x = ((kris_x * 2) + 8)
            --obj_mainchara.y = ((kris_y * 2) + 4)
            --with (obj_mainchara)
            --    visible = true
            --if i_ex(global.cinstance[1]) then
            --    with (global.cinstance[1])
            --        instance_destroy()
            --end
            --if (kris_only == 0 && i_ex(global.cinstance[0])) then
            --    global.cinstance[0].x = ((sus_x * 2) + 10)
            --    global.cinstance[0].y = (sus_y * 2)
            --    with (obj_caterpillarchara) then
            --        visible = true
            --        scr_caterpillar_interpolate()
            --        facing[target] = 0
            --        sprite_index = dsprite
            --    end
            --end
            --instance_destroy()
        end
    end
    if (self.sus_draw == 1) then
        --[[if instance_exists(obj_kris_headobj) then
            obj_kris_headobj.x = (kris_x + 14)
            obj_kris_headobj.y = (kris_y - 2)
        end]]
        --[[if (self.darkzone == false) then
            self:drawAnimStrip(self.kris_sprite, self.sus_index, (self.kris_x + self.fake_shakeamount), self.kris_y, 1)
            if (self.kris_only == 0) then
                self:drawAnimStrip(self.sus_sprite, self.sus_index, (self.sus_x + self.fake_shakeamount), self.sus_y, 1)
            end
        else
            self:drawAnimStrip(self.kris_sprite, self.sus_index, ((self.kris_x * 2) + self.fake_shakeamount), (self.kris_y * 2), 1) -- TODO: 2, 2
            if (self.kris_only == 0) then
                self:drawAnimStrip(self.sus_sprite, self.sus_index, ((self.sus_x * 2) + self.fake_shakeamount), (self.sus_y * 2), 1) -- TODO: 2, 2
            end
        end]]
    end
    -- sprite code --
    if self.use_sus_index then
        self.kris_sprite:setFrame(math.floor(self.sus_index) + 1)
        self.sus_sprite:setFrame(math.floor(self.sus_index) + 1)
    end

    self.kris_sprite_holder:setPosition(self.kris_x + self.fake_shakeamount, self.kris_y)
    self.sus_sprite_holder:setPosition(self.sus_x + self.fake_shakeamount, self.sus_y)
    -----------------

    -- Reset canvas to draw to
    love.graphics.setCanvas(SCREEN_CANVAS)

    -- Draw the canvas on the screen scaled by 2x
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, 0, 0, 0, 2, 2)

    self.stage:draw()

end

return darktransition