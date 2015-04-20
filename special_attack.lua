require 'special_wreck'
require 'spread_gun'
attacks = {
  wreck = get_wrecked,
  random_fwd = get_spread

}
function draw_special()
  if gamestate.special_triggered then
  gamestate.special.draw()
end

end
function start_special()

  if gamestate.n_specials+1 <=#gamestate.special_attacks and not gamestate.special_triggered then
    gamestate.shoot_time = 0
    gamestate.special_loose=false
    gamestate.n_specials = gamestate.n_specials +1
    local specialname = gamestate.special_attacks[gamestate.n_specials]

    gamestate.special = attacks[specialname]()
    gamestate.special_triggered = true

    return true
  end
  return false
end
function update_special(dt)
  if gamestate.special_triggered then
    gamestate.special.update(dt)
  end
end
