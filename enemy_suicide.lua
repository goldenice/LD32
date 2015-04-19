function add_suicide_enemy(gamestate,x,y,tick,scroll,rotation)
  local ship =  love.graphics.newImage("assets/entity/ships/enemy_001.png")
  local still = false
  local e = add_enemy(gamestate,x,y,32,16,0,0,tick,scroll,rotation,still,ship)
  local dx = gamestate.player.x - e.x
  local dy = gamestate.player.y - e.y
  local dist = math.sqrt(dx*dx+dy*dy)
  e.ddx = (dx) / (dist)
  e.ddy = (dy) / (dist)
  e.rotation = math.atan2 ( -e.ddx,e.ddy)
  print(e)
  return e
end

function suicide_enemy_ai(enemy,dt)
  local velocity = 100
  print(velocity)
  local r = math.rad(enemy.rotation)
  local dx = enemy.ddx* velocity * dt
  local dy = enemy.ddy*velocity*dt

  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  enemy.tick = enemy.tick + dt
  for i=1, cols_len do
    local col = cols[i]

    if col.other.ctype =="player" then
      resetGame()
      return 3
    end


  end

  return false
end
