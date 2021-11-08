require("CommunityAPIShared")

CommunityAPI.Client = {
    ItemTooltip = require("ItemTooltipAPI/ItemTooltipAPIClient"),
    IsoRangeScan = require("IsoRangeScanAPI/Client"),
    Light = require("LightAPI/LightAPIClient"),
    Spawner = require("SpawnerAPI/Client"),
    WorldSound = require("WorldSoundAPI/WorldSoundAPIClient"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Client] =================================================")
for k, v in pairs(CommunityAPI.Client) do
    print("CommunityAPI.Client."..k, v)
end