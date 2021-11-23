local JsonAPI = require("CommunityAPI/JsonUtils")

---@class ModNewsAPI
local ModNewsAPI = {}
local Data = {}

--- Load the data
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
                if Data[modID] ~= nil and Data[modID][articleName] ~= nil then
                    if data.isViewed and data.lastUpdateDate == Data[modID][articleName].lastUpdateDate then
                        Data[modID][articleName].isViewed = true
                    end
                end
            end
        end
    end
end
Events.OnGameBoot.Add(ModNewsAPILoadData)

--- Add a new Article for your mod
---@param modID string The mod ID
---@param articleName string The article Name
---@param articleTextName string  Article text name from Translate
---@param lastUpdateDate string  String with date of last update. If you changed article and want to notify that article updated - change this param
---@return nil
function ModNewsAPI.AddArticle(modID, articleName, articleTextName, lastUpdateDate)
    if Data[modID] == nil then
        Data[modID] = {}
    end
    Data[modID][articleName] = {}
    Data[modID][articleName].modID = modID
    Data[modID][articleName].articleName = articleName
    Data[modID][articleName].articleTextName = articleTextName
    Data[modID][articleName].lastUpdateDate = lastUpdateDate
    Data[modID][articleName].isViewed = false
end

--- Get all Data (readonly)
---@return table
function ModNewsAPI.GetAll()
    return copyTable(Data)
end

--- Get a specific mod article (readonly)
---@param modID string The mod ID
---@param articleName string The article Name
---@return table
function ModNewsAPI.GetArticle(modID, articleName)
    if Data[modID] and Data[modID][articleName] then
        return copyTable(Data[modID][articleName])
    end
end

--- Check if an article is viewed already
---@param modID string The mod ID
---@param articleName string The article Name
---@return boolean True if viewed
function ModNewsAPI.GetArticleIsViewed(modID, articleName)
    if Data[modID] and Data[modID][articleName] then
        return Data[modID][articleName].isViewed
    end
end

--- Set an article as viewed
---@param modID string The mod ID
---@param articleName string The article Name
function ModNewsAPI.SetArticleAsViewed(modID, articleName)
    if Data[modID] and Data[modID][articleName] then
        Data[modID][articleName].isViewed = true
    end
end

return ModNewsAPI