---@class PerkAPI
local PerkAPI = {}
PerkAPI.PerkList = {}

--- Adds perk. If not write xp for levels - will set default: 50, 100, 200, 500, 1000, 2000, 3000, 4000, 5000, 6000
---@param perkName string
---@param categoryName string
---@param _xpLvl1 number
---@param _xpLvl2 number
---@param _xpLvl3 number
---@param _xpLvl4 number
---@param _xpLvl5 number
---@param _xpLvl6 number
---@param _xpLvl7 number
---@param _xpLvl8 number
---@param _xpLvl9 number
---@param _xpLvl10 number
---@return nil
function PerkAPI.AddPerk(perkName, categoryName, _xpLvl1, _xpLvl2, _xpLvl3, _xpLvl4, _xpLvl5, _xpLvl6, _xpLvl7, _xpLvl8, _xpLvl9, _xpLvl10)   
    if tostring(Perks.FromString(perkName)) ~= "MAX" then return end    -- Don't add default skills again
    
    -- Set default skill lvl requirements
    if _xpLvl1 == nil then
        _xpLvl1, _xpLvl2, _xpLvl3, _xpLvl4, _xpLvl5, _xpLvl6, _xpLvl7, _xpLvl8, _xpLvl9, _xpLvl10 = 50, 100, 200, 500, 1000, 2000, 3000, 4000, 5000, 6000
    end

    if PerkAPI.PerkList[categoryName] == nil then
        PerkAPI.PerkList[categoryName] = {}
    end
    table.insert(PerkAPI.PerkList[categoryName], { perkName, _xpLvl1, _xpLvl2, _xpLvl3, _xpLvl4, _xpLvl5, _xpLvl6, _xpLvl7, _xpLvl8, _xpLvl9, _xpLvl10 })
end

--- Get perk by name
---@param perkName string
---@return any PerkFactory.Perk  Java object
function PerkAPI.GetPerk(perkName)
    if Perks.FromString(perkName) == Perks.getMaxIndex() then return nil end
    return Perks.FromString(perkName)
end

return PerkAPI
