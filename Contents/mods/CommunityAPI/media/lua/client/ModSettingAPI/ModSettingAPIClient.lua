require("ModSettingAPI/ModSetting")
require("ModSettingAPI/ModSettingPanel")
local jsonUtils = require("CommunityAPI/JsonUtils")

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
---@param sectionName string
function ModSettingAPI:createSection(modID, sectionName)
    local panel = ModSettingPanel:new(modID, sectionName)

    if ModSetting.Data[modID] == nil then
        ModSetting.Data[modID] = {}
    end
    ModSetting.Data[modID][sectionName] = panel

    -- NEED FOR CREATE cAPI_ModSettings folder!
    local filewriter = getFileWriter("cAPI_ModSettings" .. getFileSeparator() .. "TEMP", true, false)
    filewriter:write("")
    filewriter:close()
    
    -- Read config file
    local configFile = getFileReader("cAPI_ModSettings" .. getFileSeparator() .. modID .. ".txt", true)
    if configFile ~= nil then
        local line = configFile:readLine()
        local config = nil
        if line ~= nil then
            config = jsonUtils.Decode(line)    
        end
        configFile:close()
        
        if ModSetting.SettingValues[modID] == nil then
            ModSetting.SettingValues[modID] = {}
        end
        if config ~= nil then
            for settName, value in pairs(config) do
                ModSetting.SettingValues[modID][settName] = value
            end
        end
        configFile:close()
    end

    return panel
end

---@param modID string
---@param sectionName string
function ModSettingAPI:getSection(modID, sectionName)
    if ModSetting.Data[modID] == nil then return end
    return ModSetting.Data[modID][sectionName]
end

---@param modID string
---@param settingName string
function ModSettingAPI:getSettingValue(modID, settingName)
    if ModSetting.SettingValues[modID] == nil then
        return nil
    end
    return ModSetting.SettingValues[modID][settingName]
end

---@param modID string
---@param settingName string
---@param value string|number|tableColor|bool|Keyboard.Key_
function ModSettingAPI:setSettingValue(modID, settingName, value)
    if ModSetting.SettingValues[modID] == nil then
        ModSetting.SettingValues[modID] = {}
    end
    ModSetting.SettingValues[modID][settingName] = value
end

---@param sectionName string
function ModSettingAPI:getOrCreateSandboxSection(sectionName)
    if ModSandboxSetting.Data[sectionName] == nil then
        ModSandboxSetting.Data[sectionName] = SandboxSettingPanel:new(sectionName)
    end
    return ModSandboxSetting.Data[sectionName]
end

---@param sectionName string
---@param settingName string
function ModSettingAPI:getSandboxValue(sectionName, settingName)
    if ModSandboxSetting.SettingValues[sectionName] == nil then
        return nil
    end
    return ModSandboxSetting.SettingValues[sectionName][settingName]
end

---@param sectionName string
---@param settingName string
---@param value string|number|tableColor|bool|Keyboard.Key_
function ModSettingAPI:setSandboxValue(sectionName, settingName, value)
    if ModSandboxSetting.SettingValues[sectionName] == nil then
        ModSandboxSetting.SettingValues[sectionName] = {}
    end
    ModSandboxSetting.SettingValues[sectionName][settingName] = value
end

return ModSettingAPI