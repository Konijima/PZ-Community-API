# Utils

**Contributors:** Shurutsue, Konijima, Chuck, Aiteron  
**Packages:**  
- [CommunityAPI.Utils.Color](#communityapiutilscolor)  
- [CommunityAPI.Utils.Inventory](#communityapiutilsinventory)  
- [CommunityAPI.Utils.Iso](#communityapiutilsiso)  
- [CommunityAPI.Utils.Math](#communityapiutilsmath)  
- [CommunityAPI.Utils.String](#communityapiutilsstring)  
- [CommunityAPI.Utils.Table](#communityapiutilstable)  

## Description

Utility packages to use in your API and Mods.

<br>

# Packages

## CommunityAPI.Utils.Color
<details><summary>Click to expand!</summary><br>



<br></details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.Inventory
<details><summary>Click to expand!</summary><br>
  
### FindAllItemInInventoryByTag(container, tag)
Retrieve all items in a container from a tag

| Param     | Type                                                                                                   | Description                     |
|-----------|--------------------------------------------------------------------------------------------------------|---------------------------------|
| container | [ItemContainer](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/ItemContainer.html) | The item container to search in |
| tag       | string                                                                                                 | The tag to search for           |

**return:** [ArrayList](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html)<[InventoryItem](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/InventoryItem.html)>

<br></details>

  
________________________________________________________________________________________________________________________

  
## CommunityAPI.Utils.Iso
<details><summary>Click to expand!</summary><br>
  
### RecursiveGetSquare(object)
Safely get the square of an IsoObject recursively

| Param  | Type                                                                                                                                                                                         | Description                       |
|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| object | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The object to get the square from |

**return:** [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)

<br>

### GetIsoRange(center, range, fractalOffset)
Description here

| Param         | Type                                                                                                                                                                                         | Description                                                           |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| center        | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The center point object                                               |
| range         | number                                                                                                                                                                                       | Tiles to scan from center, not including center. ex: range of 1 = 3x3 |
| fractalOffset | number                                                                                                                                                                                       | Fractal offset - spreads out squares by this number                   |

**return:** table<[IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)>

<br>

### GetIsoGameCharactersInFractalRange(center, range, fractalRange, _lookForType, _addedBooleanFunctions)
Get all humanoid in fractal range from a center point

| Param                  | Type                                                                                                                                                                                         | Description                                                           |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| center                 | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The center point object                                               |
| range                  | number                                                                                                                                                                                       | Tiles to scan from center, not including center. ex: range of 1 = 3x3 |
| fractalOffset          | number                                                                                                                                                                                       | Fractal offset - spreads out squares by this number                   |
| _lookForType           | string \| nil                                                                                                                                                                                | Get only a specific type                                              |
| _addedBooleanFunctions | table \| nil                                                                                                                                                                                 | Table of function(s) must return true to pass                         |

**return:** table<[IsoGameCharacter](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/characters/IsoGameCharacter.html)>

<br>

### GetIsoGameCharactersInRange(center, range, _lookForType, _addedBooleanFunctions)
Get all humanoid in range from a center point

| Param                  | Type                                                                                                                                                                                         | Description                                                           |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| center                 | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The center point object                                               |
| range                  | number                                                                                                                                                                                       | Tiles to scan from center, not including center. ex: range of 1 = 3x3 |
| fractalOffset          | number                                                                                                                                                                                       | Fractal offset - spreads out squares by this number                   |
| _lookForType           | string \| nil                                                                                                                                                                                | Get only a specific type                                              |
| _addedBooleanFunctions | table \| nil                                                                                                                                                                                 | Table of function(s) must return true to pass                         |

**return:** table<[IsoGameCharacter](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/characters/IsoGameCharacter.html)>

<br></details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.Math
<details>
<summary>Click to expand!</summary><br>

### GetDistance2DBetweenPoints(x1, y1, x2, y2)
Get the 2D distance between two point

| Param | Type   | Description                  |
|-------|--------|------------------------------|
| x1    | number | X coordinate of first point  |
| y1    | number | Y coordinate of first point  |
| x2    | number | X coordinate of second point |
| y2    | number | Y coordinate of second point |

**return:** number

<br>

### GetDistance2DBetweenSquares(square1, square2)
Get the 2D distance between two squares

| Param   | Type                                                                                             | Description       |
|---------|--------------------------------------------------------------------------------------------------|-------------------|
| square1 | [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The first square  |
| square2 | [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The second square |

**return:** number

<br></details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.String
<details><summary>Click to expand!</summary><br>
  
### SquareToId(square)
Transform a square position into a unique string

| Param  | Type                                                                                             | Description                         |
|--------|--------------------------------------------------------------------------------------------------|-------------------------------------|
| square | [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The square to get the position from |

**return:** string

<br>

### PositionToId(x, y ,z)
Transform a position into a unique string

| Param | Type   | Description |
|-------|--------|-------------|
| x     | number | X position  |
| y     | number | Y position  |
| z     | number | Z position  |

**return:** string

<br>

### SplitString(str, delimiter)
Split a string by a delimiter string

| Param     | Type   | Description              |
|-----------|--------|--------------------------|
| str       | string | The string to split      |
| delimiter | string | The string to split with |

**return:** table<string>

<br>

### NumberToDecimalString(value, _decimal)
Format a number into string with decimal

| Param    | Type        | Description                   |
|----------|-------------|-------------------------------|
| value    | number      | The number value to format    |
| _decimal | number\|nil | Amount of decimal, default: 2 |

**return:** string

<br></details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.Table
<details><summary>Click to expand!</summary><br>

### CountTableEntries(targetTable)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<br>

### GetTableKeys(targetTable)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<br>

### TableContains(table, value)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<br>

### GetBaseClass(object, level)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<br>

### GetAllBaseClasses(object, excludeCurrent)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<br>

### IsClassChildOf(object, class)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<br></details>
