local physics = require("physics")
physics.start()
local player = display.newImageRect("images/bomb.png", 50, 50)
physics.addBody(player, "static")
player.x = display.contentCenterX
player.y = 400
local screenWidth = display.contentWidth

local line = display.newRect(0, 0, screenWidth * 2, 2)
line.y = 500
line:setFillColor(0, 0, 0)
physics.addBody(line, "static")

local speed = 2
local touch_x
local score = 0
local on_touch
local scoreText = display.newText("Score: 0", display.contentCenterX, 10, native.systemFont, 20)

local function updateScore()
    scoreText.text = "Score: " .. score
end

local move = function()
    local target_x = player.x
    if touch_x > player.x then
        target_x = math.min(touch_x, player.x + 10)
    elseif touch_x < player.x then
        target_x = math.max(touch_x, player.x - 10)
    end

    if target_x ~= player.x then
        transition.to(player, { x = target_x, time = math.abs(target_x - player.x) / speed, onComplete = on_touch })
    end
end

on_touch = function(event)
    if event.phase == "began" then
        touch_x = event.x
        move()
        return true
    elseif event.phase == "moved" then
        touch_x = event.x
        move()
    elseif event.phase == "ended" then
        touch_x = player.x
        move()
    else
        move()
    end
end

local min_x = 40
local max_x = 300
local min_delay = 0.3
local max_delay = 1.02
local coin = {}


local generateCoin

generateCoin = function()
    local x = math.random(min_x, max_x)
    local y = 100

    local coin = display.newImageRect("images/coin.png", 50, 50)
    coin.x = x
    coin.y = y
    physics.addBody(coin)
    local drop_time = 4000
    local drop_distance = 1000

    transition.to(coin, { y = display.contentHeight, time = drop_time }) --,onComplete = function() coin:removeSelf() end})
end

Runtime:addEventListener("touch", on_touch)

local timeLeft = 10
local function updateTimer()
    timeLeft = timeLeft - 1
    print(timeLeft)
    if timeLeft == 0 then
        print("结束")
        return
    else
        generateCoin()
    end
end

local timerID = timer.performWithDelay(1000, updateTimer, timeLeft)

local function touchcoin(event)
    if (event.phase == "began") then
        if (event.object1 == player) then
            event.object2:removeSelf()
            print("collision!")
            score = score + 1
            print("score:" .. score)
            updateScore()
        elseif (event.object2 == player) then
            event.object1:removeSelf()
            print("collision!")
            score = score + 1
            print("score:" .. score)
            updateScore()
        elseif (event.object1 == line) then
            event.object2:removeSelf()
            print("lost")
        elseif (event.object2 == line) then
            event.object1:removeSelf()
            print("lost")
        end
    end
end
Runtime:addEventListener("collision", touchcoin)
