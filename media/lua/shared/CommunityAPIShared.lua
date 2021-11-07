---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

-- Add Shared APIs

CommunityAPI.BodyLocations = require("BodyLocationsAPI/Shared")

-----------------------------------------------------------------------------------

print("Loading CommunityAPIShared =================================================")
for k, v in pairs(CommunityAPI) do
    print("CommunityAPI."..k, v)
end