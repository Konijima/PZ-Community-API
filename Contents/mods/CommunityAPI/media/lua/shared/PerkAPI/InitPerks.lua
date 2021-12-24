require("CommunityAPI")
local PerkAPI = CommunityAPI.Shared.Perk
local EventAPI = CommunityAPI.Shared.Event

local function PerkAPIAddPerks()
    for categoryName, categoryPerksData in pairs(PerkAPI.PerkList) do
        -- Add base category perk. If exist - get from Perks
        local categoryPerk = Perks.FromString(categoryName)
        if tostring(categoryPerk) == "MAX" then
            Perk.new(categoryName)
            categoryPerk = Perks.FromString(categoryName)
            PerkFactory.AddPerk(categoryPerk, categoryName, Perks.None, 50, 100, 200, 500, 1000, 2000, 3000, 4000, 5000, 6000);
        end

        for _, perkData in ipairs(categoryPerksData) do
            Perk.new(perkData[1])
            PerkFactory.AddPerk(Perks.FromString(perkData[1]), perkData[1], categoryPerk, perkData[2], perkData[3], perkData[4], perkData[5], perkData[6], perkData[7], perkData[8], perkData[9], perkData[10], perkData[11])    
        end
    end
    EventAPI.Trigger("CommunityAPI", "OnInitCustomPerks")   -- Trigger event for start init traits
end

Events.OnGameBoot.Add(PerkAPIAddPerks)
