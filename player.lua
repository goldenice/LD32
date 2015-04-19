deadzone = 0.3

-- Player functions

function updatePlayer( dt)
  local speed = gamestate.player.speed

  local dx, dy = 0, 0

  dx = 0
  dy = 0
  gamestate.shoot_time =     gamestate.shoot_time + dt
  if joystick:isDown(1 )  and gamestate.shoot_time > gamestate.shoot_timeout then
    gamestate.shoot_time = 0
    add_bullet(gamestate.player.x, gamestate.player.y ,0, "standard", "player")
  end
  dx = joystick:getGamepadAxis("rightx") * dt * gamestate.player.speed
  dy = joystick:getGamepadAxis("righty") * dt * gamestate.player.speed
  moved = true


  if math.abs(dx) < math.abs(deadzone) then
    dx = 0
    moved = false
  else
    if dx > 0 then
      dx = (dx - deadzone*dt * gamestate.player.speed)/(1-deadzone)
    else
      dx = (dx + deadzone*dt * gamestate.player.speed)/(1-deadzone)
    end
  end
  if dy*dy < deadzone*deadzone then
    dy = 0
    moved = false
  else
    if dy > 0 then
      dy = (dy - deadzone*dt * gamestate.player.speed)/(1-deadzone)
    else
      dy = (dy + deadzone*dt * gamestate.player.speed)/(1-deadzone)
    end
  end
  if moved then
    --gamestate.player.r = math.atan2(dy,dx)
  end
  dy = dy + dt*scroll

  if dx ~= 0 or dy ~= 0 then
    local cols
    gamestate.player.x, gamestate.player.y, cols, cols_len = gamestate.world:move(gamestate.player, gamestate.player.x + dx, gamestate.player.y + dy, playerfilter)
    if gamestate.player.y > -2*tile_width+windowHeight/2-gamestate.scroll then
      gamestate.player.y = -2*tile_width+windowHeight/2-gamestate.scroll
    end
    if gamestate.player.y < -gamestate.scroll then
      gamestate.player.y = -gamestate.scroll
    end
    gamestate.shadow=false
    for i=1, cols_len do
      local col = cols[i]
      if col.other.isEnemy then
        print("honorable death")
        resetGame()
        return
      end
      if col.other.isShadow then
        print("honorable death")
        gamestate.shadow=true

      end
      if col.other.ctype == "death" then
        print("stupid death")
        resetGame()
        return
      end
      if col.other.ctype == "end" then
        nextLevel()
      end
    end
  end
end

function playerfilter(item, other)
  if     other.isBullet   then return 'cross'
  elseif     other.isShadow   then return 'cross'
  elseif other.isWall   then return 'slide'
  elseif other.isUpgrade   then return 'cross'
  elseif other.isSpring then return 'bounce'
  else return 'slide'
  end
  -- else return nil
end

function drawPlayer()
  love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset,  gamestate.player.y+0.5*height-gamestate.player.yoffset, 180, 1, 1, gamestate.player.width / 2, gamestate.player.height / 2)
end
