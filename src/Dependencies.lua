Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'

require 'src/Animation'
require 'src/Adventurer'

gTextures = {
    ['adventurer-crouch-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-crouch-00.png'),
    ['adventurer-crouch-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-crouch-01.png'),
    ['adventurer-crouch-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-crouch-02.png'),
    ['adventurer-crouch-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-crouch-03.png'),
    ['adventurer-idle1-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-00.png'),
    ['adventurer-idle1-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-01.png'),
    ['adventurer-idle1-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-02.png'),
    ['adventurer-idle1-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-03.png'),
    ['adventurer-idle2-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-2-00.png'),
    ['adventurer-idle2-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-2-01.png'),
    ['adventurer-idle2-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-2-02.png'),
    ['adventurer-idle2-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-idle-2-03.png'),
    ['adventurer-jump-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-jump-00.png'),
    ['adventurer-jump-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-jump-01.png'),
    ['adventurer-jump-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-jump-02.png'),
    ['adventurer-jump-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-jump-03.png'),
    ['adventurer-run-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-run-00.png'),
    ['adventurer-run-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-run-01.png'),
    ['adventurer-run-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-run-02.png'),
    ['adventurer-run-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-run-03.png'),
    ['adventurer-run-04'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-run-04.png'),
    ['adventurer-run-05'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-run-05.png'),
    ['adventurer-fall-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-fall-00.png'),
    ['adventurer-fall-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-fall-01.png'),
    ['adventurer-slide-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-slide-00.png'),
    ['adventurer-slide-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-slide-01.png'),
    ['adventurer-stand-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-stand-00.png'),
    ['adventurer-stand-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-stand-01.png'),
    ['adventurer-stand-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-stand-02.png'),
    ['adventurer-swrd-drw-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-drw-00.png'),
    ['adventurer-swrd-drw-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-drw-01.png'),
    ['adventurer-swrd-drw-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-drw-02.png'),
    ['adventurer-swrd-drw-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-drw-03.png'),
    ['adventurer-swrd-shte-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-shte-00.png'),
    ['adventurer-swrd-shte-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-shte-01.png'),
    ['adventurer-swrd-shte-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-shte-02.png'),
    ['adventurer-swrd-shte-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-swrd-shte-03.png'),
    ['adventurer-crouch-walk-00'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-crouch-walk-00.png'),
    ['adventurer-crouch-walk-01'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-crouch-walk-01.png'),
    ['adventurer-crouch-walk-02'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-crouch-walk-02.png'),
    ['adventurer-crouch-walk-03'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-crouch-walk-03.png'),
    ['adventurer-crouch-walk-04'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-crouch-walk-04.png'),
    ['adventurer-crouch-walk-05'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-crouch-walk-05.png'),
    ['adventurer-get-up-00'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-00.png'),
    ['adventurer-get-up-01'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-01.png'),
    ['adventurer-get-up-02'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-02.png'),
    ['adventurer-get-up-03'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-03.png'),
    ['adventurer-get-up-04'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-04.png'),
    ['adventurer-get-up-05'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-05.png'),
    ['adventurer-get-up-06'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-get-up-06.png'),
    ['adventurer-run3-00'] = love.graphics.newImage('assets/run3/adventurer-run3-00.png'),
    ['adventurer-run3-01'] = love.graphics.newImage('assets/run3/adventurer-run3-01.png'),
    ['adventurer-run3-02'] = love.graphics.newImage('assets/run3/adventurer-run3-02.png'),
    ['adventurer-run3-03'] = love.graphics.newImage('assets/run3/adventurer-run3-03.png'),
    ['adventurer-run3-04'] = love.graphics.newImage('assets/run3/adventurer-run3-04.png'),
    ['adventurer-run3-05'] = love.graphics.newImage('assets/run3/adventurer-run3-05.png'),
    ['adventurer-walk-00'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-walk-00.png'),
    ['adventurer-walk-01'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-walk-01.png'),
    ['adventurer-walk-02'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-walk-02.png'),
    ['adventurer-walk-03'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-walk-03.png'),
    ['adventurer-walk-04'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-walk-04.png'),
    ['adventurer-walk-05'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-walk-05.png'),
    ['adventurer-attack1-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack1-00.png'),
    ['adventurer-attack1-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack1-01.png'),
    ['adventurer-attack1-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack1-02.png'),
    ['adventurer-attack1-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack1-03.png'),
    ['adventurer-attack1-04'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack1-04.png'),
    ['adventurer-attack2-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack2-00.png'),
    ['adventurer-attack2-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack2-01.png'),
    ['adventurer-attack2-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack2-02.png'),
    ['adventurer-attack2-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack2-03.png'),
    ['adventurer-attack2-04'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack2-04.png'),
    ['adventurer-attack3-00'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack3-00.png'),
    ['adventurer-attack3-01'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack3-01.png'),
    ['adventurer-attack3-02'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack3-02.png'),
    ['adventurer-attack3-03'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack3-03.png'),
    ['adventurer-attack3-04'] = love.graphics.newImage('assets/Adventurer-1.5/Individual Sprites/adventurer-attack3-04.png'),
    ['adventurer-run2-00'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-run2-00.png'),
    ['adventurer-run2-01'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-run2-01.png'),
    ['adventurer-run2-02'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-run2-02.png'),
    ['adventurer-run2-03'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-run2-03.png'),
    ['adventurer-run2-04'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-run2-04.png'),
    ['adventurer-run2-05'] = love.graphics.newImage('assets/Adventurer-Hand-Combat/Individual Sprites/adventurer-run2-05.png'),
    ['background_layer_1'] = love.graphics.newImage('assets/background/background_layer_1.png'),
    ['background_layer_2'] = love.graphics.newImage('assets/background/background_layer_2.png'),
    ['background_layer_3'] = love.graphics.newImage('assets/background/background_layer_3.png'),
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}