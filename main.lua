-- love shorthands
lg = love.graphics
lw = love.window
lk = love.keyboard
la = love.audio
le = love.event

-- general libraries
vec = require 'libs/vector'
colors = require 'libs/colors'

-- collision
bump = require 'libs/bump'
world = bump.newWorld()
moonshine = require 'libs/moonshine'
effect = moonshine(moonshine.effects.crt)
            .chain(moonshine.effects.scanlines)
effect.scanlines.opacity = 0.2

-- resolution
push = require 'libs/push'
gameW, gameH = 800, 450
local windowW, windowH = lw.getDesktopDimensions()
push:setupScreen(gameW, gameH, windowW * 0.7, windowH * 0.7)
lg.setDefaultFilter('nearest', 'nearest')

-- assets
assets = require('libs/cargo').init('assets')

-- visual
anim8 = require 'libs/anim8'
screen = require 'libs/shack'
screen:setDimensions(push:getDimensions())

-- audio
require 'libs/slam'
bgm = la.newSource('assets/audio/SwingJeDing.mp3', 'stream')
bgm:setLooping(true)
bgm:setVolume(0.3)
bgm:play()

exp3 = la.newSource('assets/audio/exp3.wav', 'static')
exp8 = la.newSource('assets/audio/exp8.wav', 'static')
pow3 = la.newSource('assets/audio/pow3.wav', 'static')
hit1 = la.newSource('assets/audio/hit1.wav', 'static')

step3 = la.newSource('assets/audio/stairs3.wav', 'static')
step3:setVolume(0.5)
step3:setLooping(true)

step4 = la.newSource('assets/audio/stairs4.wav', 'static')
step4:setVolume(0.5)
step4:setLooping(true)

-- classes
Class = require 'libs/class'
Entity = require 'classes/Entity'
Player = require 'classes/Player'
Ball = require 'classes/Ball'
Wall = require 'classes/Wall'

-- states
gamestate = require 'libs/gamestate'
startScreen = require 'states.startScreen'
gameScreen = require 'states.gameScreen'

-- game vars
telekinesisRadius = 80
kickStr = 2
launchStr = 45
debug = false

function love.load()
    lw.setTitle('Telekinessball')

    lg.setFont(assets.fonts.Graph35pix(64))
    
    gamestate.registerEvents()
    gamestate.switch(startScreen)
end

function love.keypressed(k)
    if k == 'f' then
        push:switchFullscreen()
    elseif k == 'q' or k == 'escape' then
        le.quit()
    end
end