require("CommunityAPI")

local original_ISAttachItemHotbar_perform = ISAttachItemHotbar.perform

function ISAttachItemHotbar:perform(...)
    original_ISAttachItemHotbar_perform(self, ...)
    CommunityAPI.Shared.Event.Trigger(
        "GameEventAPI",
        "OnHotbarItemAttched",
        self.character,
        self.item,
        self.slot,
        self.slotIndex,
        self.hotbar
    )
end
