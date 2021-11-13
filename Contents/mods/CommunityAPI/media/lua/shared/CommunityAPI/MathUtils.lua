local MathUtils = {}

--- Get the distance between two point
---@param x1 number X coordinate of first point
---@param y1 number Y coordinate of first point
---@param x2 number X coordinate of second point
---@param y2 number Y coordinate of second point
---@return number
function MathUtils.GetDistanceFromTo(x1, y1, x2, y2)
    return IsoUtils.DistanceTo(x1, y1, x2, y2)
end

--- Get the distance including height between two point
---@param x1 number X coordinate of first point
---@param y1 number Y coordinate of first point
---@param z1 number Z coordinate of first point
---@param x2 number X coordinate of second point
---@param y2 number Y coordinate of second point
---@param z2 number Z coordinate of second point
---@return number
function MathUtils.GetDistance3DFromTo(x1, y1, z1, x2, y2, z2)
    return IsoUtils.DistanceTo(x1, y1, z1, x2, y2, z2)
end

--- Get the distance between two objects
---@param object1 IsoObject|IsoGridSquare The first object or square
---@param object2 IsoObject|IsoGridSquare The second object or square
---@return number
function MathUtils.GetDistanceBetweenObjects(object1, object2)
    return IsoUtils.DistanceTo(object1:getX(), object1:getY(), object2:getX(), object2:getY())
end

--- Get the distance including height between two objects
---@param object1 IsoObject|IsoGridSquare The first object or square
---@param object2 IsoObject|IsoGridSquare The second object or square
---@return number
function MathUtils.GetDistance3DBetweenObjects(object1, object2)
    return IsoUtils.DistanceTo(object1:getX(), object1:getY(), object1:getZ(), object2:getX(), object2:getY(), object2:getZ())
end

return MathUtils