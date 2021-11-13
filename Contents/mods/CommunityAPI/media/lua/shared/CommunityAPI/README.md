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

## CommunityAPI.Utils.Color
<details>
<summary>Click to expand!</summary>

</details>



## CommunityAPI.Utils.Inventory
<details>
<summary>Click to expand!</summary>

### FindAllItemInInventoryByTag(container, tag)
Retrieve all items in a container from a tag

| Param     | Type                                                                                                   | Description                     |
|-----------|--------------------------------------------------------------------------------------------------------|---------------------------------|
| container | [ItemContainer](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/ItemContainer.html) | The item container to search in |
| tag       | string                                                                                                 | The tag to search for           |

**return:** [ArrayList](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html)<[InventoryItem](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/InventoryItem.html)>

</details>



## CommunityAPI.Utils.Iso
<details>
<summary>Click to expand!</summary>

### RecursiveGetSquare(object)
Safely get the square of an IsoObject recursively

| Param  | Type                                                                                                                                                                                         | Description                       |
|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| object | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The object to get the square from |

**return:** [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)

---

### GetIsoRange(center, range, fractalOffset)
Description here

| Param         | Type                                                                                                                                                                                         | Description                                                           |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| center        | [IsoObject](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoObject.html) \| [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html) | The center object                                                     |
| range         | number                                                                                                                                                                                       | Tiles to scan from center, not including center. ex: range of 1 = 3x3 |
| fractalOffset | number                                                                                                                                                                                       | Fractal offset - spreads out squares by this number                   |

**return:** table<[IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)>

---

### GetIsoGameCharactersInFractalRange(center, range, fractalRange, lookForType, addedBooleanFunctions)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### GetIsoGameCharactersInRange(center, range, lookForType, addedBooleanFunctions)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

</details>



## CommunityAPI.Utils.Math
<details>
<summary>Click to expand!</summary>

### GetDistance(x1, y1, x2, y2)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

</details>



## CommunityAPI.Utils.String
<details>
<summary>Click to expand!</summary>

### SquareToId(square)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### PositionToId(x, y ,z)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### SplitString(str, delimiter)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

</details>



## CommunityAPI.Utils.Table
<details>
<summary>Click to expand!</summary>

### CountTableEntries(targetTable)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### GetTableKeys(targetTable)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### TableContains(table, value)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### GetBaseClass(object, level)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### GetAllBaseClasses(object, excludeCurrent)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

---

### IsClassChildOf(object, class)
| Param | Type | Description |
|-------|------|-------------|
|       |      |             |
|       |      |             |
|       |      |             |

**return:** nil

</details>