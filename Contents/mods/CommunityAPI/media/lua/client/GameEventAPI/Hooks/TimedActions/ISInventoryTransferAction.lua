require("CommunityAPI")

local original_ISInventoryTransferAction_waitToStart = ISInventoryTransferAction.waitToStart

function ISInventoryTransferAction:waitToStart(...)
    local cancel = false
    local function cancelEvent()
        cancel = true
    end
    local changedContainer
    local function setDestinationContainer(customContainer)
        changedContainer = customContainer
    end
    CommunityAPI.Shared.Event.Trigger(
        "GameEventAPI",
        "OnBeforeItemTransfer",
        self.character,
        self.item,
        self.srcContainer,
        self.destContainer,
        cancelEvent,
        setDestinationContainer
    )

    if cancel then
        self.maxTime = -1
        self.destContainer = self.srcContainer
        self.hasBeenCancelled = true -- is required for OnAfterItemTransfer
        return false
    end
    self.destContainer = changedContainer or self.destContainer

    -- VANILLA OBJECT DOES NOT HAVE waitToStart at the moment
    if original_ISInventoryTransferAction_waitToStart then
        return original_ISInventoryTransferAction_waitToStart(self, ...)
    else
        return false
    end
end

local original_ISInventoryTransferAction_perform = ISInventoryTransferAction.perform

function ISInventoryTransferAction:perform(...)
    if #self.queueList > 0 then -- perform() removes item from the beginning of queue and runs one "empty" perform at the end
        local itemsStack = self.queueList[1].items
        original_ISInventoryTransferAction_perform(self, ...) -- must be after the if clause
        if not self.hasBeenCancelled then -- prevents from triggering if cancelled by the BeforeItemTransfer
            for i, item in ipairs(itemsStack) do
                CommunityAPI.Shared.Event.Trigger(
                    "GameEventAPI",
                    "OnAfterItemTransfer",
                    self.character,
                    item,
                    self.srcContainer,
                    self.destContainer
                )
            end
        end
    else
        original_ISInventoryTransferAction_perform(self, ...)
    end
end