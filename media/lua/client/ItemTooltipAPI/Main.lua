require("ISBaseObject")

---------------------------------------------------------------------------------

---@private
---@class InventoryTooltipField
local InventoryTooltipField = ISBaseObject:derive("InventoryTooltipField")

---@param item InventoryItem
function InventoryTooltipField:getValue(item)
    local valueType = type(self.getValueFunc)
    if valueType == "function" then
        self.getValueFunc(self.result, item)
    elseif valueType == "string" or valueType == "number" or valueType == "boolean" then
        self.result.value = self.getValueFunc
    end
end

---@param fieldType string field, label, progress, spacer
---@param name string
---@param param string|number|boolean|function
function InventoryTooltipField:new(fieldType, name, getValueFunc, labelColor)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self
    o.fieldType = fieldType
    o.name = name
    o.result = {
        value = nil,
        color = nil,
        labelColor = nil,
    }
    o.getValueFunc = getValueFunc

    if type(labelColor) == "table" then
        if type(o.result.labelColor) ~= "table" then o.result.labelColor = {}; end
        if type(labelColor.r) == "number" then o.result.labelColor.r = labelColor.r; end
        if type(labelColor.g) == "number" then o.result.labelColor.g = labelColor.g; end
        if type(labelColor.b) == "number" then o.result.labelColor.b = labelColor.b; end
        if type(labelColor.a) == "number" then o.result.labelColor.a = labelColor.a; end
    end

    return o
end

---------------------------------------------------------------------------------

---@private
---@class InventoryTooltipInstance
local InventoryTooltipInstance = ISBaseObject:derive("InventoryTooltipInstance")

---@param name string
---@param getValueFunc string|number|boolean|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addField(name, getValueFunc, labelColor)
    self.fields[name] = InventoryTooltipField:new("field", name, getValueFunc, labelColor)
    return self.fields[name]
end

---@param getValueFunc string|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addLabel(getValueFunc, labelColor)
    local name = "label_" .. self:fieldCount()
    self.fields[name] = InventoryTooltipField:new("label", name, getValueFunc, labelColor)
    return self.fields[name]
end

---@param name string
---@param getValueFunc number|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addProgress(name, getValueFunc, labelColor)
    self.fields[name] = InventoryTooltipField:new("progress", name, getValueFunc, labelColor)
    return self.fields[name]
end

---@param getValueFunc string|number|boolean|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addSpacer()
    local name = "spacer_" .. self:fieldCount()
    self.fields[name] = InventoryTooltipField:new("spacer", name)
    return self.fields[name]
end

---@return number
function InventoryTooltipInstance:fieldCount()
    local count = 0
    for _ in pairs(self.fields) do count = count + 1 end
    return count
end

---@param itemFullType string
---@return InventoryTooltipInstance
function InventoryTooltipInstance:new(itemFullType)
    local o = ISBaseObject:new()
    setmetatable(o, self)

    self.__index = self
    o.itemFullType = itemFullType
    o.fields = {}
    return o
end

---------------------------------------------------------------------------------

local Tooltips = {}

---@return table<string, InventoryTooltipInstance>
local function GetTooltip(itemFullType)
    return Tooltips[itemFullType]
end

---@return InventoryTooltipInstance
local function CreateToolTip(itemFullType)
    local newTooltip = InventoryTooltipInstance:new(itemFullType)
    Tooltips[itemFullType] = newTooltip
    return newTooltip
end

---@param current number
---@param max number
local function GetRGB(current, max)
    if current < 1 and current > 0 then
        current = current * 100
        max = max * 100
    end
    local r = ((max - current) / max)
    local g = (current / max)
    return {r = r, g = g, b = 0}
end

---@param current number
---@param max number
local function GetReversedRGB(current, max)
    if current < 1 and current > 0 then
        current = current * 100
        max = max * 100
    end
    local g = ((max - current) / max)
    local r = (current / max)
    return {r = r, g = g, b = 0}
end

---@param floatVal number
---@return string
local function GetFloatString(floatVal)
    return string.format("%.2f", floatVal);
end

local function GetSafeColor(color, default)
    if type(color) ~= "table" then color = default; end
    if type(color.r) ~= "number" then color.r = default.r; end
    if type(color.g) ~= "number" then color.g = default.g; end
    if type(color.b) ~= "number" then color.b = default.b; end
    if type(color.a) ~= "number" then color.a = default.a; end
    return color
end

---------------------------------------------------------------------------------

---@public
---@class ItemTooltipAPI
ItemTooltipAPI = {}
ItemTooltipAPI.GetTooltip = GetTooltip
ItemTooltipAPI.CreateToolTip = CreateToolTip
ItemTooltipAPI.GetRGB = GetRGB
ItemTooltipAPI.GetReversedRGB = GetReversedRGB
ItemTooltipAPI.GetFloatString = GetFloatString
ItemTooltipAPI.GetSafeColor = GetSafeColor

---------------------------------------------------------------------------------