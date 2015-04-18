local bump       = require 'bump'
local bump_debug = require 'bump_debug'
local sti = require "Simple-Tiled-Implementation"
margin = 0.001
scroll= -100
require 'gamestate'
local instructions = [[
  bump.lua simple demo

    arrows: move
    tab: toggle debug info
    delete: run garbage collector
]]

local cols_len = 0 -- how many collisions are happening

-- World creation
local gamestate = resetgamestate("testmap")


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



-- Player functions

local function updatePlayer(dt)
  local speed = gamestate.player.speed

  local dx, dy = 0, 0
  --if love.keyboard.isDown('right') or joystick:isGamepadDown("dpright") then
--
  --  gamestate.player.r = gamestate.player.r + dt
  --elseif love.keyboard.isDown('left') or joystick:isGamepadDown("dpleft") then
  --  gamestate.player.r=gamestate.player.r -dt
--
--  end
  --if love.keyboard.isDown('down') or joystick:isGamepadDown("dpdown")  then
  --  dx = -speed *math.cos(gamestate.player.r) *dt
--    dy = -speed *math.sin(gamestate.player.r) *dt
  --elseif love.keyboard.isDown('up') or joystick:isGamepadDown("dpup") then
  --  dx = speed *math.cos(gamestate.player.r)* dt
  --  dy = speed *math.sin(gamestate.player.r) *dt
  --end
  dx = joystick:getGamepadAxis("leftx") * dt * gamestate.player.speed
  dy = joystick:getGamepadAxis("lefty") * dt * gamestate.player.speed
  moved = true
  if dx*dx < margin then
    dx = 0
    moved = false
  end
  if dy*dy < margin then
    dy = 0
    moved = false
  end
  if moved then
  --gamestate.player.r = math.atan2(dy,dx)
  end
  dy = dy + dt*scroll
  if dx ~= 0 or dy ~= 0 then
    local cols
    gamestate.player.x, gamestate.player.y, cols, cols_len = gamestate.world:move(gamestate.player, gamestate.player.x + dx, gamestate.player.y + dy)
    for i=1, cols_len do
      local col = cols[i]
      if col.other.type == "death" then
        resetGame()
      else
        consolePrint(("col.type = %s"):format(col.other.type))
      end
      consolePrint(("col.other = %s, col.type = %s, col.normal = %d,%d"):format(col.other, col.type, col.normal.x, col.normal.y))
    end
  end
end

local function drawPlayer()
  love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset,  gamestate.player.y+0.5*height-gamestate.player.yoffset, gamestate.player.r, 1, 1, width / 2, height / 2)
end

-- Block functions

local blocks = {}



local function drawBlocks()
  for _,block in ipairs(gamestate.blocks) do
    drawBox(block, 255,0,0)
  end
  drawBox(gamestate.player,255,0,0)
end
function resetGame()
  gamestate = resetgamestate("testmap")
  gamestate.world:add(gamestate.player, gamestate.player.x, gamestate.player.y, gamestate.player.w, gamestate.player.h)
  hamster = love.graphics.newImage("assets/entity/ships/ship_001.png")
  width = hamster:getWidth()
  gamestate.map:setDrawRange(0,0,love.graphics.getWidth(), love.graphics.getHeight())

  height = hamster:getHeight()
  collectgarbage("collect")
end
function loadmap(mapname)
  gamestate = resetgamestate()
  gamestate.world:add(gamestate.player, gamestate.player.x, gamestate.player.y, gamestate.player.w, gamestate.player.h)
  hamster = love.graphics.newImage("assets/entity/ships/ship_001.png")
  width = hamster:getWidth()
  height = hamster:getHeight()
  addBlock(0,       0,     800, 32) -- x,y,w,h
  addBlock(0,      32,      32, 600-32*2)
  addBlock(800-32, 32,      32, 600-32*2)
  addBlock(0,      600-32, 800, 32)

  collectgarbage("collect")
end


-- Main LÖVE functions

function love.load()
  windowWith = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  local joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  resetGame()
end


function love.update(dt)
  cols_len = 0
  updatePlayer(dt)
  gamestate.scroll = gamestate.scroll   - dt*scroll
end

function love.draw()
  zoom = 2
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
  if shouldDrawDebug then
    drawBlocks()
  end
  drawMessage()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( ).."scroll:"..gamestate.scroll), 10, 10-gamestate.scroll)
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end
end
