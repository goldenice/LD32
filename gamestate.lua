local bump       = require 'bump'
local bump_debug = require 'bump_debug'
require 'mapcol'
local sti = require "Simple-Tiled-Implementation"

function resetgamestate(mname)

    local s = {}

    s.player = { x=50,y=50,w=8,h=8,r=0, speed = 300,xoffset = 28,yoffset = 4 }
    s.blocks = {}
    s.world = bump.newWorld()
    s.map = sti.new("maps/testmap2")
    s.collisiontiles = findSolidTiles(s)
    s.scroll = -s.map.height*tile_height
    s.player.y = s.player.y - s.scroll
    return s
end
