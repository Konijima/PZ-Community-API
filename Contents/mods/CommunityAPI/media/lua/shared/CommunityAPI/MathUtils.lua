local MathUtils = {}

--- Get the distance between two point
---@param x1 number X coordinate of first point
---@param y1 number y coordinate of first point
---@param x2 number X coordinate of second point
---@param y2 number y coordinate of second point
function MathUtils.getDistance(x1, y1, x2, y2)
    local a = x1 - x2
    local b = y1 - y2
    return math.sqrt( a*a + b*b )
end

return MathUtils