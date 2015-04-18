function findEnemies(gamestate)
  local layer = gamestate.map.layers["enemies"]
  local map = gamestate.map
  local enemies = {}

  local o = layer.objects
  for _, v in pairs(o) do
    if  v then
      gamestate.n_enemies = gamestate.n_enemies + 1
      gamestate.n_blocks = gamestate.n_blocks + 1
      v.isEnemy=true
      props =v.properties
      local type = ""
      print(#v.properties)
      local ctype = v.properties.ctype
      if ctype then
        --v.ctype = ctype
      end
      local type = v.properties.type
      if type then
        v.type = type
      end
      v.w = v.width
      v.h = v.height
      gamestate.world:add(v,v.x,v.y,v.width,v.height)
      v.xoffset = 20
      v.yoffset = 0
      enemies["a"..gamestate.n_enemies] = v
      gamestate.blocks["a"..gamestate.n_blocks] = v

      v.block =gamestate.n_blocks
      v.id =gamestate.n_enemies
    end
  end
  return enemies
end

function aienemy(dt)
  --print("enemy")
  remove = {}
  for i,enemy in pairs(gamestate.enemies) do
    if -gamestate.scroll < tonumber(enemy.properties.scroll) then

      local do_remove = laneAI(enemy,dt)
      if do_remove == 3 then
        return
      end
      if do_remove== 1 then
        gamestate.world:update(enemy,0,-100)
        delete_enemy(enemy)


      end
    end
    if cols_len > 0 then
    end
  end
end

function laneAI(enemy,dt)
  local velocity = 100
  local r = math.rad(enemy.rotation)
  local dx = math.sin(r)* velocity * dt
  local dy = -math.cos(r)*velocity*dt

  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  enemy.properties.tick = enemy.properties.tick + dt
  for i=1, cols_len do
    local col = cols[i]

    if col.other.ctype =="player" then
      resetGame()
      return 3
    end

    return 0

  end

  if  enemy.properties.tick > 0.5 then
    add_bullet(enemy.x,enemy.y,180,"standard","enemy")

    enemy.properties.tick = 0
  end
  return false
end

function enemyfilter(item, other)
  return 'cross'

  -- else return nil
end



function drawEnemies()
  for _, enemy in pairs(gamestate.enemies) do
    if enemy.properties.still then

      love.graphics.draw(hamster, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0, 1, 1, width / 2, height / 2)
    else
      love.graphics.draw(hamster, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, math.rad(enemy.rotation), 1, 1, width / 2, height / 2)
    end

  end
end
