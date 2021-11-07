require("CommunityAPI")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip

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

local ItemTooltip = ItemTooltipAPI.CreateToolTip("Base.Example")

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