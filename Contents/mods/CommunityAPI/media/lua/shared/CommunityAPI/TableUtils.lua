local TableUtils = {}

--- Get the total count of entry in a table
---@param targetTable table The table to get count from
function TableUtils.CountTableEntries(targetTable)
    local count = 0
    for _ in pairs(targetTable) do
        count = count + 1
    end
    return count
end

--- Get all the keys of a lua table
---@param targetTable table The table to get keys from
function TableUtils.GetTableKeys(targetTable)
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
function TableUtils.TableContains(table, value)
    if type(table) == "table" then
        for i=1, #table do
            if table[i] == value then
                return true
            end
        end
        for _, v in pairs(table) do
            if v == value then
                return true
            end
        end
    end
    return false
end

--- Get the base class of object, optionally choose how deep you want to check.
---@param object table Will return nil if the object is not a table.
---@param _level  number Will return the deepest found if level is higher than the actual amount of base classes.
function TableUtils.GetBaseClass(object, _level)
    if not _level or _level < 1 then _level = 1; end

    if type(object) == "table" then
        local baseClass = getmetatable(object)
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

--- Get a table containing all the base class from the current to the deepest.
---@param object table Will return nil if the object is not a table.
---@param _excludeCurrent boolean optionally exclude the current object class from the list
---@return table|nil
function TableUtils.GetAllBaseClasses(object, _excludeCurrent)
    if type(object) == "table" then
        local baseClasses = {}
        local current = getmetatable(object)

        local lastBaseClass
        for i=1, 10 do
            local baseClass = TableUtils.GetBaseClass(object, i)
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
---@param object table The table object to check
---@param class table|string The class to find
---@return boolean
function TableUtils.IsClassChildOf(object, class)
    local classType = type(class)
    local allBaseClasses = TableUtils.GetAllBaseClasses(object, false)
    if allBaseClasses then
        for i=1, #allBaseClasses do
            if (classType == "table" and allBaseClasses[i] == class) or (classType == "string" and allBaseClasses[i].Type == class) then
                return true
            end
        end
    end
    return false
end

return TableUtils