require("CommunityAPI")

--- render

local original_ISInventoryPage_render = ISInventoryPage.render
function ISInventoryPage:render(...)
    original_ISInventoryPage_render(self, ...)

    -- do you stuff here and trigger events you want
    -- add the events in categories in GameEventAPIClient.lua
    -- CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnSomething", param1)
end
