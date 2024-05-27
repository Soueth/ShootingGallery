function love.load()
    target = {}
    target.radius = 50
    target.y = love.graphics.getHeight() / 2
    target.x = love.graphics.getWidth() / 2

    sprites = {}

    sprites.mira = love.graphics.newImage('sprites/crosshairs.png')
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.alvo = love.graphics.newImage('sprites/target.png')

    score = 0
    timer = 0
    gameState = 0

    gameFont = love.graphics.newFont(35)
    love.mouse.setVisible(false)
end

function love.update(dt)
    if (timer > 0) then
        timer = timer - dt
    end

    if (timer < 0) then
        timer = 0
        gameState = 0
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setFont(gameFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Score: ' .. score, 8, 5)

    if gameState == 0 then
        love.graphics.printf('Clique em qualquer lugar para começar', 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
    end

    if gameState == 1 then
        love.graphics.draw(sprites.alvo, target.x - target.radius, target.y - target.radius)
        love.graphics.printf('Timer: ' .. math.ceil(timer), love.graphics.getWidth() / 2 - 80, 5, 200, 'left')
    end

    love.graphics.draw(sprites.mira, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y , button , isTouch , press)
    if (button == 1 or button == 2) and gameState == 1 then
        pressTarget = distanceBetween(x, y, target.x, target.y) <= target.radius
        if pressTarget then
            if button == 1 then
                score = score + 1
            else
                score = score + 2
            end
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius + 50, love.graphics.getHeight() - target.radius)
        elseif score > 0 then
            score = score - 1
        end

        if button == 2 then
            if timer > 1 then
                timer = timer - 1
            else 
                timer = 0
                gameState = 0
            end
        end    
    elseif button == 1 and gameState == 0 then
        gameState = 1
        timer = 10
        score = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end