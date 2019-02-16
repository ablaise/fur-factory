local Object = require('core/object')
local Stage  = require('core/stage')

local Credit = {}
Object:instantiate(Credit, Stage)

function Credit:new(game)
  self.game = game
end

function Credit:update(dt)
end

function Credit:draw()
end

return Credit