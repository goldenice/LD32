function add_rotating_tank_enemy(gamestate,x,y,tick,scroll,rotation)
  local ship =  enemy_parts["turret_base"]
  local still = true
  local e = add_enemy(gamestate,x,y,64,64,0,0,tick,scroll,rotation,still,ship,rotating_tank_draw)

  e.health = 5
  e.img2 =enemy_parts["turret_guns"]
  e.img3 =enemy_parts["turret_cover"]
  local dx = gamestate.player.x - e.x
  local dy = gamestate.player.y - e.y
  e.rot = 120
  e.xoffset2 = e.xoffset -12
  e.xoffset3 = e.xoffset
  e.yoffset3 = e.yoffset
  e.yoffset2 = e.yoffset -8
  local dist = math.sqrt(dx*dx+dy*dy)
  e.ddx = (dx) / (dist)
  e.ddy = (dy) / (dist)
  e["ai"] = rotating_tank_enemy_ai
  e.rotation = math.atan2 ( -e.ddx,e.ddy)
  return e
end

function rotating_tank_enemy_ai(enemy,dt)
  enemy.rot  = enemy.rot +  dt*80
  i = 0
  if enemy.y + gamestate.scroll > tonumber(enemy.ascroll) then
    i=1
  end
    if  tonumber(enemy.tick) > 0.1 then

      add_standard_enemy_bullet(enemy.x +32- 38*math.sin(math.rad(-enemy.rot)),enemy.y+32 - 38*math.cos(math.rad(-enemy.rot)),enemy.rot,"enemy")
      enemy.tick = 0
    end
  return 0,0.8*scroll*dt*i
end
function rotating_tank_draw( enemy  )


    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
    love.graphics.draw(enemy.img2, enemy.x+0.5*width-enemy.xoffset2,  enemy.y+0.5*height-enemy.yoffset2, math.rad(enemy.rot+180) , 1, 1, enemy.width , enemy.height)
    love.graphics.draw(enemy.img3, enemy.x+0.5*width-enemy.xoffset3,  enemy.y+0.5*height-enemy.yoffset3, 0 , 1, 1, width / 2, height / 2)


end
