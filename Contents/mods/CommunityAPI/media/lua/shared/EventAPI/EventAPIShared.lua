local DEBUG = getCore():getDebug()

local events = {}

local EventAPI = {}

---@param modName string
---@param eventName string
---@param eventFunc string
function EventAPI.Add(modName, eventName, eventFunc)
    if not events[modName] then events[modName] = {} end
    if not events[modName][eventName] then events[modName][eventName] = ArrayList.new() end
    if not events[modName][eventName]:contains(eventFunc) then
        events[modName][eventName]:add(eventFunc)
        if DEBUG then print("CommunityAPI: Event [", eventName,"] added in mod [", modName, "]") end
    end
end

---@param modName string
---@param eventName string
---@param eventFunc string
function EventAPI.Remove(modName, eventName, eventFunc)
    if events[modName] and events[modName][eventName] and events[modName][eventName]:contains(eventFunc) then
        events[modName][eventName]:remove(eventFunc)
        if DEBUG then print("CommunityAPI: Event [", eventName,"] removed from mod [", modName, "]") end
    end
end

---@param modName string
---@param eventName string
---@vararg any
function EventAPI.Trigger(modName, eventName, ...)
    if events[modName] and events[modName][eventName] then
        for i=0, events[modName][eventName]:size()-1 do
            local handler = events[modName][eventName]:get(i)
            if not pcall(handler, ...) then
                if DEBUG then print("CommunityAPI: Error in triggering Event [", eventName,"] from mod [", modName, "]") end
                EventAPI.Remove(modName, eventName, handler)
            else
                if DEBUG then print("CommunityAPI: Event [", eventName,"] triggered from mod [", modName, "]") end
            end
        end
    end
end

return EventAPI