local item, super = Class("mane_ax", true)

function item:init()
    super.init(self)

    self.reactions = Utils.merge(self.reactions, {
		dess = "Too heavy",
        ostarwalker = "Too   sharp",
    })

end

return item