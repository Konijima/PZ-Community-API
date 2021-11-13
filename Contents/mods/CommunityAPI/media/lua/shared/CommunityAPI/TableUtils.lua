local TableUtils = {}

--- Get the total count of entry in a table
---@param targetTable table The table to count total of entries
---@return number
function TableUtils.CountTableEntries(targetTable)
    local count = 0
    for _ in pairs(targetTable) do
        count = count + 1
    end
    return count
end

--- Get all the keys of a lua table
---@param targetTable table The table to get the keys from
---@return table<number, string>
function TableUtils.GetTableKeys(targetTable)
    local keys = {}
    for key in pairs(targetTable) do
        table.insert(keys, key)
    end
    return keys
end

--- Check if a value is found in a table
---@param targetTable table The table to search in
---@param targetValue any The value to find
---@return boolean
function TableUtils.TableContains(targetTable, targetValue)
    if type(targetTable) == "table" then
        for i=1, #targetTable do
            if targetTable[i] == targetValue then
                return true
            end
        end
        for _, v in pairs(targetTable) do
            if v == targetValue then
                return true
            end
        end
    end
    return false
end

--- Get the base class of an object, optionally choose how deep you want to check
---@param tableObject table The table object to get the base class from
---@param _level number Get the deepest base class found, default: 1
---@return table|nil
function TableUtils.GetBaseClass(tableObject, _level)
    if not _level or _level < 1 then _level = 1; end

    if type(tableObject) == "table" then
        local baseClass = getmetatable(tableObject)
        for i=2, _level do
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

--- Get list of all derived class from the current to the deepest level
---@param tableObject table The table object to get all base class from
---@param _excludeCurrent boolean Optionally exclude the current object class from the list, default: false
---@return table<number, table>|nil
function TableUtils.GetAllBaseClasses(tableObject, _excludeCurrent)
    if type(tableObject) == "table" then
        local baseClasses = {}
        local current = getmetatable(tableObject)

        local lastBaseClass
        for i=1, 10 do
            local baseClass = TableUtils.GetBaseClass(tableObject, i)
            if baseClass ~= nil and lastBaseClass ~= baseClass then
                if not _excludeCurrent or _excludeCurrent and current ~= baseClass then
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
---@param tableObject table The table object to check
---@param tableClass table|string The class to compare with
---@return boolean
function TableUtils.IsClassChildOf(tableObject, tableClass)
    local classType = type(tableClass)
    local allBaseClasses = TableUtils.GetAllBaseClasses(tableObject, false)
    if allBaseClasses then
        for i=1, #allBaseClasses do
            if (classType == "table" and allBaseClasses[i] == tableClass) or (classType == "string" and allBaseClasses[i].Type == tableClass) then
                return true
            end
        end
    end
    return false
end

return TableUtils