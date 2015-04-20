function get_sides()
  local spread = {}
  spread.tick = 0
  spread.salvos = 40
  spread.tock = 0
  spread.timeper = 1/32

  spread.charge=0
  spread.update = update_sides
  spread.trigger = trigger_sides
  spread.draw  = draw_sides
  return spread
end
function update_sides(dt)
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.timeper then
    gamestate.special.tick = 0
    local rotation = 80
    add_standard_bullet(gamestate.player.x, gamestate.player.y , rotation, "player")
    rotation = -80
    add_standard_bullet(gamestate.player.x, gamestate.player.y , rotation, "player")
    gamestate.special.tock = gamestate.special.tock  + 1
  end
  if gamestate.special.tock   > gamestate.special.salvos then
    gamestate.special_triggered=false
  end


end

function trigger_sides()

end

function draw_sides ()

end
