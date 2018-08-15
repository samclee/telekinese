local startScreen = {}

function startScreen:enter()

end

function startScreen:update(dt)
    canim:update(dt)
    p1input:update()
    p2input:update()
    
    if p1input:pressed('action') or p2input:pressed('action') then
        gamestate.switch(gameScreen)
    end
end

function startScreen:draw()
    push:start()
    
    effect(function()
    
    lg.setColor(colors.white)
    lg.draw(assets.sprites.field, 0, 0)
    canim:draw(csheet, 400 - 96, 200)

    lg.setColor(colors.black)
    lg.setFont(fontBig)
    lg.printf('Telekinessball', 0, 100, gameW, 'center')
    
    lg.setFont(fontSml)
    lg.printf('samchristopherlee.com', 0, 350, gameW, 'center')
    lg.printf('github.com/YoungTheRhino', 0, 390, gameW, 'center')
    
    lg.setColor(colors.white)
     
    end)
    
    push:finish()
end

return startScreen