require 'boss_weapons'
function load_boss_resources()


  boss_initial_img =  love.graphics.newImage("assets/entity/enemies/boss_001_noshields_noorb.png")

  boss_first_img  =love.graphics.newImage("assets/entity/enemies/boss_001_idle.png")
  boss_first_grid = anim8.newGrid(128, boss_first_img:getHeight(), boss_first_img:getWidth(), boss_first_img:getHeight())
  boss_first_animation =  anim8.newAnimation(boss_first_grid('1-2',1), 0.1)
  boss_second = love.graphics.newImage("assets/entity/enemies/boss_001_nobottom.png")
  boss_noleft  =love.graphics.newImage("assets/entity/enemies/boss_001_nobottom_noleft.png")
  boss_noright  =love.graphics.newImage("assets/entity/enemies/boss_001_nobottom_noright.png")
  boss_final  =love.graphics.newImage("assets/entity/enemies/boss_001_bare.png")
end
function add_boss_enemy(gamestate,x,y,tick,scroll,rotation)
  local still = true
  local ship =  nil
  local e = add_enemy(gamestate,x,y,64,32,0,0,tick,scroll,rotation,still,ship,boss_enemy_initial_draw)
  e.health = 90
  e.first_health = 30
  e.left_health = 30
  e.yoffset = 0
  e.xoffset = 32
  e.right_health = 30
  e.isBoss = true
  e.front_col = {x = 0, y=64,width=64,height=16}
  e.front_col.isPart = true
  e.front_col.part = "front"
  e.ydirection = 1
  e.cy = 0
  e.time_x = 0
  e.y_timer=0
  e.shield_left_col = {x = -32, y=72,width=48,height=16}
  e.shield_right_col = {x = 48, y=72,width=48,height=16}
  e.shield_left_col.isShield = true
  e.shield_right_col.isShield = true
  e.left_col ={x = -32, y=16,width=48,height=32}
  e.left_col.isPart = true
  e.left_col.part = "left"
  e.right_col ={x = 48, y=16,width=48,height=32}
  e.right_col.isPart = true
  e.right_col.part = "right"
  add_enemy_part(gamestate,e.front_col,e)
  add_enemy_part(gamestate,e.left_col,e)
  add_enemy_part(gamestate,e.right_col,e)
  add_enemy_part(gamestate,e.shield_left_col,e)
  add_enemy_part(gamestate,e.shield_right_col,e)
  print(e.front_col.block)
  print(e.left_col.block..":"..e.left_col.x..":"..e.x..":"..e.left_col.y..":"..e.y)

  gamestate.boss = e
  reset_timers (gamestate,e)
  e["ai"] = boss_enemy_phase_in_ai
  return e
end

function reset_timers (gamestate,e)
  e.timer_multiplier = 1
  e.circle_timer = 0
  e.left_cannon_timer = 0
  e.right_cannon_timer = 0.25
  e.ion_cannon_timer = 0
  e.boss_circle_motion_cannon_active = false
  e.circle_motion_timer = 2
  e.circle_motion_single_bullet = 0
  e.circle_motion_counter = 0
  e.fwd_gun_timer = 0
end
function add_enemy_part(gamestate,part,e)
  part.w = part.width
  part.h = part.height
  part.x = part.x + e.x
  part.y = part.y + e.y
  gamestate.world:add(part,part.x,part.y,part.width,part.height)
  gamestate.n_blocks = gamestate.n_blocks + 1
  gamestate.blocks["a"..gamestate.n_blocks] = part
  gamestate.boss_intro = true
  part.block =gamestate.n_blocks


end
function strafe(enemy,dt)
  local velocity = 120

  local ddx = enemy.ydirection *velocity* dt
  enemy.time_x = enemy.time_x + dt
  if enemy.time_x > 1 then
    enemy.ydirection = -enemy.ydirection
    enemy.time_x = 0
  end


  return ddx
end
-- initial / loading stage
--
--
--
function boss_enemy_phase_in_ai(enemy,dt)
  local velocity = 50
  scroll=-80

  dy = -0.2*scroll*dt
  if gamestate.boss.y + gamestate.scroll > 100 then
    enemy["ai"] = boss_first_stage_start_ai
    enemy["draw"] = boss_enemy_first_stage_draw
    gamestate.boss_active = true
    gamestate.boss_intro = false
  end
  return 0,0
end

-- first stage stage

