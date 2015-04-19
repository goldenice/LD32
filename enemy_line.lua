function add_line_enemy(gamestate,x,y,tick,scroll,rotation)
  local still = true
  local ship =  enemy_parts["line"]
  local e = add_enemy(gamestate,x,y,32,16,0,0,tick,scroll,rotation,still,ship,std_draw)
  e.health = 2
  e["ai"] = line_enemy_ai
  return e
end

function line_enemy_ai(enemy,dt)
  local velocity = 100
  local r = math.rad(enemy.rotation)
  local dx = math.sin(r)* velocity * dt
  local dy = -math.cos(r)*velocity*dt


  if  tonumber(enemy.tick) > 0.5 then
    add_standard_bullet(enemy.x,enemy.y,180,"enemy")

    enemy.tick = 0
  end
  return dx,dy
end
function line_draw(enemy,dt)

end
