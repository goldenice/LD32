tile_width =16
tile_height=16
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  gamestate.n_blocks =gamestate.n_blocks +1

  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.world:add(block, x,y,w,h)
  return block
end

function findSolidTiles(gamestate)
    local map = gamestate.map
    local collidable_tiles = {}
    local layer = map.layers["collision"]
    for y = 1, map.height do
    	for x = 1, map.width do

        if layer.data[y][x] then
          collidable_tiles[#collidable_tiles] = addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,gamestate)
        end
      end
    end

    return collidable_tiles
end

local function addEndBlock(x,y,w,h,gamestate)
  gamestate.n_blocks =gamestate.n_blocks +1

  local block = {x=x,y=y,w=w,h=h,isEnd, ctype ="end"}
  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.world:add(block, x,y,w,h)
  return block
end


function findEndLevelTiles(gamestate)
    local map = gamestate.map
    local collidable_tiles = {}
    local layer = map.layers["endlevel"]
    for y = 1, map.height do
    	for x = 1, map.width do

        if layer.data[y][x] then
          collidable_tiles[#collidable_tiles] = addEndBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,gamestate)
        end
      end
    end

    return collidable_tiles
end

local function addShadowBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="shadow",isShadow=true}
  gamestate.shadowworld:add(block, x,y,w,h)
  return block
end
function findShadowTiles(gamestate)
    local map = gamestate.map
    local collidable_tiles = {}
    local layer = map.layers["shadow"]
    for y = 1, map.height do
    	for x = 1, map.width do

        if layer.data[y][x] then
          collidable_tiles[#collidable_tiles] = addShadowBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,gamestate)
        end
      end
    end

    return collidable_tiles
end
