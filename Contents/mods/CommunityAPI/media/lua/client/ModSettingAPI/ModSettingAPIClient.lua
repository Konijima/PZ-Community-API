require("CommunityAPI")
local ModSettingPanel = require("ModSettingAPI/ModSettingPanel")
local ModSandboxSetting = require("ModSettingAPI/ModSandboxSetting")
local ModSetting = require("ModSettingAPI/ModSetting")
local SandboxSettingPanel = require("ModSettingAPI/SandboxSettingPanel")

local JsonAPI = CommunityAPI.Utils.Json

---@class ModSettingAPI
local ModSettingAPI = {}
ModSettingAPI.ValueType = require("ModSettingAPI/ModSettingValueType")

--- Create setting section (tab panel) in mods tab. Returned section
---@param modID string
---@param sectionName string
---@return ModSettingPanel
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

--- Get setting section (tab panel)
---@param modID string
---@param sectionName string
---@return ModSettingPanel|nil
function ModSettingAPI:getSection(modID, sectionName)
    if ModSetting.Data[modID] == nil then return end
    return ModSetting.Data[modID][sectionName]
end

---@param modID string
---@param settingName string
---@return string|number|tableColor|bool|Keyboard.Key_|nil
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

--- Create sandbox setting section (item in list of setting categories). Return sandbox setting panel
---@param sectionName string
---@return SandboxSettingPanel
function ModSettingAPI:getOrCreateSandboxSection(sectionName)
    if ModSandboxSetting.Data[sectionName] == nil then
        ModSandboxSetting.Data[sectionName] = SandboxSettingPanel:new(sectionName)
    end
    return ModSandboxSetting.Data[sectionName]
end

---@param sectionName string
---@param settingName string
---@return string|number|tableColor|bool|Keyboard.Key_
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