tile_width =16
tile_height=16
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,type="death"}
  gamestate.blocks[#gamestate.blocks+1] = block
  gamestate.world:add(block, x,y,w,h)
  return block
end

function findSolidTiles(gamestate)
    local map = gamestate.map
    local collidable_tiles = {}
    local layer = map.layers["collision"]
    for x = 1, #layer.data do
    	for y = 1, #layer.data[x] do
    		print(layer.data[y][x])
        print(y..":"..x)
        if layer.data[y][x] then

          collidable_tiles[#collidable_tiles] = addBlock((x)*tile_width,(y)*tile_height,tile_width,tile_height,gamestate)
        end
      end
    end

    return collidable_tiles
end
