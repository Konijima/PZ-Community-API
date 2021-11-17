local DEBUG = getCore():getDebug()

local EventAPI = {}

-- Store the added handlers
local handlers = {}

---@param modName string
---@param eventName string
---@param eventFunc string
function EventAPI.Add(modName, eventName, eventFunc)
    local wrapFunc = function(...)
        if not pcall(eventFunc, ...) then
            if DEBUG then print("CommunityAPI: Error in triggered Event [", eventName,"] from mod [", modName, "]") end
            EventAPI.Remove(modName, eventName, eventFunc)
        end
    end
    handlers[eventFunc] = wrapFunc
    LuaEventManager.AddEvent(modName .. "|" .. eventName)
    Events[modName .. "|" .. eventName].Add(wrapFunc)

    if DEBUG then print("CommunityAPI: Event [", eventName,"] added in mod [", modName, "]") end
end

---@param modName string
---@param eventName string
---@param eventFunc string
function EventAPI.Remove(modName, eventName, eventFunc)
    if handlers[eventFunc] then
        Events[modName .. "|" .. eventName].Remove(handlers[eventFunc])
        handlers[eventFunc] = nil
        if DEBUG then print("CommunityAPI: Event [", eventName,"] removed from mod [", modName, "]") end
    end
end

---@param modName string
---@param eventName string
---@vararg any
function EventAPI.Trigger(modName, eventName, ...)
    LuaEventManager.triggerEvent(modName .. "|" .. eventName, ...)
    if DEBUG then print("CommunityAPI: Event [", eventName,"] triggered from mod [", modName, "]") end
end

return EventAPI
