local gameScreen = {}

-- game vars
local arena = nil
local balls = {}

local p1 = Player(world, 300, 300, assets.sprites.pl, colors.aqua)
local p2 = Player(world, 500, 300, assets.sprites.pl, colors.orange)

function gameScreen:enter()
    --sti.new('assets/maps/map1.lua', { 'bump' })
end

function gameScreen:update(dt)
    local dx, dy = 0, 0
    
    -- p1 input
    if (lk.isDown('w')) then dy = dy - 1 end
    if (lk.isDown('s')) then dy = dy + 1 end
    if (lk.isDown('a')) then dx = dx - 1 end
    if (lk.isDown('d')) then dx = dx + 1 end
    
    if (dx ~= 0 or dy ~= 0) then
        local rss = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
        p1:update(dt, dx / rss, dy / rss)
    end
    
    -- p2 input
    
    -- update balls
end

function gameScreen:draw()
    push:start()
    
    p1:draw()
    p2:draw()
    
    -- draw balls
    
    lg.print('Game Screen', 0, 0)
    
    push:finish()
end

function gameScreen:keypressed(k)
    if (k == 'space') then
        p1:action(balls)
    end
    
    if (k == 'enter') then
        p1:action(balls)
    end
end

return gameScreen