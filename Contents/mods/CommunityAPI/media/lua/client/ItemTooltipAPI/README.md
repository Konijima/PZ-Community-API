# ItemTooltipAPI
**Developer:** Konijima  
**Contributors:**  -  
**Package:** CommunityAPI.Client.ItemTooltip

<br>

## Description
Make complex custom item tooltip for your new items.  
Can be used to override existing vanilla item completely.  
  
<br>

## How to use
  
1) Create a directory `ItemTooltips` in your mod directory `media/lua/client/`.
2) Create a file per item named `<itemModule>_<itemName>.lua` inside `media/lua/client/ItemTooltips/`.
3) Use `require("ItemTooltipAPI/Main")` in the scripts that use it.
4) Adding `require=CommunityAPI` to your `mod.info` to make sure the API is enabled as well.
  
Tooltip can be reloaded via your file `ItemTooltips/<itemModule>_<itemName>.lua`

<br>

# Methods

### CreateToolTip(itemFullType)
Create a new Tooltip for a specific Item

| Param        | Type   | Description                                    |
|--------------|--------|------------------------------------------------|
| itemFullType | string | Item to create the tooltip for e.g: "Base.Axe" |

**return:** InventoryTooltipField

<br>

# InventoryTooltipField Methods

### addField(name, getValueFunc, _labelColor)
Add a text field

| Param        | Type                                                                              | Description                                      |
|--------------|-----------------------------------------------------------------------------------|--------------------------------------------------|
| name         | string                                                                            | The field name to appear on the left             |
| getValueFunc | string\|number\|boolean\|function                                                 | Set the field value directly or using a function |
| _labelColor  | [Color](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/core/Color.html) | Optionally set the label color                   |

**return:** nil

<br>

### addLabel(getValueFunc, _labelColor)
Add a label

| Param        | Type                                                                              | Description                                           |
|--------------|-----------------------------------------------------------------------------------|-------------------------------------------------------|
| getValueFunc | string\|function                                                                  | Set the label text value directly or using a function |
| _labelColor  | [Color](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/core/Color.html) | Optionally set the label color                        |

**return:** nil

<br>

### addProgress(name, getValueFunc)
Add a progress bar

| Param        | Type                                                                              | Description                                             |
|--------------|-----------------------------------------------------------------------------------|---------------------------------------------------------|
| name         | string                                                                            | The field name to appear on the left                    |
| getValueFunc | number\|function                                                                  | Set the progress bar value directly or using a function |
| _labelColor  | [Color](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/core/Color.html) | Optionally set the label color                          |

**return:** nil

<br>

### addExtraItems(name, getValueFunc, _labelColor)
Add extra item icons

| Param        | Type                                                                              | Description                          |
|--------------|-----------------------------------------------------------------------------------|--------------------------------------|
| name         | string                                                                            | The field name to appear on the left |
| getValueFunc | function                                                                          | Set the extra items using a function |
| _labelColor  | [Color](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/core/Color.html) | Optionally set the label color       |

**return:** nil

<br>

### addSpacer()
No parameter  
**return:** nil

<br>

## Example of `getValueFunction`
Set the result of this field with the function that your define.  
```lua
---@param result table
---@param item InventoryItem
local function myGetValueFunction(result, item)
    local itemModData = item:getModData()
    result.value = itemModData.currentValue or 0 -- Set the value
    result.color = { r=1.0, g=1.0, b=1.0, a=1.0 } -- Set the value color
    result.labelColor = { r=1.0, g=1.0, b=1.0, a=1.0 } -- Set the label color
end
newTooltip:addField("New Field Label", myGetValueFunction)
```

<br>

## Example of Item Tooltip
```lua
require("CommunityAPI")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip

-- Create the new Tooltip
local baseAxeTooltip = ItemTooltipAPI.CreateToolTip("Base.Axe")

-- Add extra items
function getExtraItemsFunc(result, item)
    result.value = { "Base.Axe", "Base.Disc" }
end
baseAxeTooltip:addExtraItems("Contains", getExtraItemsFunc)

-- Add regular field
local function getDamageFieldFunc(result, item)
    result.value = "+10"
    result.color = { r=0, g=1, b=0, a=1 }
end
baseAxeTooltip:addField("Damage", getDamageFieldFunc)

-- Add progress field
local function getDurabilityProgressFunc(result, item)
    result.value = ItemTooltipAPI.GetRGB(0.5, 1.0)
end
baseAxeTooltip:addProgress("Durability", getDurabilityProgressFunc)

-- Add spacer
baseAxeTooltip:addSpacer()

-- Add a text label
local function getTextLabelFunc(result, item)
    result.value = "Some text label!"
    result.labelColor = { r=0, g=0, b=1, a=1 }
end
baseAxeTooltip:addLabel(getTextLabelFunc)
```
