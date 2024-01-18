---@class halldoor : Event
---@overload fun(...) : halldoor
local halldoor, super = Class(Event, "halldoor")

function halldoor:init(data)
    super:init(self, data.x, data.y)
    self:setOrigin(0, 0)
    self:setSprite("hall_door_closed")
end

return halldoor