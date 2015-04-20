local wreckingball = {}

function get_wrecked()
  wreckingball = {}
  wreckingball.tick = 0
  wreckingball.load_ticks = 1
  wreckingball.charge_ticks = 5.7
  wreckingball.flying_ticks = 3
  wreckingball.charge=0
  wreckingball.xx = 0
  wreckingball.yy = 0
  wreckingball.x = 0
  wreckingball.y = 0
  wreckingball.w = 32
  wreckingball.h = 32
  wreckingball.width = 32
  wreckingball.height = 32
  wreckingball.dist = 0
  wreckingball.rotation = 0
  wreckingball.xoffset = -16
  wreckingball.speed = 0
  wreckingball.yoffset =-16

  wreckingball.update = load_wreckingball_update
  wreckingball.trigger = trigger_wreckingball
  wreckingball.draw  = draw_wreckingball
  return wreckingball
end
function load_wreckingball_update(dt)
  gamestate.special.tick = gamestate.special.tick + dt*2
  gamestate.special.yy = gamestate.special.yy + 100*dt*2
  gamestate.special.y = gamestate.special.yy +gamestate.player.y
  gamestate.special.x = gamestate.special.xx+gamestate.player.x

  if gamestate.special.tick > gamestate.special.load_ticks then
    gamestate.special.tick = 0
    gamestate.special.dist = gamestate.special.yy
    gamestate.special.update =charge_wreckingball_update
    gamestate.n_blocks = gamestate.n_blocks + 1
    gamestate.blocks["a"..gamestate.n_blocks] = gamestate.special
    gamestate.special.block =gamestate.n_blocks

    gamestate.world:add(gamestate.special,gamestate.special.x,gamestate.special.y,gamestate.special.w,gamestate.special.h)
  end
end
function charge_wreckingball_update(dt)
  local actualX, actualY, cols, len = gamestate.world:check(gamestate.special, gamestate.special.x, gamestate.special.y)
  for i=1,len do
    local col = cols[i]
    if cols[i].other.isEnemy then
      if cols[i].other.isBoss and not cols[i].other.isPart then
      else
          delete_enemy(cols[i].other)
      end
    end
  end
  gamestate.special.tick = gamestate.special.tick + dt
  gamestate.special.charge = gamestate.special.charge + dt
  gamestate.special.speed = gamestate.special.speed+dt*50
  gamestate.special.rotation = gamestate.special.rotation + gamestate.special.speed*dt
  gamestate.special.xx = -gamestate.special.dist * math.sin(math.rad(gamestate.special.rotation))
  gamestate.special.yy = gamestate.special.dist *math.cos(math.rad(gamestate.special.rotation))
  gamestate.special.x = gamestate.special.xx + gamestate.player.x
  gamestate.special.y = gamestate.special.yy + gamestate.player.y
  if gamestate.special.tick > gamestate.special.charge_ticks then
    gamestate.special.tick = 0
    gamestate.special.update =fire_wrecking_ball
  end

end
function trigger_wreckingball ()
  if gamestate.special.update == charge_wreckingball_update then
    gamestate.special.tick = 0
    gamestate.special.update =fire_wrecking_ball
  end
end
function fire_wrecking_ball(dt)
    gamestate.special.tick = 0
    gamestate.special_triggered=false
    gamestate.world:remove(gamestate.special)
    gamestate.blocks["a"..gamestate.special.block] = nil
    wrecking = add_wreckingball(gamestate.special.x,gamestate.special.y,270+gamestate.special.rotation,player)
    wrecking.speed = gamestate.special.speed*2


end

function draw_wreckingball()
  local width = 16
  local height = 16
  love.graphics.draw(bullet_type_images["wreck"],gamestate.special.x+0.5*width-gamestate.special.xoffset,gamestate.special.y+0.5*height-gamestate.special.yoffset, math.rad(gamestate.special.rotation) , 1, 1, width,height)

end
function wreck_box(item,other)

  return 'cross'
end
