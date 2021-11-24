require("CommunityAPIShared")

CommunityAPI.Client = {
    ItemTooltip = require("ItemTooltipAPI/ItemTooltipAPIClient"),
    Light = require("LightAPI/LightAPIClient"),
    ModNews = require("ModNewsAPI/ModNewsAPIClient"),
    ModSetting = require("ModSettingAPI/ModSettingAPIClient"),
    Spawner = require("SpawnerAPI/SpawnerAPIClient"),
    WorldSound = require("WorldSoundAPI/WorldSoundAPIClient"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Client] =================================================")
for k, v in pairs(CommunityAPI.Client) do
    print("CommunityAPI.Client."..k, v)
end