local ColorUtils = {}

--- Get a color from Red to Green based on a current value / max value
---@param current number
---@param max number
function ColorUtils.GetColorFromCurrentMax(current, max)
    if current < 1 and current > 0 then
        current = current * 100
        max = max * 100
    end
    local r = ((max - current) / max)
    local g = (current / max)
    return {r = r, g = g, b = 0}
end

--- Get a color from Green to Red based on a current value / max value
---@param current number
---@param max number
function ColorUtils.GetReversedColorFromCurrentMax(current, max)
    if current < 1 and current > 0 then
        current = current * 100
        max = max * 100
    end
    local g = ((max - current) / max)
    local r = (current / max)
    return {r = r, g = g, b = 0}
end

--- Create a color object from rgba parameters
---@param r number Red
---@param g number Green
---@param b number Blue
---@param _a number|nil Alpha
---@return table
function ColorUtils.RgbaToColor(r, g, b, _a)
    local color = { r=r, g=g, b=b, a=_a }
    if type(color.a) ~= "number" then color.a = 1; end
    return color
end

--- Get a color or set a default color, used to make sure the returned
---@param color table { r= number, g=number, b=number, a=number }
---@param defaultColor table { r= number, g=number, b=number, a=number }
---@return table
function ColorUtils.GetColorOrDefault(color, defaultColor)
    if type(color) ~= "table" then
        return defaultColor
    end
    if type(color.r) ~= "number" then color.r = defaultColor.r; end
    if type(color.g) ~= "number" then color.g = defaultColor.g; end
    if type(color.b) ~= "number" then color.b = defaultColor.b; end
    if type(color.a) ~= "number" then color.a = defaultColor.a; end
    return color
end

return require("CommunityAPI/TableProtection")(ColorUtils)
