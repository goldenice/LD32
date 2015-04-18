function findEnemies(gamestate)
  local layer = gamestate.map.layers["enemies"]
  local enemies = {}
  local o = layer.objects
		for _, v in ipairs(o) do
      if  v then
        props = v.properties
        local type = ""
        print(#v.properties)
        for d, p in ipairs(props) do
          if d== "type" then
            v.type = p
          end

          if d== "ctype" then
            v.ctype = p
            print(p)
          end
        end
        v.w = v.width
        v.h = v.height
        gamestate.world:add(v,v.x,v.y,v.width,v.height)
        v.xoffset = 26
        v.yoffset = 0
        enemies[#enemies+1] = v
        gamestate.blocks[#gamestate.blocks+1] = v
      end

		end
    return enemies

end

function aienemy(gamestate,dt)
  --print("enemy")

  for _,enemy in ipairs(gamestate.enemies) do
    dx = 10
    dy = 0
    enemy.x, enemy.y, cols, cols_len =gamestate.world:move(enemy, enemy.x + dx*dt, enemy.y + dy*dt)
    if cols_len > 0 then
    end
  end
end
