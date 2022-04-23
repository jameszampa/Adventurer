Adventurer = Class{}

function Adventurer:init()
    self.x = VIRTUAL_WIDTH / 2 - ADVENTURER_WIDTH
    self.y = -ADVENTURER_HEIGHT

    self.dx = 0
    self.dx_floor = 0
    self.dy = 0

    self.jump_velocity = 0

    self.attack_counter = 0

    self.get_up_timer = 0
    self.lockout_timer = 0
    self.swd_draw_timer = 0
    self.swd_sheath_timer = 0
    self.stand_up_timer = 0
    self.attack1_timer = 0
    self.attack2_timer = 0
    self.attack3_timer = 0
    self.jumpSquat_timer = 0

    self.speed_before_jump = 0

    self.state = 'idle'
    self.direction = 'left'

    self.idle1 = {'adventurer-idle1-00', 'adventurer-idle1-01', 'adventurer-idle1-02', 'adventurer-idle1-03'}
    self.crouch = {'adventurer-crouch-00', 'adventurer-crouch-01', 'adventurer-crouch-02', 'adventurer-crouch-03'}
    self.jumpSquat = {'adventurer-jump-00', 'adventurer-jump-01'}
    self.jump = {'adventurer-jump-02', 'adventurer-jump-03'}
    self.fall = {'adventurer-fall-00', 'adventurer-fall-01'}
    self.run = {'adventurer-run-00', 'adventurer-run-01', 'adventurer-run-02', 'adventurer-run-03', 'adventurer-run-04', 'adventurer-run-05'}
    self.slide = {'adventurer-slide-00', 'adventurer-slide-01'}
    self.slideTransition = {'adventurer-stand-00', 'adventurer-stand-01', 'adventurer-stand-02'}
    self.lockout = {'adventurer-crouch-00', 'adventurer-idle1-00'}
    self.idle2 = {'adventurer-idle2-00', 'adventurer-idle2-01', 'adventurer-idle2-02', 'adventurer-idle2-03'}
    self.swd_draw = {'adventurer-swrd-drw-00', 'adventurer-swrd-drw-01', 'adventurer-swrd-drw-02', 'adventurer-swrd-drw-03'}
    self.swd_sheath = {'adventurer-swrd-shte-00', 'adventurer-swrd-shte-01', 'adventurer-swrd-shte-02', 'adventurer-swrd-shte-03'}
    self.crouch_walk = {'adventurer-crouch-walk-00', 'adventurer-crouch-walk-01', 'adventurer-crouch-walk-02', 'adventurer-crouch-walk-03', 'adventurer-crouch-walk-04', 'adventurer-crouch-walk-05'}
    self.ground = {'adventurer-get-up-00'}
    self.stand_up = {'adventurer-get-up-01','adventurer-get-up-02','adventurer-get-up-03','adventurer-get-up-04','adventurer-get-up-05','adventurer-get-up-06'}
    self.swd_run = {'adventurer-run3-00', 'adventurer-run3-01', 'adventurer-run3-02', 'adventurer-run3-03', 'adventurer-run3-04', 'adventurer-run3-05'}
    self.walk = {'adventurer-walk-00', 'adventurer-walk-01', 'adventurer-walk-02', 'adventurer-walk-03', 'adventurer-walk-04', 'adventurer-walk-05'}
    self.attack1 = {'adventurer-attack1-00', 'adventurer-attack1-01', 'adventurer-attack1-02', 'adventurer-attack1-03', 'adventurer-attack1-04'}
    self.attack2 = {'adventurer-attack2-00', 'adventurer-attack2-01', 'adventurer-attack2-02', 'adventurer-attack2-03', 'adventurer-attack2-04'}
    self.attack3 = {'adventurer-attack3-00', 'adventurer-attack3-01', 'adventurer-attack3-02', 'adventurer-attack3-03', 'adventurer-attack3-04'}
    self.sprint = {'adventurer-run2-00','adventurer-run2-01','adventurer-run2-02','adventurer-run2-03','adventurer-run2-04','adventurer-run2-05'}

    self.animation = Animation({frames = self.idle1, interval = 0.2})
end

