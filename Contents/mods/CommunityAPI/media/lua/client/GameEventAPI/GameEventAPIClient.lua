local GameEventAPI = {
    MyEventCategory = {
        OnDisplaySomething = {},
    },
    TimedActions = {
        OnApplyBandageStarted = {},
        OnApplyBandageStop = {},
        OnApplyBandagePerform = {},
    },
}

-- Automated Events Add/Remove setup
for category, _ in pairs(GameEventAPI) do
    for event, _ in pairs(GameEventAPI[category]) do
        GameEventAPI[category][event].Add = function(func)
            CommunityAPI.Shared.Event.Add("GameEventAPI", event, func)
        end
        GameEventAPI[category][event].Remove = function(func)
            CommunityAPI.Shared.Event.Remove("GameEventAPI", event, func)
        end
    end
end

return GameEventAPI
