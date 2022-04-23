Wolf = Class{}

function Wolf:init()
    self.x = (VIRTUAL_WIDTH * 0.75) - WOLF_WIDTH
    self.y = VIRTUAL_HEIGHT - WOLF_HEIGHT

    self.dx = 0
    self.dx_floor = 0
    self.dy = 0

    self.hp = math.random(8) + math.random(8) + 2

    self.state = 'idle'
    self.direction = 'left'

    self.idle = {'Wolf_Idle_1', 'Wolf_Idle_2', 'Wolf_Idle_3', 'Wolf_Idle_4', 'Wolf_Idle_5', 'Wolf_Idle_6', 'Wolf_Idle_7', 'Wolf_Idle_8', 'Wolf_Idle_9', 'Wolf_Idle_10', 'Wolf_Idle_11', 'Wolf_Idle_12'}

    self.animation = Animation({frames = self.idle, interval = 0.2})
end

function Wolf:update(dt)
    -- update position
    self.x = self.x + self.dx_floor * dt
    self.y = self.y + self.dy * dt

    -- apply gravity and collision with ground
    if self.y < VIRTUAL_HEIGHT - WOLF_HEIGHT then
        self.dy = self.dy + GRAVITY
    elseif self.y > VIRTUAL_HEIGHT - WOLF_HEIGHT then
        self.y = VIRTUAL_HEIGHT - WOLF_HEIGHT
        self.dy = 0
    end

    -- update direction based on velocity
    if self.dx_floor > 1 then
        self.direction = 'right'
    elseif self.dx_floor < -1 then
        self.direction = 'left'
    end

    self.animation:update(dt)
end

function Wolf:updateState(state)
    if state == self.state then
        return
    end
    self.state = state
    if self.state == 'idle' then
        self.animation = Animation({frames = self.idle, interval = 0.2, hold = false})
    end
end

function Wolf:render()
    if self.direction == 'right' then
        love.graphics.draw(gTextures[self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, 1, 1, -WOLF_WIDTH / 2, 0)
    else
        love.graphics.draw(gTextures[self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, -1, 1, VIRTUAL_WIDTH / 4, 0)
    end
end
