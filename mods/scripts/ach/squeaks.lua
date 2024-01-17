local Ach, super = Class(Achievement)

function Ach:init()
    super:init(self)
    
    self.name = "Squeak Master" -- Display name

    self.iconanimated = false -- If icons should be animated, if true then the input for both icons should be a table of paths
    self.icon = "achievements/squeaks" -- Normal icon
    self.desc = "You have squeaked 100 times." -- Description
    self.hint = nil -- If info hidden is true then this will show up in place of description, used for hints
    self.hidden = false -- Doesn't show up in the menu if not collected
    self.rarity = "Rare" -- An indicator on how difficult this achievement is. "Common", "Uncommon", "Rare", "Epic" "Legendary", "Unique", "Impossible"
    self.completion = 100 -- Shows a percent indicator if true, shows x/int if an integer, nothing if false.
    self.progress = 0
    self.index = 3 -- Order in which the achievements will show up on the menu.
end

return Ach