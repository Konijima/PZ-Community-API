require("CommunityAPI")
local TraitAPI = CommunityAPI.Shared.Trait
local EventAPI = CommunityAPI.Shared.Event

function TraitAPI_InitTraits()
    -- Add default traits as TraitAPIObj
    local existTraits = TraitFactory.getTraits()
    for i=0, existTraits:size()-1 do
        local traitObj = existTraits:get(i)
        local traitObjType = traitObj:getType()
        local traitAPIObj = TraitAPI.TraitList[traitObjType]

        if traitAPIObj == nil then
            TraitAPI.TraitList[traitObjType] = TraitAPI.Trait:new(traitObjType)
            traitAPIObj = TraitAPI.TraitList[traitObjType]

            traitAPIObj:setUIName(traitObj:getLabel())
            traitAPIObj:setDescription(traitObj:getDescription())
            traitAPIObj:setIsProfessionTrait(traitObj:isFree())
            traitAPIObj:setRemoveInMP(traitObj:isRemoveInMP())

            if TraitAPI.ChangeTraitCostList[traitObjType] ~= nil then
                traitAPIObj:setTraitScoreCost(TraitAPI.ChangeTraitCostList[traitObjType])
            else
                traitAPIObj:setTraitScoreCost(traitObj:getCost())
            end
            
            local incompTraits = traitObj:getMutuallyExclusiveTraits()
            for j=0, incompTraits:size()-1 do
                traitAPIObj:addIncompatibleTrait(incompTraits:get(j))    
            end
            
            local table = transformIntoKahluaTable(traitObj:getXPBoostMap())
            for perk, value in pairs(table) do
                traitAPIObj:addXPBoost(perk:getId(), value)
            end
            
            local freeRecipes = traitObj:getFreeRecipes()
            for j=0, freeRecipes:size()-1 do
                traitAPIObj:addRecipe(freeRecipes:get(j))    
            end

            if TraitAPI.ChangeItemCostList[traitObjType] ~= nil then
                traitAPIObj:setItemScoreCost(TraitAPI.ChangeItemCostList[traitObjType])
            else
                if traitAPIObj.traitScoreCost > 0 then
                    traitAPIObj:setItemScoreCost(-1)
                else
                    traitAPIObj:setItemScoreCost(1)
                end
            end

            if TraitAPI.SpecificItemList[traitObjType] ~= nil then
                for itemName, cost in pairs(TraitAPI.SpecificItemList[traitObjType]) do
                    traitAPIObj:addSpecificItem(itemName, cost)
                end
            end

            traitAPIObj.isFormattedDescription = true
        end
    end

    for traitName, traitAPIObj in pairs(TraitAPI.TraitList) do
        local traitObj = TraitFactory.addTrait(traitAPIObj.name, traitAPIObj.UIName, traitAPIObj.traitScoreCost, traitAPIObj.UIDescriptionName, traitAPIObj.isProfessionTrait, traitAPIObj.removeInMP)
		
        for _, boostData in ipairs(traitAPIObj.xpBoosts) do
            traitObj:addXPBoost(Perks.FromString(boostData[1]), boostData[2])    
        end

        for _, incompatibleTrait in ipairs(traitAPIObj.incompatibleTraits) do
            TraitFactory.setMutualExclusive(traitName, incompatibleTrait)
        end

        for _, recipeName in ipairs(traitAPIObj.freeRecipes) do
            traitObj:getFreeRecipes():add(recipeName)
        end

        if not traitAPIObj.isFormattedDescription then
            BaseGameCharacterDetails.SetTraitDescription(traitObj)
        end
    end

    EventAPI.Trigger("CommunityAPI", "OnInitCustomTraits")  -- Trigger event for start Profession init
end

EventAPI.Add("CommunityAPI", "OnInitCustomPerks", TraitAPI_InitTraits)
