local M = {}


function M:new(actor, activateFn)
  local o = {
    actor = actor,
    activateFn = activateFn,
  }
  self.__index = self
  return setmetatable(o, self)
end

function M:activate()
  self.activateFn(self.actor)
end

return M
