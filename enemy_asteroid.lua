function add_asteroid_enemy(gamestate,x,y,tick,scroll,rotation)
  local ship =  enemy_parts["asteroid_big"]
  local still = false
  local e = add_enemy(gamestate,x,y,48,32,0,0,tick,scroll,rotation,still,ship,asteroid_draw)
  e.yoffset = 16
  e.xoffset = 8
  e.health = 3

  e.isAsteroid = true
  e["ai"] = asteroid_enemy_ai

  return e
end

function asteroid_enemy_ai(enemy,dt)
  local velocity = 100
  local r = math.rad(enemy.rotation)
  local dx = math.sin(r)* velocity * dt
  local dy = -math.cos(r)*velocity*dt
  enemy.tick = 0

  return 0,0
end
function asteroid_draw( enemy  )

  if enemy.still then

    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
  else
    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, enemy.rotation, 1, 1, width / 2, height / 2)
  end

end
