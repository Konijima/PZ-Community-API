local IsoUtils = {}

--- Safely get the square of an IsoObject recursively
---@param object IsoObject|IsoGridSquare
---@return IsoGridSquare
function IsoUtils.RecursiveGetSquare(object)
    if instanceof(object, "IsoGridSquare") then
        return object
    end

    if not instanceof(object, "IsoObject") then
        return nil
    end

    local square
    if instanceof(object, "IsoGameCharacter") and object:getVehicle() then
        square = object:getVehicle()
    end

    if not instanceof(square, "IsoGridSquare") then
        square = square:getSquare()
    end

    return square
end

---@param center IsoObject|IsoGridSquare
---@param range number tiles to scan from center, not including center. ex: range of 1 = 3x3
---@param fractalOffset number fractal offset - spreads out squares by this number
---@return table<IsoGridSquare>
function IsoUtils.GetIsoRange(center, range, fractalOffset)
    center = IsoUtils.RecursiveGetSquare(center)
    if not center then
        return {}
    end

    if not fractalOffset then
        fractalOffset = 1
    else
        fractalOffset = (fractalOffset*2)+1
    end

    --true center
    local centerX, centerY = center:getX(), center:getY()
    --add center to squares at the start
    local squares = {center}

    --no point in running everything below, return squares
    if range < 1 then return squares end

    --create a ring of IsoGridSquare around center, i=1 skips center
    for i=1, range do

        local fractalFactor = i*fractalOffset
        --currentX and currentY have to pushed off center for the logic below to kick in
        local currentX, currentY = centerX-fractalFactor, centerY+fractalFactor
        -- ring refers to the path going around center, -1 to skip center
        local expectedRingLength = (8*i)-1

        for _=0, expectedRingLength do
            --if on top-row and not at the upper-right
            if (currentY == centerY+fractalFactor) and (currentX < centerX+fractalFactor) then
                --move-right
                currentX = currentX+fractalOffset
                --if on right-column and not the bottom-right
            elseif (currentX == centerX+fractalFactor) and (currentY > centerY-fractalFactor) then
                --move down
                currentY = currentY-fractalOffset
                --if on bottom-row and not on far-left
            elseif (currentY == centerY-fractalFactor) and (currentX > centerX-fractalFactor) then
                --move left
                currentX = currentX-fractalOffset
                --if on left-column and not on top-left
            elseif (currentX == centerX-fractalFactor) and (currentY < centerY+fractalFactor) then
                --move up
                currentY = currentY+fractalOffset
            end

            ---@type IsoGridSquare square
            local square = getCell():getOrCreateGridSquare(currentX, currentY, 0)
            --[DEBUG]] getWorldMarkers():addGridSquareMarker(square, 0.8, fractalOffset-1, 0, false, 0.5)
            table.insert(squares, square)
        end
    end
    --[[DEBUG
    print("---[ IsoRange ]---\n total "..#squares.."/"..((range*2)+1)^2)
    for k,v in pairs(squares) do
        ---@type IsoGridSquare vSquare
        local vSquare = v
        print(" "..k..": "..centerX-vSquare:getX()..", "..centerY-vSquare:getY())
    end
    ]]
    return squares
end

--- Get all humanoid in fractal range from a center point
---@param center IsoObject|IsoGridSquare the center point
---@param range number tiles to scan from center, not including center. ex: range of 1 = 3x3
---@param fractalRange number number of rows, made up of `range`, from the center range
---@param lookForType string|nil get only a specific type
---@param addedBooleanFunctions table table of function(s) must return true to pass
---@return table<IsoGameCharacter>
function IsoUtils.GetIsoGameCharactersInFractalRange(center, range, fractalRange, lookForType, addedBooleanFunctions)
    center = IsoUtils.RecursiveGetSquare(center)
    if not center then
        return {}
    end

    --range and fractalRange are flipped in the parameters here because:
    -- "fractalRange" represents the number of rows from center out but with an offset of "range" instead
    local fractalCenters = IsoUtils.GetIsoRange(center, fractalRange, range)
    local fractalObjectsFound = {}
    ---print("getHumanoidsInFractalRange: centers found: "..#fractalCenters)
    --pass through each "center square" found
    for i=1, #fractalCenters do
        local objectsFound = IsoUtils.GetIsoGameCharactersInRange(fractalCenters[i], range, lookForType, addedBooleanFunctions)
        ---print(" fractal center "..i..":  "..#objectsFound)
        --store a list of objectsFound within the fractalObjectsFound list
        table.insert(fractalObjectsFound, objectsFound)
    end

    return fractalObjectsFound
end

--- Get all humanoid in range from a center point
---@param center IsoObject|IsoGridSquare the center point
---@param range number tiles to scan from center, not including center. ex: range of 1 = 3x3
---@param lookForType string|nil get only a specific type
---@param addedBooleanFunctions table table of function(s) must return true to pass
---@return table<IsoGameCharacter>
function IsoUtils.GetIsoGameCharactersInRange(center, range, lookForType, addedBooleanFunctions)
    center = IsoUtils.RecursiveGetSquare(center)
    if not center then
        return {}
    end

    local squaresInRange = IsoUtils.GetIsoRange(center, range)
    local objectsFound = {}

    for sq=1, #squaresInRange do

        ---@type IsoGridSquare
        local square = squaresInRange[sq]
        local squareContents = square:getLuaMovingObjectList()

        for i=1, #squareContents do
            ---@type IsoMovingObject|IsoGameCharacter foundObject
            local foundObj = squareContents[i]

            if instanceof(foundObj, "IsoGameCharacter") and (not lookForType or instanceof(foundObj, lookForType)) then

                local booleanPass = true
                if addedBooleanFunctions and (#addedBooleanFunctions > 0) then
                    for k,func in pairs(addedBooleanFunctions) do
                        if not func(foundObj) then
                            booleanPass = false
                        end
                    end
                end

                if booleanPass then
                    table.insert(objectsFound, foundObj)

                end
            end
        end
    end

    return objectsFound
end

return IsoUtils