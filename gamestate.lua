local bump       = require 'bump'
local bump_debug = require 'bump_debug'
require 'mapcol'
require 'enemy'
local sti = require "Simple-Tiled-Implementation"


function resetgamestate(mname)
  local s = {}
  print(mname)
  s.player = { x=love.graphics.getWidth()/4,y=love.graphics.getHeight()/3,w=8,h=16,r=0, speed = 450,xoffset = 17,yoffset = 5, ctype="player",isPlayer=true}
  s.blocks = {}
  s.score =  0
  s.special_attack = nil
  s.special_triggered = false
  s.n_specials = 0
  s.special_attacks = {"spread","spread"}
  s.shoot_timeout = 1/8
  s.shoot_time = 0
  s.special_loose = false
  s.bullets = {}
  s.n_bullets = 0
  s.retry = 3
  s.retry_wait = 2
  s.retry_max_wait = 2
  s.retry_wait_tick = 0
  gamestate.playing = true
  s.retry_shown = false
  s.n_blocks = 0
  s.n_enemies = 0
  s.shadow=false
  s.effects = {}
  s.n_effects = 0
  s.world = bump.newWorld()
  s.shadowworld = bump.newWorld()
  s.mapname = mname
  s.map = sti.new(mname)
  s.collisiontiles = findSolidTiles(s)
  s.scroll = -s.map.height*tile_height +love.graphics.getHeight()*1.5
  s.startscroll = s.scroll
  s.player.y = s.player.y - s.scroll
  s.enemies = {}
  findEnemies(s)
  s.endStates = findEndLevelTiles(s)
  s.shadows = findShadowTiles(s)
  s.bg_image1 = background_1[cur]
  s.bg_image1:setWrap("repeat", "repeat")
  s.bg_quad1 = love.graphics.newQuad(0, 0, love.graphics.getWidth()+64,2*s.map.height*tile_height, s.bg_image1:getWidth(), s.bg_image1:getHeight())
-- note how the Quad's width and height are larger than the image width and height.
  s.bg_image2 = background_2[cur]
  s.bg_image2:setWrap("repeat", "repeat")
  s.bg_quad2 = love.graphics.newQuad(0, 0, love.graphics.getWidth()+64,2*s.map.height*tile_height, s.bg_image2:getWidth(), s.bg_image2:getHeight())
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
