Wolf = Class{}

function Wolf:init()
    self.x = (VIRTUAL_WIDTH * 0.75) - WOLF_WIDTH
    self.y = VIRTUAL_HEIGHT - WOLF_HEIGHT

    self.dx = 0
    self.dy = 0

    self.hp = math.random(8) + math.random(8) + 2

    self.state = ''
    self.direction = 'right'

    self.distanceToAdventurer = 0
    self.facingAdventurer = false

    self.attack = 1

    self.num_hits = 0
    self.hit_reset = true

    self:updateState('Idle')
end

function Wolf:update(dt, adventurer)
    -- update position
    self.x = self.x + math.floor(self.dx) * dt
    self.y = self.y + math.floor(self.dy) * dt

    -- apply gravity and collision with ground
    if self.y < VIRTUAL_HEIGHT - WOLF_HEIGHT then
        self.dy = self.dy + GRAVITY
    elseif self.y > VIRTUAL_HEIGHT - WOLF_HEIGHT then
        self.y = VIRTUAL_HEIGHT - WOLF_HEIGHT
        self.dy = 0
    end

    -- update direction based on velocity
    if math.floor(self.dx) > 1 then
        self.direction = 'right'
    elseif math.floor(self.dx) < -1 then
        self.direction = 'left'
    end

    self.distanceToAdventurer = math.sqrt((adventurer.x - self.x) ^ 2 + (adventurer.y - self.y) ^ 2)

    if self.direction == 'left' and adventurer.x < self.x then
        self.facingAdventurer = true
    elseif self.direction == 'right' and adventurer.x > self.x then
        self.facingAdventurer = true
    else
        self.facingAdventurer = false
    end

    if self.state == 'Idle' and self.distanceToAdventurer <= 25 and self.facingAdventurer then
        self:updateState('Attack')
    elseif self.state == 'Attack' then
        self:updateState('Attack')
    else
        self:updateState('Run')
    end

    if self.state == 'Run' then
        if adventurer.x < self.x then
            self.dx = self.dx - WOLF_SPEED * dt
            if self.dx < -WOLF_SPEED then
                self.dx = -WOLF_SPEED
            end
        elseif adventurer.x > self.x then
            self.dx = self.dx + WOLF_SPEED * dt
            if self.dx > WOLF_SPEED then
                self.dx = WOLF_SPEED
            end
        end

        if self.distanceToAdventurer <= 25 then
            self.dx = 0
            self:updateState('Attack')
        end

        if self.distanceToAdventurer >= VIRTUAL_WIDTH / 2 + WOLF_WIDTH then
            self.dx = 0
            self:updateState('Idle')
        end
    end

    if self.state == 'Attack' then
        if self.animation:getCurrentFrame() >= 9 then
            if self.distanceToAdventurer <= 25 and self.hit and self.facingAdventurer then
                adventurer.hp = adventurer.hp - self.attack
                self.hit = false
            end
        end
        if self.animation:getCurrentFrame() == #wolfTextures[self.state] then
            self.hit = true
            self:updateState('Idle')
        end
    end

    self.animation:update(dt)
    return adventurer
end

function Wolf:updateState(state)
    if state == self.state then
        return
    end
    self.state = state
    local indexs = {}
    for x = 1, #wolfTextures[self.state] do
        table.insert(indexs, x)
    end
    local interval = 0.2
    if self.state == 'Attack' then
        interval = 0.1
    elseif self.state == 'Run' then
        interval = 0.15
    end
    self.animation = Animation({frames = indexs, interval = interval, hold = false})
end

function Wolf:render()
    if self.direction == 'right' then
        love.graphics.draw(wolfTextures[self.state][self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, 1, 1, -WOLF_WIDTH / 2, 0)
    else
        love.graphics.draw(wolfTextures[self.state][self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, -1, 1, VIRTUAL_WIDTH / 4, 0)
    end
end
