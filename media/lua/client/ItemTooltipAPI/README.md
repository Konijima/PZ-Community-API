# ItemTooltipAPI
**Developer:** Konijima  
**Contributors:**  -  
  
## Description
Make complex custom item tooltip for your new items.  
Can be used to override existing vanilla item completely.  
  
## How to use
  
1) Create a directory `ItemTooltips` in your mod directory `media/lua/client`.
2) Create a file per item named `<itemModule>_<itemName>.lua` inside `ItemTooltips` directory.
3) Use `require("ItemTooltipAPI/Main")` in the scripts that use it.
4) Adding `require=CommunityAPI` to your `mod.info` to make sure the API is enabled as well.
  
Tooltip can be reloaded via your file `ItemTooltips/<itemModule>_<itemName>.lua`
  
**Methods**
```lua
--- ItemTooltipAPI

ItemTooltipAPI.GetRGB(numberCurrent, numberMax) -- Get a color from Red to Green
ItemTooltipAPI.GetReversedRGB(numberCurrent, numberMax) -- Get a color from Green to Red
ItemTooltipAPI.GetFloatString(number) -- Return a decimal number as a string
local newTooltip = ItemTooltipAPI.CreateToolTip(itemFullType) -- Returns a tooltip instance

--- Tooltip Instance

-- addField
newTooltip:addField(labelText, getValueFunction) -- Dynamic field value
newTooltip:addField(labelText, valueText, labelColor) -- Fixed field value

-- addProgress
newTooltip:addProgress(labelText, getValueFunction) -- Dynamic progress bar value
newTooltip:addProgress(labelText, numberValue) -- Fixed progress bar value

-- addLabel
newTooltip:addLabel(labelText) -- Fixed label text
newTooltip:addLabel(getValueFunction) -- Dynamic label text
newTooltip:addLabel(labelText, labelColor) -- Fixed label text with fixed label color

-- addSpacer
newTooltip:addSpacer() -- Add some space in between lines
```

**Get Value Function**
```lua
local function myGetValueFunction(result, item)
  result.value = 1 -- Set the value
  result.color = { r=1.0, g=1.0, b=1.0, a=1.0 } -- Set the value color
  result.labelColor = { r=1.0, g=1.0, b=1.0, a=1.0 } -- Set the label color
  item:getModData() -- Use the InventoryItem to check data 
  if instanceof(item, "HandWeapon") then end -- Verify if its the right item type
end
```

**Color Format**
```lua
local color = { r=1.0, g=1.0, b=1.0, a=1.0 }
```

**Example**
```lua
require("ItemTooltipAPI/Main")

local function typeField(result, item)
    result.value = item:getType()
end

local function dynamicField(result, item)
    local usedDelta = item:getUsedDelta()
    result.value = ItemTooltipAPI.GetFloatString(usedDelta)
    result.color = ItemTooltipAPI.GetRGB(usedDelta, 1)
end

local function conditionProgress(result, item)
    result.value = 0.33
    result.color = ItemTooltipAPI.GetRGB(result.value, 1)
end

local function capacityProgress(result, item)
    result.value = 0.85
    result.color = ItemTooltipAPI.GetReversedRGB(result.value, 1)
end

local function customColorProgress(result, item)
    result.value = 0.75
    result.color = { r=0, g=0, b=0.6, a=0.8 }
end

local function dynamicLabel(result, item)
    result.value = "This is a very long dynamic label that can change\ndepending of the items state or what ever you need!"
    result.labelColor = { r=1, g=0, b=0.5, a=1 }
end

-- Create the new Tooltip

local ItemTooltip = ItemTooltipAPI.CreateToolTip("Base.Axe")

-- Add the field, progress, label or spacer

ItemTooltip:addField("Type field", typeField)
ItemTooltip:addField("Dynamic field", dynamicField)
ItemTooltip:addField("Fixed Text field", "Some text", { r=0, g=1, b=0, a=1 }) -- Fixed label with custom label color
ItemTooltip:addProgress("Progress", conditionProgress)
ItemTooltip:addProgress("Reversed Progress", capacityProgress)
ItemTooltip:addProgress("Fixed Progress", 0.5)
ItemTooltip:addProgress("Custom Color Progress", customColorProgress)
ItemTooltip:addSpacer()
ItemTooltip:addLabel("This is some label between spacers!", { r=1, g=0, b=0, a=1 }) -- Fixed label with custom color
ItemTooltip:addSpacer()
ItemTooltip:addLabel(dynamicLabel) -- Dynamic label
ItemTooltip:addSpacer()
```
