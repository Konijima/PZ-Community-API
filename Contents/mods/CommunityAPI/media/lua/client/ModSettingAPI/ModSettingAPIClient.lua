require("ModSettingAPI/ModSetting")
require("ModSettingAPI/ModSettingTab")

---@class ModSettingAPI
ModSettingAPI = {}
ModSettingAPI.ValueType = {}
ModSettingAPI.ValueType.CheckBox = "CHECKBOX"
ModSettingAPI.ValueType.ComboBox = "COMBOBOX"
ModSettingAPI.ValueType.ColorPicker = "COLORPICKER"
ModSettingAPI.ValueType.VolumeControl = "VOLUMECONTROL"
ModSettingAPI.ValueType.EntryBox = "ENTRYBOX"
ModSettingAPI.ValueType.KeyBind = "KEYBIND"

---@param modID string
---@param tabName string
function ModSettingAPI:createTab(modID, tabName)
    local tab = ModSettingTab:new(modID, tabName)

    if ModSetting.Data[modID] == nil then
        ModSetting.Data[modID] = {}
    end
    ModSetting.Data[modID][tabName] = tab

    return tab
end

---@param modID string
---@param tabName string
function ModSettingAPI:getTab(modID, tabName)
    if ModSetting.Data[modID] == nil then return end
    return ModSetting.Data[modID][tabName]
end

---@param modID string
---@param settingName string
function ModSettingAPI:getSettingValue(modID, settingName)
    return ModSetting.SettingValues[modID][settingName]
end

---@param modID string
---@param settingName string
---@param value string|number|tableColor|bool|Keyboard.Key_
function ModSettingAPI:setSettingValue(modID, settingName, value)
    ModSetting.SettingValues[modID][settingName] = value
end

return ModSettingAPI