require("CommunityAPI")

local JsonAPI = CommunityAPI.Utils.Json

-- Constants
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

---@class ModSetting
local ModSetting = {}
ModSetting.Data = {}
ModSetting.SettingValuesBuffer = {}
ModSetting.SettingValues = {}

-- Hook 
local defaultMainOptions_create = MainOptions.create
function MainOptions:create()
    defaultMainOptions_create(self)

    local panel = ISPanelJoypad:new(0, 0, self:getWidth(), self.tabs:getHeight() - self.tabs.tabHeight)
	panel:initialise()
	panel:instantiate()
	panel:setAnchorRight(true)
	panel:setAnchorLeft(true)
	panel:setAnchorTop(true)
	panel:setAnchorBottom(true)
	panel:noBackground()
	panel.borderColor = {r=0, g=0, b=0, a=0};
	panel:setScrollChildren(true)

	-- rerouting the main panel's pre / render functions so we can add in the stencil stuff there...
	panel.render = MainOptions.subPanelRender
	panel.prerender = MainOptions.subPanelPreRender

	self.tabs:addView(getText("UI_mainscreen_mods"), panel)

    ModSetting:loadModSettingPanel(panel)
end

-- Hook 
local defaultMainOptions_apply = MainOptions.apply
function MainOptions:apply(closeAfter)
    ModSetting:saveValues()

    defaultMainOptions_apply(self, closeAfter)
end

-- Hook 
local defaultMainOptions_close = MainOptions.close
function MainOptions:close()
    for modID, _ in pairs(ModSetting.Data) do
        ModSetting:updateSettingView(modID)
    end
    defaultMainOptions_close(self)
end

-- Hook
local defaultMainScreen_onMenuItemMouseDownMainMenu = MainScreen.onMenuItemMouseDownMainMenu
MainScreen.onMenuItemMouseDownMainMenu = function(item, x, y)
    ModSetting.listbox.selected = 1
    if ModSetting.listbox.items[ModSetting.listbox.selected] ~= nil then
        ModSetting:updateSettingView(ModSetting.listbox.items[ModSetting.listbox.selected].item)    
    end
    defaultMainScreen_onMenuItemMouseDownMainMenu(item, x, y)
end

function ModSetting:saveValues()
    for modID, data in pairs(ModSetting.SettingValuesBuffer) do
        for settName, value in pairs(data) do
            ModSetting.SettingValues[modID][settName] = value
        end
    end
    for _, viewObject in ipairs(ModSetting.tabs.viewList) do
        local settDataFromTab = viewObject.view:getSettingValues()
        for settingName, value in pairs(settDataFromTab) do
            ModSetting.SettingValues[viewObject.view.modID][settingName] = value
            print(settingName, value)
        end        
	end

    for modID, data in pairs(ModSetting.SettingValues) do
        local saved_presets = getFileWriter("cAPI_ModSettings" .. getFileSeparator() .. modID .. ".txt", true, false)
        saved_presets:write(JsonAPI.Encode(data))
        saved_presets:close()
    end
end

function ModSetting:loadModSettingPanel(panel)
    self.panel = panel

    -- List of mods
    self.listbox = ISScrollingListBox:new(16, 16, 300, self.panel:getHeight()-32);
    self.listbox:initialise();
    self.listbox:instantiate();
    self.listbox:setFont(UIFont.Large, 2);
    self.listbox.drawBorder = true;
    self.listbox.doDrawItem = ModSetting.modListDrawItem;
    self.listbox:setOnMouseDownFunction(self.panel, ModSetting.onClickOption);
    self.listbox.selected = 1
    self.panel:addChild(self.listbox);

    -- Tabs container panel
    self.tabs = ISTabPanel:new(self.listbox:getRight() + 16, 16, self.panel:getWidth() - self.listbox:getWidth() - 32 - 16, self.panel:getHeight()-32);
	self.tabs:initialise();
	self.tabs:setAnchorBottom(true);
	self.tabs:setAnchorRight(true);
	self.tabs.target = self.panel;
	self.tabs:setEqualTabWidth(false)
	self.tabs.tabPadX = 40
	self.tabs:setCenterTabs(false)
    self.tabs.render = ModSetting.tabContainerRender
	self.panel:addChild(self.tabs);  

    -- Add mod settings
    for modID, _ in pairs(ModSetting.Data) do
        local modInfo = getModInfoByID(modID)
        if modInfo == nil then
            self.listbox:addItem("IncorrectModID " .. modID, modID);
        else
            self.listbox:addItem(modInfo:getName(), modID);
        end
    end

    if self.listbox.items[self.listbox.selected] ~= nil then
        ModSetting:updateSettingView(self.listbox.items[self.listbox.selected].item)    
    end
end

function ModSetting:modListDrawItem(y, item, alt)
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), item.height-1, 0.7,0.1,0.4,0.1);
    end
    if self.mouseoverselected == item.index then
        self:drawRect(0, y, self:getWidth(), item.height-1, 0.25,0.5,0.5,0.5);
    end
    self:drawRectBorder(0, y + item.height - 1, self:getWidth(), 1, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    self:drawText(item.text, 16, y + (item.height - FONT_HGT_LARGE) / 2 + 1, 0.6, 0.7, 0.9, 1.0, UIFont.Medium);

    return y+item.height;
end

function ModSetting.onClickOption(option)
    ModSetting:updateSettingView(ModSetting.listbox.items[ModSetting.listbox.selected].item)
end

function ModSetting:updateSettingView(modID)
    for _, viewObject in ipairs(ModSetting.tabs.viewList) do
        local settDataFromTab = viewObject.view:getSettingValues()
        for settingName, value in pairs(settDataFromTab) do
            if ModSetting.SettingValuesBuffer[viewObject.view.modID] == nil then
                ModSetting.SettingValuesBuffer[viewObject.view.modID] = {}
            end
            ModSetting.SettingValuesBuffer[viewObject.view.modID][settingName] = value
        end        
	end

    -- clear old tabs in tab panel
	for _, viewObject in ipairs(self.tabs.viewList) do
		self.tabs:removeChild(viewObject.view);
	end
	self.tabs.viewList = {}

    -- load new tabs
    if ModSetting.Data[modID] ~= nil then
        for tabName, tab in pairs(ModSetting.Data[modID]) do
            tab:setWidth(self.tabs:getWidth())
            tab:setHeight(self.tabs:getHeight() - self.tabs.tabHeight)
            tab:initialise()
            tab:instantiate()
            tab:setScrollChildren(true)
            tab:addScrollBars();

            self.tabs:addView(tabName, tab)
        end
    end
end

return ModSetting