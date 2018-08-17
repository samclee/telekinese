local gameScreen = {}

-- animation/visual
local trophy = assets.sprites.trophy
local spritesheet = assets.sprites.spritesheet
local g = anim8.newGrid(32, 32, spritesheet:getWidth(), spritesheet:getHeight())
local plAnims = {
                anim8.newAnimation(g('1-2', 1), 0.2),
                anim8.newAnimation(g('3-4', 1), 0.1)
                }

-- game vars
local walls = {
                Wall(-20, 225, 40, 450), -- left
                Wall(820, 225, 40, 450), -- right
                Wall(400, -20, 800, 40), -- top
                Wall(400, 470, 800, 40), --btm
                
                Wall(32 * 7.5, 32 * 4, 32, 64), --TL
                Wall(32 * 7.5, 32 * 10, 32, 64), --BL
                Wall(32 * 17.5, 32 * 4, 32, 64), --TR
                Wall(32 * 17.5, 32 * 10, 32, 64), --BR

                }

local goals = {
                Goal(7, 225, 14, 128, 1),
                Goal(793, 225, 14, 128, 2),
}

local scores = {0, 0}

local balls = {
                Ball(0, 0, assets.sprites.ball),
                Ball(0, 0, assets.sprites.ball),
                Ball(0, 0, assets.sprites.ball),
                Ball(0, 0, assets.sprites.ball),
                Ball(0, 0, assets.sprites.ball),
                }
local ballLocs = { {400-24, 225-24},
                   {340-24, 125-24},
                   {460-24, 125-24},
                   {340-24, 325-24},
                   {460-24, 325-24},
                   }

local p1 = Player(0, 0, spritesheet, plAnims, colors.aqua, step3)
local p2 = Player(0, 0, spritesheet, plAnims, colors.orange, step4)
local maxScore = 1
local gameEnd = false

-- timeout variables
local maxIdleTime = 15
local timeIdleStart = 0
local timeIdle = 0
local countingIdleTime = false

function gameScreen:reset()
    screen:setShake(10)
    exp3:play()
    scores[1], scores[2] = 0, 0
    gameEnd = false
    
    for i,ball in ipairs(balls) do
        ball.velVec.x, ball.velVec.y = 0, 0
        local newLoc = ballLocs[i]
        world:update(ball, newLoc[1], newLoc[2])
        ball.pos.x, ball.pos.y =  newLoc[1], newLoc[2]
    end
    
    p1:teleport(224, 208)
    p1.facing = 1
    
    p2:teleport(544, 208)
    p2.facing = -1
    
    -- time out variables
    countingIdleTime = false
    timeIdleStart = 0
    timeIdle = 0
end

function gameScreen:enter()
    lg.setFont(fontBig)
    self:reset()
end

function gameScreen:update(dt)
    Timer.update(dt)
    
    local anyInputPressed = false
    if scores[1] >= maxScore or scores[2] >= maxScore then
        gameEnd = true
    end
    
    if gameEnd then 
        canim:update(dt) 
        canim2:update(dt)
    end
    
    local dx, dy = 0, 0
    screen:update(dt)
    
    -- p1 input --
    p1input:update()
    -- movement
    local ix, iy = p1input:get('move')
    if iy ~= 0 or ix ~= 0 then anyInputPressed = true end
    if (iy < 0) then dy = dy - 1 end
    if (iy > 0) then dy = dy + 1 end
    if (ix < 0) then dx = dx - 1 end
    if (ix > 0) then dx = dx + 1 end
    p1:update(dt, dx, dy)
    -- keypresses
    if p1input:pressed('action') then
        anyInputPressed = true
        if gameEnd then
            self:reset()
        else
            p1:action(balls)
        end
    end
    
    if p1input:pressed('reset') then
        anyInputPressed = true
        self:reset()
    end
    
    if p1.pos.x < -p1.w or p1.pos.x > gameW or p1.pos.y < -p1.h or p1.pos.y > gameH then
        p1:teleport(224, 208)
    end
    
    -- p2 input --
    p2input:update()
    --movement
    dx, dy = 0, 0
    ix, iy = 0, 0
    ix, iy = p2input:get('move')
    if iy ~= 0 or ix ~= 0 then anyInputPressed = true end
    if (iy < 0) then dy = dy - 1 end
    if (iy > 0) then dy = dy + 1 end
    if (ix < 0) then dx = dx - 1 end
    if (ix > 0) then dx = dx + 1 end
    p2:update(dt, dx, dy)
    -- keypresses
    if p2input:pressed('action') then
        anyInputPressed = true
        if gameEnd then
            self:reset()
        else
            p2:action(balls)
        end
    end
    
    if p2input:pressed('reset') then
        anyInputPressed = true
        self:reset()
    end
    
    if not anyInputPressed then
        if not countingIdleTime then
            countingIdleTime = true
            timeIdleStart = lt.getTime()
        else
            timeIdle = lt.getTime() - timeIdleStart
        end
    else
        countingIdleTime = false
    end
    
    if p2.pos.x < -p2.w or p2.pos.x > gameW or p2.pos.y < -p2.h or p2.pos.y > gameH then
        p2:teleport(544, 208)
    end
    
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
    
    lg.draw(assets.sprites.field, 0, 0)
    
    -- draw balls
    for i,ball in ipairs(balls) do
        ball:draw()
    end
    
    for i,goal in ipairs(goals) do
        goal:draw()
    end
    
    -- draw player
    p1:draw()
    p2:draw()
    
    -- draw scores
    if not gameEnd then
        lg.setColor(colors.aqua)
        lg.printf(scores[1] .. '/' .. maxScore, 20, 20, gameW, 'left')
        lg.setColor(colors.orange)
        lg.printf(scores[2] .. '/' .. maxScore, -20, 20, gameW, 'right')
    -- game over stuff
    else
        -- trophy
        local winX, winY = p1.pos.x, p1.pos.y
        if scores[2] >= 10 then
            winX, winY = p2.pos.x, p2.pos.y
        end
        
        lg.setColor(colors.white)
        lg.draw(trophy, winX - 8, winY - 55)
        
        -- button animation
        canim:draw(csheet, 400 - 96 - 290, 320)
        canim2:draw(csheet, 400 - 96 + 290, 320)
        
        -- game over
        lg.setColor(colors.black)
        lg.printf('GAME', 20, 20, gameW, 'left')
        lg.printf('OVER', -20, 20, gameW, 'right')
    end
    
    if countingIdleTime and timeIdle > maxIdleTime - 6 then 
        lg.setColor(0, 0, 0, 0.9)
        lg.rectangle('fill', 100, 180, 600, 100)
        lg.setColor(1, 1, 1, 0.9)
        lg.printf('RESET IN ' .. math.floor(maxIdleTime - timeIdle), 0, 200, gameW, 'center')
        
        if timeIdle > maxIdleTime then
            gamestate.switch(startScreen)
        end
    end
    
    end)
    
    push:finish()
end

return gameScreen