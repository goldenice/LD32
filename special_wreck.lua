function get_wrecked()
  local wreckingball = {}
  wreckingball.tick = 0
  wreckingball.load_ticks = 1
  wreckingball.charge_ticks = 6
  wreckingball.flying_ticks = 3
  wreckingball.charge=0
  wreckingball.update = load_wreckingball_update
  wreckingball.trigger = trigger_wreckingball
  wreckingball.draw  = draw_wreckingball
  return wreckingball
end
function load_wreckingball_update(dt)
  print("loading ball")
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.load_ticks then
    gamestate.special.tick = 0
    gamestate.special.update =charge_wreckingball_update
  end

end
function charge_wreckingball_update(dt)
  print("swinging ball")
  gamestate.special.tick = gamestate.special.tick + dt
  gamestate.special.charge = gamestate.special.charge + dt
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
  print("firing ball"..gamestate.special.charge)
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.flying_ticks then
    gamestate.special.tick = 0
    gamestate.special_triggered=false
    print("end of ball")
  end
end

function draw_wreckingball()

end
