local Stage = {}

function Stage:new(game)
  self.game = game
  self.config = self.game:getConfig()
  self.done = false
  self.step = 0
  self.animation = {}
  self.entities = {}
end

function Stage:enter()
  if self.animation ~= nil then
    for key in pairs(self.animation) do
      self.animation[key]:reset()
    end
  end
end

function Stage:leaving(fade)
  love.graphics.push("all")
  love.graphics.setColor(0, 0, 0, fade)
  love.graphics.rectangle("fill", 0, 0, 600, 600)
  love.graphics.pop("all")
end

function Stage:removeEntity(id)
  for i=1,#self.entities do
    if self.entities[i].id == id then
      table.remove(self.entities, i)
      return true
    end
  end

  return false
end

function Stage:isTouchingEntity()
  for i=1,#self.entities do
    if self:isTouching(self.entities[i]) then
      return true
    end
  end

  return false
end

function Stage:isTouchingEntityById(id)
  for i=1,#self.entities do
    if self.entities[i].id == id and self:isTouching(self.entities[i]) then
      return true
    end
  end

  return false
end

function Stage:isTouching(area1, area2)
  return area1.x < area2.x + area2.width
     and area1.x + area1.width > area2.x 
     and area1.y < area2.y + area2.height
     and area1.height + area1.y > area2.y
end

function Stage:keypressed(key, scancode, isrepeat)
end

function Stage:draw()
end

function Stage:getGUI()
  return self.gui
end

function Stage:setDone(value)
  self.done = value
end

function Stage:isDone()
  return self.done
end

return Stage