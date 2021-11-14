local jsonUtils = require("CommunityAPI/JsonUtils")

---@class ModSandboxSetting
ModSandboxSetting = {}
ModSandboxSetting.Data = {}
ModSandboxSetting.SettingValuesBuffer = {}
ModSandboxSetting.SettingValues = {}
ModSandboxSetting.needSaveData = false

-- Hook
local defaultSandboxOptionsScreen = SandboxOptionsScreen.create
function SandboxOptionsScreen:create()
    defaultSandboxOptionsScreen(self)

    for sectionName, panel in pairs(ModSandboxSetting.Data) do
        local item = {}
        item.panel = panel
        self.listbox:addItem(sectionName, item);
    end
    ModSandboxSetting.needSaveData = false
end

-- Rewrite default function
function SandboxOptionsScreen:onMouseDownListbox(item)
	if item.page then
		if self.currentPanel then
            if self.currentPanel.sectionName ~= nil then
                ModSandboxSetting:saveToBufferSandboxValues(self.currentPanel.sectionName, self.currentPanel:getSettingValues())
            end
			self:removeChild(self.currentPanel)
			self.currentPanel = nil
		end
		if item.panel then
			self:addChild(item.panel)
			item.panel:setWidth(self.width - 24 - self.listbox:getRight() - 24)
			item.panel:setHeight(self.listbox:getHeight())
			self.currentPanel = item.panel
		end
    else
        if self.currentPanel then
            if self.currentPanel.sectionName ~= nil then
                ModSandboxSetting:saveToBufferSandboxValues(self.currentPanel.sectionName, self.currentPanel:getSettingValues())
            end
			self:removeChild(self.currentPanel)
			self.currentPanel = nil
		end
		if item.panel then
            item.panel:setX(self.listbox:getRight() + 24)
            item.panel:setY(self.listbox:getY())
            item.panel:setWidth(self.width - 24 - self.listbox:getRight() - 24)
			item.panel:setHeight(self.listbox:getHeight())
            item.panel:initialise()
            item.panel:instantiate()
            item.panel:setScrollChildren(true)
            item.panel:addScrollBars();

			self:addChild(item.panel)
			
			self.currentPanel = item.panel
		end
	end
end

-- Hook
local defaultSandboxOptionsScreen_onOptionMouseDown = SandboxOptionsScreen.onOptionMouseDown
function SandboxOptionsScreen:onOptionMouseDown(button, x, y)
    if button.internal == "PLAY" then
        if self.currentPanel.sectionName ~= nil then
            ModSandboxSetting:saveToBufferSandboxValues(self.currentPanel.sectionName, self.currentPanel:getSettingValues())
        end
    end    
    defaultSandboxOptionsScreen_onOptionMouseDown(self, button, x, y)
end

-- Hook
local defaultCharacterCreationMain_onOptionMouseDown = CharacterCreationMain.onOptionMouseDown
function CharacterCreationMain:onOptionMouseDown(button, x, y)
    if button.internal == "NEXT" then
        for sectionName, data in pairs(ModSandboxSetting.SettingValuesBuffer) do
            for settingName, value in pairs(data) do
                if ModSandboxSetting.SettingValues[sectionName] == nil then
                    ModSandboxSetting.SettingValues[sectionName] = {}
                end
                ModSandboxSetting.SettingValues[sectionName][settingName] = value
            end
        end
        ModSandboxSetting.needSaveData = true
    end
    defaultCharacterCreationMain_onOptionMouseDown(self, button, x, y)
end

function ModSandboxSetting:saveToBufferSandboxValues(sectionName, values)
    for settingName, value in pairs(values) do
        if ModSandboxSetting.SettingValuesBuffer[sectionName] == nil then
            ModSandboxSetting.SettingValuesBuffer[sectionName] = {}
        end
        ModSandboxSetting.SettingValuesBuffer[sectionName][settingName] = value
    end       
end

function ModSandboxSetting.loadSandboxOptionsAtGameStart()
    if ModSandboxSetting.needSaveData then
        local fileWriter = getFileWriter("cAPI_SandboxSettings" .. getFileSeparator() .. getSaveInfo(getWorld():getWorld()).saveName .. ".txt", true, false)
        fileWriter:write(jsonUtils.Encode(ModSandboxSetting.SettingValues))
        fileWriter:close()
    else
        -- NEED FOR CREATE cAPI_SandboxSettings folder!
        local filewriter = getFileWriter("cAPI_SandboxSettings" .. getFileSeparator() .. "TEMP", true, false)
        filewriter:write("")
        filewriter:close()

        local fileReader = getFileReader("cAPI_SandboxSettings" .. getFileSeparator() .. getSaveInfo(getWorld():getWorld()).saveName .. ".txt", true)
        local line = fileReader:readLine()
        local config = nil
        if line ~= nil then
            config = jsonUtils.Decode(line)   
        end
        fileReader:close()

        if config ~= nil and type(config) == "table" then
            for sectionName, data in pairs(config) do
                for settingName, value in pairs(data) do
                    ModSandboxSetting.SettingValues[sectionName][settingName] = value
                end
            end
        end
    end
end

Events.OnGameTimeLoaded.Add(ModSandboxSetting.loadSandboxOptionsAtGameStart)