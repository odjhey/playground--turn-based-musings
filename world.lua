local M = {}

function M:new()
  local o = {
    events = {},
    turn = 0
  }
  self.__index = o
  return setmetatable(o, self)
end

return M
