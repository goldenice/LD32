-- ui demensions: x: 320, y: 720
ui_time_per_frame = 2
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
  if cur == 1 then
    if gamestate.time < ui_time_per_frame then
      story_dia("Stores inc. has monopolized by giving away free weapons, but..")
    elseif gamestate.time < ui_time_per_frame*2 then
      story_dia("They are giving away shitty weapons...")
    elseif gamestate.time < ui_time_per_frame*3 then
      story_dia("and charging people for onetime upgrades")
    elseif gamestate.time < ui_time_per_frame*4 then
      story_dia("These Fremium bastards have to be stopped!!")
    end
  end
  if cur == 2 then
    if gamestate.time < ui_time_per_frame then
      story_dia("They are getting stronger")
    elseif gamestate.time < ui_time_per_frame*2 then
      story_dia("Their executives must be nearby")
    end
  end
  if  gamestate.boss_intro then
    if gamestate.time < ui_time_per_frame then
      story_dia("You have found us, but don't smile yet")
    elseif gamestate.time < ui_time_per_frame*2 then
      story_dia("Your story ends here, tonight")
    elseif gamestate.time < ui_time_per_frame*3 then
      story_dia("We will never be stopped")
    elseif gamestate.time < ui_time_per_frame*4 then
      story_dia("Muhahahahahaha")
    end
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
function story_dia(text)
  love.graphics.setColor(255, 255, 255, 50) -- red, green, blue, opacity (this would be white with 20% opacity

  love.graphics.rectangle("fill", 1, 620-gamestate.scroll, 640, 50 )

  love.graphics.setColor(255, 255, 255, 255) -- red, green, blue, opacity (this would be white with 20% opacity)
  love.graphics.print(text,11,630-gamestate.scroll)
end
