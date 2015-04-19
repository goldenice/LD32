local bump       = require 'bump'
local bump_debug = require 'bump_debug'
local sti = require "Simple-Tiled-Implementation"
require 'bullet'
require 'player'
require 'effect'
anim8 = require 'anim8'

scroll= -180
zoom = 2
shadow_x = -16
shadow_y = -16
require 'gamestate'
require 'enemy'
local instructions = [[
bump.lua simple demo

arrows: move
tab: toggle debug info
delete: run garbage collector
]]
levels = {"maps/testmap2","maps/testmap2"}
background1_url = {"assets/backgrounds/space_002.png", "assets/backgrounds/space_002.png"}
background_1 = {}
background2_url = {"assets/backgrounds/space_001.png", "assets/backgrounds/space_001.png"}
background_2 = {}
add_scroll_1 = 0.1
add_scroll_2 = 0.65

cur = 1
local cols_len = 0 -- how many collisions are happening

-- World creation
gamestate = {}
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
  if gamestate.shadow then
    love.graphics.setShader(bw_shader)
    love.graphics.setColor(255, 255, 255, 50) -- red, green, blue, opacity (this would be white with 20% opacity

    love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset+shadow_x,  gamestate.player.y+0.5*height-gamestate.player.yoffset+shadow_y, gamestate.player.r, 1, 1, width / 2, height / 2)

    love.graphics.setColor(255, 255, 255, 255) -- red, green, blue, opacity (this would be white with 20% opacity)
    love.graphics.setShader()
  end
  love.graphics.draw(hamster, gamestate.player.x+0.5*width-gamestate.player.xoffset,  gamestate.player.y+0.5*height-gamestate.player.yoffset, gamestate.player.r, 1, 1, width / 2, height / 2)


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
  hamster = love.graphics.newImage("assets/entity/ships/ship_003.png")
  width = hamster:getWidth()
  gamestate.map:setDrawRange(0,0,love.graphics.getWidth(), love.graphics.getHeight())

  height = hamster:getHeight()
  collectgarbage("collect")
end


-- Main LÖVE functions

function love.load()
  bw_shader = love.graphics.newShader[[
  vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
  vec4 c = Texel(texture, texture_coords); // This reads a color from our texture at the coordinates LOVE gave us (0-1, 0-1)
  return vec4(vec3(0,0,0), c.a*0.1
  ); // This just returns a white color that's modulated by the brightest color channel at the given pixel in the texture. Nothing too complex, and not exactly the prettiest way to do B&W :P
}
  ]]

  for i,bg in ipairs(background1_url) do
    background_1[i] = love.graphics.newImage(bg)
  end
  for i,bg in ipairs(background2_url) do
    background_2[i] = love.graphics.newImage(bg)
  end
  loadmap(levels[cur])
  loadbullets()
  fill_effect_table()
  get_effect_anims()
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
    update_effects(dt)
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
    love.graphics.draw(gamestate.bg_image1, gamestate.bg_quad1, 0, add_scroll_1*gamestate.scroll,0, 1, 1, width / 2, height / 2)
    love.graphics.draw(gamestate.bg_image2, gamestate.bg_quad2, 0, add_scroll_2*gamestate.scroll,0, 1, 1, width / 2, height / 2)

    gamestate.map:draw()
    -- Draw only the tiles on screen
    drawPlayer()
    drawEnemies()
    draw_bullets()
    draw_effects()
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
