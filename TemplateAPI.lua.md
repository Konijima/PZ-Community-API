# Example of an API structure
  
```lua
---@class PrivateObject
local PrivateObject = ISBaseObject:derive("PrivateObject")

function PrivateObject:new(param1)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self
    o.param1 = param1
    return o
end

------------------------------------------------------------------

---@class TemplateAPI
local TemplateAPI = {}

local privateVariable = {}

local function privateFunction(param1)
    table.insert(privateVariable, PrivateObject:new(param1))
end

function TemplateAPI.publicFunction(param1)
    privateFunction(param1)
end

return TemplateAPI
```