function add_suicide_enemy(gamestate,x,y,tick,scroll,rotation)
  local ship =  enemy_parts["suicide"]
  local still = false
  local e = add_enemy(gamestate,x,y,32,32,0,0,tick,scroll,rotation,still,ship,suicide_draw)
  e.health = 3
  local dx = gamestate.player.x - e.x
  local dy = gamestate.player.y - e.y
  local dist = math.sqrt(dx*dx+dy*dy)
  e.ddx = (dx) / (dist)
  e.ddy = (dy) / (dist)
  e["ai"] = suicide_enemy_ai

  e.rotation = math.atan2 ( -e.ddx,e.ddy)
  return e
end

function suicide_enemy_ai(enemy,dt)
  local velocity = 100
  local r = math.rad(enemy.rotation)

  local dx = gamestate.player.x - enemy.x
  local dy = gamestate.player.y - enemy.y
  local dist = math.sqrt(dx*dx+dy*dy)
  if dist > 400 then
  enemy.ddx = (dx) / (dist)
  enemy.ddy = (dy) / (dist)
  end

  local dx = enemy.ddx* velocity * dt
  local dy = enemy.ddy*velocity*dt
  return dx,dy
end
function suicide_draw( enemy  )

  if enemy.still then

    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
  else
    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, enemy.rotation, 1, 1, width / 2, height / 2)
  end

end
