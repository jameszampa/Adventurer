PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.adventurer = Adventurer()
end

function PlayState:update(dt)
    Timer.update(dt)
    self.adventurer:update(dt)

end

function PlayState:render()
    love.graphics.push()
    self.adventurer:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(self.adventurer.state, 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(self.adventurer.attack_counter, 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')
    love.graphics.pop()
end