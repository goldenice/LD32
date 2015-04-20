require 'special_wreck'
require 'spread_gun'
require 'special_circle'
require 'special_sides'
require 'special_topleft'
require 'special_topright'
attacks = {
  wreck = get_wrecked,
  random_fwd = get_spread,
  circle = get_circle,
  topleft = get_topleft,
  topright = get_topright,
  sides = get_sides

}
function draw_special()
  if gamestate.special_triggered then
  gamestate.special.draw()
end

end
function trigger_special()
  if gamestate.special_triggered then
    gamestate.special.trigger()
  end
end

function start_ball()

  if   not gamestate.special_triggered then
    gamestate.shoot_time = 0
    gamestate.special_loose=false

    local specialname = gamestate.special_attacks["wreck"]

    gamestate.special = attacks["wreck"]()
    gamestate.special_triggered = true

    return true
  end
  return false
end
function start_special()

  if gamestate.n_specials+1 <=#gamestate.special_attacks and not gamestate.special_triggered then
    gamestate.shoot_time = 0
    gamestate.special_loose=false
    gamestate.n_specials = gamestate.n_specials +1
    print(gamestate.special_attacks[gamestate.n_specials])
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
