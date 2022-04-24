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
require 'src/Wolf'
require 'src/UI'
require 'src/Utils'

adventurerTextures = importAdventurerAssets()

wolfTextures = importWolfAssets()

background1 = love.graphics.newImage('assets/background/background_layer_1.png')
background2 = love.graphics.newImage('assets/background/background_layer_2.png')
background3 = love.graphics.newImage('assets/background/background_layer_3.png')

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}