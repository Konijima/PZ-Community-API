---@class GameEvent
local GameEvent = {}
function GameEvent:new()
    local o = {}
    setmetatable(o, {})
    ---@param func function
    function o.Add(func) end

    ---@param func function
    function o.Remove(func) end
    return o
end

---@class GameEventAPI
local GameEventAPI = {
    --MyEventCategory = {
    --    OnDisplaySomething = GameEvent:new(),
    --},
    TimedActions = {
        OnApplyBandageStart = GameEvent:new(),
        OnApplyBandageStop = GameEvent:new(),
        OnApplyBandagePerform = GameEvent:new(),
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

--- TEST

local test = true
if test then
    print("GameEventAPI Test mode enabled!")
    for categoryName, _ in pairs(GameEventAPI) do
        for eventName, event in pairs(GameEventAPI[categoryName]) do

            local function testHandler(...)
                local args = {...}
                for k, v in pairs(args) do
                    print("Event [", eventName,"] Params [", k," = ", v,"]")
                end
            end

            print("GameEventAPI Test mode watching for event [", eventName,"]!")
            event.Remove(testHandler)
            event.Add(testHandler)
        end
    end
end

return GameEventAPI
