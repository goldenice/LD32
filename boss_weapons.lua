function auto_aim(x,y,gamestate)
  local dx = gamestate.player.x - x
  local dy = gamestate.player.y - y


  return math.deg(math.atan2(dx,-dy))
end
function boss_ion_cannon(gamestate,dt)
  local e = gamestate.boss
  dt = dt * e.timer_multiplier
  e.ion_cannon_timer = e.ion_cannon_timer+dt
  if e.ion_cannon_timer > 0.4 then
    e.ion_cannon_timer = 0
    add_ion_enemy_bullet(e.x+16, e.y+80 , math.rad(180)+auto_aim(e.x,e.y,gamestate), "enemy")
  end
end
function boss_left_cannon(gamestate,dt)
  local e = gamestate.boss
  dt = dt * e.timer_multiplier
  e.left_cannon_timer = e.left_cannon_timer+dt
  if e.left_cannon_timer > 0.8 then
    e.left_cannon_timer = 0
    add_3_spread_bullet(e.x-16, e.y+42 , 180, "enemy")

  end

end
function boss_right_cannon(gamestate,dt)
  local e = gamestate.boss
  dt = dt * e.timer_multiplier
  e.right_cannon_timer = e.right_cannon_timer+dt
  if e.right_cannon_timer > 0.8 then
    e.right_cannon_timer = 0
    add_3_spread_bullet(e.x+64, e.y+42 , 180, "enemy")

  end
end
function boss_circle_cannon(gamestate,dt)
  local e = gamestate.boss
  dt = dt * e.timer_multiplier
  e.circle_timer = e.circle_timer+dt
  if e.circle_timer > 4 then
    e.circle_timer = 0
    add_360_spread_bullet(e.x+24,e.y+14,e.circle_motion_counter*18,"enemy")

  end
end
function circle_motion_timer(gamestate,dt)
  local e = gamestate.boss
  dt = dt * e.timer_multiplier
  e.circle_motion_timer = e.circle_motion_timer+dt

  if e.circle_motion_timer > 4 then
    e.circle_motion_timer = 0
    e.boss_circle_motion_cannon_active = true
  end
  if e.boss_circle_motion_cannon_active then
    e.circle_motion_single_bullet = e.circle_motion_single_bullet + dt
    if e.circle_motion_single_bullet>0.05  then
       e.circle_motion_counter = e.circle_motion_counter + 1
       e.circle_motion_single_bullet = 0

       add_standard_enemy_bullet(e.x+24,e.y+14,e.circle_motion_counter*18,"enemy")
       if e.circle_motion_counter*18 > 360 then
         e.circle_motion_counter = 0
         e.circle_motion_single_bullet = 0
        e.boss_circle_motion_cannon_active = false

     end


    end
  end
end
