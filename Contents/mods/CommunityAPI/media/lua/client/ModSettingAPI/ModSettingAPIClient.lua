require("CommunityAPI")
local ModSettingPanel = require("ModSettingAPI/ModSettingPanel")
local ModSandboxSetting = require("ModSettingAPI/ModSandboxSetting")
local ModSetting = require("ModSettingAPI/ModSetting")
local SandboxSettingPanel = require("ModSettingAPI/SandboxSettingPanel")

local JsonAPI = CommunityAPI.Utils.Json

---@class ModSettingAPI
local ModSettingAPI = {}
ModSettingAPI.ValueType = require("ModSettingAPI/ModSettingValueType")

--- Create mod setting section (tab panel) in mods tab in global settings. Return mod setting section panel
---@param modID string  Mod ID
---@param sectionName string  Name of tab panel in MODS tab
---@return ModSettingPanel
function ModSettingAPI.CreateModSettingSection(modID, sectionName)
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
            config = JsonAPI.Decode(line)    
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

--- Get mod setting section panel
---@param modID string  Mod ID
---@param sectionName string  Name of tab panel in MODS tab
---@return ModSettingPanel|nil
function ModSettingAPI.GetSection(modID, sectionName)
    if ModSetting.Data[modID] == nil then return end
    return ModSetting.Data[modID][sectionName]
end

---@param modID string  Mod ID
---@param settingName string  Setting name
---@return string|number|table|boolean|nil
function ModSettingAPI.GetSettingValue(modID, settingName)
    if ModSetting.SettingValues[modID] == nil then
        return nil
    end
    return ModSetting.SettingValues[modID][settingName]
end

---@param modID string  Mod ID
---@param settingName string  Setting name
---@param value string|number|table|boolean|nil  Setting value. Depends on ValueType of setting
function ModSettingAPI.SetSettingValue(modID, settingName, value)
    if ModSetting.SettingValues[modID] == nil then
        ModSetting.SettingValues[modID] = {}
    end
    ModSetting.SettingValues[modID][settingName] = value
end

--- Create sandbox setting section (item in list of setting categories). Return sandbox setting section panel
---@param sectionName string  Name of section in list of setting categories
---@return SandboxSettingPanel
function ModSettingAPI.CreateSandboxSection(sectionName)
    ModSandboxSetting.Data[sectionName] = SandboxSettingPanel:new(sectionName)
    return ModSandboxSetting.Data[sectionName]
end

--- Get sandbox setting section (item in list of setting categories). Return sandbox setting section panel
---@param sectionName string  Name of section in list of setting categories
---@return SandboxSettingPanel
function ModSettingAPI.GetSandboxSection(sectionName)
    return ModSandboxSetting.Data[sectionName]
end

---@param sectionName string  Name of section in list of setting categories
---@param settingName string  Setting name
---@return string|number|table|boolean|nil
function ModSettingAPI.GetSandboxValue(sectionName, settingName)
    if ModSandboxSetting.SettingValues[sectionName] == nil then
        return nil
    end
    return ModSandboxSetting.SettingValues[sectionName][settingName]
end

---@param sectionName string  Name of section in list of setting categories
---@param settingName string  Setting name
---@param value string|number|table|boolean|nil  Setting value. Depends on ValueType of setting
function ModSettingAPI.SetSandboxValue(sectionName, settingName, value)
    if ModSandboxSetting.SettingValues[sectionName] == nil then
        ModSandboxSetting.SettingValues[sectionName] = {}
    end
    ModSandboxSetting.SettingValues[sectionName][settingName] = value
end

return ModSettingAPI