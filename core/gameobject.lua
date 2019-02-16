local Object = require('core/object')

local GameObject = {}
Object:instantiate(GameObject)

function GameObject:new(image, frames, default, speed, sprlc, sprcc)
  self.timer = 0
  self.index = 1
  self.speed = speed / 1000
  self.image = image
  
  -- number of sprites per line and column
  self.spriteLineCount = sprlc
  self.spriteColumnCount = sprcc
  
  -- size of the image containing sprites
  self.imageWidth  = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  
  -- size of a sprite
  self.width  = self.imageWidth / self.spriteLineCount
  self.height = self.imageHeight / self.spriteColumnCount

  -- we cut the image into a table of sprites
  self.frame = {}
  for x = 1, self.spriteLineCount do
    self.frame[x] = {}
    for y = 1, self.spriteColumnCount do
      self.frame[x][y] = love.graphics.newQuad((x-1)*self.width, (y-1)*self.height, self.width, self.height, self.image:getDimensions())
    end
  end
  
  self.objects = {}
    
  for i=1, #frames do
    table.insert(self.objects, self.frame[frames[i][1]][frames[i][2]])
  end

  if #frames > 0 then
    self.current = self.objects[1]
  end
  
  self.default = self.frame[default[1]][default[2]]

  return self
end

function GameObject:update(dt)
  if self.play then
    self.timer = self.timer + dt
    
    if self.timer >= self.speed then
      self.index = self.index + 1
      
      if self.index > #self.objects then
        self.index = 1
      end
      
      self.current = self.objects[self.index]
      self.timer = self.timer - self.speed
    end
  end
end

function GameObject:get()
  return self.current
end

function GameObject:draw()
end

function GameObject:start()
  self.play = true
  self.timer = 0
  self.current = self.default
end

function GameObject:stop()
  self.play = false
  self.timer = 0
  self.current = self.default
end

function GameObject:getDefault()
  return self.default
end

return GameObject