local Object = require('core/object')
local Entity = require('core/entity')

local Cat = {}
Object:instantiate(Cat, Entity)

function Cat:new(game)
  self.catpath = {}
  table.insert(self.catpath, {x=0,   y=544, orientation="right"});
  table.insert(self.catpath, {x=0,   y=348, orientation="right"});
  table.insert(self.catpath, {x=0,   y=152, orientation="right"});
  table.insert(self.catpath, {x=600, y=544, orientation="left"});
  table.insert(self.catpath, {x=600, y=348, orientation="left"});
  table.insert(self.catpath, {x=600, y=152, orientation="left"});
  
  -- pixels per second
  self.speed = self.config.catspeed
  
  self.image  = love.graphics.newImage("assets/img/cat.png")
  self.width  = 76
  self.height = 44
  
  self.drop = Object:create('core/animation', 1000, true)
  
  self.walking = {}
  self.walking.right = Object:create('core/gameobject', self.image, {{1,1},{2,1}}, {1,1}, 100, 2, 2)
  self.walking.left  = Object:create('core/gameobject', self.image, {{1,2},{2,2}}, {1,2}, 100, 2, 2)
  
  self.right = false
  self.left = false
  
  self:init()
end

-- custom "bot" function :)
function Cat:init()
  local index = love.math.random(1, #self.catpath)
  local path = self.catpath[index]
  
  self.x = path.x
  self.y = path.y
  
  if path.orientation == "right" then
    self.sprite = self.walking.right
    self.right = true
    self.left = false
  else
    self.sprite = self.walking.left
    self.left = true
    self.right = false
  end
  
  self.sprite:start()
end

function Cat:draw()
  love.graphics.draw(self.image, self.sprite:get(), self.x, self.y)
end

function Cat:update(dt)
  self.sprite:update(dt)
  
  if self.right then
    self.x = self.x + self.speed*dt
  end
  
  if self.left then
    self.x = self.x - self.speed*dt
  end
  
  self:droping(dt)
  
  if self.x < 0 - self.image:getWidth() or self.x > 600 then
    self:init()
  end
end

function Cat:droping(dt)
  -- percentage of chance that it drops
  local trigger = self.config.spawnrate
  local progress = self.drop:update(dt)
  
  if progress <= 0 then
    local luck = love.math.random(0, 100)
    
    if trigger >= luck and (self.x > 50 and self.x < 550) then
      self.game:createBall(self.x, self.y + self.height - 16)
    end
  end
end

function Cat:isMoving()
  return self.right or self.left
end

return Cat