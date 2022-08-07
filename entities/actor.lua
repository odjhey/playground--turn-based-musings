local M = {}


function M:new(maxHp, attack, maxAtb)
  local o = {
    hp = maxHp,
    maxHp = maxHp,
    alive = true,
    attack = attack,
    maxAtb = maxAtb,
    atb = 0
  }
  self.__index = self
  return setmetatable(o, self)
end

function M:isReady()
  return self.atb >= self.maxAtb
end

function M:act(fn)
  fn()
  self.atb = 0
end

function M:receive(damage)
  self.hp = self.hp - damage

  if (self.hp < 0) then
    self.alive = false
  end
end

return M
