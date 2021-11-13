local InventoryUtils = {}

--- Find all item in an inventory by tag
---@param inventory ItemContainer
---@param tag string
---@return ArrayList
function InventoryUtils.FindAllItemInInventoryByTag(inventory, tag)
    local foundItems = ArrayList.new()
    local validItems = getScriptManager():getItemsTag(tag)
    if validItems then
        for i=0, validItems:size()-1 do
            foundItems:addAll(inventory:getItemsFromFullType(validItems:get(i):getFullName()))
        end
    end
    return foundItems
end

return InventoryUtils