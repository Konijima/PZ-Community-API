require("CommunityAPIShared")

CommunityAPI.Client = {
    ItemTooltip = require("ItemTooltipAPI/Client"),
    Light = require("LightAPI/Client"),
    WorldSound = require("WorldSoundAPI/Client"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Client] =================================================")
for k, v in pairs(CommunityAPI.Client) do
    print("CommunityAPI.Client."..k, v)
end