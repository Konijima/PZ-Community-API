require("CommunityAPI")

local original_ISInventoryTransferAction_waitToStart = ISInventoryTransferAction.waitToStart

function ISInventoryTransferAction:waitToStart(...)
    local eventData = {
        cancel = false,
        character = self.character,
        destContainer = self.destContainer,
        item = self.item,
        srcContainer = self.srcContainer
    }
    CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnBeforeItemTransfer", eventData)

    if eventData.cancel then
        self.maxTime = -1
        self.destContainer = self.srcContainer
        self.hasBeenCancelled = true
        return false
    end
    self.destContainer = eventData.destContainer or self.destContainer

    -- VANILLA OBJECT DOES NOT HAVE waitToStart at the moment
    if original_ISInventoryTransferAction_waitToStart then
        return original_ISInventoryTransferAction_waitToStart(self, ...)
    else
        return false
    end
end
