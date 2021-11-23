---@class Profession
local Profession = {}
Profession.__index = Profession

---@param name string
---@return table
function Profession:new(name)
	local o = {}
	setmetatable(o, self)
	self.__index = self

    o.name = name
    o.UIName = "UNDEFINED"
    o.textureName = ""
    o.professionScoreCost = 0
    o.itemScoreCost = 0
    o.freeTraits = {}
    o.xpBoosts = {}
    o.freeRecipes = {}
    o.specificItems = {}

    o.isFormattedDescription = false

	return o
end

---@param name string
function Profession:setUIName(name)
    self.UIName = getText(name)
end

---@param name string
function Profession:setTextureName(name)
    self.textureName = name
end

---@param scoreCost number
function Profession:setProfessionScoreCost(scoreCost)
    self.professionScoreCost = scoreCost
end

---Set how many points will give for start items choose (need for Expanded Character Creation)
---@param scoreCost number
function Profession:setItemScoreCost(scoreCost)
    self.itemScoreCost = scoreCost
end

---@param traitName string
function Profession:addFreeTrait(traitName)
    table.insert(self.freeTraits, traitName)
end

---@param perkName string
---@param value string  From 1 to 3: 1 = +75%, 2 = +100%, 3 = +125%
function Profession:addXPBoost(perkName, value)
    table.insert(self.xpBoosts, { perkName, value })
end 

---@param recipeName string
function Profession:addRecipe(recipeName)
    table.insert(self.freeRecipes, recipeName)
end

---Adds specific items to start item choose (need for Expanded Character Creation)
---@param itemName string
---@param cost number
function Profession:addSpecificItem(itemName, cost)
    self.specificItems[itemName] = cost
end

--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

---@class ProfessionAPI
local ProfessionAPI = {}
ProfessionAPI.ProfessionList = {}
ProfessionAPI.Profession = Profession
ProfessionAPI.ChangeProfessionCostList = {}
ProfessionAPI.ChangeItemCostList = {}
ProfessionAPI.SpecificItemList = {}

---@param name string
---@return table Profession
function ProfessionAPI.CreateProfession(name)
    ProfessionAPI.ProfessionList[name] = Profession:new(name)
    return ProfessionAPI.ProfessionList[name]
end

---@param name string
---@return table Profession
function ProfessionAPI.GetProfession(name)
    return ProfessionAPI.ProfessionList[name]
end


---Get how many points will give for start items choose (need for Expanded Character Creation). Works with default professions too
---@param name string
---@return number
function ProfessionAPI.GetProfessionItemCost(name)
    if ProfessionAPI.ProfessionList[name] == nil then
        return 0
    end
    return ProfessionAPI.ProfessionList[name].itemScoreCost
end

---@param name string
---@param cost number
function ProfessionAPI.ChangeProfessionCost(name, cost)
    if ProfessionAPI.ProfessionList[name] ~= nil then
        ProfessionAPI.ProfessionList[name].professionScoreCost = cost
    else
        ProfessionAPI.ChangeProfessionCostList[name] = cost
    end
end

---Change how many points will give for start items choose (need for Expanded Character Creation). Works with default professions too
---@param name string
---@param cost number
function ProfessionAPI.ChangeItemCost(name, cost)
    if ProfessionAPI.ProfessionList[name] ~= nil then
        ProfessionAPI.ProfessionList[name].itemScoreCost = cost
    else
        ProfessionAPI.ChangeItemCostList[name] = cost
    end
end

---Adds specific items to start item choose (need for Expanded Character Creation). Works with default professions too
---@param professionName string
---@param itemName string
---@param cost number
function ProfessionAPI.AddSpecificItem(professionName, itemName, cost)
    if ProfessionAPI.ProfessionList[professionName] ~= nil then
        ProfessionAPI.ProfessionList[professionName].specificItems[itemName] = cost
    else
        if ProfessionAPI.SpecificItemList[professionName] == nil then
            ProfessionAPI.SpecificItemList[professionName] = {}
        end
        ProfessionAPI.SpecificItemList[professionName][itemName] = cost
    end
end

return ProfessionAPI