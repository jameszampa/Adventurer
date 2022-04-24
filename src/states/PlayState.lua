PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.adventurer = Adventurer()
    self.wolf = Wolf()
    self.ui = UI()
    self.backgroundScroll = 0
    self.camX = 0
    self.camY = 0
end

function PlayState:update(dt)
    Timer.update(dt)
    self.adventurer:update(dt)
    self.adventurer = self.wolf:update(dt, self.adventurer)
    self.ui:update(dt, self.adventurer)

    self.backgroundScroll = (self.backgroundScroll + self.adventurer.dx_floor * dt) % BACKGROUND_LOOPING_POINT

    self.camX = self.adventurer.x - (VIRTUAL_WIDTH / 2) + ADVENTURER_WIDTH
    self.camY = 0
end

function PlayState:render()
    love.graphics.push()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(background1, -self.backgroundScroll, 0)
    love.graphics.draw(background2, -self.backgroundScroll, 0)
    love.graphics.draw(background3, -self.backgroundScroll, 0)
    self.ui:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    -- love.graphics.printf(self.adventurer.state, 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(tostring(self.wolf.state), 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(self.wolf.num_hits, 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    -- love.graphics.setFont(gFonts['small'])
    -- love.graphics.setColor(0, 0, 0, 255)
    -- love.graphics.print("HP: " .. tostring(self.wolf.hp), math.floor(self.wolf.x + WOLF_WIDTH * 1.25) - 1, math.floor(self.wolf.y - WOLF_HEIGHT / 4) - 1)
    -- love.graphics.setColor(255, 0, 0, 255)
    -- love.graphics.print("HP: " .. tostring(self.wolf.hp), math.floor(self.wolf.x + WOLF_WIDTH * 1.25), math.floor(self.wolf.y - WOLF_HEIGHT / 4))
    -- love.graphics.setColor(255, 255, 255, 255)

    self.wolf:render()
    self.adventurer:render()


    love.graphics.pop()
end