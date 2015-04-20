function get_circle()
  local spread = {}
  spread.tick = 0
  spread.salvos = 40
  spread.tock = 0
  spread.timeper = 1/128

  spread.charge=0
  spread.update = update_circle
  spread.trigger = trigger_circle
  spread.draw  = draw_circle
  return spread
end
function update_circle(dt)
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.timeper then
    gamestate.special.tick = 0
    local rotation = math.random()*360

    add_standard_bullet(gamestate.player.x, gamestate.player.y , rotation, "player")
    gamestate.special.tock = gamestate.special.tock  + 1
  end
  if gamestate.special.tock   > gamestate.special.salvos then
    gamestate.special_triggered=false
  end


end

function trigger_circle()

end

function draw_circle ()

end
