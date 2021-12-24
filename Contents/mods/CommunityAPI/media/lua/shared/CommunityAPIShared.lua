---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

CommunityAPI.Utils = {
    Color = require("CommunityAPI/ColorUtils"),
    Inventory = require("CommunityAPI/InventoryUtils"),
    Iso = require("CommunityAPI/IsoUtils"),
    Json = require("CommunityAPI/JsonUtils"),
    Math = require("CommunityAPI/MathUtils"),
    String = require("CommunityAPI/StringUtils"),
    Table = require("CommunityAPI/TableUtils"),
}

CommunityAPI.Shared = {
    BodyLocations = require("BodyLocationsAPI/BodyLocationsAPIShared"),
    Event = require("EventAPI/EventAPIShared"),
    Perk = require("PerkAPI/PerkAPIClient"),
    Profession = require("ProfessionAPI/ProfessionAPIClient"),
    Trait = require("TraitAPI/TraitAPIClient"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPIShared =================================================")
for k, v in pairs(CommunityAPI.Utils) do
    print("CommunityAPI.Utils."..k, v)
end
for k, v in pairs(CommunityAPI.Shared) do
    print("CommunityAPI.Shared."..k, v)
end
