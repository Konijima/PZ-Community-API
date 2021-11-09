---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

CommunityAPI.Utilities = require("CommunityAPI/Utilities")

CommunityAPI.Shared = {
    BodyLocations = require("BodyLocationsAPI/BodyLocationsAPIShared")
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPIShared =================================================")
for k, v in pairs(CommunityAPI.Shared) do
    print("CommunityAPI.Shared."..k, v)
end