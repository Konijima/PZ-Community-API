---@class Trait
local Trait = {}
Trait.__index = Trait

---@param name string
---@return table
function Trait:new(name)
	local o = {}
	setmetatable(o, self)
	self.__index = self

    o.name = name
    o.UIName = "UNDEFINED"
    o.UIDescriptionName = "UNDEFINED"
    o.traitScoreCost = 0
    o.itemScoreCost = 0
    o.isProfessionTrait = false
    o.removeInMP = false
    
    o.incompatibleTraits = {}
    o.xpBoosts = {}
    o.freeRecipes = {}
    o.specificItems = {}

    o.isFormattedDescription = false

	return o
end

---@param name string
function Trait:setUIName(name)
    self.UIName = getText(name)
end

---@param description string
function Trait:setDescription(descriptionName)
    self.UIDescriptionName = getText(descriptionName)
end

---@param scoreCost number
function Trait:setTraitScoreCost(scoreCost)
    self.traitScoreCost = scoreCost
end

---Set how many points will give for start items choose (need for Expanded Character Creation)
---@param scoreCost number
function Trait:setItemScoreCost(scoreCost)
    self.itemScoreCost = scoreCost
end

---If true, then the player will not be able to choose trait. Need for add trait only by profession (Don't foget add trait in when create new/change old Profession!)
---@param value boolean
function Trait:setIsProfessionTrait(value)
    self.isProfessionTrait = value
end

---If true - will be removed in Multiplayer
---@param value boolean
function Trait:setRemoveInMP(value)
    self.removeInMP = value
end

---@param traitName string
function Trait:addIncompatibleTrait(traitName)
    table.insert(self.incompatibleTraits, traitName)
end

---@param perkName string
---@param value number  From 1 to 3: 1 = +75%, 2 = +100%, 3 = +125%
function Trait:addXPBoost(perkName, value)
    table.insert(self.xpBoosts, { perkName, value })
end 

---@param recipeName string
function Trait:addRecipe(recipeName)
    table.insert(self.freeRecipes, recipeName)
end

---Adds specific items to start item choose (need for Expanded Character Creation)
---@param itemName string
---@param cost number
function Trait:addSpecificItem(itemName, cost)
    self.specificItems[itemName] = cost
end

--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---@class TraitAPI
local TraitAPI = {}
TraitAPI.Trait = Trait
TraitAPI.TraitList = {}
TraitAPI.ChangeTraitCostList = {}
TraitAPI.ChangeItemCostList = {}
TraitAPI.SpecificItemList = {}


---@param name string
---@return table Trait
function TraitAPI.CreateTrait(name)
    TraitAPI.TraitList[name] = Trait:new(name)
    return TraitAPI.TraitList[name]
end

---@param name string
---@return table Trait
function TraitAPI.GetTrait(name)
    return TraitAPI.TraitList[name]
end

---Change trait cost without full rewriting trait. Works with default traits
---@param name string
---@param cost number
function TraitAPI.ChangeTraitCost(name, cost)
    if TraitAPI.TraitList[name] ~= nil then
        TraitAPI.TraitList[name].traitScoreCost = cost
    else
        TraitAPI.ChangeTraitCostList[name] = cost
    end
end

---Change how many points will give for start items choose (need for Expanded Character Creation). Works with default traits too
---@param name string
---@param cost number
function TraitAPI.ChangeItemCost(name, cost)
    if TraitAPI.TraitList[name] ~= nil then
        TraitAPI.TraitList[name].itemScoreCost = cost
    else
        TraitAPI.ChangeItemCostList[name] = cost
    end
end

---Get how many points will give for start items choose (need for Expanded Character Creation). Works with default traits too
---@param name string
---@return number
function TraitAPI.GetTraitItemCost(name)
    if TraitAPI.TraitList[name] == nil then
        return 0
    end
    return TraitAPI.TraitList[name].itemScoreCost
end

---Adds specific items to start item choose (need for Expanded Character Creation). Works with default traits too
---@param traitName string
---@param itemName string
---@param cost number
function TraitAPI.AddSpecificItem(traitName, itemName, cost)
    if TraitAPI.TraitList[traitName] ~= nil then
        TraitAPI.TraitList[traitName].specificItems[itemName] = cost
    else
        if TraitAPI.SpecificItemList[traitName] == nil then
            TraitAPI.SpecificItemList[traitName] = {}
        end
        TraitAPI.SpecificItemList[traitName][itemName] = cost
    end
end

return TraitAPI

