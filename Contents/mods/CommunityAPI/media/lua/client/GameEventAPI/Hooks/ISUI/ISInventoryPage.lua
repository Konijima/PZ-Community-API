require("CommunityAPI")

local original_ISInventoryPage_render = ISInventoryPage.render
local lastInventoryContainer = nil
local lastLootContainer = nil
local lastSquare = nil

local function triggerLootEvents(inventory)
    CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnDisplayContainerContents", inventory)
    CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnDisplayLootContainerContents", inventory)
end

function ISInventoryPage:render(...)
    original_ISInventoryPage_render(self, ...)
    if self.onCharacter then
        if self.inventory ~= lastInventoryContainer then
            CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnDisplayContainerContents", self.inventory)
            CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnDisplayInventoryContainerContents", self.inventory)
            lastInventoryContainer = self.inventory
        end
    else
        if self.inventory ~= lastLootContainer then
            triggerLootEvents(self.inventory)
            lastLootContainer = self.inventory
        elseif self.inventory:getType() == "floor" then
            local currentSquare = getPlayer():getSquare()
            if currentSquare ~= lastSquare then
                triggerLootEvents(self.inventory)
                lastSquare = currentSquare
            end
        end
    end
end
