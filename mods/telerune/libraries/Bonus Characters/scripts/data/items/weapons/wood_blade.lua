local item, super = Class("wood_blade", true)

function item:init()
    super.init(self)

    self.reactions = Utils.merge(self.reactions, {
		dess = "I'm not a fucking nerd",
        ostarwalker = "That's   just a stick",
    })

end

return item