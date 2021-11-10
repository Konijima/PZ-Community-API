require("CommunityAPI")
require("ISBaseObject")

---------------------------------------------------------------------------------

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

---@param fieldType string field, label, progress, spacer, extra
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
    o.result.labelColor = CommunityAPI.Utils.Color.GetColorOrDefault(labelColor, { r=1, g=1, b=0.8, a=1 })

    return o
end

---------------------------------------------------------------------------------

---@class InventoryTooltipInstance
local InventoryTooltipInstance = ISBaseObject:derive("InventoryTooltipInstance")

--- Add a text field
---@param name string
---@param getValueFunc string|number|boolean|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addField(name, getValueFunc, labelColor)
    self.fields[name] = InventoryTooltipField:new("field", name, getValueFunc, labelColor)
    return self.fields[name]
end

--- Add a label
---@param getValueFunc string|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addLabel(getValueFunc, labelColor)
    local name = "label_" .. self:getFieldCount()
    self.fields[name] = InventoryTooltipField:new("label", name, getValueFunc, labelColor)
    return self.fields[name]
end

--- Add a progress bar
---@param name string
---@param getValueFunc number|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addProgress(name, getValueFunc, labelColor)
    self.fields[name] = InventoryTooltipField:new("progress", name, getValueFunc, labelColor)
    return self.fields[name]
end

--- Add a extra item icons
---@param name string
---@param getValueFunc number|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addExtraItems(name, getValueFunc, labelColor)
    self.fields[name] = InventoryTooltipField:new("extra", name, getValueFunc, labelColor)
    return self.fields[name]
end

--- Add a spacer
---@return InventoryTooltipField
function InventoryTooltipInstance:addSpacer()
    local name = "spacer_" .. self:getFieldCount()
    self.fields[name] = InventoryTooltipField:new("spacer", name)
    return self.fields[name]
end

--- Get the total amount of field added to this tooltip
---@return number
function InventoryTooltipInstance:getFieldCount()
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

---@class ItemTooltipAPI
local ItemTooltipAPI = {}
local Tooltips = {}

---@return table<string, InventoryTooltipInstance>
function ItemTooltipAPI.GetTooltip(itemFullType)
    return Tooltips[itemFullType]
end

--- Create a new Tooltip for a specific Item
---@param itemFullType string Item to create the tooltip for e.g: "Base.Axe"
---@return InventoryTooltipInstance
function ItemTooltipAPI.CreateToolTip(itemFullType)
    local newTooltip = InventoryTooltipInstance:new(itemFullType)
    Tooltips[itemFullType] = newTooltip
    return newTooltip
end

return ItemTooltipAPI
