-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local rope = display.newImage("images/rope.png", 0.01, 0.01)
rope.x = centerX
rope.y = centerY




local moveSpeed = 3 
local pullSpeed = 7
local movetime = 0
local offsetY = 0

local function handleImageTap(event)
    rope.y = rope.y + pullSpeed
end

local function moveImage(event)
    movetime = movetime + 1
    if movetime > 10 then
        rope.y = rope.y - moveSpeed
        movetime = 0
        print(rope.y)

        
        if rope.y > 280 then
            print("獲勝！")
            Runtime:removeEventListener("enterFrame", moveImage)
            Runtime:removeEventListener("tap",handleImageTap)  
            local scoreText = display.newText("獲勝", display.contentCenterX, display.contentCenterY, native.systemFont, 110)
        end
    end
end




local function startGame()
    Runtime:addEventListener("enterFrame", moveImage)
    Runtime:addEventListener("tap", handleImageTap)
end

local startButton = display.newRect(centerX, centerY, 100, 50)
startButton:setFillColor(0.8, 0.8, 0.8)

local buttonText = display.newText("Start", centerX, centerY, native.systemFont, 20)

local function onStartButtonTap(event)
    if event.phase == "ended" then
        display.remove(startButton)
        display.remove(buttonText)
        startGame()
    end
    return true
end

startButton:addEventListener("touch", onStartButtonTap)


