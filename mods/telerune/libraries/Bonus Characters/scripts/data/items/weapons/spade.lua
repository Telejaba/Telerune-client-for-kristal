local item, super = Class(Item, "spade")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Spade"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/spade"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A glowy, white spade. Summoned by magic."

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 0,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        lancer = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Hey, let's let Lancer keep that.",
        ralsei = "Not my type of magic...",
        noelle = "Shiny...",
        berdly = "Hoho! I'm not touching this pointy witchcraft!",
        lancer = "Mine!",
    }
end

return item