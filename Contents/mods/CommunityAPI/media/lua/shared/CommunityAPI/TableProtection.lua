---@param unprotectedTable table The table to protect
---@return table
return function(unprotectedTable)
    return setmetatable({}, {
        __index = unprotectedTable,
        __newindex = function(t,k,v) error("You cannot overwrite ["..k.."]!") end,
        __metatable = "protected"
    })
end
