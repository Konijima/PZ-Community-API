---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

CommunityAPI.Shared = {
    BodyLocations = require("BodyLocationsAPI/Shared")
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPIShared =================================================")
for k, v in pairs(CommunityAPI.Shared) do
    print("CommunityAPI.Shared."..k, v)
end