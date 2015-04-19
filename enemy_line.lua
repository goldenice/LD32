function add_line_enemy(gamestate,x,y,tick,scroll,rotation)
  local still = true
  local ship =  love.graphics.newImage("assets/entity/ships/enemy_001.png")
  local e = add_enemy(gamestate,x,y,32,16,0,0,tick,scroll,rotation,still,ship)
  print(e)
  return e
end

function line_enemy_ai(enemy,dt)
  local velocity = 100
  print(velocity)
  local r = math.rad(enemy.rotation)
  local dx = math.sin(r)* velocity * dt
  local dy = -math.cos(r)*velocity*dt

  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  enemy.tick = enemy.tick + dt
  for i=1, cols_len do
    local col = cols[i]

    if col.other.ctype =="player" then
      resetGame()
      return 3
    end


  end

  if  enemy.tick > 0.5 then
    add_bullet(enemy.x,enemy.y,180,"standard","enemy")

    enemy.tick = 0
  end
  return false
end
