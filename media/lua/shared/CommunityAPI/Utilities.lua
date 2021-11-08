local Utilities = {}

--- Transform a position into a unique string
---@param x number
---@param y number
---@param z number
---@return string
function Utilities.PositionToId(x, y ,z)
    return tostring(x) .. "|" .. tostring(y) .. "|" .. tostring(z)
end

--- Split a string by a delimiter string
---@param str string the string to split
---@param delimiter string the string to split with
---@return table<string>
function Utilities.SplitString(str, delimiter)
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
function Utilities.GetDistance(x1, y1, x2, y2)
    local a = x1 - x2
    local b = y1 - y2
    return math.sqrt( a*a + b*b )
end

--- Get the total count of entry in a table
---@param targetTable table The table to get count from
function Utilities.CountTableEntries(targetTable)
    local count = 0
    for key in pairs(targetTable) do
        count = count + 1
    end
    return count
end

--- Get all the keys of a lua table
---@param targetTable table The table to get keys from
function Utilities.GetTableKeys(targetTable)
    local keys = {}
    for key in pairs(targetTable) do
        table.insert(keys, key)
    end
    return keys
end

return Utilities