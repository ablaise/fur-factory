local Entity = {}

function Entity:new(game)
  self.game = game
  self.config = self.game:getConfig()
  self.x = 0
  self.y = 0
  self.width = 0
  self.height = 0
  self.image = nil
end

function Entity:draw()
end

function Entity:update(dt)
end

function Entity:isTouching(area)
  return self.x < area.x + area.width 
     and self.x + self.width > area.x 
     and self.y < area.y + area.height
     and self.height + self.y > area.y
end

function Entity:setX(x)
  self.x = x
end

function Entity:setY(y)
  self.y = y
end

function Entity:getArea()
  local area = {}
  area.x = self.x
  area.y = self.y
  area.width = self.width
  area.height = self.height
  
  return area
end

return Entity