Adventurer = Class{}

function Adventurer:init()
    self.x = VIRTUAL_WIDTH / 2 - ADVENTURER_WIDTH
    self.y = -ADVENTURER_HEIGHT

    self.hp = 10
    self.max_hp = 10

    self.dx = 0
    self.dx_floor = 0
    self.dy = 0

    self.has_sword = false
    self.knock_down = false

    self.jump_velocity = 0

    self.attack_counter = 0
    self.punch_counter = 0
    self.kick_counter = 0

    self.get_up_timer = 0
    self.lockout_timer = 0
    self.swd_draw_timer = 0
    self.swd_sheath_timer = 0
    self.stand_up_timer = 0
    self.attack1_timer = 0
    self.attack2_timer = 0
    self.attack3_timer = 0
    self.jumpSquat_timer = 0
    self.punch_timer = 0
    self.kick_timer = 0
    self.run_punch_timer = 0

    self.speed_before_jump = 0

    self.state = 'idle'
    self.direction = 'left'

    local indexs = {}
    for x = 1, #adventurerTextures[self.state] do
        table.insert(indexs, x)
    end
    self.animation = Animation({frames = indexs, interval = 0.2, hold = false})
end

function Adventurer:updateVelocity(acceleration_constant, dt)
    self.dx = self.dx + acceleration_constant * dt
    if self.state == 'crouch-walk' or self.state == 'walk' then
        if self.dx > ADVENTURER_MAX_CROUCH_WALK_SPEED then
            self.dx = ADVENTURER_MAX_CROUCH_WALK_SPEED
        elseif self.dx < -ADVENTURER_MAX_CROUCH_WALK_SPEED then
            self.dx = -ADVENTURER_MAX_CROUCH_WALK_SPEED
        end
    elseif self.state == 'run2' or self.state == 'run2-no-swrd' then
        if self.dx > ADVENTURER_MAX_SPRINT_SPEED then
            self.dx = ADVENTURER_MAX_SPRINT_SPEED
        elseif self.dx < -ADVENTURER_MAX_SPRINT_SPEED then
            self.dx = -ADVENTURER_MAX_SPRINT_SPEED
        end
    elseif self.state == 'jump' or self.state == 'fall' then
        local limit = 0
        if self.state_before_jump == 'walk' then
            limit = ADVENTURER_MAX_CROUCH_WALK_SPEED
        elseif self.state_before_jump == 'run2' or self.state_before_jump == 'run2-no-swrd' then
            limit = ADVENTURER_MAX_SPRINT_SPEED
        elseif self.state_before_jump == 'run' or self.state_before_jump == 'run3' then
            limit = ADVENTURER_MAX_RUN_SPEED
        else
            limit = ADVENTURER_MAX_RUN_SPEED
        end
            

        if self.dx > limit then
            self.dx = limit
        elseif self.dx < -limit then
            self.dx = -limit
        end
    else
        if self.dx > ADVENTURER_MAX_RUN_SPEED then
            self.dx = ADVENTURER_MAX_RUN_SPEED
        elseif self.dx < -ADVENTURER_MAX_RUN_SPEED then
            self.dx = -ADVENTURER_MAX_RUN_SPEED
        end
    end
    self.dx_floor = math.floor(self.dx)
end

