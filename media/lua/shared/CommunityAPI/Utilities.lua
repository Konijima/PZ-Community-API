local Utilities = {}

--- Transform a square position into a unique string
---@param square IsoGridSquare
---@return string
function Utilities.squareToId(square)
    if instanceof(square, "IsoGridSquare") then
        return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
    end
end

--- Transform a position into a unique string
---@param x number
---@param y number
---@param z number
---@return string
function Utilities.positionToId(x, y ,z)
    return tostring(x) .. "|" .. tostring(y) .. "|" .. tostring(z)
end

--- Split a string by a delimiter string
---@param str string the string to split
---@param delimiter string the string to split with
---@return table<string>
function Utilities.splitString(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

--- Get the distance between two point
---@param x1 number X coordinate of first point
---@param y1 number y coordinate of first point
---@param x2 number X coordinate of second point
---@param y2 number y coordinate of second point
function Utilities.getDistance(x1, y1, x2, y2)
    local a = x1 - x2
    local b = y1 - y2
    return math.sqrt( a*a + b*b )
end

--- Get the total count of entry in a table
---@param targetTable table The table to get count from
function Utilities.countTableEntries(targetTable)
    local count = 0
    for key in pairs(targetTable) do
        count = count + 1
    end
    return count
end

--- Get all the keys of a lua table
---@param targetTable table The table to get keys from
function Utilities.getTableKeys(targetTable)
    local keys = {}
    for key in pairs(targetTable) do
        table.insert(keys, key)
    end
    return keys
end

--- Check if a value is found in a table
---@param table table The table to search in
---@param value any The value to find
---@return boolean
function Utilities.tableContains(table, value)
    if type(table) == "table" then
        for i=1, #table do
            if table[i] == value then
                return true
            end
        end
        for k, v in pairs(table) do
            if v == value then
                return true
            end
        end
    end
    return false
end

--- Find all item in an inventory by tag
---@param inventory ItemContainer
---@param tag string
---@return ArrayList|nil
function Utilities.findAllItemInInventoryByTag(inventory, tag)
    if instanceof(inventory, "ItemContainer") and type(tag) == "string" then
        local foundItems = ArrayList.new();
        local validItems = getScriptManager():getItemsTag(tag);
        if validItems then
            for i=0, validItems:size()-1 do
                foundItems:addAll(inventory:getItemsFromFullType(validItems:get(i):getFullName()));
            end
        end
        return foundItems;
    end
end

--- Get the base class of object, optionally choose how deep you want to check.
---@param object table Will return nil if the object is not a table.
---@param level  number Will return the deepest found if level is higher than the actual amount of base classes.
function Utilities.getBaseClass(object, level)
    if not level or level < 1 then level = 1; end

    if type(object) == "table" then
        local baseClass = getmetatable(object)
        for i=2, level do
            if type(baseClass) == "table" then
                local class = getmetatable(baseClass)
                if class then
                    baseClass = class
                end
            end
        end
        return baseClass
    end
end

--- Get a table containing all the base class from the current to the deepest.
---@param object table Will return nil if the object is not a table.
---@param excludeCurrent boolean optionally exclude the current object class from the list
---@return table|nil
function Utilities.getAllBaseClasses(object, excludeCurrent)
    if type(object) == "table" then
        local baseClasses = {}
        local current = getmetatable(object)

        local lastBaseClass
        for i=1, 10 do
            local baseClass = Utilities.getBaseClass(object, i)
            if baseClass ~= nil and lastBaseClass ~= baseClass then
                if not exludeCurrent or exludeCurrent and current ~= baseClass then
                    table.insert(baseClasses, baseClass)
                end
                lastBaseClass = baseClass
            else
                break
            end
        end

        return baseClasses
    end
end

--- Check if table object derive from this class
---@param object table The table object to check
---@param class table|string The class to find
---@return boolean
function Utilities.isClassChildOf(object, class)
    local classType = type(class)
    local allBaseClasses = Utilities.getAllBaseClasses(object, false)
    if allBaseClasses then
        for i=1, #allBaseClasses do
            if (classType == "table" and allBaseClasses[i] == class) or (classType == "string" and allBaseClasses[i].Type == class) then
                return true
            end
        end
    end
    return false
end

--- Safely get the square of an IsoObject recursively
---@param object IsoObject|IsoGridSquare
---@return IsoGridSquare
function Utilities.recursiveGetSquare(object)
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
function Utilities.getIsoRange(center, range, fractalOffset)
    center = Utilities.recursiveGetSquare(center)
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

---@param center IsoObject|IsoGridSquare
---@param range number tiles to scan from center, not including center. ex: range of 1 = 3x3
---@param fractalRange number number of rows, made up of `range`, from the center range
---@param lookForType string
---@return table
function Utilities.getHumanoidsInFractalRange(center, range, fractalRange, lookForType)
    center = Utilities.recursiveGetSquare(center)
    if not center then
        return {}
    end

    --range and fractalRange are flipped in the parameters here because:
    -- "fractalRange" represents the number of rows from center out but with an offset of "range" instead
    local fractalCenters = Utilities.getIsoRange(center, fractalRange, range)
    local fractalObjectsFound = {}
    ---print("getHumanoidsInFractalRange: centers found: "..#fractalCenters)
    --pass through each "center square" found
    for i=1, #fractalCenters do
        local objectsFound = Utilities.getHumanoidsInRange(fractalCenters[i], range, lookForType)
        ---print(" fractal center "..i..":  "..#objectsFound)
        --store a list of objectsFound within the fractalObjectsFound list
        table.insert(fractalObjectsFound, objectsFound)
    end

    return fractalObjectsFound
end

--- Get all humanoid in range from a center point
---@param center IsoObject|IsoGridSquare
---@param range number tiles to scan from center, not including center. ex: range of 1 = 3x3
---@param lookForType string
---@return table
function Utilities.getHumanoidsInRange(center, range, lookForType)
    center = Utilities.recursiveGetSquare(center)
    if not center then
        return {}
    end

    local squaresInRange = Utilities.getIsoRange(center, range)
    local objectsFound = {}

    for sq=1, #squaresInRange do

        ---@type IsoGridSquare
        local square = squaresInRange[sq]
        local squareContents = square:getLuaMovingObjectList()

        for i=1, #squareContents do
            ---@type IsoMovingObject|IsoGameCharacter foundObject
            local foundObj = squareContents[i]

            if instanceof(foundObj, "IsoGameCharacter") and (not lookForType or instanceof(foundObj, lookForType)) then
                if foundObj:isOutside() then
                    table.insert(objectsFound, foundObj)
                end
            end
        end
    end

    return objectsFound
end

return Utilities