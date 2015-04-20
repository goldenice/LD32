function get_circle()
  local spread = {}
  spread.tick = 0
  spread.salvos = 2
  spread.tock = 0
  spread.timeper = 1
  spread.firing = false
  spread.charge=0
  spread.subbullet = 0
  spread.bullet_time = 0.5
  spread.bullets=0
  spread.update = update_circle
  spread.trigger = trigger_circle
  spread.draw  = draw_circle
  return spread
end
function update_circle(dt)
  gamestate.special.tick = gamestate.special.tick + dt
  if gamestate.special.tick > gamestate.special.timeper then
    gamestate.special.tick = 0
    gamestate.special.firing = true
    gamestate.special.subbullet = 0
    gamestate.special.bullet_time = 0.05
    gamestate.special.bullets=0
  end
  if gamestate.special.firing then
  gamestate.special.subbullet = gamestate.special.subbullet + dt
  if gamestate.special.subbullet > gamestate.special.bullet_time then
    gamestate.special.bullets= gamestate.special.bullets + 1
    local rotation = math.random()*360

    add_standard_bullet(gamestate.player.x, gamestate.player.y , rotation, "player")

      if gamestate.special.bullets > 80 then
        gamestate.special.firing = false
        gamestate.special.tock = gamestate.special.tock  + 1

      end
    end
  end
  if gamestate.special.tock   > gamestate.special.salvos then
    gamestate.special_triggered=false
  end


end

function trigger_circle()

end

function draw_circle ()

end
