---@class InventoryUtils
local InventoryUtils = {}

--- Find all item in an inventory by tag
---@param inventory ItemContainer
---@param tag string
---@return ArrayList|nil
function InventoryUtils.findAllItemInInventoryByTag(inventory, tag)
    if instanceof(inventory, "ItemContainer") and type(tag) == "string" then
        local foundItems = ArrayList.new();
        local validItems = getScriptManager():getItemsTag(tag);
        if validItems then
            for i=0, validItems:size()-1 do
                foundItems:addAll(inventory:getItemsFromFullType(validItems:get(i):getFullName()));
            end
        end
        return foundItems;
    end
end

return InventoryUtils