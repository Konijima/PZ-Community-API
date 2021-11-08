require("CommunityAPIShared")

CommunityAPI.Client = {
    ItemTooltip = require("ItemTooltipAPI/ItemTooltipAPIClient"),
    IsoRangeScan = require("IsoRangeScanAPI/IsoRangeScanAPIClient"),
    Light = require("LightAPI/LightAPIClient"),
    Spawner = require("SpawnerAPI/SpawnerAPIClient"),
    WorldSound = require("WorldSoundAPI/WorldSoundAPIClient"),
    Generator = require("GeneratorAPI/GeneratorAPIClient"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Client] =================================================")
for k, v in pairs(CommunityAPI.Client) do
    print("CommunityAPI.Client."..k, v)
end