function love.load()
  Player = {}
  Boss = {}

  Player.maxHp = 10
  Player.hp = 10
  Player.attack = 3

  Boss.hp = 100
  Boss.maxHp = 100
  Boss.attack = 2

  Game = {}
  Game.over = false
  Game.keyChain = {}

  World = {}
  World.events = {}
  World.turn = 0
  table.insert(World.events,
    { turn = World.turn, v = "Init" }
  )

  World.nextTurn = function()
    World.turn = World.turn + 1

    -- table.insert(World.events,
    --   { turn = World.turn, v = "NextTurn" }
    -- )

    if World.turn % 10 == 0 then
      table.insert(World.events,
        { turn = World.turn, v = "BossAttack" }
      )
      Player.hp = Player.hp - Boss.attack
    end

    if Boss.hp < 0 then
      Game.over = true
    end

    if Player.hp < 0 then
      Game.over = true
    end

  end

  World.nextTurn()


end

function love.update(dt)
end

function love.draw()
  local output = {}
  local eventsOutput = {}

  table.insert(output, 'Player')
  table.insert(output, 'hp: ' .. Player.hp)
  table.insert(output, 'a: ' .. Player.attack)

  table.insert(output, '')

  table.insert(output, 'Boss')
  table.insert(output, 'hp: ' .. Boss.hp)
  table.insert(output, 'a: ' .. Boss.attack)

  if Game.over then
    table.insert(output, '')
    if Player.hp < 0 then
      table.insert(output, 'You Died')
    else
      table.insert(output, 'Boss killed')
    end
    table.insert(output, 'Game Over')
  end

  table.insert(eventsOutput, 'Actions')

  for i = table.maxn(World.events), 1, -1 do
    table.insert(eventsOutput, World.events[i].turn .. " " .. World.events[i].v)
  end

  love.graphics.rectangle('fill', 15, 0, 10 * Player.maxHp, 12)
  love.graphics.setColor(0, 255, 0) -- reset colours
  love.graphics.rectangle('fill', 15, 0, 10 * Player.hp, 10)
  love.graphics.setColor(255, 255, 255) -- reset colours

  love.graphics.rectangle('fill', 15, 150, Boss.maxHp, 12)
  love.graphics.setColor(0, 255, 0) -- reset colours
  love.graphics.rectangle('fill', 15, 150, Boss.hp / Boss.maxHp * 100, 10)
  love.graphics.setColor(255, 255, 255) -- reset colours

  love.graphics.setFont(love.graphics.newFont(30))
  love.graphics.print(table.concat(output, '\n'), 15, 20)

  love.graphics.setFont(love.graphics.newFont(12))
  love.graphics.print(table.concat(eventsOutput, '\n'), 500, 15)

end

function love.keypressed(key)

  if key == 'q' then
    table.insert(Game.keyChain, 'q')
    if table.concat(Game.keyChain) == 'qq' then
      table.insert(World.events, { turn = World.turn, v = "press 1 more q to reload" })
    end
    if table.concat(Game.keyChain) == 'qqq' then
      love.load()
    end
  else
    Game.keyChain = {}
  end


  if Game.over then
    love.load()
  end

  if key == 'a' then
    table.insert(World.events, { turn = World.turn, v = "Player attack" })
    Boss.hp = Boss.hp - Player.attack
    World.nextTurn()
  end

  if key == 'h' then
    table.insert(World.events, { turn = World.turn, v = "Player heal" })
    Player.hp = Player.hp + 1
    World.nextTurn()
  end


  if key == 'n' then
    World.nextTurn()
  end
end
