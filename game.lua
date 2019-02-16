local Object = require('core/object')

local Game = {}
Object:instantiate(Game)

function Game:new()
  self:init()
end

function Game:init()
  self.config = {}
  self.config.playerspeed = 200
  self.config.catspeed    = 250
  self.config.ladderspeed = 200
  self.config.spawntime   = 6000
  self.config.spawnrate   = 50
  
  self.main = love.audio.newSource("assets/audio/memoires.mp3", "static")
  self.main:setVolume(0.8)
  self.main:setLooping(true)
  self.main:play()
  
  self.drop = love.audio.newSource("assets/audio/ball.wav", "static")
  self.drop:setVolume(1)
  self.drop:setLooping(false)
  
  self.background = love.graphics.newImage("assets/img/background.png")
  self.sidehouse  = love.graphics.newImage("assets/img/side-house.png")
  self.smallball  = love.graphics.newImage("assets/img/small-ball.png")
  self.jumper     = love.graphics.newImage("assets/img/jumper.png")
  
  self.gui  = {}
  self.font = love.graphics.newFont("assets/fonts/9k.ttf", 16)
  self.gui.text = Object:create('core/ui/font', self.font, 16, 1, 16, 16)
  
  self.score = 0
  self.pull  = 0
  
  self.timer = Object:create('core/animation', 1000, true)
  self.chrono = 60*2
  
  self.balls = {}

  self.stage = {}
  self.stage.title  = Object:create('stage/title', self)
  self.stage.house  = Object:create('stage/house', self)
  self.stage.credit = Object:create('stage/credit', self)
  
  self.step = {
    TITLE  = 1,
    HOUSE  = 2,
    CREDIT = 3
  }

  self.current = self.step.TITLE
  self.gameover = false
end

function Game:update(dt)
  if not self.gameover then
    if self.current == self.step.TITLE then
      self.stage.title:update(dt)
    elseif self.current == self.step.HOUSE then
      self:runChrono(dt)
      self.stage.house:update(dt)
   
      for i=1,#self.balls do
        self.balls[i]:update(dt)
        if self.balls[i]:isRemoved() then
          table.remove(self.balls, i)  
          break
        end
      end
    elseif self.current == self.step.CREDIT then
      self.stage.credit:update(dt)
    end
  end
end

function Game:draw()
  if not self.gameover then
    if self.current == self.step.TITLE then
      self.stage.title:draw()
    elseif self.current == self.step.HOUSE then
      self.stage.house:draw()

      for i=1,#self.balls do
        self.balls[i]:draw()
      end

      -- user interface
      love.graphics.push("all")
      love.graphics.setColor(1, 1, 1, 0.6)
      love.graphics.rectangle("fill", 0, 0, 600, 60)
      love.graphics.pop("all")
      love.graphics.draw(self.smallball, 32, 8)
      self.gui.text:draw("PELOTE : " .. self.score, 70, 2, 1)
      love.graphics.draw(self.jumper, 20, 32)
      self.gui.text:draw("PULL : " .. self.pull, 70, 29, 1)
      self.gui.text:draw("Temps restant : " .. self.chrono, 220, 18, 1)
    elseif self.current == self.step.CREDIT then
        self.stage.credit:draw()
    end
  else
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.sidehouse, 0, 0)
    love.graphics.push("all")
    love.graphics.setColor(1, 1, 1, 0.95)
    love.graphics.rectangle("fill", 0, 300 - 60, 600, 120)
    love.graphics.pop("all")
    self.gui.text:draw("Fin de la partie, vous avez remporté " .. (self.score*50 + self.pull*400) .. " points !", 85, 270, 1)
    self.gui.text:draw("Appuyez sur ENTREE pour recommencer", 120, 300, 1)
  end
end

function Game:keypressed(key, scancode, isrepeat)
  if not self.gameover then
    if self.current == self.step.TITLE then
      self.stage.title:keypressed(key, scancode, isrepeat)
    elseif self.current == self.step.HOUSE then
      self.stage.house:keypressed(key, scancode, isrepeat)
    elseif self.current == self.step.CREDIT then
      self.stage.credit:keypressed(key, scancode, isrepeat)
    end
  else
    if key == "return" or key == "kpenter" then
      self.main:stop()
      self:init()
    end
  end
end

function Game:keyreleased(key)
  if not self.gameover then
    if self.current == self.step.TITLE then
     self.stage.title:keyreleased(key)
    elseif self.current == self.step.HOUSE then
      self.stage.house:keyreleased(key)
    elseif self.current == self.step.CREDIT then
      self.stage.credit:keyreleased(key)
    end
  end
end

function Game:runChrono(dt)
  if not self.gameover then
    local progress = self.timer:update(dt)
    if progress <= 0 then
      self.chrono = self.chrono - 1
      if self.chrono <= 0 then
        self.gameover = true
      end
    end
  end
end

function Game:setStep(value)
  self.current = value
end

function Game:createBall(x, y)
  self.drop:play()
  table.insert(self.balls, Object:create('entity/ball', self, x, y));
end

function Game:getBalls()
  return self.balls
end

function Game:getScore()
  return self.score
end

function Game:addScore(value)
  self.score = self.score + value
end

function Game:getPull()
  return self.pull
end

function Game:addPull(value)
  self.pull = self.pull + value
end

function Game:getConfig()
  return self.config
end

return Game
