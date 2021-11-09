# WorldSoundAPI
**Developer:** Konijima  
**Contributors:**  -

## Description
Easily add Sounds at specific position categorized by unique name.

## Methods
*soundList parameter can be a string or a list of string to chain multiple sounds.*
```lua
AddSoundAt(name, x, y, z, soundList)
```
```lua
RemoveSoundAt(name, x, y, z)
```
```lua
RemoveAllSoundAt(x, y, z)
```

## Example
```lua
require("CommunityAPI")

local WorldSoundAPI = CommunityAPI.Client.WorldSound

WorldSoundAPI.AddSoundAt("computer_ambiant", x, y, z, {"ComputerBoot", "ComputerHum"})
WorldSoundAPI.AddSoundAt("computer_ambiant", x, y, z, "ComputerShutdown")
WorldSoundAPI.RemoveSoundAt("computer_ambiant", x, y, z)
WorldSoundAPI.RemoveAllSoundAt(x, y, z)
```
