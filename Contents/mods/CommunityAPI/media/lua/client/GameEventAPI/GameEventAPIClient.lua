---@class GameEvent
local GameEvent = {}
function GameEvent:new()
    local o = {}
    o.Type = "GameEvent"
    ---@param func function
    function o.Add(func)
    end

    ---@param func function
    function o.Remove(func)
    end
    return o
end

---@class GameEventAPI
local GameEventAPI = {
    --MyEventCategory = {
    --    OnDisplaySomething = GameEvent:new(),
    --},
    Render = {
        OnBeforeFirstInventoryTooltipDisplay = GameEvent:new()
    },
    TimedActions = {
        OnApplyBandageStart = GameEvent:new(),
        OnApplyBandageStop = GameEvent:new(),
        OnApplyBandagePerform = GameEvent:new(),
        OnAfterItemTransfer = GameEvent:new(),
        OnBeforeItemTransfer = GameEvent:new(),
        OnHotbarItemAttached = GameEvent:new()
    }
}

--- Automatically set GameEvent found in GameEventAPI
for eventName, event in pairs(GameEventAPI) do
    if event and event.Type == "GameEvent" then
        print("GameEventAPI: Setting event [", eventName,"]")
        GameEventAPI[eventName].Add = function(func)
            CommunityAPI.Shared.Event.Add("GameEventAPI", eventName, func)
        end
        GameEventAPI[eventName].Remove = function(func)
            CommunityAPI.Shared.Event.Remove("GameEventAPI", eventName, func)
        end
    end
end

--- All custom hooks
local hooks = {}

--- Hook into any Object Method Before and After
---@param objectName string
---@param methodName string
---@param beforeFunc function
---@param afterFunc function
function GameEventAPI.HookInto(objectName, methodName, beforeFunc, afterFunc)
    --- Find the vanilla object and method
    if type(_G[objectName]) == "table" and type(_G[objectName][methodName]) == "function" then
        local eventName = "HookInto." .. objectName .. "." .. methodName
        local eventNameBefore = eventName .. ".before"
        local eventNameAfter = eventName .. ".after"

        --- Set the overwrite only the first time
        if not hooks[eventName] then
            --- Save the original
            hooks[eventName] = {
                Original = _G[objectName][methodName]
            }

            --- Overwrite
            _G[objectName][methodName] = function(self, ...)
                CommunityAPI.Shared.Event.Trigger("GameEventAPI", eventNameBefore, self, ...)
                local result = hooks[eventName].Original(self, ...)
                CommunityAPI.Shared.Event.Trigger("GameEventAPI", eventNameAfter, self, ...)
                if result then return result; end
            end

            print("Overwrite for [", objectName,".", methodName,"] has been set!")
        end

        --- Add the before handler
        if type(beforeFunc) == "function" then
            CommunityAPI.Shared.Event.Remove("GameEventAPI", eventNameBefore, beforeFunc)
            CommunityAPI.Shared.Event.Add("GameEventAPI", eventNameBefore, beforeFunc)
        end

        --- Add the after handler
        if type(afterFunc) == "function" then
            CommunityAPI.Shared.Event.Remove("GameEventAPI", eventNameAfter, afterFunc)
            CommunityAPI.Shared.Event.Add("GameEventAPI", eventNameAfter, afterFunc)
        end
    end
end

--- START TEST

local test = false
if test then

    --- HOOK INTO TEST

    local function before_start(self) print(self); end
    local function after_start(self) print(self); end
    GameEventAPI.HookInto("ISApplyBandage", "start", before_start, after_start)

    local function before_stop(self) print(self); end
    local function after_stop(self) print(self); end
    GameEventAPI.HookInto("ISApplyBandage", "stop", before_stop, after_stop)

    local function before_perform(self) print(self); end
    local function after_perform(self) print(self); end
    GameEventAPI.HookInto("ISApplyBandage", "perform", before_perform, after_perform)

    --- TEST API EVENTS

    print("GameEventAPI Test mode enabled!")
    for eventName, event in pairs(GameEventAPI) do
        if event and event.Type == "GameEvent" then
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

--- END TESTS

return GameEventAPI
