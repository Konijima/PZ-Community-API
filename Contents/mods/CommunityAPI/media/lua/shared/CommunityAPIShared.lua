---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

CommunityAPI.Utils = {
    Inventory = require("CommunityAPI/InventoryUtils"),
    Iso = require("CommunityAPI/IsoUtils"),
    Math = require("CommunityAPI/MathUtils"),
    String = require("CommunityAPI/StringUtils"),
    Table = require("CommunityAPI/TableUtils"),
}

CommunityAPI.Shared = {
    BodyLocations = require("BodyLocationsAPI/BodyLocationsAPIShared")
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPIShared =================================================")
for k, v in pairs(CommunityAPI.Shared) do
    print("CommunityAPI.Shared."..k, v)
end