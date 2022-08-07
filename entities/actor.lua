local M = {}


function M:new(maxHp, attack)
  local o = {
    hp = maxHp,
    maxHp = maxHp,
    alive = true,
    attack = attack
  }
  self.__index = self
  return setmetatable(o, self)
end

function M:receive(damage)
  self.hp = self.hp - damage

  if (self.hp < 0) then
    self.alive = false
  end
end

return M
