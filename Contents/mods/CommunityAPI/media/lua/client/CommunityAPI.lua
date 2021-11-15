require("CommunityAPIShared")

CommunityAPI.Client = {
    GameEvent = require("GameEventAPI/GameEventAPIClient"),
    ItemTooltip = require("ItemTooltipAPI/ItemTooltipAPIClient"),
    Light = require("LightAPI/LightAPIClient"),
    ModSetting = require("ModSettingAPI/ModSettingAPIClient"),
    Spawner = require("SpawnerAPI/SpawnerAPIClient"),
    WorldSound = require("WorldSoundAPI/WorldSoundAPIClient"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Client] =================================================")
for k, v in pairs(CommunityAPI.Client) do
    print("CommunityAPI.Client."..k, v)
end