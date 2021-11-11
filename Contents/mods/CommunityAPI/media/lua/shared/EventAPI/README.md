# EventAPI
**Developer:** Konijima  
**Contributors:**  -  
**Package:** CommunityAPI.Shared.Event  

## Description
Add, remove and trigger custom events for your API and Mods.

## Methods

### `Add(modName, eventName, eventFunc)`
```
    - modName : string : the mod name
    - eventName : string : the event name
    - eventFunc : function : the function to add
```
___

### `Remove(modName, eventName, eventFunc)`
```
    - modName : string : the mod name
    - eventName : string : the event name
    - eventFunc : function : the function to remove
```

___

### `Trigger(modName, eventName, ...)`
```
    - modName : string : the mod name
    - eventName : string : the event name
    - ... : any : one or multiple parameter of any types
```

## Example of usage in an API
```lua
require("CommunityAPI")

local EventAPI = CommunityAPI.Shared.Event

local MyApi = {
    Events = {
        OnPlayerDead = {},
    }
}

function MyApi.Events.OnPlayerDead.Add(func)
    EventAPI.Add("MyApi", "OnPlayerDead", func)
end

function MyApi.Events.OnPlayerDead.Remove(func)
    EventAPI.Remove("MyApi", "OnPlayerDead", func)
end

-- This doesn't have to be exposed if unwanted
function MyApi.Events.OnPlayerDead.Trigger(playerObj)
    EventAPI.Trigger("MyApi", "OnPlayerDead", playerObj)
end

return MyApi
```

## Example of usage in a Mod
```lua
require("CommunityAPI")

local EventAPI = CommunityAPI.Shared.Event

local function onComputerBooting(param1, param2, param3)
    print("Computer booting! Params:", param1, param2, param3)
end

EventAPI.Add("ComputerMod", "OnComputerBooting", onComputerBooting)
EventAPI.Trigger("ComputerMod", "OnComputerBooting", "arg1", "arg2", "arg3")
EventAPI.Remove("ComputerMod", "OnComputerBooting", onComputerBooting)
```