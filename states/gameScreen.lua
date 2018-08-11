local gameScreen = {}

-- animation
local spritesheet = assets.sprites.spritesheet
local g = anim8.newGrid(32, 32, spritesheet:getWidth(), spritesheet:getHeight())
local plAnims = {
                anim8.newAnimation(g('1-2', 1), 0.2),
                anim8.newAnimation(g('3-4', 1), 0.1)
                }

-- game vars
local walls = {
                Wall(-5, 225, 10, 450), -- left
                Wall(805, 225, 10, 450), -- right
                Wall(400, -5, 800, 10), -- top
                Wall(400, 455, 800, 10), --btm
                }

local goals = {
                Goal(50, 225, 10, 450, 1),
                Goal(750, 225, 10, 450, 2),
}

local scores = {0, 0}

local balls = {
                Ball(400, 25, assets.sprites.ball),
                Ball(400, 125, assets.sprites.ball),
                Ball(400, 225, assets.sprites.ball),
                Ball(400, 325, assets.sprites.ball),
                Ball(400, 425, assets.sprites.ball),
                }

local p1 = Player(300, 225, spritesheet, plAnims, colors.aqua, step3)
local p2 = Player(500, 225, spritesheet, plAnims, colors.orange, step4)
p2.facing = -1

local gameEnd = false

function gameScreen:reset()
    screen:setShake(10)
    exp3:play()
    scores[1], scores[2] = 0, 0
    gameEnd = false
end

function gameScreen:enter()
    self:reset()
end

function gameScreen:update(dt)
    if scores[1] >= 10 or scores[2] >= 10 then
        gameEnd = true
    end
    
    local dx, dy = 0, 0
    screen:update(dt)
    
    -- p1 input
    -- keyboard
    if (lk.isDown('w')) then dy = dy - 1 end
    if (lk.isDown('s')) then dy = dy + 1 end
    if (lk.isDown('a')) then dx = dx - 1 end
    if (lk.isDown('d')) then dx = dx + 1 end
    
    -- joystick
    
    p1:update(dt, dx, dy)
    
    -- p2 input
    -- keyboard
    dx, dy = 0, 0
    if (lk.isDown('up')) then dy = dy - 1 end
    if (lk.isDown('down')) then dy = dy + 1 end
    if (lk.isDown('left')) then dx = dx - 1 end
    if (lk.isDown('right')) then dx = dx + 1 end
    
    -- joystick
    
    p2:update(dt, dx, dy)
    
    -- update balls
    for i,ball in ipairs(balls) do
        ball:update(dt, p1, p2)
    end
    
    -- update goals
    for i,goal in ipairs(goals) do
        goal:update(dt, scores)
    end
end

function gameScreen:draw()
    push:start()
    
    effect(function()
    
    screen:apply()
    
    lg.draw(assets.sprites.field1, 0, 0)
    
    -- draw balls
    for i,ball in ipairs(balls) do
        ball:draw()
    end
    
    if debug then
        for i,goal in ipairs(goals) do
            goal:draw()
        end
    end
    
    -- draw player
    p1:draw()
    p2:draw()
    
    -- draw scores
    lg.setColor(colors.black)
    lg.printf(scores[1] .. '/10    ' .. scores[2] .. '/10', 0, 50, gameW, 'center')
    
    lg.setColor(colors.white)
    if scores[1] >= 10 then
        lg.draw(assets.sprites.trophy, 330, 50)
    end
    
    end)
    
    push:finish()
end

function gameScreen:keypressed(k)
    if k == 'r' then
        self:reset()
    end
    
    if k == 'space' then
        p1:action(balls)
    end
    
    if k == 'return' then
        p2:action(balls)
    end
end

return gameScreen