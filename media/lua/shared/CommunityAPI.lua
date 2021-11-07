---@class CommunityAPI
CommunityAPI = CommunityAPI or {}

CommunityAPI.Client = CommunityAPI.Client or {
    ItemTooltip = require("ItemTooltipAPI/Client"),
}

CommunityAPI.Shared = CommunityAPI.Shared or {
}

CommunityAPI.Server = CommunityAPI.Server or {
    Distribution = require("DistributionAPI/Server"),
}