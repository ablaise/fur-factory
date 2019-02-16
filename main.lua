io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest")

local Object = require('core/object')
local Game   = Object:create('game')

function love.load()
  love.math.setRandomSeed(love.timer.getTime())
  love.mouse.setVisible(false)
  love.window.setTitle("Fur Factory - Pot-au-jeu game jam #1")
  love.window.setMode(600, 600)
end

function love.update(dt)
  Game:update(dt)
end

function love.draw()
  Game:draw()
end

function love.keypressed(key, scancode, isrepeat)
  Game:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
  Game:keyreleased(key)
end