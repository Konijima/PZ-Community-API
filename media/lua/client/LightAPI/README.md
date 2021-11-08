# LightAPI
**Developer:** Konijima  
**Contributors:**  -

## Description
Easily add Lights at specific position categorized by unique name.  
The API take care of disposing and recreating the light source if the square is unloaded and reloaded later.  

## How to use
```lua
require("CommunityAPI")

local lightAPI = CommunityAPI.Client.Light

lightAPI.AddLightAt("computer_screen", position.x, position.y, position.z, 2, { r=0.20, g=0.30, b=0.20 })
lightAPI.SetLightColorAt("computer_screen", position.x, position.y, position.z, { r=0.20, g=0.30, b=0.20 })
lightAPI.SetLightRadiusAt("computer_screen", position.x, position.y, position.z, 2)
lightAPI.RemoveLightAt("computer_screen", position.x, position.y, position.z)
```

## Methods

```lua
AddLightAt(name, x, y, z, radius, color)
```

```lua
SetLightColorAt(name, x, y, z, newColor)
```

```lua
SetLightRadiusAt(name, x, y, z, newRadius)
```

```lua
RemoveLightAt(name, x, y, z)
```
