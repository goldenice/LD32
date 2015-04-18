local bump       = require 'bump'
local bump_debug = require 'bump_debug'
require 'mapcol'
require 'enemy'
local sti = require "Simple-Tiled-Implementation"

function resetgamestate(mname)
  local s = {}
  print(mname)
  s.player = { x=love.graphics.getWidth()/4,y=2,w=8,h=8,r=0, speed = 450,xoffset = 28,yoffset = 4, ctype="player",isPlayer=true}
  s.blocks = {}
  s.shoot_timeout = 1/12
  s.shoot_time = 0
  s.bullets = {}
  s.n_bullets = 0
  s.n_blocks = 0
  s.n_enemies = 0
  s.effects = {}
  s.n_effects = 0
  s.world = bump.newWorld()
  s.mapname = mname
  s.map = sti.new(mname)
  s.collisiontiles = findSolidTiles(s)
  s.scroll = -s.map.height*tile_height +love.graphics.getHeight()*1.5
  s.player.y = s.player.y - s.scroll
  s.enemies = findEnemies(s)
  s.endStates = findEndLevelTiles(s)
  return s
end
function reload_upon_death()
  print("your mom")
  local s = resetgamestate(gamestate.mapname)
  s.player.y = s.player.y + s.scroll
  s.scroll = -s.map.height*tile_height +love.graphics.getHeight()*0.5
  s.player.y = s.player.y - s.scroll
  return s
end
