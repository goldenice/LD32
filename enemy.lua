require 'enemy_line'
require 'enemy_suicide'
require 'enemy_tank'
require 'enemy_rotating_tank'
require 'enemy_asteroid'
require 'enemy_asteroid_small'
require 'enemy_boss'

enemy_parts = {}

function add_enemy_parts()
  enemy_parts["suicide"] = love.graphics.newImage("assets/entity/ships/enemy_001.png")
  enemy_parts["line"]  =  love.graphics.newImage("assets/entity/ships/enemy_001.png")
  enemy_parts["turret_cover"]  =  love.graphics.newImage("assets/entity/enemies/turret_cover.png")
  enemy_parts["turret_base"]  =  love.graphics.newImage("assets/entity/enemies/turret_base.png")
  enemy_parts["turret_guns"]  =  love.graphics.newImage("assets/entity/enemies/turret_guns.png")
  enemy_parts["asteroid_big"]  =  love.graphics.newImage("prerenders/astroid 2/astroid20004.png")
  enemy_parts["asteroid_small"]  =  love.graphics.newImage("prerenders/astroid 1/astroid10004.png")

end
function add_enemy (gamestate,x,y,width, height,xoffset,yoffset,  tick,scroll,rotation,still,img,draw)
  gamestate.n_enemies = gamestate.n_enemies + 1
  gamestate.n_blocks = gamestate.n_blocks + 1
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.score = 100
  enemy.tick = tick
  enemy.width = width
  enemy.height = height
  enemy.w = width
  enemy.draw = draw
  enemy.health=1
  enemy.h = height
  enemy.xoffset = xoffset
  enemy.yoffset = yoffset
  enemy.scroll = scroll
  enemy.isEnemy=true
  if still then
  enemy.still = still
  end
  enemy.rotation = rotation
  enemy.img = img
  gamestate.world:add(enemy,enemy.x,enemy.y,enemy.width,enemy.height)
  gamestate.blocks["a"..gamestate.n_blocks] = enemy
  gamestate.enemies["a"..gamestate.n_enemies]  = enemy
  enemy.block =gamestate.n_blocks
  enemy.id =gamestate.n_enemies
  return enemy
end
function findEnemies(gamestate)
  local layer = gamestate.map.layers["enemies"]
  local map = gamestate.map

  local o = layer.objects
  for _, v in pairs(o) do
    if  v then
    --  if v.properties.type =="line" then
      if v.properties.type == "suicide" then
        add_suicide_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
      end
      if v.properties.type == "rtank" then
        local e = add_rotating_tank_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
        e.ascroll = v.properties.ascroll
      end
      if v.properties.type == "tank" then
        add_tank_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
      end
      if v.properties.type == "boss" then
        add_boss_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
      end
      if v.properties.type == "asteroid" then
        add_asteroid_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
      end
      if v.properties.type == "line" then
        add_line_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
      end
      if v.properties.type == "test" then
        add_test_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)
      end
    --  end
    end
  end
  return enemies
end

function aienemy(dt)
  remove = {}
  for i,enemy in pairs(gamestate.enemies) do
    if enemy.y+gamestate.scroll < 0 + windowHeight and enemy.y+gamestate.scroll >  -windowHeight-tonumber(enemy.scroll)   then

      local dx,dy = enemy["ai"](enemy,dt)
      if not enemy.isBoss then
        enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx, enemy.y + dy,enemyfilter)
        enemy.tick = enemy.tick + dt

      end

  end
end
end
function enemyfilter(item, other)
  return 'cross'

  -- else return nil
end



function drawEnemies()
  for _, enemy in pairs(gamestate.enemies) do
    if enemy.y+gamestate.scroll < 0 + windowHeight and enemy.y+gamestate.scroll >  -windowHeight-tonumber(enemy.scroll)   then

    enemy["draw"](enemy)
  end
  end
end

function std_draw( enemy  )

  if enemy.still then

    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
  else
    love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, enemy.rotation, 1, 1, width / 2, height / 2)
  end

end