function Adventurer:updateVelocity(acceleration_constant, dt)
    self.dx = self.dx + acceleration_constant * dt
    if self.state == 'crouch_walk' or self.state == 'walk' then
        if self.dx > ADVENTURER_MAX_CROUCH_WALK_SPEED then
            self.dx = ADVENTURER_MAX_CROUCH_WALK_SPEED
        elseif self.dx < -ADVENTURER_MAX_CROUCH_WALK_SPEED then
            self.dx = -ADVENTURER_MAX_CROUCH_WALK_SPEED
        end
    elseif self.state == 'sprint' then
        if self.dx > ADVENTURER_MAX_SPRINT_SPEED then
            self.dx = ADVENTURER_MAX_SPRINT_SPEED
        elseif self.dx < -ADVENTURER_MAX_SPRINT_SPEED then
            self.dx = -ADVENTURER_MAX_SPRINT_SPEED
        end
    elseif self.state == 'jump' or self.state == 'fall' then
        local limit = 0
        if self.state_before_jump == 'walk' then
            limit = ADVENTURER_MAX_CROUCH_WALK_SPEED
        elseif self.state_before_jump == 'sprint' then
            limit = ADVENTURER_MAX_SPRINT_SPEED
        elseif self.state_before_jump == 'run' or self.state_before_jump == 'swd_run' then
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

    -- apply collision with walls
    if self.x < 0 then
        self.x = 0
    elseif self.x > VIRTUAL_WIDTH - ADVENTURER_WIDTH then
        self.x = VIRTUAL_WIDTH - ADVENTURER_WIDTH
    end

    -- update direction based on velocity
    if self.dx_floor > 1 then
        self.direction = 'right'
    elseif self.dx_floor < -1 then
        self.direction = 'left'
    end

    -- apply acceleration to adventurer based on 'A', 'lshift', and 'D' keyboard input
    if (self.state == 'idle' or self.state == 'run') and love.keyboard.isDown('d') and not love.keyboard.isDown('lshift') and not love.keyboard.isDown('lalt') and not love.keyboard.isDown('lctrl') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('run')
    elseif (self.state == 'idle' or self.state == 'run') and love.keyboard.isDown('a') and not love.keyboard.isDown('lshift') and not love.keyboard.isDown('lalt') and not love.keyboard.isDown('lctrl') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('run')
    elseif (self.state == 'idle' or self.state == 'run' or self.state == 'sprint') and love.keyboard.isDown('a') and love.keyboard.isDown('lctrl') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('sprint')
    elseif (self.state == 'idle' or self.state == 'run' or self.state == 'sprint') and love.keyboard.isDown('d') and love.keyboard.isDown('lctrl') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('sprint')
    elseif (self.state == 'idle' or self.state == 'run' or self.state == 'walk') and love.keyboard.isDown('a') and love.keyboard.isDown('lalt') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('walk')
    elseif (self.state == 'idle' or self.state == 'run' or self.state == 'walk') and love.keyboard.isDown('d') and love.keyboard.isDown('lalt') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('walk')
    elseif (self.state == 'idle2' or self.state == 'swd_run') and love.keyboard.isDown('d') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('swd_run')
    elseif (self.state == 'idle2' or self.state == 'swd_run') and love.keyboard.isDown('a') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('swd_run')
    elseif (self.state == 'jump' or self.state == 'fall') and love.keyboard.isDown('d') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
    elseif (self.state == 'jump' or self.state == 'fall') and love.keyboard.isDown('a') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
    elseif (self.state == 'crouch' or self.state == 'crouch_walk') and love.keyboard.isDown('a') and love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('crouch_walk')
    elseif (self.state == 'crouch' or self.state == 'crouch_walk') and love.keyboard.isDown('d') and love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('crouch_walk')
    elseif (self.state == 'crouch_walk') and love.keyboard.isDown('a') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('run')
    elseif (self.state == 'crouch_walk') and love.keyboard.isDown('d') and not love.keyboard.isDown('lshift') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('run')
    elseif (self.state == 'walk') and love.keyboard.isDown('d') and not love.keyboard.isDown('lalt') then
        self:updateVelocity(ADVENTURER_ACCELERATION, dt)
        self:updateState('run')
    elseif (self.state == 'walk') and love.keyboard.isDown('a') and not love.keyboard.isDown('lalt') then
        self:updateVelocity(-ADVENTURER_ACCELERATION, dt)
        self:updateState('run')
    elseif (self.state == 'swd_run' or self.state == 'run' or self.state == 'slide' or self.state == 'sprint') and love.keyboard.isDown('lshift') then
        self:updateState('slide')
        if self.dx_floor > 0 then
            self:updateVelocity(-ADVENTURER_SLIDE_DECELERATION, dt)
        elseif self.dx_floor < 0 then
            self:updateVelocity(ADVENTURER_SLIDE_DECELERATION, dt)
        end
    else
        if self.state == 'slide' then
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

    if self.state == 'ground' and (love.keyboard.isDown('space') or love.keyboard.isDown('a') or love.keyboard.isDown('d')) then
        self:updateState('stand_up')
    elseif self.state == 'ground' and not love.keyboard.isDown('space') and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
        self:updateState('ground')
    end

    if self.state == 'stand_up' then
        self.stand_up_timer = self.stand_up_timer + dt
        if self.stand_up_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idle')
        end
    else
        self.stand_up_timer = 0
    end

    if self.state == 'idle2' and love.keyboard.isDown('1') then
        self:updateState('attack1')
    end

    if self.state == 'attack1' then
        self.attack1_timer = self.attack1_timer + dt
        if self.attack1_timer > #self.animation.frames * self.animation.interval then
            if self.attack_counter >= 2 then
                self:updateState('attack2')
            else
                self.attack_counter = 0
                self:updateState('idle2')
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
                self:updateState('attack3')
            else
                self.attack_counter = 0
                self:updateState('idle2')
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
            self:updateState('idle2')
        end
    else
        self.attack3_timer = 0
    end

    if self.state == 'walk' and self.dx_floor == 0 then
        self:updateState('idle')
    end

    -- go to idle or slideTransition once we have stopped running
    if (self.state == 'run' or self.state == 'sprint') and self.dx_floor == 0 then
        self:updateState('idle')
    elseif self.state == 'slide' and self.dx_floor == 0 then
        self:updateState('slideTransition')
    elseif self.state == 'swd_run' and self.dx_floor == 0 then
        self:updateState('idle2')
    end

    if self.state == 'sprint' and not love.keyboard.isDown('lctrl') then
        self:updateState('run')
    end

    if self.state == 'slideTransition' then
        self.get_up_timer = self.get_up_timer + dt
        if self.get_up_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idleLockOut')
        end
    else
        self.get_up_timer = 0
    end

    if self.state == 'idleLockOut' then
        self.lockout_timer = self.lockout_timer + dt
        local num_frames = #self.animation.frames
        if love.keyboard.isDown('lshift') then
            num_frames = #self.animation.frames - 1
        end
        if self.lockout_timer > num_frames * self.animation.interval then
            self:updateState('idle')
        end
    else
        self.lockout_timer = 0
    end

    if self.state == 'swd_draw' then
        self.swd_draw_timer = self.swd_draw_timer + dt
        if self.swd_draw_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idle2')
        end
    else
        self.swd_draw_timer = 0
    end

    if self.state == 'swd_sheath' then
        self.swd_sheath_timer = self.swd_sheath_timer + dt
        if self.swd_sheath_timer > #self.animation.frames * self.animation.interval then
            self:updateState('idle')
        end
    else
        self.swd_sheath_timer = 0
    end


    -- start jump animation if on ground and space is pressed
    if (self.state == 'idle' or self.state == 'idle2' or self.state == 'run' or self.state == 'swd_run' or self.state == 'walk' or self.state == 'sprint') and love.keyboard.isDown('space') then
        self.state_before_jump = self.state
        if self.state == 'idle' then
            self:updateState('jumpSquat')
        elseif self.state == 'idle2' then
            self:updateState('jumpSquat')
        else
            self.jump_velocity = ADVENTURER_MAX_JUMP_VELOCITY + (0.50 * ADVENTURER_MIN_JUMP_VELOCITY)
            self:updateState('jump')
        end
    end

    -- stay in jumpSquat until you release space
    if self.state == 'jumpSquat' and not love.keyboard.isDown('space') then
        self.jump_velocity = ADVENTURER_MAX_JUMP_VELOCITY + (self.jumpSquat_timer * ADVENTURER_MIN_JUMP_VELOCITY)
        self:updateState('jump')
    elseif self.state == 'jumpSquat' and love.keyboard.isDown('space') then
        self.jumpSquat_timer = self.jumpSquat_timer + dt
        if self.jumpSquat_timer > 1 then
            self.jumpSquat_timer = 1
        end
    else
        self.jumpSquat_timer = 0
    end

    -- switch to fall state once y velocity is towards ground
    if self.dy > 0 then
        self:updateState('fall')
    end

    -- switch to idle state once y velocity has reached 0 i.e. is on ground
    if self.state == 'fall' and self.dy == 0 then
        self:updateState('idle')
    end

    if self.state == 'crouch_walk' and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') and love.keyboard.isDown('lshift') and self.dx_floor == 0 then
        self:updateState('crouch')
    elseif (self.state == 'idle2' or self.state == "idle" or self.state == 'crouch') and self.y == VIRTUAL_HEIGHT - ADVENTURER_HEIGHT and love.keyboard.isDown('lshift') then
        if self.state == 'idle2' then
            self:updateState('swd_sheath')
        else
            self:updateState('crouch')
        end
    end

    if self.state == 'crouch_walk' and self.dx_floor == 0 then
        if love.keyboard.isDown('lshift') then
            self:updateState('crouch')
        else
            self:updateState('idle')
        end
    end

    -- return to idle state from crouch state if not holding 'lshift'
    if self.state == 'crouch' and not love.keyboard.isDown('lshift') then
        self:updateState('idle')
    end

    if self.state == 'idle' and (love.keyboard.wasPressed('f') or love.keyboard.wasPressed('1')) then
        self:updateState('swd_draw')
    elseif self.state == 'idle2' and love.keyboard.wasPressed('f') then
        self:updateState('swd_sheath')
    end

    self.animation:update(dt)
