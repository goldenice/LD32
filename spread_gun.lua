function get_spread()
  local spread = {}
  spread.tick = 0
  spread.salvos = 40
  spread.tock = 0
  spread.timeper = 1/32

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
    local rotation = math.random()*90-45

    add_standard_bullet(gamestate.player.x, gamestate.player.y , rotation, "player")
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