function Adventurer:update(dt)
    -- update position
    self.x = self.x + self.dx_floor * dt
    self.y = self.y + self.dy * dt

    -- apply gravity and collision with ground
    if self.y < VIRTUAL_HEIGHT - ADVENTURER_HEIGHT then
        self.dy = self.dy + GRAVITY
    elseif self.y > VIRTUAL_HEIGHT - ADVENTURER_HEIGHT then
        self.y = VIRTUAL_HEIGHT - ADVENTURER_HEIGHT
        if self.dy > 500 then
            self:updateState('ground')
        end
        self.dy = 0
    end

    -- update direction based on velocity
    if self.dx_floor > 1 then
        self.direction = 'right'
    elseif self.dx_floor < -1 then
        self.direction = 'left'
    end

    -- apply acceleration to adventurer based on 'A', 'lshift', and 'D' keyboard input
    if (self.state == 'idle' or self.state == 'idle-no-swrd' or self.state == 'run' or self.state == 'run-no-swrd') and love.keyboard.isDown('d') and not love.keyboard.isDown('lshift') and not love.keyboard.isDown('lalt') and not love.keyboard.isDown('lctrl') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        if self.has_sword then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    elseif (self.state == 'idle' or self.state == 'idle-no-swrd' or self.state == 'run' or self.state == 'run-no-swrd') and love.keyboard.isDown('a') and not love.keyboard.isDown('lshift') and not love.keyboard.isDown('lalt') and not love.keyboard.isDown('lctrl') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        if self.has_sword then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    elseif (self.state == 'idle' or self.state == 'idle-no-swrd' or self.state == 'run' or self.state == 'run-no-swrd' or self.state == 'run2' or self.state == 'run2-no-swrd') and love.keyboard.isDown('a') and love.keyboard.isDown('lctrl') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        if self.has_sword then
            self:updateState('run2', 0.2, false)
        else
            self:updateState('run2-no-swrd', 0.2, false)
        end
    elseif (self.state == 'idle' or self.state == 'idle-no-swrd' or self.state == 'run' or self.state == 'run-no-swrd' or self.state == 'run2' or self.state == 'run2-no-swrd') and love.keyboard.isDown('d') and love.keyboard.isDown('lctrl') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        if self.has_sword then
            self:updateState('run2', 0.2, false)
        else
            self:updateState('run2-no-swrd', 0.2, false)
        end
    elseif (self.state == 'idle' or self.state == 'run' or self.state == 'walk') and love.keyboard.isDown('a') and love.keyboard.isDown('lalt') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('walk', 0.2, false)
    elseif (self.state == 'idle' or self.state == 'run' or self.state == 'walk') and love.keyboard.isDown('d') and love.keyboard.isDown('lalt') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('walk', 0.2, false)
    elseif (self.state == 'idle-2' or self.state == 'run3') and love.keyboard.isDown('d') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('run3', 0.2, false)
    elseif (self.state == 'idle-2' or self.state == 'run3') and love.keyboard.isDown('a') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('run3', 0.2, false)
    elseif (self.state == 'jump' or self.state == 'fall' or self.state == 'jump-no-swrd' or self.state == 'run-punch') and love.keyboard.isDown('d') then
        if self.state == 'run-punch' then
            self:updateVelocity(-ADVENTURER_SLIDE_DECELERATION, dt)
        else
            self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        end
    elseif (self.state == 'jump' or self.state == 'fall' or self.state == 'jump-no-swrd' or self.state == 'run-punch') and love.keyboard.isDown('a') then
        if self.state == 'run-punch' then
            self:updateVelocity(ADVENTURER_SLIDE_DECELERATION, dt)
        else
            self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        end
    elseif (self.state == 'crouch' or self.state == 'crouch-walk' or self.state == 'crouch-no-swrd' or self.state == 'crouch-walk-no-swrd') and love.keyboard.isDown('a') and love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        if self.state == 'crouch' or self.state == 'crouch-walk' then
            self:updateState('crouch-walk', 0.2, false)
        elseif self.state == 'crouch-no-swrd' or self.state == 'crouch-walk-no-swrd' then
            self:updateState('crouch-walk-no-swrd', 0.2, false)
        end
    elseif (self.state == 'crouch' or self.state == 'crouch-walk' or self.state == 'crouch-no-swrd' or self.state == 'crouch-walk-no-swrd') and love.keyboard.isDown('d') and love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        if self.has_sword then
            self:updateState('crouch-walk', 0.2, false)
        else
            self:updateState('crouch-walk-no-swrd', 0.2, false)
        end
    elseif (self.state == 'crouch-walk' or self.state == 'crouch-walk-no-swrd') and love.keyboard.isDown('a') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        if self.has_swrd then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    elseif (self.state == 'crouch-walk') and love.keyboard.isDown('d') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        if self.has_swrd then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    elseif (self.state == 'walk') and love.keyboard.isDown('d') and not love.keyboard.isDown('lalt') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        if self.has_swrd then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    elseif (self.state == 'walk') and love.keyboard.isDown('a') and not love.keyboard.isDown('lalt') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        if self.has_swrd then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    elseif (self.state == 'run3' or self.state == 'run' or self.state == 'slide' or self.state == 'run2' or self.state == 'run2-no-swrd' or self.state == 'run-no-swrd' or self.state == 'slide-no-swrd') and love.keyboard.isDown('lshift') then
        if self.has_swrd then
            self:updateState('slide', 0.2, false)
        else
            self:updateState('slide-no-swrd', 0.2, false)
        end
        if self.dx_floor > 0 then
            self:updateVelocity(-ADVENTURER_SLIDE_DECELERATION, dt)
        elseif self.dx_floor < 0 then
            self:updateVelocity(ADVENTURER_SLIDE_DECELERATION, dt)
        end
    else
        if self.state == 'slide' or self.state == 'slide-no-swrd' then
            if self.dx_floor > 0 then
                self:updateVelocity(-ADVENTURER_SLIDE_DECELERATION, dt)
            elseif self.dx_floor < 0 then
                self:updateVelocity(ADVENTURER_SLIDE_DECELERATION, dt)
            end
        else
            -- apply deceleration to adventurer when neither key is pressed
            if self.dx_floor > 0 then
                self:updateVelocity(-ADVENTURER_DECELERATION, dt)
            elseif self.dx_floor < 0 then
                self:updateVelocity(ADVENTURER_DECELERATION, dt)
            end
        end
    end

    -- if self.knock_down then
    --     self.knock_down = false
    --     self:updateState('knock-dwn')
    -- end

    if self.state == 'ground' and (love.keyboard.isDown('space') or love.keyboard.isDown('a') or love.keyboard.isDown('d')) then
        self:updateState('get-up', 0.1, false)
    elseif self.state == 'ground' and not love.keyboard.isDown('space') and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
        self:updateState('ground', 0.2, true)
    end

    if self.state == 'get-up' then
        self.stand_up_timer = self.stand_up_timer + dt
        if self.stand_up_timer > #self.animation.frames * self.animation.interval then
            if self.has_sword then
                self:updateState('idle', 0.2, false)
            else
                self:updateState('idle-no-swrd', 0.2, false)
            end
        end
    else
        self.stand_up_timer = 0
    end

    if self.knock_down then
        self.knock_down = false
        if self.has_sword then
            self:updateState('hurt', 0.2, false)
        else
            self:updateState('hurt-no-swrd', 0.2, false)
        end
    end

    if (self.state == 'hurt' or self.state == 'hurt-no-swrd') and self.animation:getCurrentFrame() == #self.animation.frames then
        if self.has_sword then
            self:updateState('idle', 0.2, false)
        else
            self:updateState('idle-no-swrd', 0.2, false)
        end
    end

    if self.state == 'idle-2' and love.keyboard.isDown('1') then
        self:updateState('attack1', 0.1, false)
    end

    if self.state == 'attack1' then
        self.attack1_timer = self.attack1_timer + dt
        if self.attack1_timer > #self.animation.frames * self.animation.interval then
            if self.attack_counter >= 2 then
                self:updateState('attack2', 0.1, false)
            else
                self.attack_counter = 0
                self:updateState('idle-2', 0.2, false)
            end
        end
        if love.keyboard.wasPressed('1') then
            self.attack_counter = self.attack_counter + 1
        end
    else
        self.attack1_timer = 0
    end

    if self.state == 'attack2' then
        self.attack2_timer = self.attack2_timer + dt
        if self.attack2_timer > #self.animation.frames * self.animation.interval then
            if self.attack_counter >= 3 then
                self:updateState('attack3', 0.1, false)
            else
                self.attack_counter = 0
                self:updateState('idle-2', 0.2, false)
            end
        end
        if love.keyboard.wasPressed('1') then
            self.attack_counter = self.attack_counter + 1
        end
    else
        self.attack2_timer = 0
    end

    if self.state == 'attack3' then
        self.attack3_timer = self.attack3_timer + dt
        if self.attack3_timer > #self.animation.frames * self.animation.interval then
            self.attack_counter = 0
            self:updateState('idle-2', 0.2, false)
        end
    else
        self.attack3_timer = 0
    end

    if (self.state == 'run-no-swrd' or self.state == 'run2-no-swrd') and love.mouse.wasPressed(1) then
        self:updateState('run-punch', 0.1, false)
    end

    if self.state == 'run-punch' then
        self.run_punch_timer = self.run_punch_timer + dt
        if self.run_punch_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idle-no-swrd', 0.2, false)
        end
    else
        self.run_punch_timer = 0
    end

    if self.state == 'idle-no-swrd' and love.mouse.wasPressed(1) then
        self:updateState('punch', 0.1, false)
    elseif self.state == 'idle-no-swrd' and love.mouse.wasPressed(2) then
        self:updateState('kick', 0.1, false)
    end

    if self.state == 'kick' then
        self.kick_timer = self.kick_timer + dt
        if love.mouse.wasPressed(2) then
            self.kick_counter = self.kick_counter + 1
        end
        if self.kick_timer > 5 * self.animation.interval and self.kick_timer < #self.animation.frames * self.animation.interval then
            if self.kick_counter < 2 then
                self.kick_counter = 0
                self:updateState('idle-no-swrd', 0.2, false)
            end
        elseif self.kick_timer > #self.animation.frames * self.animation.interval then
            self.kick_counter = 0
            self:updateState('idle-no-swrd', 0.2, false)
        end
    else
        self.kick_timer = 0
    end

    if self.state == 'punch' then
        self.punch_timer = self.punch_timer + dt
        if love.mouse.wasPressed(1) then
            self.punch_counter = self.punch_counter + 1
        end
        if self.punch_timer > 4 * self.animation.interval and self.punch_timer < 8 * self.animation.interval then
            if self.punch_counter < 2 then
                self.punch_counter = 0
                self:updateState('idle-no-swrd', 0.2, false)
            end
        elseif self.punch_timer > 8 * self.animation.interval and self.punch_timer < #self.animation.frames * self.animation.interval then
            if self.punch_counter < 3 then
                self.punch_counter = 0
                self:updateState('idle-no-swrd', 0.2, false)
            end
        elseif self.punch_timer > #self.animation.frames * self.animation.interval then
            self.punch_counter = 0
            self:updateState('idle-no-swrd', 0.2, false)
        end
    else
        self.punch_timer = 0
    end
        


    if self.state == 'walk' and self.dx_floor == 0 then
        self:updateState('idle', 0.2, false)
    end

    -- go to idle or slideTransition once we have stopped running
    if (self.state == 'run' or self.state == 'run2' or self.state == 'run-no-swrd' or self.state == 'run2-no-swrd') and self.dx_floor == 0 then
        if self.has_sword then
            self:updateState('idle', 0.2, false)
        else
            self:updateState('idle-no-swrd', 0.2, false)
        end
    elseif (self.state == 'slide' or self.state == 'slide-no-swrd') and self.dx_floor == 0 then
        if self.has_sword then
            self:updateState('stand', 0.1, false)
        else
            self:updateState('stand-no-swrd', 0.1, false)
        end
    elseif self.state == 'run3' and self.dx_floor == 0 then
        self:updateState('idle-2', 0.2, false)
    end

    if (self.state == 'run2' or self.state == 'run2-no-swrd') and not love.keyboard.isDown('lctrl') then
        if self.has_sword then
            self:updateState('run', 0.2, false)
        else
            self:updateState('run-no-swrd', 0.2, false)
        end
    end

    if self.state == 'stand' or self.state == 'stand-no-swrd' then
        self.get_up_timer = self.get_up_timer + dt
        if self.get_up_timer > #self.animation.frames * self.animation.interval then
            if self.has_swrd then
                self:updateState('lockout', 0.075, false)
            else
                self:updateState('lockout-no-swrd', 0.075, false)
            end
        end
    else
        self.get_up_timer = 0
    end

    if self.state == 'lockout' or self.state == 'lockout-no-swrd' then
        self.lockout_timer = self.lockout_timer + dt
        local num_frames = #self.animation.frames
        if love.keyboard.isDown('lshift') then
            num_frames = #self.animation.frames - 1
        end
        if self.lockout_timer > num_frames * self.animation.interval then
            if self.has_swrd then
                self:updateState('idle', 0.075, false)
            else
                self:updateState('idle-no-swrd', 0.075, false)
            end
        end
    else
        self.lockout_timer = 0
    end

    if self.state == 'swrd-drw' then
        self.swd_draw_timer = self.swd_draw_timer + dt
        if self.swd_draw_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idle-2', 0.2, false)
        end
    else
        self.swd_draw_timer = 0
    end

    if self.state == 'swrd-shte' then
        self.swd_sheath_timer = self.swd_sheath_timer + dt
        if self.swd_sheath_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idle', 0.2, false)
        end
    else
        self.swd_sheath_timer = 0
    end


    -- start jump animation if on ground and space is pressed
    if (self.state == 'idle' or self.state == 'idle-2' or self.state == 'run' or self.state == 'run3' or self.state == 'walk' or self.state == 'run2' or self.state == 'run2-no-swrd' or self.state == 'idle-no-swrd' or self.state == 'run-no-swrd') and love.keyboard.isDown('space') then
        self.state_before_jump = self.state
        if (self.state == 'idle' or self.state == 'idle-2') then
            self:updateState('jumpSquat', 0.2, true)
        elseif self.state == 'idle-no-swrd' then
            self:updateState('jumpSquat-no-swrd', 0.2, true)
        else
            self.jump_velocity = ADVENTURER_MAX_JUMP_VELOCITY + (0.50 * ADVENTURER_MIN_JUMP_VELOCITY)
            if self.has_sword then
                self:updateState('jump-no-swrd', 0.2, false)
            else
                self:updateState('jump', 0.2, false)
            end
        end
    end

    -- stay in jumpSquat until you release space
    if (self.state == 'jumpSquat' or self.state == 'jumpSquat-no-swrd') and not love.keyboard.isDown('space') then
        self.jump_velocity = ADVENTURER_MAX_JUMP_VELOCITY + (self.jumpSquat_timer * ADVENTURER_MIN_JUMP_VELOCITY)
        if self.has_sword then
            self:updateState('jump', 0.2, false)
        else
            self:updateState('jump-no-swrd', 0.2, false)
        end
    elseif (self.state == 'jumpSquat' or self.state == 'jumpSquat-no-swrd') and love.keyboard.isDown('space') then
        self.jumpSquat_timer = self.jumpSquat_timer + dt
        if self.jumpSquat_timer > 1 then
            self.jumpSquat_timer = 1
        end
    else
        self.jumpSquat_timer = 0
    end

    -- switch to fall state once y velocity is towards ground
    if self.dy > 0 then
        self:updateState('fall', 0.2, false)
    end

    -- switch to idle state once y velocity has reached 0 i.e. is on ground
    if self.state == 'fall' and self.dy == 0 then
        if self.has_sword then
            self:updateState('idle', 0.2, false)
        else
            self:updateState('idle-no-swrd', 0.2, false)
        end
    end

    if (self.state == 'crouch-walk' or self.state == 'crouch-walk-no-swrd') and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') and love.keyboard.isDown('lshift') and self.dx_floor == 0 then
        if self.has_sword then
            self:updateState('crouch', 0.2, false)
        else
            self:updateState('crouch-no-swrd', 0.2, false)
        end
    elseif (self.state == 'idle-2' or self.state == "idle" or self.state == 'idle-no-swrd' or self.state == 'crouch' or self.state == 'crouch-no-swrd') and self.y == VIRTUAL_HEIGHT - ADVENTURER_HEIGHT and love.keyboard.isDown('lshift') then
        if self.state == 'idle-2' then
            self:updateState('swrd-shte', 0.1, false)
        else
            if self.has_sword then
                self:updateState('crouch', 0.2, false)
            else
                self:updateState('crouch-no-swrd', 0.2, false)
            end
        end
    end

    if (self.state == 'crouch-walk' or self.state == 'crouch-walk-no-swrd') and self.dx_floor == 0 then
        if love.keyboard.isDown('lshift') then
            if self.has_sword then
                self:updateState('crouch', 0.2, false)
            else
                self:updateState('crouch-no-swrd', 0.2, false)
            end
        else
            if self.has_sword then
                self:updateState('idle', 0.2, false)
            else
                self:updateState('idle-no-swrd', 0.2, false)
            end
        end
    end

    -- return to idle state from crouch state if not holding 'lshift'
    if (self.state == 'crouch' or self.state == 'crouch-no-swrd') and not love.keyboard.isDown('lshift') then
        if self.has_sword then
            self:updateState('idle', 0.2, false)
        else
            self:updateState('idle-no-swrd', 0.2, false)
        end
    end

    if self.state == 'idle' and (love.keyboard.wasPressed('f') or love.keyboard.wasPressed('1')) then
        self:updateState('swrd-drw', 0.1, false)
    elseif self.state == 'idle-2' and love.keyboard.wasPressed('f') then
        self:updateState('swrd-shte', 0.1, false)
    end

    self.animation:update(dt)
end

function Adventurer:updateState(state, interval, hold)
    if state == self.state then
        return
    end
    self.state = state
    local indexs = {}
    for x = 1, #adventurerTextures[self.state] do
        table.insert(indexs, x)
    end
    if self.state == 'jump' or self.state == 'jump-no-swrd' then
        self.dy = self.jump_velocity
    end
    self.animation = Animation({frames = indexs, interval = interval, hold = hold})
end

function Adventurer:render()
    if self.direction == 'right' then
        love.graphics.draw(adventurerTextures[self.state][self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, 1, 1, -ADVENTURER_WIDTH / 2, 0)
    else
        love.graphics.draw(adventurerTextures[self.state][self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, -1, 1, VIRTUAL_WIDTH / 4, 0)
    end
end
