# Utilities
Utility packages to use in API and Mods.
  
## How to use
```lua
require("CommunityAPI")

local StringUtils = CommunityAPI.Utils.String
StringUtils.SplitString("Hello world", " ")
```
  
### CommunityAPI.Utils.Inventory
```lua
FindAllItemInInventoryByTag(inventory, tag)
```
  
### CommunityAPI.Utils.Iso
```lua
RecursiveGetSquare(object)

GetIsoRange(center, range, fractalOffset)

GetIsoGameCharactersInFractalRange(center, range, fractalRange, lookForType, addedBooleanFunctions)

GetIsoGameCharactersInRange(center, range, lookForType, addedBooleanFunctions)
```
  
### CommunityAPI.Utils.Math
```lua
GetDistance(x1, y1, x2, y2)
```
  
### CommunityAPI.Utils.String
```lua
SquareToId(square)

PositionToId(x, y ,z)

SplitString(str, delimiter)
```
  
### CommunityAPI.Utils.Table
```lua
CountTableEntries(targetTable)

GetTableKeys(targetTable)

TableContains(table, value)

GetBaseClass(object, level)

GetAllBaseClasses(object, excludeCurrent)

IsClassChildOf(object, class)
```
  