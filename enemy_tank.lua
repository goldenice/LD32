function add_tank_enemy(gamestate,x,y,tick,scroll,rotation)
  local ship =  enemy_parts["turret_base"]
  local still = true
  local e = add_enemy(gamestate,x,y,64,64,0,0,tick,scroll,rotation,still,ship,tank_draw)
  e.health = 3
  e.img2 =enemy_parts["turret_guns"]
  e.img3 =enemy_parts["turret_cover"]
  local dx = gamestate.player.x - e.x
  local dy = gamestate.player.y - e.y

  e.xoffset2 = e.xoffset +32
  e.xoffset3 = e.xoffset
  e.yoffset3 = e.yoffset
  e.yoffset2 = e.yoffset + 32
  local dist = math.sqrt(dx*dx+dy*dy)
  e.ddx = (dx) / (dist)
  e.ddy = (dy) / (dist)
  e["ai"] = tank_enemy_ai

  e.rotation = math.atan2 ( -e.ddx,e.ddy)
  return e
end

function tank_enemy_ai(enemy,dt)

    if  tonumber(enemy.tick) > 0.5 then
      add_standard_enemy_bullet(enemy.x +32,enemy.y+64,180,"enemy")

      enemy.tick = 0
    end


  return 0,0.8*scroll*dt
end
function tank_draw( enemy  )


    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
    love.graphics.draw(enemy.img2, enemy.x+0.5*width-enemy.xoffset2,  enemy.y+0.5*height-enemy.yoffset2, 0 , 1, 1, width / 2, height / 2)
    love.graphics.draw(enemy.img3, enemy.x+0.5*width-enemy.xoffset3,  enemy.y+0.5*height-enemy.yoffset3, 0 , 1, 1, width / 2, height / 2)


end
