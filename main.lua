Actor = require 'entities.actor'
A = require 'actions'
BAi = require 'entities.bossAi'
G = require 'game'
W = require 'world'



function love.load()
  ActionQueue = {}
  ActionQueue.q = {}
  Game = G:new()
  World = W:new()

  Player = Actor:new(10, 3, 1)
  Boss = Actor:new(100, 2, 10)
  BossAi = BAi:new(Boss, function(actor)

    if actor:isReady() then
      actor:act(function()
        table.insert(World.events,
          { turn = World.turn, v = "BossAttack" }
        )
        A.attackAtoA(actor, Player)
      end)
    end


    if actor.hp < 60 and actor.attack ~= 5 then

      table.insert(World.events,
        { turn = World.turn, v = "Boss Rage" }
      )
      actor.attack = 5
    end
  end)


  table.insert(World.events,
    { turn = World.turn, v = "Init" }
  )

  World.nextTurn = function()
    World.turn = World.turn + 1
    Boss.atb = Boss.atb + 1
    Player.atb = Player.atb + 1

    -- table.insert(World.events,
    --   { turn = World.turn, v = "NextTurn" }
    -- )

    BossAi:activate()

    if Player:isReady() then
      local action = table.remove(ActionQueue.q, 1)
      if (action == 'a') then
        Player:act(function()
          table.insert(World.events, { turn = World.turn, v = "Player attack" })
          A.attackAtoA(Player, Boss)
        end)
      end
      if (action == 'h') then
        Player:act(function()
          table.insert(World.events, { turn = World.turn, v = "Player heal" })
          A.healAtoA(Player, Player)
        end)
      end
    end

    if Boss.hp <= 0 then
      Game.over = true
    end

    if Player.hp <= 0 then
      Game.over = true
    end

  end

  World.nextTurn()

  Timer = { timer = 0, rate = 1 }

end

function love.update(dt)
  Timer.timer = Timer.timer + dt
  if Timer.timer > Timer.rate then
    World.nextTurn()
    Timer.timer = 0
  end
end

function love.draw()
  local output = {}
  local eventsOutput = {}

  table.insert(output, 'Player')
  table.insert(output, 'hp: ' .. Player.hp)
  table.insert(output, 'a: ' .. Player.attack)
  table.insert(output, 'atb: ' .. Player.atb)

  table.insert(output, '')

  table.insert(output, 'Boss')
  table.insert(output, 'hp: ' .. Boss.hp)
  table.insert(output, 'a: ' .. Boss.attack)
  table.insert(output, 'atb: ' .. Boss.atb)

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

  love.graphics.rectangle('fill', 15, 180, Boss.maxHp, 12)
  love.graphics.setColor(0, 255, 0) -- reset colours
  love.graphics.rectangle('fill', 15, 180, Boss.hp / Boss.maxHp * 100, 10)
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
    table.insert(World.events, { turn = World.turn, v = "q a" })
    table.insert(ActionQueue.q, "a")
  end

  if key == 'h' then
    table.insert(World.events, { turn = World.turn, v = "q h" })
    table.insert(ActionQueue.q, "h")
  end


  if key == 'n' then
    World.nextTurn()
  end
end
