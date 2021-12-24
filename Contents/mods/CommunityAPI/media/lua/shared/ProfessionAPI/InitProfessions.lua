local EventAPI = CommunityAPI.Shared.Event

local function ProfessionAPI_InitProfessions()
    require("CommunityAPI")
    local ProfessionAPI = CommunityAPI.Shared.Profession

    -- Set default professions
    local profList = ProfessionFactory.getProfessions()
	for i=1, profList:size() do
		local profObj = profList:get(i-1)
        local profObjType = profObj:getType()

        local profAPIObj = ProfessionAPI.ProfessionList[profObjType]

        if profAPIObj == nil then
            ProfessionAPI.ProfessionList[profObjType] = ProfessionAPI.Profession:new(profObjType)
            profAPIObj = ProfessionAPI.ProfessionList[profObjType]

            profAPIObj:setUIName(profObj:getName())
            profAPIObj:setTextureName(profObj:getIconPath())
            profAPIObj:setProfessionScoreCost(profObj:getCost())

            if ProfessionAPI.ChangeItemCostList[profObjType] ~= nil then
                profAPIObj:setItemScoreCost(ProfessionAPI.ChangeItemCostList[profObjType])
            else
                profAPIObj:setItemScoreCost(-profObj:getCost())
            end

            local freeTraits = profObj:getFreeTraits()
            for j=0, freeTraits:size()-1 do
                profAPIObj:addFreeTrait(freeTraits:get(j))    
            end
            
            local table = transformIntoKahluaTable(profObj:getXPBoostMap())
            for perk, value in pairs(table) do
                profAPIObj:addXPBoost(perk:getId(), value)
            end
            
            local freeRecipes = profObj:getFreeRecipes()
            for j=0, freeRecipes:size()-1 do
                profAPIObj:addRecipe(freeRecipes:get(j))    
            end
        end
	end

    for profName, profAPIObj in pairs(ProfessionAPI.ProfessionList) do
        local professionObj = ProfessionFactory.addProfession(profName, profAPIObj.UIName, profAPIObj.textureName, profAPIObj.professionScoreCost)
        
        for _, boostData in ipairs(profAPIObj.xpBoosts) do
            professionObj:addXPBoost(Perks.FromString(boostData[1]), boostData[2])    
        end

        for _, freeTrait in ipairs(profAPIObj.freeTraits) do
            professionObj:addFreeTrait(freeTrait);
        end

        for _, recipeName in ipairs(profAPIObj.freeRecipes) do
            professionObj:getFreeRecipes():add(recipeName)
        end   
        
        BaseGameCharacterDetails.SetProfessionDescription(professionObj)    
    end
end

EventAPI.Add("CommunityAPI", "OnInitCustomTraits", ProfessionAPI_InitProfessions)
