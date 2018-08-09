local Entity = Class{}

function Entity:init(world, x, y, w, h)
    self.world = world
    self.pos = vec(x, y)
    self.w = w
    self.h = h
end

function Entity:getRect()
    return self.pos.x, self.pos.y, self.w, self.h
end

function Entity:getCenter()
	return vec(self.pos.x + self.w / 2, self.pos.y + self.h / 2)
end

return Entity