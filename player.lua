deadzone = 0.30

-- Player functions

function updatePlayer( dt)
  local speed = gamestate.player.speed

  local dx, dy = 0, 0
  --if love.keyboard.isDown('right') or joystick:isGamepadDown("dpright") then
--
  --  gamestate.player.r = gamestate.player.r + dt
  --elseif love.keyboard.isDown('left') or joystick:isGamepadDown("dpleft") then
  --  gamestate.player.r=gamestate.player.r -dt
--
--  end
  --if love.keyboard.isDown('down') or joystick:isGamepadDown("dpdown")  then
  --  dx = -speed *math.cos(gamestate.player.r) *dt
--    dy = -speed *math.sin(gamestate.player.r) *dt
  --elseif love.keyboard.isDown('up') or joystick:isGamepadDown("dpup") then
  --  dx = speed *math.cos(gamestate.player.r)* dt
  --  dy = speed *math.sin(gamestate.player.r) *dt
  --end
  dx = 0
  dy = 0
  dx = joystick:getGamepadAxis("leftx") * dt * gamestate.player.speed
  dy = joystick:getGamepadAxis("lefty") * dt * gamestate.player.speed
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
    for i=1, cols_len do
      local col = cols[i]
      if col.other.ctype == "death" then
        resetGame()
        return
      end
      if col.other.ctype == "end" then
        nextLevel()

      end
    end
  end
end

local playerfilter = function(item, other)
  if     other.isUpgrade   then return 'cross'
  elseif other.isWall   then return 'slide'
  elseif other.isEnd   then return 'touch'
  elseif other.isSpring then return 'bounce'
  else return 'slide'
  end
  -- else return nil
end
