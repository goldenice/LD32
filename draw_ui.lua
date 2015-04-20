-- ui demensions: x: 320, y: 720

function load_ui_elements()
  bg  = love.graphics.newImage("assets/backgrounds/panel_001.png")
  life  = love.graphics.newImage("assets/entity/ships/ship_003.png")
  mainFont = love.graphics.newFont( 20);
  pickup_bg = love.graphics.newImage("assets/tiles/gui_slots.png")
end
function draw_ui()
  love.graphics.draw(bg,640,-gamestate.scroll,0,1,1)
  love.graphics.setFont(mainFont)
  love.graphics.print("Lives",660, 10-gamestate.scroll)
  for i=1, gamestate.retry-1 do
  love.graphics.draw(life,700+i*64,10-gamestate.scroll,0,1,1)
end
  love.graphics.print("Score:   "..gamestate.score,720, 60-gamestate.scroll)

  if gamestate.boss_active then
    love.graphics.print("Boss Hull:   "..  gamestate.boss.health,730, 120-gamestate.scroll)
    love.graphics.print("Boss Left:   "..  gamestate.boss.left_health,740, 140-gamestate.scroll)
    love.graphics.print("Boss Right:   "..  gamestate.boss.right_health,750, 160-gamestate.scroll)
    love.graphics.print("Boss Center:   "..  gamestate.boss.first_health,760, 180-gamestate.scroll)
  end
  love.graphics.draw(pickup_bg,720,100-gamestate.scroll)
  if gamestate.n_specials+1 <=#gamestate.special_attacks then
  love.graphics.draw(pickups[gamestate.special_attacks[gamestate.n_specials+1]],722,102-gamestate.scroll)
  end
  if gamestate.n_specials+2 <=#gamestate.special_attacks then
  love.graphics.draw(pickups[gamestate.special_attacks[gamestate.n_specials+2]],754,102-gamestate.scroll)
  end
  if gamestate.n_specials+3 <=#gamestate.special_attacks then
  love.graphics.draw(pickups[gamestate.special_attacks[gamestate.n_specials+3]],786,102-gamestate.scroll)
  end
end

function draw_start()
  local w = windowWith
  local h = windowHeight



  love.graphics.print("Welcome to this game", 10, 10)
end

function draw_death()
  local w = windowWith
  local h = windowHeight
  love.graphics.translate(tx, ty)

  gamestate.map:setDrawRange(0, 0, w, h)

  love.graphics.print("You are DEAD", 10, 10-gamestate.scroll)
end

function draw_won()
  local w = windowWith
  local h = windowHeight
  love.graphics.translate(tx, ty)

  gamestate.map:setDrawRange(0, 0, w, h)

  love.graphics.print("You are a winner, congrats", 10, 10-gamestate.scroll)
end
function story_dia()

end
