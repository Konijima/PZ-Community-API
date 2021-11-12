# ItemTooltipAPI
**Developer:** Konijima  
**Contributors:**  -  
**Package:** CommunityAPI.Client.ItemTooltip
  
## Description
Make complex custom item tooltip for your new items.  
Can be used to override existing vanilla item completely.  
  
___

## How to use
  
1) Create a directory `ItemTooltips` in your mod directory `media/lua/client/`.
2) Create a file per item named `<itemModule>_<itemName>.lua` inside `media/lua/client/ItemTooltips/`.
3) Use `require("ItemTooltipAPI/Main")` in the scripts that use it.
4) Adding `require=CommunityAPI` to your `mod.info` to make sure the API is enabled as well.
  
Tooltip can be reloaded via your file `ItemTooltips/<itemModule>_<itemName>.lua`

___

## API Methods

### GetRGB(numberCurrent, numberMax)
```
    numberCurrent : number : The current value
    numberMax     : number : The the maximum value
    
    return : table : { r=number, g=number, b=0 } : A color between Red and Green
```
### GetReversedRGB(numberCurrent, numberMax)
```
    numberCurrent : number : The current value
    numberMax     : number : The the maximum value
    
    return : table : { r=number, g=number, b=0 } : A color between Green and Red
```
### GetFloatString(value)
```
    value : number : The value to transform
    
    return : string : The string result
```
### CreateToolTip(itemFullType)
```
    itemFullType : string : The item full type e.g: Base.Axe
    
    return : InventoryTooltipField : The tooltip object used to add fields
```

___

## InventoryTooltipField Instance Methods

### addField(labelText, getValueFunction, _labelColor)
```
    labelText        : string   : The label text for this field
    getValueFunction : function : The function to dynamicaly set values
    _labelColor      : table    : { r=number, g=number, b=number, a=number }
```

### addProgress(labelText, value)
```
    labelText : string   : The label text for this field
    value     : number   : The number current progress value from 0.0 to 1.0
    or
    value     : function : The function to dynamicaly set values
```

### addLabel(labelText, _labelColor)
```
    labelText   : string   : The label text for this field
    or
    labelText   : function : The function to dynamicaly set values
    
    _labelColor : table    : { r=number, g=number, b=number, a=number }
```

### addExtraItems(labelText, getValueFunc, _labelColor)
```
    labelText    : string   : The label text for this field
    getValueFunc : function : The function to dynamicaly set values
    _labelColor  : table    : { r=number, g=number, b=number, a=number }
```

### addSpacer()
```
    no param
```

___

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
newTooltip:addField("New Field", myGetValueFunction)
```

___

## Example
```lua
require("CommunityAPI")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip

-- Create the new Tooltip
local baseAxeTooltip = ItemTooltipAPI.CreateToolTip("Base.Axe")

-- Add extra items
function extraItems(result, item)
    result.value = { "Base.Axe", "Base.Disc" }
end
baseAxeTooltip:addExtraItems("Contains", extraItems)

-- Add regular field
local function damageField(result, item)
    result.value = "+10"
    result.color = { r=0, g=1, b=0, a=1 }
end
baseAxeTooltip:addField("Damage", damageField)

-- Add progress field
local function durabilityProgress(result, item)
    result.value = ItemTooltipAPI.GetRGB(0.5, 1.0)
end
baseAxeTooltip:addProgress("Durability", durabilityProgress)

-- Add spacer
baseAxeTooltip:addSpacer()

-- Add a text label
local function textLabel(result, item)
    result.value = "Some text label!"
    result.labelColor = { r=0, g=0, b=1, a=1 }
end
baseAxeTooltip:addLabel(textLabel)
```
