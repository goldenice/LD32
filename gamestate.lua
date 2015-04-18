local bump       = require 'bump'
local bump_debug = require 'bump_debug'
require 'mapcol'
local sti = require "Simple-Tiled-Implementation"

function resetgamestate(mname)

    local s = {}
    s.scroll = 200
    s.player = { x=50,y=50,w=32,h=32,r=0, speed = 300 }
    s.blocks = {}
    s.world = bump.newWorld()
    s.map = sti.new("maps/testmap2")
    s.collisiontiles = findSolidTiles(s)
    s.scroll = 0
    return s
end
