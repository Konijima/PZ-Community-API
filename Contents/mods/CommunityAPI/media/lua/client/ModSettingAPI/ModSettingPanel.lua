local ModSetting = require("ModSettingAPI/ModSetting")
local ModSettingHorizontalLine = require("ModSettingAPI/ModSettingHorizontalLine")
local ModSetKeyBindDialog = require("ModSettingAPI/ModSetKeyBindDialog")
local ModSettingValueType = require("ModSettingAPI/ModSettingValueType")

-- Constants
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

---@class ModSettingPanel
local ModSettingPanel = ISPanelJoypad:derive("ModSettingPanel");

---@param settingName string
---@param settingCategoryName string|nil
---@param settingLabelName string
---@param settingValueType ModSettingValueType
---@param settingDefaultValue string|number|table.RGB|bool|Keyboard.Key_    --- Depends on settingValueType
---@param settingData table.Options --- Table with (string)options for ModSettingValueType.ComboBox
function ModSettingPanel:addSetting(settingName, settingCategoryName, settingLabelName, settingValueType, settingDefaultValue, settingData)
    if settingName == nil or settingLabelName == nil or settingValueType == nil then return end

    if settingCategoryName == nil then
        settingCategoryName = "NILCAT"
    end

    self.settings[settingName] = { labelName = settingLabelName, valueType = settingValueType, categoryName = settingCategoryName, value = settingDefaultValue , data = settingData }

    if ModSetting.SettingValues[self.modID] == nil then
        ModSetting.SettingValues[self.modID] = {}
    end

    if ModSetting.SettingValues[self.modID][settingName] == nil then
        ModSetting.SettingValues[self.modID][settingName] = settingDefaultValue
    else
        self.settings[settingName].value = ModSetting.SettingValues[self.modID][settingName]
    end
end

--- ISPanelJoypad functions ---
function ModSettingPanel:new(modID, tabName)
    local o = {}
	o = ISPanelJoypad:new(0, 0, 100, 100);
	setmetatable(o, self)
	self.__index = self

	o.x = 0
    o.y = 0
	o.backgroundColor = {r=0, g=0, b=0, a=0.5};
	o.borderColor = {r=0.6, g=0.6, b=0.6, a=0.9};
	o.width = 100;
	o.height = 100;
	o.anchorLeft = true;
	o.anchorRight = true;
	o.anchorTop = true;
	o.anchorBottom = true;
    ---
    o.modID = modID
    o.tabName = tabName
    o.settings = {}
    o.settingsData = {}

    return o
end


function ModSettingPanel:initialise()
	ISPanelJoypad.initialise(self);
end

