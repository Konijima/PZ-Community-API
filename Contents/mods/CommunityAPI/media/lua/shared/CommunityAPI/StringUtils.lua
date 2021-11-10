local StringUtils = {}

--- Transform a square position into a unique string
---@param square IsoGridSquare
---@return string
function StringUtils.SquareToId(square)
    return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
end

--- Transform a position into a unique string
---@param x number
---@param y number
---@param z number
---@return string
function StringUtils.PositionToId(x, y ,z)
    return x .. "|" .. y .. "|" .. z
end

--- Split a string by a delimiter string
---@param str string the string to split
---@param delimiter string the string to split with
---@return table<string>
function StringUtils.SplitString(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)%"..delimiter) do
        table.insert(result, match)
    end
    return result
end

--- Format a number into string with decimal
---@param value number The number value to format
---@param _decimal number Amount of decimal
---@return string
function StringUtils.NumberToDecimalString(value, _decimal)
    if not type(_decimal) == "number" then _decimal = 2 end
    return string.format("%.".._decimal.."f", value);
end

return StringUtils