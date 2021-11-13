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

<p>&nbsp;</p>

# Packages

## CommunityAPI.Utils.Color
<details>
<summary>Click to expand!</summary>
<p>&nbsp;</p>
  
<p>&nbsp;</p>
</details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.Inventory
<details>
<summary>Click to expand!</summary>
<p>&nbsp;</p>
  
### FindAllItemInInventoryByTag(container, tag)
Retrieve all items in a container from a tag

| Param     | Type                                                                                                   | Description                     |
|-----------|--------------------------------------------------------------------------------------------------------|---------------------------------|
| container | [ItemContainer](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/ItemContainer.html) | The item container to search in |
| tag       | string                                                                                                 | The tag to search for           |

**return:** [ArrayList](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html)<[InventoryItem](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/InventoryItem.html)>

<p>&nbsp;</p>
</details>

  
________________________________________________________________________________________________________________________

  
## CommunityAPI.Utils.Iso
<details>
<summary>Click to expand!</summary>
<p>&nbsp;</p>
  
### RecursiveGetSquare(object)
Safely get the square of an IsoObject recursively

| Param  | Type                                                                                                                                                                                         | Description                       |
|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| object | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The object to get the square from |

**return:** [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)

<p>&nbsp;</p>

### GetIsoRange(center, range, fractalOffset)
Description here

| Param         | Type                                                                                                                                                                                         | Description                                                           |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| center        | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The center point object                                               |
| range         | number                                                                                                                                                                                       | Tiles to scan from center, not including center. ex: range of 1 = 3x3 |
| fractalOffset | number                                                                                                                                                                                       | Fractal offset - spreads out squares by this number                   |

**return:** table<[IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)>

<p>&nbsp;</p>

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

<p>&nbsp;</p>

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

<p>&nbsp;</p>
</details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.Math
<details>
<summary>Click to expand!</summary>
<p>&nbsp;</p>
  
### GetDistance(x1, y1, x2, y2)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>
</details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.String
<details>
<summary>Click to expand!</summary>
<p>&nbsp;</p>
  
### SquareToId(square)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### PositionToId(x, y ,z)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### SplitString(str, delimiter)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>
</details>


________________________________________________________________________________________________________________________


## CommunityAPI.Utils.Table
<details>
<summary>Click to expand!</summary>
<p>&nbsp;</p>

### CountTableEntries(targetTable)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### GetTableKeys(targetTable)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### TableContains(table, value)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### GetBaseClass(object, level)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### GetAllBaseClasses(object, excludeCurrent)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>

### IsClassChildOf(object, class)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

<p>&nbsp;</p>
</details>
