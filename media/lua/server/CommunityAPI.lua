require("CommunityAPIShared")

-- Add Server APIs

CommunityAPI.Distribution = require("DistributionAPI/Server")

-----------------------------------------------------------------------------------

print("Loading CommunityAPI [Server] =================================================")
for k, v in pairs(CommunityAPI) do
    print("CommunityAPI."..k, v)
end