function add_asteroid_small_enemy(gamestate,x,y,tick,scroll,rotation)
  local ship =  enemy_parts["asteroid_small"]
  local still = false
  local e = add_enemy(gamestate,x,y,32,32,0,0,tick,scroll,rotation,still,ship,asteroid_small_draw)
  e.health = 3
  e.score = 10
  e.rotation = math.random()*360
  e["ai"] = asteroid_small_enemy_ai

  return e
end

function asteroid_small_enemy_ai(enemy,dt)
  local velocity = 100
  local r = math.rad(enemy.rotation)
  local dx = math.sin(r)* velocity * dt
  local dy = -math.cos(r)*velocity*dt
  enemy.tick = 0

  return dx,dy
end
function asteroid_small_draw( enemy  )

  if enemy.still then

    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
  else
    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, enemy.rotation, 1, 1, width / 2, height / 2)
  end

end
