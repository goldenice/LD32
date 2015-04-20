
pickups = {}

function add_pickups()
  pickups["random_fwd"] = love.graphics.newImage("assets/tiles/random_fwd_chest.png")
  pickups["circle"]  =  love.graphics.newImage("assets/tiles/circle_chest.png")
  pickups["topleft"]  =  love.graphics.newImage("assets/tiles/top_left_chest.png")
  pickups["topright"]  =  love.graphics.newImage("assets/tiles/top_right_chest.png")
  pickups["sides"]  =  love.graphics.newImage("assets/tiles/sideways_chest.png")
  pickups["wreck"]  =  love.graphics.newImage("assets/tiles/wreckingball_chest.png")

end
function eat_pickup(pickup)
  gamestate.special_attacks[#gamestate.special_attacks+1] = pickup.type
  gamestate.blocks["a"..pickup.block] = nil
  gamestate.pickups["a"..pickup.id] = nil
  gamestate.world:remove(pickup)
  print("eating pickup")
end
function add_pickup (gamestate,x,y,type)
  gamestate.n_pickups = gamestate.n_pickups + 1
  gamestate.n_blocks = gamestate.n_blocks + 1
  local pickup = {}
  pickup.x = x
  pickup.y = y
  pickup.score = 100
  pickup.width = 32
  pickup.height = 32
  pickup.w = 32
  pickup.h = 32
  pickup.y_offset=0
  pickup.isPickup=true

  pickup.rotation = rotation
  pickup.img = pickups[type]
  pickup.type = type
  gamestate.world:add(pickup,pickup.x,pickup.y,pickup.width,pickup.height)
  gamestate.blocks["a"..gamestate.n_blocks] = pickup
  gamestate.pickups["a"..gamestate.n_pickups]  = pickup
  pickup.block =gamestate.n_blocks
  pickup.id =gamestate.n_pickups
  return pickup
end
function findPickups(gamestate)
  local layer = gamestate.map.layers["pickups"]
  local map = gamestate.map

  local o = layer.objects
  for _, v in pairs(o) do
    if  v then
    --  if v.properties.type =="line" then
    add_pickup(gamestate,v.x,v.y,v.properties.type)

    end
  end
  return enemies
end



function drawPickups()
  for _, pickup in pairs(gamestate.pickups) do
    if pickup.y+gamestate.scroll < windowHeight and pickup.y+gamestate.scroll >  -windowHeight   then

      love.graphics.draw(pickup.img, pickup.x+0.5*width,  pickup.y+0.5*height+pickup.y_offset, 0 , 1, 1, width / 2, height / 2)
  end
  end
end
