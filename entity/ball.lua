local Object = require('core/object')
local Entity = require('core/entity')

local Ball = {}
Object:instantiate(Ball, Entity)

function Ball:new(game, x, y)
  self.life = self.config.spawntime
  self.blink = false
  self.onground = true
  
  self.lifetime = Object:create('core/animation', self.life, false)
  self.blinking = Object:create('core/animation', 200, true)
  self.levitate = Object:create('core/animation', 500, true)
  self.remove = false
  
  self.image = love.graphics.newImage("assets/img/small-ball.png")
  
  self.x = math.floor(x)
  self.y = math.floor(y)
end

function Ball:draw()
  if not self.blink then
    love.graphics.draw(self.image, self.x, self.y)
  end
end

function Ball:update(dt)
  -- ball levitation
  local levitate = self.levitate:update(dt)
  
  if levitate <= 0 then
    self.onground = not self.onground
    
    if self.onground then
      self.y = self.y + 4
    else
      self.y = self.y - 4
    end  
  end
  
  -- we start the flashing the ball from half of its lifetime
  local progress = self.lifetime:update(dt)
  
  if progress < 0.5 then
    local _blink = self.blinking:update(dt)
    if _blink <= 0 then
      self.blink = not self.blink
    end
  end
  
  -- the deletion is requested when the animation of the lifetime is complete
  if progress <= 0 then
    self.remove = true
  end
end

function Ball:isRemoved()
  return self.remove
end

function Ball:setRemoved(value)
  self.remove = value
end

return Ball