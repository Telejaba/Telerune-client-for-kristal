---@class SoosDoor : Event
---@overload fun(...) : SoosDoor
local SoosDoor, super = Class(Event, "soosdoor")

function SoosDoor:init(data)
    super:init(self, data.x, data.y)
    self:setSprite("nothing")
    self:setOrigin(0.5, 1)
    self.solid = true
    self.collider = Hitbox(self, 0, 58, 72, 40)

    self.open = properties["open"] ~= false
    self.open_flag = properties["openflag"]
    if self.open_flag then
        self.open = Game:getFlag(self.open_flag)
    end

    if self.open then
        self:setSprite("nothing")
        self.light = Sprite("world/events/shortcut_light", 8, 96)
        self.light:play(0.25, true)
        self.light:setScale(2)
        self:addChild(self.light)
    end

    self.maps = {}
    self.names = {}
    self.markers = {}
    self.flags = {}
    local i = 1
    while properties["map"..i] do
        if properties["name"..i] then
            self.names[i] = properties["name"..i]
        else
            self.names[i] = Utils.titleCase(properties["map"..i])
        end
        if properties["flag"..i] then
            self.flags[i] = properties["flag"..i]
        end
        self.maps[self.names[i]] = properties["map"..i]
        self.markers[self.names[i]] = properties["marker"..i]
        i = i + 1
    end
end

function SoosDoor:onInteract(chara, facing)
    if not self.open then
        Game.world:showText("* (It's a lone doorframe.)[wait:5]\n* (But for some reason,[wait:5] you can't\nsee through it...)")
    else
        Game.world:startCutscene(function(cutscene)
            cutscene:text("* (This door seem to be SOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOOOOOOOOOOOS.)")
            local choices = {}
            for i=1,#self.names do
                if not self.flags[i] or Game:getFlag(self.flags[i], false) then
                    table.insert(choices, self.names[i])
                end
            end
            table.insert(choices, "Cancel")
            local choice_i = cutscene:choicer(choices)
            if choice_i < #choices then
                local name = choices[choice_i]
                local map = self.maps[name]
                if map == self.world.map.id then
                    cutscene:text("* (Amazingly,[wait:5] you are already there.)")
                else
                    Assets.playSound("dooropen")
                    self.sprite:setFrame(2)
                    self.light:remove()
                    cutscene:text("* (The door opened...)")
                    cutscene:wait(0.2) -- 6/30
                    for key,_ in pairs(Assets.sound_instances) do
                        Assets.stopSound(key, true)
                    end
                    Assets.playSound("doorclose")
                    Game.world.music:stop()
                    Game.world.fader:fadeOut(nil, {
                        speed = 0,
                    })
                    cutscene:wait(1)
                    cutscene:loadMap(map, self.markers[name] or "spawn", "down")
                    Game.world.fader:fadeIn(nil, {
                        speed = 0.25,
                    })
                end
            else
                cutscene:text("* (You doorn't.)")
            end
        end)
    end

    return true
end

function SoosDoor:updateOpen()
    self.open = Game:getFlag(self.open_flag)
    if self.open then
        self:setSprite("world/events/shortcut_door")
        if not self.light then
            self.light = Sprite("world/events/shortcut_light", 8, 96)
            self.light:play(0.25, true)
            self.light:setScale(2)
            self:addChild(self.light)
        end
    else
        self:setSprite("world/events/shortcut_door_off")
        if self.light then
            self.light:remove()
        end
    end
end

return SoosDoor