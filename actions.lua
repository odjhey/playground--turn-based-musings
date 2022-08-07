local M = {}

function M.attackAtoA(src, target)
  target:receive(src.attack)
end

function M.healAtoA(src, target)
  target:receive(-1)
end

return M
