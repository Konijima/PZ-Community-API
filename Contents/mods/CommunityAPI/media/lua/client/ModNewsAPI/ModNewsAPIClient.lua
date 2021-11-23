
---@class ModNewsAPI
local ModNewsAPI = {}
ModNewsAPI.Data = {}

---@param modID string  
---@param articleName string  
---@param articleTextName string  Article text name from Translate
---@param lastUpdateDate string  String with date of last update. If you changed article and want to notify that article updated - change this param
---@return nil
function ModNewsAPI.AddArticle(modID, articleName, articleTextName, lastUpdateDate)
    if ModNewsAPI.Data[modID] == nil then
        ModNewsAPI.Data[modID] = {}
    end
    ModNewsAPI.Data[modID][articleName] = {}
    ModNewsAPI.Data[modID][articleName].modID = modID
    ModNewsAPI.Data[modID][articleName].articleName = articleName
    ModNewsAPI.Data[modID][articleName].articleTextName = articleTextName
    ModNewsAPI.Data[modID][articleName].lastUpdateDate = lastUpdateDate
    ModNewsAPI.Data[modID][articleName].isViewed = false
end

return ModNewsAPI