local item, super = Class(Item, "light/heisenburger_lw")

function item:init(inventory)
    super.init(self)

    -- Display name
    self.name = "Heisenburger"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Light world check text
    self.check = "A weird burger with walter white's face."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    -- Default dark item conversion for this item
    self.dark_item = "heisenburger"
    
end

function item:onWorldUse()
    Game.world:startCutscene(function(cutscene)
        if Game.party[1].lw_health <= 1 then
            Game:gameOver(Game.world.player.x, Game.world.player.y)
            return true
        else
            Game.party[1].lw_health = Game.party[1].lw_health + 3
        end
        cutscene:text("* (You ate Heisenburger.)")
        cutscene:text("* (Your guts are being destroyed.)\n(It worthed that tho.)")
        cutscene:text("* (You restored 3 HP)")
    end)
    return true
end

function item:onToss()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* (Nooooooooooo\nHeisenburger died.)")
    end)
    return true
end

return item