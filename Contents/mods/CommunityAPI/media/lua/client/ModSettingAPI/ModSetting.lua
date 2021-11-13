-- Constants
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

---@class ModSetting
ModSetting = {}
ModSetting.Data = {}
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

local defaultMainOptions_apply = MainOptions.apply
function MainOptions:apply(closeAfter)
    ModSetting:saveValues()

    defaultMainOptions_apply(self, closeAfter)
end

local defaultMainOptions_close = MainOptions.close
function MainOptions:close()
    for modID, _ in pairs(ModSetting.Data) do
        ModSetting:updateSettings(modID)
    end
    defaultMainOptions_close(self)
end

function ModSetting:saveValues()
    for _, viewObject in ipairs(ModSetting.tabs.viewList) do
        local settDataFromTab = viewObject.view:getSettingValues()
        for settingName, value in pairs(settDataFromTab) do
            ModSetting.SettingValues[viewObject.view.modID][settingName] = value
            print(viewObject.view.modID, settingName, value)
        end        
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
    

    -- Load settings TODO

    -- Add mod settings
    for modID, _ in pairs(ModSetting.Data) do
        self.listbox:addItem(getModInfoByID(modID), modID);
    end
    if self.listbox.items[self.listbox.selected] ~= nil then
        ModSetting:updateSettings(self.listbox.items[self.listbox.selected].item)    
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
    ModSetting:updateSettings(ModSetting.listbox.items[ModSetting.listbox.selected].item)
end

function ModSetting:updateSettings(modID)
    -- clear old tabs in tab panel
	for _, viewObject in ipairs(self.tabs.viewList) do
		self.tabs:removeChild(viewObject.view);
	end
	self.tabs.viewList = {}

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