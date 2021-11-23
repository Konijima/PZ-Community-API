require("CommunityAPI")
local ModNewsAPI = CommunityAPI.Client.ModNews
local JsonAPI = CommunityAPI.Utils.Json

local function ModNewsAPILoadData()
    local fileReader = getFileReader("CAPI_modNewsData.txt", true)
	if not fileReader then return end
    local line = fileReader:readLine()
    local modNewsData = nil
    if line ~= nil then
        modNewsData = JsonAPI.Decode(line)   
    end
    fileReader:close()

    if modNewsData ~= nil and type(modNewsData) == "table" then
        for modID, modData in pairs(modNewsData) do
            for articleName, data in pairs(modData) do
                if ModNewsAPI.Data[modID] ~= nil and ModNewsAPI.Data[modID][articleName] ~= nil then
                    if data.isViewed and data.lastUpdateDate == ModNewsAPI.Data[modID][articleName].lastUpdateDate then
                        ModNewsAPI.Data[modID][articleName].isViewed = true
                    end
                end
            end
        end
    end
end

Events.OnGameBoot.Add(ModNewsAPILoadData)