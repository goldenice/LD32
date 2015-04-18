local bump       = require 'bump'
local bump_debug = require 'bump_debug'
local sti = require "Simple-Tiled-Implementation"
require 'bullet'
require 'player'
scroll= -100
zoom = 2
require 'gamestate'
require 'enemy'
local instructions = [[
bump.lua simple demo

arrows: move
tab: toggle debug info
delete: run garbage collector
]]
levels = {"maps/testmap2","maps/kutwindows"}
cur = 1
local cols_len = 0 -- how many collisions are happening

-- World creation
gamestate = resetgamestate(levels[1])
current_state = "G"

-- Message/debug functions
local function drawMessage()
  local msg = instructions:format(tostring(shouldDrawDebug))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, 550, 10)
end

local function drawDebug()
  bump_debug.draw(gamestate.world)

  local statistics = ("fps: %d, mem: %dKB, collisions: %d, items: %d"):format(love.timer.getFPS(), collectgarbage("count"), cols_len, gamestate.world:countItems())
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(statistics, 0, 580, 790, 'right')
end

local consoleBuffer = {}
local consoleBufferSize = 15
for i=1,consoleBufferSize do consoleBuffer[i] = "" end
local function consolePrint(msg)
  table.remove(consoleBuffer,1)
  consoleBuffer[consoleBufferSize] = msg
end

local function drawConsole()
  local str = table.concat(consoleBuffer, "\n")
  for i=1,consoleBufferSize do
    love.graphics.setColor(255,255,255, i*255/consoleBufferSize)
    love.graphics.printf(consoleBuffer[i], 10, 580-(consoleBufferSize - i)*12, 790, "left")
  end
end

-- helper function
local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end


local function drawPlayer()
  love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset,  gamestate.player.y+0.5*height-gamestate.player.yoffset, gamestate.player.r+math.rad(180), 1, 1, width / 2, height / 2)
end

-- Block functions

local blocks = {}



local function drawBlocks()
  for _,block in pairs(gamestate.blocks) do
    drawBox(block, 255,0,0)
  end
  drawBox(gamestate.player,255,0,0)
end
function resetGame()
  gamestate = reload_upon_death()
  bullets = {}
  gamestate.world:add(gamestate.player, gamestate.player.x, gamestate.player.y, gamestate.player.w, gamestate.player.h)
  gamestate.map:setDrawRange(0,0,love.graphics.getWidth(), love.graphics.getHeight())
  height = hamster:getHeight()
  collectgarbage("collect")
end
function nextLevel()
  cur = cur + 1
  if cur > #levels then
    current_state = "F"
  else
    gamestate = resetgamestate(levels[cur])
    bullets = {}
    gamestate.world:add(gamestate.player, gamestate.player.x, gamestate.player.y, gamestate.player.w, gamestate.player.h)
    gamestate.map:setDrawRange(0,0,love.graphics.getWidth(), love.graphics.getHeight())
    height = hamster:getHeight()
    collectgarbage("collect")
  end
end

function loadmap(mapname)
  gamestate = resetgamestate(mapname)
  bullets = {}

  gamestate.world:add(gamestate.player, gamestate.player.x, gamestate.player.y, gamestate.player.w, gamestate.player.h)
  hamster = love.graphics.newImage("assets/entity/ships/ship_001.png")
  width = hamster:getWidth()
  gamestate.map:setDrawRange(0,0,love.graphics.getWidth(), love.graphics.getHeight())

  height = hamster:getHeight()
  collectgarbage("collect")
end


-- Main LÖVE functions

function love.load()
  loadmap(levels[cur])
  loadbullets()


  windowWith = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  local joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  buttons = joystick:getButtonCount( joystick )
end


function love.update(dt)
  if current_state == "G" then
    cols_len = 0
    updatePlayer( dt)
    move_bullets(dt)
    aienemy(dt)
    gamestate.scroll = gamestate.scroll   - dt*scroll
  end
end

function love.draw()
  if current_state == "G" then

    love.graphics.scale(zoom, zoom)
    tx = 0

    ty = gamestate.scroll
    local w = windowWith
    local h = windowHeight
    love.graphics.translate(tx, ty)

    gamestate.map:setDrawRange(tx, ty, w, h)
    gamestate.map:draw()
    -- Draw only the tiles on screen
    drawPlayer()
    drawEnemies()
    draw_bullets()
    if shouldDrawDebug then
      drawBlocks()
    end
    drawMessage()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )).."sc:"..gamestate.scroll, 10, 10-gamestate.scroll)
  else
    local w = windowWith
    local h = windowHeight
    love.graphics.translate(tx, ty)

    gamestate.map:setDrawRange(0, 0, w, h)
    love.graphics.print("You are a winner, congrats", 10, 10-gamestate.scroll)

  end
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end
end
