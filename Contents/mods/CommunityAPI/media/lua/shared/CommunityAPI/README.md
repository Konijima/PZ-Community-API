# Utilities
Utility packages to use in API and Mods.
  
## How to use
```lua
require("CommunityAPI")

CommunityAPI.Utils
```
  
### CommunityAPI.Utils.Inventory
```lua
findAllItemInInventoryByTag(inventory, tag)
```
  
### CommunityAPI.Utils.Iso
```lua
recursiveGetSquare(object)

getIsoRange(center, range, fractalOffset)

getIsoGameCharactersInFractalRange(center, range, fractalRange, lookForType, addedBooleanFunctions)

getIsoGameCharactersInRange(center, range, lookForType, addedBooleanFunctions)
```
  
### CommunityAPI.Utils.Math
```lua
getDistance(x1, y1, x2, y2)
```
  
### CommunityAPI.Utils.String
```lua
squareToId(square)

positionToId(x, y ,z)

splitString(str, delimiter)
```
  
### CommunityAPI.Utils.Table
```lua
countTableEntries(targetTable)

getTableKeys(targetTable)

tableContains(table, value)

getBaseClass(object, level)

getAllBaseClasses(object, excludeCurrent)

isClassChildOf(object, class)
```
  