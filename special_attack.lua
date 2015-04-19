require 'special_wreck'
attacks = {
  wreck = get_wrecked
}
function draw_special()
  if gamestate.special_triggered then
  gamestate.special.draw()
end
end
function start_special()
  gamestate.shoot_time = 0

  if gamestate.n_specials+1 <=#gamestate.special_attacks then
    gamestate.n_specials = gamestate.n_specials +1
    local specialname = gamestate.special_attacks[gamestate.n_specials]
    gamestate.special = attacks[specialname]()
    gamestate.special_triggered = true
  end
end
function update_special(dt)
  if gamestate.special_triggered then
    gamestate.special.update(dt)

  end
end
