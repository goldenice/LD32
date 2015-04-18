function findEnemies(gamestate)
  local layer = gamestate.map.layers["enemies"]
  local map = gamestate.map
  local enemies = {}
  local o = layer.objects
		for _, v in ipairs(o) do
      if  v then
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
        v.xoffset = 26
        v.yoffset = 0
        enemies[#enemies+1] = v
        gamestate.blocks[#gamestate.blocks+1] = v
      end
		end
    return enemies
end

function aienemy(dt)
  --print("enemy")

  for _,enemy in ipairs(gamestate.enemies) do
    if -gamestate.scroll < tonumber(enemy.properties.scroll) then

      laneAI(enemy,dt)
    end
    if cols_len > 0 then
    end
  end
end

function laneAI(enemy,dt)
  local velocity = 100
  local r = math.rad(enemy.rotation)
  local dx = math.cos(r)* velocity * dt
  local dy = math.sin(r)*velocity*dt

  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  enemy.properties.tick = enemy.properties.tick + dt
  if  enemy.properties.tick > 0.5 then
    enemy.properties.tick = 0
    print("shooting")
  end
end

function enemyfilter(item, other)
  return 'cross'

  -- else return nil
end
