local item, super = Class("red_scarf", true)

function item:init()
    super.init(self)

    self.reactions = Utils.merge(self.reactions, {
		dess = "I hate Ralsei, god I hate them",
        ostarwalker = "It's    soft",
    })
end

return item