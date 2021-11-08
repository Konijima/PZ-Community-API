require("CommunityAPIShared")

CommunityAPI.Server = {
    Distribution = require("DistributionAPI/DistributionAPIServer"),
    Spawner = require("SpawnerAPI/Server"),
}

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Server] =================================================")
for k, v in pairs(CommunityAPI.Server) do
    print("CommunityAPI.Server."..k, v)
end