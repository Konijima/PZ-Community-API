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
---@param name string The field name to appear on the left
---@param getValueFunc string|number|boolean|function Set the field value directly or using a function
---@param _labelColor Color Optionally set the label color
function InventoryTooltipInstance:addField(name, getValueFunc, _labelColor)
    self.fields[name] = InventoryTooltipField:new("field", name, getValueFunc, _labelColor)
end

--- Add a label
---@param getValueFunc string|function Set the label text value directly or using a function
---@param _labelColor Color Optionally set the label color
function InventoryTooltipInstance:addLabel(getValueFunc, _labelColor)
    local name = "label_" .. self:getFieldCount()
    self.fields[name] = InventoryTooltipField:new("label", name, getValueFunc, _labelColor)
end

--- Add a progress bar
---@param name string The field name to appear on the left
---@param getValueFunc number|function Set the progress bar value directly or using a function
---@param _labelColor Color Optionally set the label color
function InventoryTooltipInstance:addProgress(name, getValueFunc, _labelColor)
    self.fields[name] = InventoryTooltipField:new("progress", name, getValueFunc, _labelColor)
end

--- Add extra item icons
---@param name string The field name to appear on the left
---@param getValueFunc function Set the extra items using a function
---@param _labelColor Color Optionally set the label color
function InventoryTooltipInstance:addExtraItems(name, getValueFunc, _labelColor)
    self.fields[name] = InventoryTooltipField:new("extra", name, getValueFunc, _labelColor)
end

--- Add a spacer
function InventoryTooltipInstance:addSpacer()
    local name = "spacer_" .. self:getFieldCount()
    self.fields[name] = InventoryTooltipField:new("spacer", name)
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
