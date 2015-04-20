function get_topleft()
  local spread = {}
  spread.tick = 0
  spread.salvos = 40
  spread.tock = 0
  spread.timeper = 1/32

  spread.charge=0
  spread.update = update_topleft
  spread.trigger = trigger_topleft
  spread.draw  = draw_topleft
  return spread
end
function update_topleft(dt)
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.timeper then
    gamestate.special.tick = 0
    local rotation = -30

    add_standard_bullet(gamestate.player.x, gamestate.player.y , rotation, "player")
    gamestate.special.tock = gamestate.special.tock  + 1
  end
  if gamestate.special.tock   > gamestate.special.salvos then
    gamestate.special_triggered=false
  end


end

function trigger_topleft()

end

function draw_topleft ()

end
