local Object = require('core/object')
local Stage  = require('core/stage')

local Title = {}
Object:instantiate(Title, Stage)

function Title:new(game)
  self.game = game
  self.font = love.graphics.newFont("assets/fonts/9k.ttf", 16)

  self.background  = love.graphics.newImage("assets/img/main-title.png")
  self.background2 = love.graphics.newImage("assets/img/main-title-2.png")

  self.state = {
    TITLE   = 0,
    FADING  = 1,
    LEAVING = 255
  }
  
  self.step = self.state.TITLE
  
  self.animation = {
    BLINKING = Object:create('core/animation', 300, true),
    FADING   = Object:create('core/animation', 4000, false)
  }
  
  self.gui = {}
  self.gui.text  = Object:create('core/ui/font', self.font, 16, 1, 16, 16)
  self.fading = 1
  self.first = true
end

function Title:update(dt)
  local progress = self.animation.BLINKING:update(dt)
  
  if progress <= 0 then
    self.first = not self.first
  end
  
  if self.step == self.state.FADING then
    local progress = self.animation.FADING:update(dt)
    if progress > 0 then
      self.fading = progress
    else
      self.game:setStep(self.game.step.HOUSE)
    end
  end
end

function Title:draw()
  if self.first then
    love.graphics.draw(self.background, 0, 0)
  else
    love.graphics.draw(self.background2, 0, 0)
  end
  
  if self.step == self.state.FADING then
    self:leaving(1 - self.fading)
  end
end

function Title:keypressed(key, scancode, isrepeat)
  if key == "return" or key == "kpenter" then
    self.step = self.state.FADING
  end
end

function Title:keyreleased(key)
end

return Title