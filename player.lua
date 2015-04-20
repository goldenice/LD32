deadzone = 0.3
flatout = 0.8

-- Player functions

function updatePlayer( dt)
  local speed = gamestate.player.speed
  if not gamestate.playing then
    gamestate.retry_wait  = gamestate.retry_wait  + dt
    gamestate.retry_wait_tick= gamestate.retry_wait_tick + dt
    if gamestate.retry_wait_tick  > 0.5 then
      gamestate.retry_shown = not  gamestate.retry_shown

    end
    if gamestate.retry_wait  > gamestate.retry_max_wait then
      gamestate.playing = true
    end
  end
  local dx, dy = 0, 0

  dx = 0
  dy = 0
  gamestate.shoot_time =     gamestate.shoot_time + dt
  if joystick then
    if not gamestate.boss_intro then
    if joystick:isDown(1 )  and gamestate.shoot_time > gamestate.shoot_timeout then
      gamestate.shoot_time = 0
      add_standard_bullet(gamestate.player.x, gamestate.player.y ,0, "player")
      shoot_effect(0,0)
    end
    if joystick:isDown(5 )   then
      if not gamestate.special_triggered then
        if trigger_special() then
        end
      end
    end
    if joystick:isDown(6 )   then
      trigger_special()

    end
    elseif not gamestate.special_triggered then
      gamestate.special_loose=true
    end
    dx = joystick:getGamepadAxis("leftx") * dt * gamestate.player.speed
    dy = joystick:getGamepadAxis("lefty") * dt * gamestate.player.speed*1.5
  else
  if love.keyboard.isDown("right") then
    dx = 1.2*dt*gamestate.player.speed
  elseif love.keyboard.isDown("left") then
    dx = -1.2*dt*gamestate.player.speed
  end
  if love.keyboard.isDown("up") then
    dy = -0.5*dt *1.5*gamestate.player.speed
  elseif love.keyboard.isDown("down") then
    dy = 0.5*dt *1.5*gamestate.player.speed
  end
  if not gamestate.boss_intro then
  if love.keyboard.isDown(" ")  and gamestate.shoot_time > gamestate.shoot_timeout then
    gamestate.shoot_time = 0
    add_standard_bullet(gamestate.player.x, gamestate.player.y ,0, "player")
    shoot_effect(0,0)
  end

  if love.keyboard.isDown("z")   then
       trigger_special()

  end
  if love.keyboard.isDown("lshift")   then
    if gamestate.special_loose then
      if start_special() then
        gamestate.shoot_time = 0
      end
    end
    elseif not gamestate.special_triggered then
    gamestate.special_loose=true
  end
  end
  end
  moved = true
  if dy > 0 then
    dy = dy -scroll * dt
  end
  local multiplier =(1-deadzone)
  if joystick then
    if math.abs(dx) < math.abs(deadzone) then
      dx = 0
      moved = false
    else
      if dx > 0 then
        dx = (dx - deadzone*dt * gamestate.player.speed)/(multiplier)
      else
        dx = (dx + deadzone*dt * gamestate.player.speed)/(multiplier)
      end
    end
    if dy*dy < deadzone*deadzone then
      dy = 0
      moved = false
    else
      if dy > 0 then
        dy = (dy - deadzone*dt * gamestate.player.speed)/(1-deadzone+flatout)
      else
        dy = (dy + deadzone*dt * gamestate.player.speed)/(1-deadzone+flatout)
      end
    end
  end
  if moved then
    --gamestate.player.r = math.atan2(dy,dx)
  end
  dy = dy + dt*scroll

  if dx ~= 0 or dy ~= 0 then
    local cols
    if gamestate.playing then
    gamestate.player.x, gamestate.player.y, cols, cols_len = gamestate.world:move(gamestate.player, gamestate.player.x + dx, gamestate.player.y + dy, playerfilter)
  else
    gamestate.player.x, gamestate.player.y, cols, cols_len = gamestate.world:move(gamestate.player, gamestate.player.x + dx, gamestate.player.y + dy, crossFilter)

  end
  if gamestate.player.x  < 24 then
    gamestate.player.x = 24
  end
  if gamestate.player.x > level_width-32 then
    gamestate.player.x = level_width-32
  end
    if gamestate.player.y > -2*tile_width+windowHeight/zoom-gamestate.scroll then
      gamestate.player.y = -2*tile_width+windowHeight/zoom-gamestate.scroll
    end
    if gamestate.player.y < -gamestate.scroll then
      gamestate.player.y = -gamestate.scroll
    end
    gamestate.shadow=false
    if gamestate.playing then
    for i=1, cols_len do
      local col = cols[i]
      if col.other.isEnemy then
        player_is_hit()
        return
      end
      if col.other.isPart then
        player_is_hit()
      end
      if col.other.isWall then
        resetGame()

      end
      if col.other.ctype == "death" then
        player_is_hit()
        return
      end
      if col.other.ctype == "end" then
        nextLevel()
      end
      if col.other.isPickup then
        eat_pickup(col.other)
      end
    end

    b,a,cols,cols_len = gamestate.shadowworld:move(gamestate.player, gamestate.player.x + dx, gamestate.player.y + dy, playerfilter)
    for i=1, cols_len do
      local col = cols[i]

      if col.other.isShadow then
        gamestate.shadow=true

      end
    end
  end
end




end

function playerfilter(item, other)
  if     other.isBullet   then return 'cross'
  elseif     other.isShadow   then return 'cross'
  elseif other.isWall   then return 'slide'
  elseif other.isPickup   then return 'cross'
  elseif other.isSpring then return 'bounce'
  else return 'slide'
  end
  -- else return nil
end

function crossFilter(item, other)

  return 'cross'

  -- else return nil
end
function drawPlayer()
  if gamestate.playing then
  if gamestate.shadow then
    love.graphics.setShader(bw_shader)
    love.graphics.setColor(255, 255, 255, 50) -- red, green, blue, opacity (this would be white with 20% opacity

    love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset+shadow_x,  gamestate.player.y+0.5*height-gamestate.player.yoffset+shadow_y, gamestate.player.r, 1, 1, width / 2, height / 2)

    love.graphics.setColor(255, 255, 255, 255) -- red, green, blue, opacity (this would be white with 20% opacity)
    love.graphics.setShader()
  end
  love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset,  gamestate.player.y+0.5*height-gamestate.player.yoffset, gamestate.player.r, 1, 1, width / 2, height / 2)
  else
    if gamestate.retry_shown then
      love.graphics.setColor(255, 255, 255, 90) -- red, green, blue, opacity (this would be white with 20% opacity

      love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset,  gamestate.player.y+0.5*height-gamestate.player.yoffset, gamestate.player.r, 1, 1, width / 2, height / 2)
      love.graphics.setColor(255, 255, 255, 255) -- red, green, blue, opacity (this would be white with 20% opacity)


    end
  end



end
function player_is_hit ()
  if gamestate.playing then
  gamestate.retry = gamestate.retry -1

  if gamestate.retry == 0 then
    resetGame()
  else
    gamestate.retry_wait = 0
    gamestate.retry_max_wait = 2
    gamestate.retry_wait_tick = 0
    gamestate.playing = false
    gamestate.retry_shown = false
  end
end
end
