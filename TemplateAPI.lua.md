# Example of an API structure
  
```lua
---@class PrivateObject
local PrivateObject = ISBaseObject:derive("PrivateObject")

---@param param1 string
function PrivateObject:new(param1)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self
    o.param1 = param1
    return o
end

function PrivateObject:instanceMethod()
  print(self.param1)
end

------------------------------------------------------------------

---@class TemplateAPI
local TemplateAPI = {}

local privateVariable = {}

---@param param1 string
local function privateFunction(param1)
    table.insert(privateVariable, PrivateObject:new(param1))
end
Events.OnEvent.Add(privateFunction)

function TemplateAPI.PublicFunction()
    return privateVariable
end

return TemplateAPI
```
