UI = Class{}

function UI:init()
    self.hp_meter_width = 60
    self.hp_meter_height = 6
    self.adventurer = nil
end

function UI:update(dt, adventurer)
    self.adventurer = adventurer
end

function UI:render()
    if self.adventurer then
        -- draw HP bar    
        local healthBarWidth = math.floor(self.hp_meter_width * (self.adventurer.hp / self.adventurer.max_hp))

        -- grey : background
        love.graphics.setColor(0.17, 0.22, 0.21, 255)
        love.graphics.rectangle('fill', 8, 8, self.hp_meter_width, self.hp_meter_height, self.hp_meter_width / 20, self.hp_meter_height / 2)
        -- red : health
        love.graphics.setColor(0.67, 0.26, 0.26, 1)
        love.graphics.rectangle('fill', 8, 8, healthBarWidth, self.hp_meter_height, healthBarWidth / 20, self.hp_meter_height / 2)
        -- black : outline
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('line', 8, 8, self.hp_meter_width, self.hp_meter_height, self.hp_meter_width / 20, self.hp_meter_height / 2)
    end
end
