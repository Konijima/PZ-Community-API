# Utilities

## Description
Class containing various Utilities to use in API and Mods.

## How to use
```lua
require("CommunityAPI")

CommunityAPI.Utilities.<method>
```

## Methods
```lua
--- Transform a square position into a unique string
---@param square IsoGridSquare
---@return string
squareToId(square)
```
```lua
--- Transform a position into a unique string
---@param x number
---@param y number
---@param z number
---@return string
positionToId(x, y ,z)
```
```lua
--- Split a string by a delimiter string
---@param str string the string to split
---@param delimiter string the string to split with
---@return table<string>
splitString(str, delimiter)
```
```lua
--- Get the distance between two point
---@param x1 number X coordinate of first point
---@param y1 number y coordinate of first point
---@param x2 number X coordinate of second point
---@param y2 number y coordinate of second point
getDistance(x1, y1, x2, y2)
```
```lua
--- Get the total count of entry in a table
---@param targetTable table The table to get count from
countTableEntries(targetTable)
```
```lua
--- Get all the keys of a lua table
---@param targetTable table The table to get keys from
getTableKeys(targetTable)
```
```lua
--- Check if a value is found in a table
---@param table table The table to search in
---@param value any The value to find
---@return boolean
tableContains(table, value)
```
```lua
--- Find all item in an inventory by tag
---@param inventory ItemContainer
---@param tag string
---@return ArrayList|nil
findAllItemInInventoryByTag(inventory, tag)
```
```lua
--- Get the base class of object, optionally choose how deep you want to check.
---@param object table Will return nil if the object is not a table.
---@param level  number Will return the deepest found if level is higher than the actual amount of base classes.
getBaseClass(object, level)
```
```lua
--- Get a table containing all the base class from the current to the deepest.
---@param object table Will return nil if the object is not a table.
---@param excludeCurrent boolean optionally exclude the current object class from the list
---@return table|nil
getAllBaseClasses(object, excludeCurrent)
```
```lua
--- Check if table object derive from this class
---@param object table The table object to check
---@param class table|string The class to find
---@return boolean
isClassChildOf(object, class)
```
