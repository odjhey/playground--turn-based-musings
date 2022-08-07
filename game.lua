local M = {}

function M:new()
  local o = {
    over = false,
    keyChain = {}
  }
  self.__index = o
  return setmetatable(o, self)
end

return M
