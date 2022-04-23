PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.adventurer = Adventurer()
    self.backgroundScroll = 0
    self.camX = 0
    self.camY = 0
end

function PlayState:update(dt)
    Timer.update(dt)
    self.adventurer:update(dt)

    self.backgroundScroll = (self.backgroundScroll + self.adventurer.dx * dt) % BACKGROUND_LOOPING_POINT

    self.camX = self.adventurer.x - (VIRTUAL_WIDTH / 2) + ADVENTURER_WIDTH
    self.camY = 0
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['background_layer_1'], -self.backgroundScroll, 0)
    love.graphics.draw(gTextures['background_layer_2'], -self.backgroundScroll, 0)
    love.graphics.draw(gTextures['background_layer_3'], -self.backgroundScroll, 0)


    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    self.adventurer:render()
    -- love.graphics.setFont(gFonts['medium'])
    -- love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.printf(self.adventurer.state, 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    -- love.graphics.printf(self.adventurer.attack_counter, 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')
    love.graphics.pop()
end