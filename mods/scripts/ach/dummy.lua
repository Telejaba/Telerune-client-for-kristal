local Ach, super = Class(Achievement)

function Ach:init()
    super:init(self)
    
    self.name = "Dummy Puncher" -- Display name

    self.iconanimated = false -- If icons should be animated, if true then the input for both icons should be a table of paths
    self.icon = "achievements/dummy" -- Normal icon
    self.desc = "You have punched the dummy." -- Description
    self.hint = nil -- If info hidden is true then this will show up in place of description, used for hints
    self.hidden = false -- Doesn't show up in the menu if not collected
    self.rarity = "Uncommon" -- An indicator on how difficult this achievement is. "Common", "Uncommon", "Rare", "Epic" "Legendary", "Unique", "Impossible"
    self.completion = false -- Shows a percent indicator if true, shows x/int if an integer, nothing if false.
    self.index = 4 -- Order in which the achievements will show up on the menu.
end

return Ach