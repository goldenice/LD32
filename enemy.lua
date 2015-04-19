require 'enemy_line'
require 'enemy_suicide'

function add_enemy (gamestate,x,y,width, height,xoffset,yoffset,  tick,scroll,rotation,still,img)
  print(gamestate)
  gamestate.n_enemies = gamestate.n_enemies + 1
  gamestate.n_blocks = gamestate.n_blocks + 1
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.tick = tick
  enemy.width = width
  enemy.height = height
  enemy.w = width
  enemy.h = height
  enemy.xoffset = xoffset
  enemy.yoffset = yoffset
  enemy.scroll = scroll
  print(scroll)
  enemy.isEnemy=true
  if still then
  enemy.still = still
end
  enemy.rotation = rotation
  enemy.img = img
  gamestate.world:add(enemy,enemy.x,enemy.y,enemy.width,enemy.height)
  print(gamestate.enemies)
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
        add_suicide_enemy(gamestate,v.x,v.y,v.properties.tick, v.properties.scroll,v.rotation, v.properties.still)

    --  end
    end
  end
  return enemies
end

function aienemy(dt)
  --print("enemy")
  remove = {}
  for i,enemy in pairs(gamestate.enemies) do
    if -gamestate.scroll < tonumber(enemy.scroll) then

      local do_remove = suicide_enemy_ai(enemy,dt)
      if do_remove == 3 then
        return
      end
      if do_remove== 1 then
        gamestate.world:update(enemy,0,-100)
        delete_enemy(enemy)


      end
    end
    if cols_len > 0 then
    end
  end
end

function enemyfilter(item, other)
  return 'cross'

  -- else return nil
end
function add_line_flyer(x,y,tick)
  local e = {}
  return e
end


function drawEnemies()
  for _, enemy in pairs(gamestate.enemies) do
    if enemy.still then

      love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, 0 , 1, 1, width / 2, height / 2)
    else
      love.graphics.draw(enemy.img, enemy.x+0.5*width-enemy.xoffset,  enemy.y+0.5*height-enemy.yoffset, enemy.rotation, 1, 1, width / 2, height / 2)
    end

  end
end