end

function Adventurer:updateState(state)
    if state == self.state then
        return
    end
    self.state = state
    if self.state == 'idle' then
        self.animation = Animation({frames = self.idle1, interval = 0.2, hold = false})
    elseif self.state == 'crouch' then
        self.animation = Animation({frames = self.crouch, interval = 0.2, hold = false})
    elseif self.state == 'jumpSquat' then
        self.animation = Animation({frames = self.jumpSquat, interval = 0.2, hold = true})
    elseif self.state == 'jump' then
        self.dy = self.jump_velocity
        self.animation = Animation({frames = self.jump, interval = 0.2, hold = false})
    elseif self.state == 'run' then
        self.animation = Animation({frames = self.run, interval = 0.2, hold = false})
    elseif self.state == 'fall' then
        self.animation = Animation({frames = self.fall, interval = 0.2, hold = false})
    elseif self.state == 'slide' then
        self.animation = Animation({frames = self.slide, interval = 0.2, hold = false})
    elseif self.state == 'slideTransition' then
        self.animation = Animation({frames = self.slideTransition, interval = 0.1, hold = false})
    elseif self.state == 'idleLockOut' then
        self.animation = Animation({frames = self.lockout, interval = 0.075, hold = false})
    elseif self.state == 'idle2' then
        self.animation = Animation({frames = self.idle2, interval = 0.2, hold = false})
    elseif self.state == 'swd_draw' then
        self.animation = Animation({frames = self.swd_draw, interval = 0.1, hold = false})
    elseif self.state == 'swd_sheath' then
        self.animation = Animation({frames = self.swd_sheath, interval = 0.1, hold = false})
    elseif self.state == 'crouch_walk' then
        self.animation = Animation({frames = self.crouch_walk, interval = 0.2, hold = false})
    elseif self.state == 'ground' then
        self.animation = Animation({frames = self.ground, interval = 0.2, hold = true})
    elseif self.state == 'stand_up' then
        self.animation = Animation({frames = self.stand_up, interval = 0.1, hold = false})
    elseif self.state == 'swd_run' then
        self.animation = Animation({frames = self.swd_run, interval = 0.2, hold = false})
    elseif self.state == 'walk' then
        self.animation = Animation({frames = self.walk, interval = 0.2, hold = false})
    elseif self.state == 'attack1' then
        self.animation = Animation({frames = self.attack1, interval = 0.1, hold = false})
    elseif self.state == 'attack2' then
        self.animation = Animation({frames = self.attack2, interval = 0.1, hold = false})
    elseif self.state == 'attack3' then
        self.animation = Animation({frames = self.attack3, interval = 0.1, hold = false})
    elseif self.state == 'sprint' then
        self.animation = Animation({frames = self.sprint, interval = 0.2, hold = false})
    else
        self.animation = Animation({frames = self.idle1, interval = 0.2, hold = false})
    end
end

function Adventurer:render()
    if self.direction == 'right' then
        love.graphics.draw(gTextures[self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, 1, 1, -ADVENTURER_WIDTH / 2, 0)
    else
        love.graphics.draw(gTextures[self.animation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), 0, -1, 1, VIRTUAL_WIDTH / 4, 0)
    end
end
