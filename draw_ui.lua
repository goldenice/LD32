-- ui demensions: x: 320, y: 720

function load_ui_elements()
  bg  = love.graphics.newImage("assets/backgrounds/panel_001.png")
  life  = love.graphics.newImage("assets/entity/ships/ship_003.png")
  mainFont = love.graphics.newFont( 20);

end
function draw_ui()
  love.graphics.draw(bg,640,-gamestate.scroll,0,1,1)
  love.graphics.setFont(mainFont)
  love.graphics.print("Lives",660, 10-gamestate.scroll)
  for i=1, gamestate.retry do
  love.graphics.draw(life,660+i*64,10-gamestate.scroll,0,1,1)
  love.graphics.print("Score:   "..gamestate.score,720, 60-gamestate.scroll)

  end
end
