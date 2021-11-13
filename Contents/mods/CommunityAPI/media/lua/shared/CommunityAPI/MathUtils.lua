local MathUtils = {}

--- Get the 2D distance between two point
---@param x1 number X coordinate of first point
---@param y1 number Y coordinate of first point
---@param x2 number X coordinate of second point
---@param y2 number Y coordinate of second point
---@return number
function MathUtils.GetDistance2DBetweenPoints(x1, y1, x2, y2)
    local a = x1 - x2
    local b = y1 - y2
    return math.sqrt( a*a + b*b )
end

--- Get the 2D distance between two squares
---@param square1 IsoGridSquare The first square
---@param square2 IsoGridSquare The second square
---@return number
function MathUtils.GetDistance2DBetweenSquares(square1, square2)
    local a = square1:getX() - square2:getX()
    local b = square1:getY() - square1:getY()
    return math.sqrt( a*a + b*b )
end

return MathUtils