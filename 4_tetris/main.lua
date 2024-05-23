local blocks = {
    {
        {1, 1},
        {1, 1}
    },
    {
        {1, 1, 1, 1}
    },
    {
        {0, 1, 1},
        {1, 1, 0}
    },
    {
        {1, 1, 0},
        {0, 1, 1}
    }
}

local blockColors = {
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0}
}

local gridWidth, gridHeight = 10, 20
local blockSize = 30
local grid
local currentBlock
local currentX, currentY
local blockRotation
local fallTime, fallSpeed
local currentColor
local speedIncreaseFactor = 0.9
local minFallSpeed = 0.1

function love.load()
    love.window.setMode(gridWidth * blockSize, gridHeight * blockSize)
    resetGrid()
    spawnBlock()
    fallSpeed = 1
    fallTime = 0
end

function love.update(dt)
    fallTime = fallTime + dt
    if fallTime >= fallSpeed then
        fallTime = fallTime - fallSpeed
        if not moveBlock(0, 1) then
            placeBlock()
            spawnBlock()
            fallSpeed = math.max(fallSpeed * speedIncreaseFactor, minFallSpeed)
            if not isPositionValid(currentBlock, currentX, currentY) then
                resetGrid()
                fallSpeed = 1
            end
        end
    end
end

function love.draw()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] ~= 0 then
                love.graphics.setColor(blockColors[grid[y][x]])
                love.graphics.rectangle("fill", (x - 1) * blockSize, (y - 1) * blockSize, blockSize, blockSize)
            end
        end
    end

    love.graphics.setColor(currentColor)
    for y = 1, #currentBlock do
        for x = 1, #currentBlock[y] do
            if currentBlock[y][x] ~= 0 then
                love.graphics.rectangle("fill", (currentX + x - 2) * blockSize, (currentY + y - 2) * blockSize, blockSize, blockSize)
            end
        end
    end
end

function love.keypressed(key)
    if key == "left" then
        moveBlock(-1, 0)
    elseif key == "right" then
        moveBlock(1, 0)
    elseif key == "down" then
        moveBlock(0, 1)
    elseif key == "up" then
        rotateBlock()
    end
end

function resetGrid()
    grid = {}
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = 0
        end
    end
end

function spawnBlock()
    local blockIndex = love.math.random(#blocks)
    currentBlock = blocks[blockIndex]
    currentColor = blockColors[blockIndex]
    currentX = math.floor(gridWidth / 2) - math.floor(#currentBlock[1] / 2)
    currentY = 1
    blockRotation = 0
end

function moveBlock(dx, dy)
    if isPositionValid(currentBlock, currentX + dx, currentY + dy) then
        currentX = currentX + dx
        currentY = currentY + dy
        return true
    end
    return false
end

function rotateBlock()
    local newBlock = {}
    for y = 1, #currentBlock[1] do
        newBlock[y] = {}
        for x = 1, #currentBlock do
            newBlock[y][x] = currentBlock[#currentBlock - x + 1][y]
        end
    end

    if isPositionValid(newBlock, currentX, currentY) then
        currentBlock = newBlock
    end
end

function isPositionValid(block, posX, posY)
    for y = 1, #block do
        for x = 1, #block[y] do
            if block[y][x] ~= 0 then
                local newX = posX + x - 1
                local newY = posY + y - 1

                if newX < 1 or newX > gridWidth or newY > gridHeight or (newY > 0 and grid[newY][newX] ~= 0) then
                    return false
                end
            end
        end
    end
    return true
end

function placeBlock()
    for y = 1, #currentBlock do
        for x = 1, #currentBlock[y] do
            if currentBlock[y][x] ~= 0 then
                grid[currentY + y - 1][currentX + x - 1] = findBlockColor(currentColor)
            end
        end
    end

    for y = gridHeight, 1, -1 do
        local fullRow = true
        for x = 1, gridWidth do
            if grid[y][x] == 0 then
                fullRow = false
                break
            end
        end

        if fullRow then
            for removeY = y, 2, -1 do
                for x = 1, gridWidth do
                    grid[removeY][x] = grid[removeY - 1][x]
                end
            end

            for x = 1, gridWidth do
                grid[1][x] = 0
            end

            y = y + 1
        end
    end
end

function findBlockColor(color)
    for i, c in ipairs(blockColors) do
        if c[1] == color[1] and c[2] == color[2] and c[3] == color[3] then
            return i
        end
    end
    return 1
end