function ModSettingPanel:createChildren()
    ISPanelJoypad.createChildren(self);

    if ModSetting.SettingValues[self.modID] ~= nil then
        for settName, value in pairs(ModSetting.SettingValues[self.modID]) do
            if self.settings[settName] ~= nil then
                self.settings[settName].value = value   
            end
        end
    end

    local settingsByCategory = {}
    for setName, data in pairs(self.settings) do
        if settingsByCategory[data.categoryName] == nil then
            settingsByCategory[data.categoryName] = {}
        end
        table.insert(settingsByCategory[data.categoryName], { settingName = setName, labelName = data.labelName, valueType = data.valueType, value = data.value , data = data.data })
    end

    local y = 16
    local x = 400
    for catName, data in pairs(settingsByCategory) do
        if catName ~= "NILCAT" then
            y = self:addCategory(y, catName)    
        end
        for _, settingData in ipairs(data) do
            if settingData.valueType == ModSettingValueType.CheckBox then
                local label = ISLabel:new(x, y + 3, FONT_HGT_SMALL, settingData.labelName, 1, 1, 1, 1, UIFont.Small, false)
                label:initialise()
                self:addChild(label)

                local tickBox = ISTickBox:new(x + 20, y, 20, FONT_HGT_SMALL + 4, "", nil, nil)
                tickBox:initialise()
                self:addChild(tickBox)
                tickBox:addOption("")
                tickBox:setWidthToFit()

                if settingData.value then
                    tickBox:setSelected(1, true)
                end

                self.settingsData[settingData.settingName] = { ModSettingValueType.CheckBox , tickBox }
                y = y + FONT_HGT_SMALL + 4 + 10
            end
            if settingData.valueType == ModSettingValueType.ComboBox then
                local label = ISLabel:new(x, y + 3, FONT_HGT_SMALL, settingData.labelName, 1, 1, 1, 1, UIFont.Small, false)
                label:initialise()
                self:addChild(label)

                local comboBox = ISComboBox:new(x + 20, y, 300, FONT_HGT_SMALL + 3 * 2);
                comboBox:initialise();

                for i, k in ipairs(settingData.data) do
                    comboBox:addOption(k);
                end

                comboBox.selected = settingData.value;
                self:addChild(comboBox);
                
                self.settingsData[settingData.settingName] = { ModSettingValueType.ComboBox , comboBox }
                y = y + FONT_HGT_SMALL + 4 + 10
            end
            if settingData.valueType == ModSettingValueType.ColorPicker then
                local colorPicker = ISColorPicker:new(0, 16)
                colorPicker:initialise()
                colorPicker.resetFocusTo = self
                colorPicker:setInitialColor(ColorInfo.new(settingData.value.r, settingData.value.g, settingData.value.b, 1.0));
                
                local colorButton = ISButton:new(x + 20, y + (math.max(FONT_HGT_SMALL, 15 + 4) - 15) / 2, 15, 15,"", self);
                colorButton:setOnClick(function()
                    colorPicker:setX(0)
                    colorPicker:setY(16)
                    colorPicker.pickedFunc = function(_, color)
                        colorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
                    end
                    local color = colorButton.backgroundColor
                    local colorInfo = ColorInfo.new(color.r, color.g, color.b, 1)
                    colorPicker:setInitialColor(colorInfo);
                    self:addChild(colorPicker)
                    colorPicker:setVisible(true);
                    colorPicker:bringToTop();
                end)
                colorButton:initialise();
                colorButton.backgroundColor = {r = settingData.value.r, g = settingData.value.g, b = settingData.value.b, a = 1};
                self:addChild(colorButton);

                local label = ISLabel:new(x, y + 3, FONT_HGT_SMALL, settingData.labelName, 1, 1, 1, 1, UIFont.Small, false)
                label:initialise()
                self:addChild(label)

                self.settingsData[settingData.settingName] = { ModSettingValueType.ColorPicker , colorButton }
                y = y + FONT_HGT_SMALL + 4 + 10
            end
            if settingData.valueType == ModSettingValueType.VolumeControl then
                local label = ISLabel:new(x, y + 3, FONT_HGT_SMALL, settingData.labelName, 1, 1, 1, 1, UIFont.Small, false)
                label:initialise()
                self:addChild(label)
                
                local volumeControl = ISVolumeControl:new(x + 20, y, 300, 20);
                volumeControl:initialise();
                volumeControl:setVolume(settingData.value)
                self:addChild(volumeControl)

                self.settingsData[settingData.settingName] = { ModSettingValueType.VolumeControl, volumeControl }
                y = y + FONT_HGT_SMALL + 4 + 10
            end
            if settingData.valueType == ModSettingValueType.EntryBox then
                local label = ISLabel:new(x, y + 3, FONT_HGT_SMALL, settingData.labelName, 1, 1, 1, 1, UIFont.Small, false)
                label:initialise()
                self:addChild(label)

                local entry = ISTextEntryBox:new(settingData.value, x + 20, y, 300, FONT_HGT_SMALL + 3 * 2)
                entry.font = UIFont.Small
                entry:setAnchorRight(true)
                self:addChild(entry)
                entry:setEditable(true)
                entry:setSelectable(true)
 

                self.settingsData[settingData.settingName] = { ModSettingValueType.EntryBox, entry }
                y = y + FONT_HGT_SMALL + 4 + 10
            end
            if settingData.valueType == ModSettingValueType.KeyBind then
                local label = ISLabel:new(x, y + 3, FONT_HGT_SMALL, settingData.labelName, 1, 1, 1, 1, UIFont.Small, false)
                label:initialise()
                self:addChild(label)

                local btn = ISButton:new(x + 20, y, 100, FONT_HGT_SMALL + 2, getKeyName(tonumber(settingData.value)), self)
                btn:setOnClick(function(_, button)
                    local keybindName = button.internal

                    local modal = ModSetKeyBindDialog:new(keybindName)
                    modal:initialise()
                    modal:instantiate()
                    modal:setCapture(true)
                    modal:setAlwaysOnTop(true)
                    modal.onAccept = function(key)
                        btn.key = key
                        btn:setTitle(getKeyName(tonumber(key)))
                    end
                    modal:addToUIManager()
                    GameKeyboard.setDoLuaKeyPressed(false)
                end)
                btn.internal = settingData.labelName
                btn:initialise();
                btn:instantiate();
                self:addChild(btn);

                self.settingsData[settingData.settingName] = { ModSettingValueType.KeyBind, btn }
                y = y + FONT_HGT_SMALL + 4 + 10
            end
        end
    end
    self:setScrollHeight(y + 20)
end

function ModSettingPanel:addCategory(y, catName)
    y = y + 15;

    local sbarWidth = 13
    local hLine = ModSettingHorizontalLine:new(50, y - 8, self.width - 50 * 2 - sbarWidth)
    hLine.anchorRight = true
    self:addChild(hLine)

    local label = ISLabel:new(100, y, FONT_HGT_MEDIUM, catName, 1, 1, 1, 1, UIFont.Medium)
    label:setX(70);
    label:initialise();
    label:setAnchorRight(true);
    self:addChild(label);

    return y + FONT_HGT_MEDIUM + 10;
end


function ModSettingPanel:onClick(button)
end

function ModSettingPanel:instantiate()
    ISPanelJoypad.instantiate(self);

    self:setScrollChildren(true)
    self:addScrollBars();
end

function ModSettingPanel:prerender()
    self:setStencilRect(0,0,self:getWidth(),self:getHeight());
    ISPanelJoypad.prerender(self);
end

function ModSettingPanel:render()
    ISPanelJoypad.render(self);
    self:clearStencilRect();
end

function ModSettingPanel:getSettingValues()
    local valueTable = {}
    for settName, data in pairs(self.settingsData) do
        if data[1] == ModSettingValueType.CheckBox then
            valueTable[settName] = data[2]:isSelected(1)
        end
        if data[1] == ModSettingValueType.ComboBox then
            valueTable[settName] = data[2].selected
        end
        if data[1] == ModSettingValueType.ColorPicker then
            valueTable[settName] = data[2].backgroundColor
        end
        if data[1] == ModSettingValueType.VolumeControl then
            valueTable[settName] = data[2]:getVolume()
        end
        if data[1] == ModSettingValueType.EntryBox then
            valueTable[settName] = data[2]:getInternalText() or ""
        end
        if data[1] == ModSettingValueType.KeyBind then
            valueTable[settName] = data[2].key
        end
    end
    return valueTable
end

return ModSettingPanel