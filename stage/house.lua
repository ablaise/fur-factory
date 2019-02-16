local Object = require('core/object')
local Stage  = require('core/stage')

local House = {}
Object:instantiate(House, Stage)

function House:new(game)
  self.game = game
  
  self.action = love.audio.newSource("assets/audio/sewing-machine.mp3", "static")
  self.action:setVolume(0.5)
  self.action:setLooping(false)
  
  self.font = love.graphics.newFont("assets/fonts/9k.ttf", 16)
  
  self.background = love.graphics.newImage("assets/img/background.png")
  self.sidehouse  = love.graphics.newImage("assets/img/side-house.png")
  self.machine    = love.graphics.newImage("assets/img/sewing-machine.png")
  self.machinex = 16
  self.machiney = 500
  
  local stairlift1 = {}
  stairlift1.active = false
  stairlift1.up = false
  stairlift1.empty = love.graphics.newImage("assets/img/stairlift.png")
  stairlift1.use   = love.graphics.newImage("assets/img/granny-sitting.png")
  stairlift1.x = 557
  stairlift1.y = 516
  stairlift1.begin  = 516
  stairlift1.ending = 320
  
  local stairlift2 = {}
  stairlift2.active = false
  stairlift2.up = false
  stairlift2.empty = love.graphics.newImage("assets/img/stairlift-2.png")
  stairlift2.use   = love.graphics.newImage("assets/img/granny-sitting-2.png")
  stairlift2.x = 0
  stairlift2.y = 320
  stairlift2.begin  = 320
  stairlift2.ending = 124
  
  self.stairlift = {}
  table.insert(self.stairlift, stairlift1)
  table.insert(self.stairlift, stairlift2)
  
  self.area = {}
  self.area.machine = {}
  self.area.machine.x = self.machinex
  self.area.machine.y = self.machiney
  self.area.machine.width  = self.machine:getWidth() - 50
  self.area.machine.height = self.machine:getHeight()

  local ladder1 = {}
  ladder1.reference = 1
  ladder1.join = 2
  ladder1.x = 516
  ladder1.y = 408
  ladder1.width = 84
  ladder1.height = 184
  
  local ladder2 = {}
  ladder2.reference = 1
  ladder2.join = 1
  ladder2.x = 516
  ladder2.y = 212
  ladder2.width = 84
  ladder2.height = 184
  
  local ladder3 = {}
  ladder3.reference = 2
  ladder3.join = 3
  ladder3.x = 0
  ladder3.y = 212
  ladder3.width = 84
  ladder3.height = 184
  
  local ladder4 = {}
  ladder4.reference = 2
  ladder4.join = 2
  ladder4.x = 0
  ladder4.y = 12
  ladder4.width = 84
  ladder4.height = 184
  
  self.area.ladder = {}
  table.insert(self.area.ladder, ladder1)
  table.insert(self.area.ladder, ladder2)
  table.insert(self.area.ladder, ladder3)
  table.insert(self.area.ladder, ladder4)
  
  self.floor = 1
  
  self.cat = Object:create('entity/cat', self.game)
  self.granny = Object:create('entity/grandma', self.game)

  self.state = {
    TITLE   = 0,
    FADING  = 1,
    LEAVING = 255
  }
  
  self.step = self.state.TITLE
  
  self.animation = {
    FADING = Object:create('core/animation', 4000, false)
  }
  
  self.gui = {}
  self.gui.text  = Object:create('core/ui/font', self.font, 16, 1, 16, 16)
  self.fading = 1
end

function House:update(dt)
  -- no stairlift should move
  if not self.stairlift[1].active and not self.stairlift[2].active then
    self.granny:update(dt)
  end
  
  self.cat:update(dt)
  
  for i=1,#self.stairlift do
    if self.stairlift[i].active then
      if not self.stairlift[i].up then
        self.stairlift[i].y = self.stairlift[i].y - self.config.ladderspeed*dt
        
        if self.stairlift[i].y < self.stairlift[i].ending then
          self.stairlift[i].y = self.stairlift[i].ending
          self.stairlift[i].active = false
          self.stairlift[i].up = true
          self:setSpawn(self.floor, self.stairlift[i].up)
        end
      else
        self.stairlift[i].y = self.stairlift[i].y + self.config.ladderspeed*dt
        
        if self.stairlift[i].y > self.stairlift[i].begin then
          self.stairlift[i].y = self.stairlift[i].begin
          self.stairlift[i].active = false
          self.stairlift[i].up = false
          self:setSpawn(self.floor, self.stairlift[i].up)
        end
      end
    end
  end
end

function House:draw()
  love.graphics.draw(self.background, 0, 0)

  for i=1,#self.stairlift do
    love.graphics.draw(self.stairlift[i].empty, self.stairlift[i].x, self.stairlift[i].y)
    if self.stairlift[i].active then
      love.graphics.draw(self.stairlift[i].use, self.stairlift[i].x - (i==1 and 13 or 0), self.stairlift[i].y - 32)
    end
  end
  
  if not self.stairlift[1].active and not self.stairlift[2].active then
    self.granny:draw()
  end

  self.cat:draw()
  love.graphics.draw(self.machine, self.area.machine.x, self.area.machine.y)
  love.graphics.draw(self.sidehouse, 0, 0)
end

function House:setSpawn(floor, up)
  if floor == 1 then
    self.granny:setX(516)
    self.granny:setY(492)
    self.granny:setDirection("left")
  elseif floor == 2 and up then
    self.granny:setX(516)
    self.granny:setY(296)
    self.granny:setDirection("left")
  elseif floor == 2 and not up then
    self.granny:setX(12)
    self.granny:setY(296)
    self.granny:setDirection("right")
  elseif floor == 3 then
    self.granny:setX(12)
    self.granny:setY(100)
    self.granny:setDirection("right")
  end
end

function House:keypressed(key, scancode, isrepeat)
  self.granny:keypressed(key, scancode, isrepeat)
  
  -- interaction with the sewing machine
  if key == "return" or key == "kpenter" then
    if self:isTouching(self.granny:getArea(), self.area.machine) then
      if self.game:getScore() >= 5 then
        self.action:play()
        self.game:addScore(-5)
        self.game:addPull(1)
      end
    end
    
    for i=1,#self.area.ladder do
      if self:isTouching(self.granny:getArea(), self.area.ladder[i]) then
        local index = self.area.ladder[i].reference
        self.stairlift[index].active = true
        self.floor = self.area.ladder[i].join
      end
    end
  end
end

function House:keyreleased(key)
  self.granny:keyreleased(key)
end

return House