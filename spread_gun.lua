function get_spread()
  local spread = {}
  spread.tick = 0
  spread.salvos = 20
  spread.tock = 0
  spread.timeper = 1/16

  spread.charge=0
  spread.update = update_spread
  spread.trigger = trigger_spread
  spread.draw  = draw_spread
  return spread
end
function update_spread(dt)
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.timeper then
    gamestate.special.tick = 0
    local rr = (math.random(0,6)-3)*30
    if not rr then
      print("none")
    end
    add_standard_bullet(gamestate.player.x, gamestate.player.y , rr, "player")
    gamestate.special.tock = gamestate.special.tock  + 1
  end
  if gamestate.special.tock   > gamestate.special.salvos then
    gamestate.special_triggered=false
  end


end

function trigger_spread()

end

function draw_spread ()

end
