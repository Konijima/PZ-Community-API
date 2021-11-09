# WorldSoundAPI
**Developer:** Konijima  
**Contributors:**  -

## Description
Easily add Sounds at specific position categorized by unique name.

## How to use
```lua
require("CommunityAPI")

local worldSoundAPI = CommunityAPI.Client.WorldSound

worldSoundAPI.AddSoundAt("computer_ambiant", x, y, z, {"ComputerBoot", "ComputerHum"})
worldSoundAPI.AddSoundAt("computer_ambiant", x, y, z, "ComputerShutdown")
worldSoundAPI.RemoveSoundAt("computer_ambiant", x, y, z)
worldSoundAPI.RemoveAllSoundAt(x, y, z)
```

## Methods
```lua
AddSoundAt(name, x, y, z, soundList)
--- soundList can be a string or a list of string to chain multiple sounds
```

```lua
RemoveSoundAt(name, x, y, z)
```

```lua
RemoveAllSoundAt(x, y, z)
```