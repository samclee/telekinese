local Player = Class{ __includes = Entity }

function Player:init(world, x, y, sprite, color)
    -- visual
    self.id = 'player'
    self.sprite = sprite
    self.color = color
    
    -- technical
    self.spd = 7
    self.grabbedBalls = {}
    
    Entity.init(self, world, x, y, sprite:getWidth(), sprite:getHeight())
    
    -- collision
    self.world:add(self, self:getRect()) 
    self.filter = function(item, other)
        if (other.id == 'player') then
            return 'cross'
        end
        
        return 'slide'
    end
end

function Player:update(dt, dx, dy)
    if dx ~= 0 or dy ~= 0 then
        local rss = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
        dx, dy = dx / rss, dy  / rss
    end

    local actualX, actualY, cols, len = self.world:move(self, self.pos.x + dx * self.spd, 
                                            self.pos.y + dy * self.spd, self.filter)

    -- collisions
    for i=1,len do
        local otherObj = cols[i].other

        -- kick active ball
        if otherObj.id == 'ball' and otherObj.status == 0 then
            otherObj.velVec = (otherObj.pos - self.pos):normalized() * kickStr
        end
    end
    
    -- if isGrabbing, attempt to move all grabbed balls with you
    for i,ball in ipairs(self.grabbedBalls) do
        if (self.pos - ball.pos):len() < telekinesisRadius then
            ball.velVec = vec(dx * self.spd, dy * self.spd)
        else
            ball.velVec = (self.pos - ball.pos):normalized() * 12
        end

    end
    
    self.pos.x, self.pos.y = actualX, actualY
end

function Player:launchAll()
    for i = #self.grabbedBalls, 1, -1 do
        local ball = self.grabbedBalls[i]
        ball.velVec = (ball.pos - self.pos):normalized() * launchStr
        ball.status = 0
        table.remove(self.grabbedBalls, i)
    end
end

function Player:grabBalls(balls)
    for i,ball in ipairs(balls) do
        if ball.status == 0 and (ball.pos - self.pos):len() < telekinesisRadius then
            ball.velVec.x, ball.velVec.y = 0, 0
            ball.status = 1
            table.insert(self.grabbedBalls, ball)
        end
    end
end

function Player:action(balls)
    if #self.grabbedBalls > 0 then
        self:launchAll()
    else
        self:grabBalls(balls)
    end
end

function Player:draw()
    -- telekinesis field
    lg.setColor(self.color[1], self.color[2], self.color[3], 0.5)
    lg.circle('fill', self.pos.x + self.w / 2, self.pos.y + self.h / 2, telekinesisRadius)
    
    -- character sprite
    lg.setColor(self.color)
    lg.draw(self.sprite, self.pos.x, self.pos.y)

    -- debug
    if debug then
        lg.setColor(colors.red[1], colors.red[2], colors.red[3], 0.8)
        lg.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
    end
    
    lg.setColor(colors.white)
end

return Player