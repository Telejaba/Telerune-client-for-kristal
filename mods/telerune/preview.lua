local preview = {}

-- whether to fade out the default background
preview.hide_background = false

function preview:init(mod, button)
    -- code here gets called when the mods are loaded
    self.particles = {}
    self.particle_timer = 0

    button:setFavoritedColor(181/255, 230/255, 29/255)
end

function preview:update()
    -- code here gets called every frame, before any draws
    -- to only update while the mod is selected, check self.selected (or self.fade)

    local to_remove = {}
    for _,particle in ipairs(self.particles) do
        particle.radius = particle.radius
        particle.radius = particle.radius - (DT * 4)
        particle.y = particle.y - particle.speed * (DTMULT * 2)

        if particle.radius <= 0 then
            table.insert(to_remove, particle)
        end
    end

    for _,particle in ipairs(to_remove) do
        Utils.removeFromTable(self.particles, particle)
    end

    self.particle_timer = self.particle_timer + DT
    if self.particle_timer >= 0.25 then
        self.particle_timer = 0
        local radius = Utils.random() * 48 + 16
        table.insert(self.particles, {radius = radius, x = Utils.random() * SCREEN_WIDTH, y = SCREEN_HEIGHT + radius, max_radius = radius, speed = Utils.random() * 0.5 + 0.5})
    end
end

function preview:draw()
    -- code here gets drawn to the background every frame!!
    -- make sure to check  self.fade  or  self.selected  here

    if self.fade > 0 then
        love.graphics.setBlendMode("add")

        for _,particle in ipairs(self.particles) do
            local alpha = (particle.radius / particle.max_radius) * self.fade

            Draw.setColor(1, 1, 1, alpha)
            love.graphics.draw(Assets.getTexture("ui/menu/icon/fire"), particle.x, particle.y, 0, particle.radius, particle.radius)
        end

        love.graphics.setBlendMode("alpha")
    end
end

function preview:drawOverlay()
    -- code here gets drawn above the menu every frame
    -- so u can make cool effects
    -- if u want
end

return preview