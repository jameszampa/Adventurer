StartState = Class{__includes = BaseState}

function StartState:init()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.clear()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(background1, 0, 0)
    love.graphics.draw(background2, 0, 0)
    love.graphics.draw(background3, 0, 0)

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Adventurer.', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Press Enter', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
end