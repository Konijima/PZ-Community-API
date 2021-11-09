# LightAPI
**Developer:** Konijima  
**Contributors:**  -

## Description
Easily add Lights at specific position categorized by unique name.  
The API take care of disposing and recreating the light source if the square is unloaded and reloaded later.  

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

## Example
```lua
require("CommunityAPI")

local LightAPI = CommunityAPI.Client.Light

LightAPI.AddLightAt("computer_screen", position.x, position.y, position.z, 2, { r=0.20, g=0.30, b=0.20 })
LightAPI.SetLightColorAt("computer_screen", position.x, position.y, position.z, { r=0.20, g=0.30, b=0.20 })
LightAPI.SetLightRadiusAt("computer_screen", position.x, position.y, position.z, 2)
LightAPI.RemoveLightAt("computer_screen", position.x, position.y, position.z)
```
