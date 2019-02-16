local Object = require('core/object')
local Entity = require('core/entity')

local Grandma = {}
Object:instantiate(Grandma, Entity)

function Grandma:new(game)
  -- pixels par seconde
  self.speed = self.config.playerspeed
  
  self.pickup = love.audio.newSource("assets/audio/pickup.mp3", "static")
  self.pickup:setVolume(1)
  self.pickup:setLooping(false)
  
  self.image = love.graphics.newImage("assets/img/granny.png")
  -- we do not count the cane for collisions
  self.width  = 72 - 20
  self.height = 96
  
  self.walking = {}
  self.walking.right = Object:create('core/gameobject', self.image, {{1,1}, {2,1}, {3,1}}, {1,1}, 200, 3, 2)
  self.walking.left  = Object:create('core/gameobject', self.image, {{1,2}, {2,2}, {3,2}}, {1,2}, 200, 3, 2)
  
  self.x = 108
  self.y = 492
  self.sprite = self.walking.right
  
  self.right = false
  self.left = false
end

function Grandma:draw()
  love.graphics.draw(self.image, self.sprite:get(), self.x, self.y)
end

function Grandma:update(dt)
  self.sprite:update(dt)

  if self.right then
    self.x = self.x + self.speed*dt
    if not self:onBound() then
      self.x = self.x - self.speed*dt
    end
  end
  
  if self.left then
    self.x = self.x - self.speed*dt
    if not self:onBound() then
      self.x = self.x + self.speed*dt
    end
  end
    
  local balls = self.game:getBalls()
  
  for i=1,#balls do
    local ball = balls[i]
    
    if self:isTouching({x=ball.x,y=ball.y,width=16,height=16}) then
      self.pickup:play()
      table.remove(self.game:getBalls(), i)
      self.game:addScore(1)
      break
    end
  end
end

function Grandma:isMoving()
  return self.up or self.right or self.down or self.left
end

function Grandma:keypressed(key, scancode, isrepeat)
  if key == "left" or key == "right" then
    if love.keyboard.isDown(key) then
      self:moveTo(key)
    end
    
    if love.keyboard.isDown(key) then
      self:moveTo(key)
    end
  end
end

function Grandma:moveTo(direction)
  if direction == "right" then
    self.left = false
    self.right = true
    self.sprite = self.walking.right
    self.sprite:start()
  end
  
  if direction == "left" then
    self.right = false
    self.left = true
    self.sprite = self.walking.left
    self.sprite:start()
  end
end

function Grandma:keyreleased(key)
  if key == "right" then
    self.right = false
  end
  
  if key == "left" then
    self.left = false
  end
  
  if not self.left and not self.right then
    self.sprite:stop()
  end
end

function Grandma:setDirection(dir)
  if dir == "left" then
    self.sprite = self.walking.left
  else
    self.sprite = self.walking.right
  end
end

function Grandma:onBound()
  return self.x >= 0 and self.x < 600 - self.width - 20
end

return Grandma