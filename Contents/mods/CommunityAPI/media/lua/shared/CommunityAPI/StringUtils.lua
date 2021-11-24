local StringUtils = {}

--- Transform a square position into a unique string
---@param square IsoGridSquare The square to get the position from
---@return string
function StringUtils.SquareToId(square)
    return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
end

--- Transform a position into a unique string
---@param x number X position
---@param y number Y position
---@param z number Z position
---@return string
function StringUtils.PositionToId(x, y ,z)
    return x .. "|" .. y .. "|" .. z
end

--- Split a string by a delimiter string
---@param str string The string to split
---@param delimiter string The string to split with
---@return string[]
function StringUtils.SplitString(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)%"..delimiter) do
        table.insert(result, match)
    end
    return result
end

--- Format a number into string with decimal
---@param value number The number value to format
---@param _decimal number Amount of decimal, default: 2
---@return string
function StringUtils.NumberToDecimalString(value, _decimal)
    if not type(_decimal) == "number" then _decimal = 2 end
    return string.format("%.".._decimal.."f", value);
end

---Parse each line of site html file by parseLineFunc
---@param url string Url ("https://" or "http://")
---@param parseLineFunc function Get line and return useful data item (not empty string or any object) else nil or empty string
---@return table any List with all useful data items
function StringUtils.ParseSite(url, parseLineFunc)
    local siteData = getUrlInputStream(url)
    local resultData = {}
    
    if siteData ~= nil then
        local currentLine = siteData:readLine()
        while currentLine ~= nil do     
            local dataItem = parseLineFunc(currentLine)
            if dataItem ~= nil and dataItem ~= "" then
                table.insert(resultData, dataItem)
            end
            currentLine = siteData:readLine()
        end
    end
    return resultData
end

return StringUtils