--e.first_stage
--e.left
--e.right
function boss_first_stage_start_ai(enemy,dt)
  boss_first_animation:update(dt)
  velocity = 50
  boss_ion_cannon(gamestate,dt)

  local dx = 0
  if enemy.x > gamestate.player.x-32 then
    dx =  -velocity * dt
  else
    dx =  velocity * dt
  end
  local dy = scroll*dt
  dx = dx + strafe(enemy,dt)
  enemy.dx = dx
  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  enemy.front_col.x, enemy.front_col.y, cols, cols_len =gamestate.world:move(enemy.front_col, enemy.front_col.x + dx, enemy.front_col.y + dy,enemyfilter)
  enemy.shield_left_col.x, enemy.shield_left_col.y, cols, cols_len =gamestate.world:move(enemy.shield_left_col, enemy.shield_left_col.x + dx, enemy.shield_left_col.y + dy,enemyfilter)
  enemy.shield_right_col.x, enemy.shield_right_col.y, cols, cols_len =gamestate.world:move(enemy.shield_right_col, enemy.shield_right_col.x + dx, enemy.shield_right_col.y + dy,enemyfilter)
  enemy.left_col.x, enemy.left_col.y, cols, cols_len =gamestate.world:move(enemy.left_col, enemy.left_col.x + dx, enemy.left_col.y + dy,enemyfilter)
  enemy.right_col.x, enemy.right_col.y, cols, cols_len =gamestate.world:move(enemy.right_col, enemy.right_col.x + dx, enemy.right_col.y + dy,enemyfilter)

  if  tonumber(enemy.tick) > 0.5 then
    add_standard_enemy_bullet(enemy.x,enemy.y,180,"enemy")

    enemy.tick = 0
  end
  if enemy.first_health < 0 then
    enemy["ai"] = boss_second_stage_start_ai
    enemy["draw"] = boss_enemy_initial_draw
    add_effect("explosion",enemy.shield_left_col.x,enemy.shield_left_col.y)
    add_effect("explosion",enemy.shield_right_col.x,enemy.shield_right_col.y)
    add_effect("explosion",enemy.front_col.x,enemy.front_col.y)

    gamestate.world:remove(enemy.shield_left_col)
    gamestate.world:remove(enemy.shield_right_col)

    gamestate.world:remove(enemy.front_col)
    gamestate.blocks["a"..enemy.shield_left_col.block] = nil
    gamestate.blocks["a"..enemy.shield_right_col.block] = nil
    gamestate.blocks["a"..enemy.front_col.block] = nil


  end
  return 0,0
end

-- second stage

function boss_second_stage_start_ai(enemy,dt)
  local velocity = 100
  local dx = 0
  boss_circle_cannon(gamestate,dt)
  circle_motion_timer(gamestate,dt)

    boss_left_cannon(gamestate,dt)
    boss_right_cannon(gamestate,dt)

    local dx = 0
    if enemy.x > gamestate.player.x-32 then
      dx =  -velocity * dt
    else
      dx =  velocity * dt
    end
    enemy.dx = dx

  local dy = scroll*dt
  enemy.left_col.x, enemy.left_col.y, cols, cols_len =gamestate.world:move(enemy.left_col, enemy.left_col.x + dx, enemy.left_col.y + dy,enemyfilter)
  enemy.right_col.x, enemy.right_col.y, cols, cols_len =gamestate.world:move(enemy.right_col, enemy.right_col.x + dx, enemy.right_col.y + dy,enemyfilter)
  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  if  tonumber(enemy.tick) > 0.5 then
    add_standard_enemy_bullet(enemy.x,enemy.y,180,"enemy")

    enemy.tick = 0
  end
  if enemy.right_health < 0 then
    enemy["ai"] = boss_enemy_third_left_stage_ai
    enemy["draw"] = boss_enemy_third_left_stage_draw
    gamestate.world:remove(enemy.right_col)
    gamestate.blocks["a"..enemy.right_col.block] = nil
    add_effect("explosion",enemy.right_col.x,enemy.right_col.y)

  end
  if enemy.left_health < 0 then
    enemy["ai"] = boss_enemy_third_right_stage_ai
    enemy["draw"] = boss_enemy_third_right_stage_draw
    gamestate.world:remove(enemy.left_col)
    gamestate.blocks["a"..enemy.left_col.block] = nil
    add_effect("explosion",enemy.left_col.x,enemy.left_col.y)
  end
  return 0,0
