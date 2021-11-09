local StringUtils = {}

--- Transform a square position into a unique string
---@param square IsoGridSquare
---@return string
function StringUtils.squareToId(square)
    if instanceof(square, "IsoGridSquare") then
        return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
    end
end

--- Transform a position into a unique string
---@param x number
---@param y number
---@param z number
---@return string
function StringUtils.positionToId(x, y ,z)
    return tostring(x) .. "|" .. tostring(y) .. "|" .. tostring(z)
end

--- Split a string by a delimiter string
---@param str string the string to split
---@param delimiter string the string to split with
---@return table<string>
function StringUtils.splitString(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

return StringUtils