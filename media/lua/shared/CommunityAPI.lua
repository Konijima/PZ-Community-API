---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

CommunityAPI.Client = CommunityAPI.Client or {
    ItemTooltip = require("ItemTooltipAPI/Client"),
}

CommunityAPI.Shared = CommunityAPI.Shared or {
    BodyLocations = require("BodyLocationsAPI/Shared"),
}

CommunityAPI.Server = CommunityAPI.Server or {
    Distribution = require("DistributionAPI/Server"),
}