end
-- no left
function boss_enemy_third_right_stage_ai(enemy,dt)
  local velocity = 150
  boss_circle_cannon(gamestate,dt)
  circle_motion_timer(gamestate,dt)
  boss_right_cannon(gamestate,dt)
  local dx = 0

  if enemy.x > gamestate.player.x-32 then
    dx =  -velocity * dt
  else
    dx =  velocity * dt
  end
  enemy.dx = dx

  local dy = scroll*dt
  enemy.right_col.x, enemy.right_col.y, cols, cols_len =gamestate.world:move(enemy.right_col, enemy.right_col.x + dx, enemy.right_col.y + dy,enemyfilter)
  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  if  tonumber(enemy.tick) > 0.5 then
    add_standard_enemy_bullet(enemy.x,enemy.y,180,"enemy")

    enemy.tick = 0
  end
  if enemy.right_health < 0 then
    enemy["ai"] = boss_enemy_third_final_stage_ai
    enemy["draw"] = boss_enemy_final_stage_draw
    gamestate.world:remove(enemy.right_col)
    gamestate.blocks["a"..enemy.right_col.block] = nil
    add_effect("explosion",enemy.right_col.x,enemy.right_col.y)

  end
  return 0,0
end


-- no right
function boss_enemy_third_left_stage_ai(enemy,dt)
  local velocity = 150
  boss_circle_cannon(gamestate,dt)
  circle_motion_timer(gamestate,dt)
  boss_left_cannon(gamestate,dt)
  local dx = 0

  if enemy.x > gamestate.player.x-32 then
    local dx =  -velocity * dt
  else
    local dx =  velocity * dt
  end
  enemy.dx = dx

  local dy = scroll*dt
  enemy.left_col.x, enemy.left_col.y, cols, cols_len =gamestate.world:move(enemy.left_col, enemy.left_col.x + dx, enemy.left_col.y + dy,enemyfilter)
  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  if  tonumber(enemy.tick) > 0.5 then
    add_standard_enemy_bullet(enemy.x,enemy.y,180,"enemy")

    enemy.tick = 0
  end
  if enemy.left_health < 0 then
    add_effect("explosion",enemy.left_col.x,enemy.left_col.y)

    enemy["ai"] = boss_enemy_third_final_stage_ai
    enemy["draw"] = boss_enemy_final_stage_draw
    gamestate.world:remove(enemy.left_col)
    gamestate.blocks["a"..enemy.left_col.block] = nil
  end
  return 0,0
end

-- final
function boss_enemy_third_final_stage_ai(enemy,dt)
  local velocity = 200
  enemy.timer_multiplier = 5
  boss_circle_cannon(gamestate,dt)
  circle_motion_timer(gamestate,dt)
  boss_fwd_gun(gamestate,dt)
  local dx = 0

  if enemy.x > gamestate.player.x-32 then
    local dx =  -velocity * dt
  else
    local dx =  velocity * dt
  end
  dx = dx + strafe(enemy,dt)
  enemy.dx = dx

  local dy = scroll*dt
  enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
  if  tonumber(enemy.tick) > 0.5 then
    add_standard_enemy_bullet(enemy.x,enemy.y,180,"enemy")

    enemy.tick = 0
  end
  return 0,0
end

-- final

-- incoming boss
-- boss_001_noshields_noorb
function boss_enemy_initial_draw(enemy,dt)

    love.graphics.draw(boss_initial_img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)

end
-- boss first phase
-- boss_001_idle
function boss_enemy_first_stage_draw(enemy,dt)
  boss_first_animation:draw(boss_first_img, enemy.x-enemy.xoffset, enemy.y-enemy.yoffset)

end
-- no shields
-- boss_001_nobottom
function boss_enemy_second_stage_stage_draw(enemy,dt)
  love.graphics.draw(boss_second, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)

end

-- no left
-- boss_001_nobottom_noleft
function boss_enemy_third_right_stage_draw(enemy,dt)
  love.graphics.draw(boss_noleft, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)

end


-- no right
--boss_001_nobottom_noright
function boss_enemy_third_left_stage_draw(enemy,dt)
  love.graphics.draw(boss_noright, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)

end
-- end stage
-- boss_001_bare   boss_final
function boss_enemy_final_stage_draw(enemy,dt)
  love.graphics.draw(boss_final, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)

end
