require("CommunityAPI")

local original_ISToolTipInv_render = ISToolTipInv.render

function ISToolTipInv:render(...)
    if (self.lastItem ~= self.item) then -- ensures the event is not retriggered unnecessarily as the render() is constantly recalled
        self.lastItem = self.item
        CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnBeforeFirstInventoryTooltipDisplay", self.item)
    end
    original_ISToolTipInv_render(self, ...)
end

local function test()
    print("test triggered")
end

CommunityAPI.Client.GameEvent.Render.OnBeforeFirstInventoryTooltipDisplay.Add(test)

-- Events["GameEventAPI|OnBeforeFirstInventoryTooltipDisplay"].Add(test)
