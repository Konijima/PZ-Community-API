require("CommunityAPIShared")

-- Add Client APIs

CommunityAPI.ItemTooltip = require("ItemTooltipAPI/Client")

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Client] =================================================")
for k, v in pairs(CommunityAPI) do
    print("CommunityAPI."..k, v)
end