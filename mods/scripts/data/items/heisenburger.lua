local item, super = Class(HealItem, "heisenburger")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Heisenburger"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n70HP"
    -- Shop description
    self.shop = "Heisenburbur\nA weird burger with walter white's face\nheals 70HP"
    -- Menu description
    self.description = "A weird burger with walter white's face made of...\nUhh... Idk, I hope it isn't meth! +70HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 70
    -- Amount this item heals for specific characters in the overworld (optional)
    self.world_heal_amounts = {
        ["noelle"] = 20
    }

    -- Default shop price (sell price is halved)
    self.price = 70
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "They let him cook to perfection!",
        ralsei = "Wth is this blue thing in it...?",
        noelle = "I-is this real meat...?",
        telejaba = "Heisenburbur."
        -- rookie = "Heisenburbur.",
        -- bluboldishead = "Heisenburbur.",
        -- rrllmm = "Heisenburbur.",
        -- olegis = "Heisenburbur."
    }
end

function item:convertToLightEquip(chara)
    return "light/heisenburger_lw"
end

return item