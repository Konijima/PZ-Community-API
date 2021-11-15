# LightAPI
**Developer:** Konijima  
**Contributors:** -  
**Package:** CommunityAPI.Client.Light

## Description
Add Lights at specific position categorized by unique name.  
The API take care of disposing and recreating the light source if the square is unloaded and reloaded later.  

## Methods

### AddLightAt(name, x, y, z, radius, color)
```
    name : string : the name assigned to this light
    x : number : the x position
    y : number : the y position
    z : number : the z position
    radius : number : the radius must be minimum of 1
    color : table : { r=1, g=1, b=1, a=1 }
```
### SetLightColorAt(name, x, y, z, newColor)
```
    name : string : the name assigned to this light
    x : number : the x position
    y : number : the y position
    z : number : the z position
    newColor : table : { r=1, g=1, b=1, a=1 }
```
### SetLightRadiusAt(name, x, y, z, newRadius)
```
    name : string : the name assigned to this light
    x : number : the x position
    y : number : the y position
    z : number : the z position
    newRadius : number : the radius must be minimum of 1
```
### RemoveLightAt(name, x, y, z)
```
    name : string : the name assigned to this light
    x : number : the x position
    y : number : the y position
    z : number : the z position
```

## Usage
```lua
require("CommunityAPI")

local LightAPI = CommunityAPI.Client.Light

LightAPI.AddLightAt("computer_screen", x, y, z, 1, { r=0.20, g=0.30, b=0.20 })
LightAPI.SetLightColorAt("computer_screen", x, y, z, { r=1, g=1, b=1 })
LightAPI.SetLightRadiusAt("computer_screen", x, y, z, 3)
LightAPI.RemoveLightAt("computer_screen", x, y, z)
```

## Example
```lua
require("CommunityAPI")

local LightAPI = CommunityAPI.Client.Light

local obj = {
    name = "Computer",
    state = false,
    position = { x=10000, y=2000, z=0 },
}

function obj:toggle()
    if self.state then
        self.state = false
        LightAPI.RemoveLightAt(self.name, self.position.x, self.position.y, self.position.z)
    else
        self.state = true
        LightAPI.AddLightAt(self.name, self.position.x, self.position.y, self.position.z, 1, { r=0.20, g=0.30, b=0.20 })
    end
end

obj:toggle()
```