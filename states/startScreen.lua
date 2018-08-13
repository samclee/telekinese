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
    lg.rectangle('fill', 0, 0, gameW, gameH)

    lg.setColor(colors.black)
    lg.setFont(fontBig)
    lg.printf('Telekinessball', 0, 100, gameW, 'center')
    
    lg.setFont(fontSml)
    lg.printf('samchristopherlee.com', 0, 350, gameW, 'center')
    lg.printf('github.com/YoungTheRhino', 0, 390, gameW, 'center')
    
    if lj.getJoystickCount() < 2 then
        lg.setColor(colors.red)
        local msg = '(' .. lj.getJoystickCount() .. ') gamepads detected.\nTo use gamepads, please connect them and restart.\nOtherwise, press \'action\''
        lg.printf(msg, 0, 200, gameW, 'center')
    else
        lg.setColor(colors.white)
        canim:draw(csheet, 400 - 96, 200)
    end
     
    end)
    
    push:finish()
end

return startScreen