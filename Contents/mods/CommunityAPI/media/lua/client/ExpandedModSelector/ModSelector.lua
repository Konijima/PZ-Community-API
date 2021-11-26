require("CommunityAPI")
local EMS_ModInfoPanel = require("ExpandedModSelector/ModInfoPanel")
local EMS_ModListBox = require("ExpandedModSelector/ModListBox")
local EMS_ModPosterPanel = require("ExpandedModSelector/ModPosterPanel")
local EMS_ModThumbnailPanel = require("ExpandedModSelector/ModThumbnailPanel")


local ModSettingAPI = CommunityAPI.Client.ModSetting

local FONT_HGT_TITLE = getTextManager():getFontHeight(UIFont.Title)
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

local EMS_ModSelector = ISPanelJoypad:derive("EMS_ModSelector");
EMS_ModSelector.incompatible = {}
EMS_ModSelector.turnedOnModsOnOpenWindow = {}

function EMS_ModSelector:initialise()
    ISPanelJoypad.initialise(self);
end

function EMS_ModSelector:getActiveMods()
	if self.loadGameFolder then
		return ActiveMods.getById("currentGame")
	end
	return ActiveMods.getById(self.isNewGame and "currentGame" or "default")
end

function EMS_ModSelector:isModActive(modInfo)
	return self:getActiveMods():isModActive(modInfo:getId())
end

function EMS_ModSelector:onDblClickMap(item)
	if not self.modorderui or not self.modorderui:isVisible() then
		if self.listbox:isMouseOverScrollBar() then return end
		if self.listbox.mouseOverButton then
			item = self.listbox.mouseOverButton.item
		end
		self:forceActivateMods(item.modInfo, not self:isModActive(item.modInfo));
	end
end

function EMS_ModSelector:forceActivateMods(modInfo, activate)
	if modInfo:isAvailable() then
		self:getActiveMods():setModActive(modInfo:getId(), activate);
		-- we also activate the required mod if needed
		if self:isModActive(modInfo) and modInfo:getRequire() then
			for l=0,modInfo:getRequire():size() - 1 do
				for i,k in ipairs(self.listbox.items) do
					local modInfo2 = k.item.modInfo
					if modInfo2:getId() and modInfo2:getId():trim() == modInfo:getRequire():get(l):trim() then
						self:forceActivateMods(modInfo2, self:isModActive(modInfo));
					end
				end
			end
		end
	end
	-- check the "parents" mod to disable
	if not self:isModActive(modInfo) then
		for i,activatedMod in ipairs(self.listbox.items) do
			local modInfo2 = activatedMod.item.modInfo
			if self:isModActive(modInfo2) and modInfo2:getRequire() then
				for l=0,modInfo2:getRequire():size() - 1 do
					if modInfo:getId() == modInfo2:getRequire():get(l):trim() then
						self:forceActivateMods(modInfo2, false);
					end
				end
			end
		end
	end
	self.mapGroups:createGroups(self:getActiveMods(), false)
	self.mapConflicts = self.mapGroups:checkMapConflicts()
end

function EMS_ModSelector:onModsEnabledTick(option, selected)
	getCore():setOptionModsEnabled(selected)
end

--************************************************************************--
--** EMS_ModSelector:instantiate
--**
--************************************************************************--
function EMS_ModSelector:instantiate()
    self.javaObject = UIElement.new(self);
    self.javaObject:setX(self.x);
    self.javaObject:setY(self.y);
    self.javaObject:setHeight(self.height);
    self.javaObject:setWidth(self.width);
    self.javaObject:setAnchorLeft(self.anchorLeft);
    self.javaObject:setAnchorRight(self.anchorRight);
    self.javaObject:setAnchorTop(self.anchorTop);
    self.javaObject:setAnchorBottom(self.anchorBottom);

	self.modsWasChanged = false
end

function EMS_ModSelector:populateListBox(directories)
	self.listbox:clear();
	local modIDs = {}
	for _,directory in ipairs(directories) do
		-- Display the first mod with a given ID.
		-- There may be mods in User\Zomboid\mods, User\Zomboid\Workshop\,
		-- and steamapps\workshop\content\108600\.  The order can be changed
		-- using the -modfolders commandline option.
		local isLoadMod = false
		local sep = getFileSeparator()
		if self.chooseModCatComboBox.selected == 4 then
			isLoadMod = string.find(string.lower(directory), string.lower(sep .. "Zomboid"..sep.."mods"..sep), 1, true) ~= nil
		elseif self.chooseModCatComboBox.selected == 5 then
			isLoadMod = string.find(string.lower(directory), string.lower(sep .. "steamapps"..sep.."workshop"..sep.."content"..sep.."108600"..sep), 1, true) ~= nil 
		elseif self.chooseModCatComboBox.selected == 6 then
			isLoadMod = string.find(string.lower(directory), string.lower(sep .. "Zomboid"..sep .."Workshop"..sep), 1, true) ~= nil 
		else
			isLoadMod = true
		end

		if isLoadMod then
			local modInfo = getModInfo(directory)
			if modInfo and not modIDs[modInfo:getId()] then
				local item = {}
				item.modInfo = modInfo
				item.modInfoExtra = self:readInfoExtra(modInfo:getId())
				self.listbox:addItem("", item)
				modIDs[modInfo:getId()] = true
			end
		end
	end

	for i,k in ipairs(self.listbox.items) do
		local modInfo = k.item.modInfo
		if self:isModActive(modInfo) and not modInfo:isAvailable() then
			self:getActiveMods():setModActive(modInfo:getId(), false)
		end
		k.item.isActive = self:isModActive(modInfo)
	end

	self.ModsEnabled = getCore():getOptionModsEnabled()

	table.sort(self.listbox.items, function(a,b)
		return not string.sort(a.item.modInfo:getName(), b.item.modInfo:getName())
	end)

	self.mapGroups:createGroups(self:getActiveMods(), false)
	self.mapConflicts = self.mapGroups:checkMapConflicts()

	self:updateIncompatibility()
	self.listbox:updateFilter()
end

function EMS_ModSelector:setExistingSavefile(folder)
	self.loadGameFolder = folder
	local info = getSaveInfo(folder)
	local activeMods = info.activeMods or ActiveMods.getById("default")
	ActiveMods.getById("currentGame"):copyFrom(activeMods)

	-- Remember the list of map directories.  The user isn't allowed to change
	-- these by enabling/disabling mods.
	self.loadGameMapName = info.mapName or 'Muldraugh, KY'
end

function EMS_ModSelector:create()
    local labelHgt = FONT_HGT_SMALL
    self.smallFontHgt = labelHgt
    local buttonHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)

    self.topRect = {}
    self.topRect.x = 16
    self.topRect.y = 10 + FONT_HGT_TITLE + 10
    self.topRect.h = 8 + buttonHgt + 8
   
    local listY = self.topRect.y + self.topRect.h + 10
    local listHgt = self.height-(5 + buttonHgt + 10)-listY
    self.listbox = ModListBox:new(16, listY, self.width/2-16, listHgt);
    self.listbox:initialise();
    self.listbox:instantiate();
    self.listbox:setAnchorLeft(true);
    self.listbox:setAnchorRight(true);
    self.listbox:setAnchorTop(true);
    self.listbox:setAnchorBottom(true);
    self.listbox.itemheight = 128;
    self.listbox.drawBorder = true
    self.listbox:setOnMouseDoubleClick(self, EMS_ModSelector.onDblClickMap);
    self:addChild(self.listbox);

    self.backButton = ISButton:new(16, self.height-buttonHgt - 5, 100, buttonHgt, getText("UI_btn_back"), self, EMS_ModSelector.onOptionMouseDown);
    self.backButton.internal = "BACK";
    self.backButton:initialise();
    self.backButton:instantiate();
    self.backButton:setAnchorLeft(true);
    self.backButton:setAnchorRight(false);
    self.backButton:setAnchorTop(false);
    self.backButton:setAnchorBottom(true);
    self.backButton.borderColor = {r=1, g=1, b=1, a=0.1};
    self.backButton:setFont(UIFont.Small);
    self.backButton:ignoreWidthChange();
    self.backButton:ignoreHeightChange();
    self:addChild(self.backButton);

	-- Preset combo box
	self.savedPresets = ISComboBox:new(self.backButton:getRight()+16, self.backButton:getY(), 250, self.backButton:getHeight(), self, EMS_ModSelector.loadPreset);
	self.savedPresets:setAnchorTop(false);
	self.savedPresets:setAnchorBottom(true);
	self.savedPresets.openUpwards = true;
	self:addChild(self.savedPresets)

	-- Load presets
	self.savedPresets:addOption(getText("UI_characreation_SelectToLoad"))
	local saved_presets = self:readSaveFile();
	for key,val in pairs(saved_presets) do
		self.savedPresets:addOption(key)
	end

	--- Preset buttons ---
	self.saveBuildButton = ISButton:new(self.savedPresets:getRight() + 10, self.backButton:getY(), 50, 25, getText("UI_btn_save"), self, EMS_ModSelector.onOptionMouseDown);
	self.saveBuildButton.internal = "SAVE_PRESET"
	self.saveBuildButton:initialise();
	self.saveBuildButton:instantiate();
	self.saveBuildButton:setAnchorLeft(true);
	self.saveBuildButton:setAnchorRight(false);
	self.saveBuildButton:setAnchorTop(false);
	self.saveBuildButton:setAnchorBottom(true);
	self.saveBuildButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self:addChild(self.saveBuildButton);

    self.delBuildButton = ISButton:new(self.saveBuildButton:getRight() + 10, self.backButton:getY(), 50, 25, getText("UI_btn_delete"), self, EMS_ModSelector.onOptionMouseDown);
	self.delBuildButton.internal = "DELETE_PRESET"
	self.delBuildButton:initialise();
	self.delBuildButton:instantiate();
	self.delBuildButton:setAnchorLeft(true);
	self.delBuildButton:setAnchorRight(false);
	self.delBuildButton:setAnchorTop(false);
	self.delBuildButton:setAnchorBottom(true);
	self.delBuildButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self:addChild(self.delBuildButton);

    self.allBuildButton = ISButton:new(self.delBuildButton:getRight() + 10, self.backButton:getY(), 50, 25, getText("UI_EMS_Enable_All"), self, EMS_ModSelector.onOptionMouseDown);
	self.allBuildButton.internal = "TURN_ON_ALL_PRESET"
	self.allBuildButton:initialise();
	self.allBuildButton:instantiate();
	self.allBuildButton:setAnchorLeft(true);
	self.allBuildButton:setAnchorRight(false);
	self.allBuildButton:setAnchorTop(false);
	self.allBuildButton:setAnchorBottom(true);
	self.allBuildButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self:addChild(self.allBuildButton);

    self.noneBuildButton = ISButton:new(self.allBuildButton:getRight() + 10, self.backButton:getY(), 50, 25, getText("UI_EMS_Disable_All"), self, EMS_ModSelector.onOptionMouseDown);
	self.noneBuildButton.internal = "DISABLE_ALL_PRESET"
	self.noneBuildButton:initialise();
	self.noneBuildButton:instantiate();
	self.noneBuildButton:setAnchorLeft(true);
	self.noneBuildButton:setAnchorRight(false);
	self.noneBuildButton:setAnchorTop(false);
	self.noneBuildButton:setAnchorBottom(true);
	self.noneBuildButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self:addChild(self.noneBuildButton);
	--- ---

    local size = getTextManager():MeasureStringX(UIFont.Small, getText("UI_EMS_Open_Workshop"));
    size = math.max(size + 10 * 2, 100)
    self.getModButton = ISButton:new(16, self.topRect.y + 8, size, buttonHgt,  getText("UI_EMS_Open_Workshop"), self, EMS_ModSelector.onOptionMouseDown);
    self.getModButton.internal = "OPEN_WORKSHOP";
    self.getModButton:initialise();
    self.getModButton:instantiate();
    self.getModButton:setAnchorLeft(false);
    self.getModButton:setAnchorRight(true);
    self.getModButton:setAnchorTop(true);
    self.getModButton:setAnchorBottom(false);
    self.getModButton.borderColor = {r=1, g=1, b=1, a=1};
    self.getModButton.backgroundColor = {r=0, g=0.5, b=0.75, a=1.0};
    self.getModButton.backgroundColorMouseOver = {r=0, g=0.65, b=0.85, a=1.0};
    self.getModButton:setFont(UIFont.Small);
    --self.getModButton:ignoreWidthChange();
    --self.getModButton:ignoreHeightChange();
	if not getSteamModeActive() then
		self.getModButton.tooltip = getText("UI_mods_WorkshopRequiresSteam")
	end
    self:addChild(self.getModButton);

	-- Filter entry
	local entry = ISTextEntryBox:new("", self.getModButton:getX() + self.getModButton:getWidth() + 16, self.getModButton:getY(), 300, 25)
	entry.font = UIFont.Medium
	entry:setAnchorRight(true)
	self:addChild(entry)
	entry:setEditable(true)
	entry:setSelectable(true)
	entry.onTextChange = function(S)
		S.parent.listbox:updateFilter()
	end
	self.filterEntry = entry

	self.acceptButton = ISButton:new(self.width - 16, self.height - buttonHgt - 5, 100, buttonHgt, getText("UI_btn_accept"), self, EMS_ModSelector.onOptionMouseDown);
	self.acceptButton.internal = "DONE";
	self.acceptButton:initialise();
	self.acceptButton:instantiate();
	self.acceptButton:setAnchorLeft(false);
	self.acceptButton:setAnchorRight(true);
	self.acceptButton:setAnchorTop(false);
	self.acceptButton:setAnchorBottom(true);
	self.acceptButton.borderColor = {r=1, g=1, b=1, a=0.1};
	self.acceptButton:setFont(UIFont.Small);
	self.acceptButton:ignoreWidthChange();
	self.acceptButton:ignoreHeightChange();
	self:addChild(self.acceptButton);
	self.acceptButton:setWidthToTitle()
	self.acceptButton:setWidth(self.acceptButton.width + 32)
	self.acceptButton:setX(self.width - 16 - self.acceptButton.width)

	self.modOrderbtn = ISButton:new(self.acceptButton:getRight() - 16 - 100, self.height - buttonHgt - 5, 100, buttonHgt, getText("UI_mods_ModsOrder"), self, EMS_ModSelector.onOptionMouseDown);
	self.modOrderbtn.internal = "MODSORDER";
	self.modOrderbtn:initialise();
	self.modOrderbtn:instantiate();
	self.modOrderbtn:setAnchorLeft(false);
	self.modOrderbtn:setAnchorRight(true);
	self.modOrderbtn:setAnchorTop(false);
	self.modOrderbtn:setAnchorBottom(true);
	self.modOrderbtn.borderColor = {r=1, g=1, b=1, a=0.1};
	self.modOrderbtn:setFont(UIFont.Small);
	self.modOrderbtn:ignoreWidthChange();
	self.modOrderbtn:ignoreHeightChange();
	self:addChild(self.modOrderbtn);
	self.modOrderbtn:setWidthToTitle()
	self.modOrderbtn:setX(self.acceptButton:getX() - 16 - self.modOrderbtn.width)

	local left = self.listbox:getRight() + 16
	local top = self.listbox:getY()
	local panel = ModInfoPanel:new(left, top, self.width - 16 - left, self.listbox.height)
	panel:setAnchorBottom(true)
	self:addChild(panel)
	panel:addScrollBars()
	panel:setScrollChildren(true)
	self.infoPanel = panel
	self.urlButton = self.infoPanel.urlButton

	-- Mod name large label
	local size = getTextManager():MeasureStringX(UIFont.Large, "MODNAME");
    local label = ISLabel:new(left + panel:getWidth()/2.0 - size/2.0, self.topRect.y + (self.topRect.h - FONT_HGT_LARGE) / 2, FONT_HGT_LARGE + 2 * 2, "MODNAME", 1.0, 1.0, 1.0, 1.0, UIFont.Large, true)
	label:setColor(0.7, 0.7, 0.7)
	label.font = UIFont.Large
	self:addChild(label)
	self.modNameTitle = label

	-- Version label
	size = getTextManager():MeasureStringX(UIFont.Small, "");
    label = ISLabel:new(left + panel:getWidth() - size - 120, panel:getY() - FONT_HGT_SMALL - 6, FONT_HGT_SMALL + 2 * 2, "", 1.0, 1.0, 1.0, 1.0, UIFont.Small, true)
	label:setColor(0.7, 0.7, 0.7)
	label.font = UIFont.Small
	self:addChild(label)
	self.versionLabel = label

	-- Choose what mods select
	local combo = ISComboBox:new(self.filterEntry:getX() + self.filterEntry:getWidth() + 16, self.getModButton:getY(), 260, 25, self, EMS_ModSelector_onModsModified);
	combo:initialise();
	combo:addOption(getText("UI_EMS_All_mods"))
    combo:addOption(getText("UI_EMS_Map_mods"))
    combo:addOption(getText("UI_EMS_Activated_mods"))
	combo:addOption("*\\Zomboid\\mods\\*")
	combo:addOption("*\\steamapps\\workshop\\content\\108600\\*")
	combo:addOption("*\\Zomboid\\Workshop\\*")
	combo.selected = 1;
	self:addChild(combo);
	self.chooseModCatComboBox = combo
end

function EMS_ModSelector:prerender()
	EMS_ModSelector.instance = self
	self:updateButtons();
    self.listbox.mouseOverButton = nil
    ISPanelJoypad.prerender(self);
	if self.listbox.items and self.listbox.items[self.listbox.selected] then
		self.infoPanel:setModInfo(self.listbox.items[self.listbox.selected].item.modInfo)
		
		local modName = self.listbox.items[self.listbox.selected].item.modInfo:getName()
		self.modNameTitle:setName(modName)
		self.modNameTitle:setX(self.listbox:getRight() + 16 + self.infoPanel:getWidth()/2.0 - getTextManager():MeasureStringX(UIFont.Large, modName)/2.0)

		local version = self.listbox.items[self.listbox.selected].item.modInfo:getVersionMin()
		if version ~= nil then
			self.versionLabel:setName("Version min: " .. version:toString())

			if version:isGreaterThan(getCore():getGameVersion()) then
				self.versionLabel:setColor(0.9, 0.3, 0.3, 0.9)
			else
				self.versionLabel:setColor(0.9, 0.9, 0.9, 0.9)
			end
		else
			self.versionLabel:setName("")
		end
		
	end
    self:drawTextCentre(getText("UI_mods_SelectMods"), self.width / 2, 10, 1, 1, 1, 1, UIFont.Title);
end

function EMS_ModSelector:updateButtons()
	local item = self.listbox.items[self.listbox.selected]
	if item then
		local modInfo = item.item.modInfo
		self.infoPanel.buttonToggle:setEnable(modInfo:isAvailable())
		self.infoPanel.buttonToggle:setTitle(getText(self:isModActive(modInfo) and "UI_mods_ModDisable" or "UI_mods_ModEnable"))
		self.infoPanel.buttonOptions:setEnable(false)
		if modInfo:getWorkshopID() and isSteamOverlayEnabled() then
			self.urlButton:setEnable(true);
			self.urlButton.workshopID = modInfo:getWorkshopID()
			self.urlButton:setTitle(getText("UI_WorkshopSubmit_OverlayButton"))
		elseif modInfo:getUrl() and modInfo:getUrl() ~= "" then
			self.urlButton:setVisible(true);
			self.urlButton.workshopID = nil
			self.urlButton.url = modInfo:getUrl();
--			self.urlButton:setTitle("URL : " .. modInfo:getUrl());
			self.urlButton:setEnable(true);
			self.urlButton:setTitle(getText("UI_mods_OpenWebBrowser"))
		else
			self.urlButton:setTitle(getText("UI_mods_OpenWebBrowser"))
			self.urlButton:setEnable(false);
		end
	else
		self.infoPanel.buttonToggle:setEnable(false)
		self.infoPanel.buttonOptions:setEnable(false)
	end

	self.modOrderbtn.enable = self.mapConflicts
	if self.modorderui and self.modorderui:isReallyVisible() then
		self.modOrderbtn.blinkBG = false
		self.modOrderbtn.tooltip = nil
	else
		self.modOrderbtn.blinkBG = self.mapConflicts
		self.modOrderbtn.tooltip = self.mapConflicts and getText("UI_mods_ConflictDetected") or nil
	end
end

function EMS_ModSelector:onBack()
	self:populateListBox(getModDirectoryTable())

	for i,k in ipairs(self.listbox.items) do
		if k.item.isActive then
			if not EMS_ModSelector.turnedOnModsOnOpenWindow[k.item.modInfo:getId()] then
				self:getActiveMods():setModActive(k.item.modInfo:getId(), false)
			end
		else
			if EMS_ModSelector.turnedOnModsOnOpenWindow[k.item.modInfo:getId()] then
				self:getActiveMods():setModActive(k.item.modInfo:getId(), true)
			end
		end
	end
	EMS_ModSelector.turnedOnModsOnOpenWindow = {}

	if self.modorderui then
		self.modorderui:removeFromUIManager()
	end
	self:setVisible(false)

	if self.loadGameFolder then
		LoadGameScreen.instance:setVisible(true, self.joyfocus)
		return
	end

	if self.isNewGame then
		NewGameScreen.instance:setVisible(true, self.joyfocus)
	else
		MainScreen.instance.bottomPanel:setVisible(true)
		if self.joyfocus then
			self.joyfocus.focus = MainScreen.instance
			updateJoypadFocus(self.joyfocus)
		end
	end
end

function EMS_ModSelector:onAccept()
	if self.modorderui then
		self.modorderui:removeFromUIManager()
	end
	self:setVisible(false)

	local activeMods = self:getActiveMods()
	-- Remove mod IDs for missing mods from ActiveMods.mods
	activeMods:checkMissingMods()
	-- Remove unused map directories from ActiveMods.mapOrder
	activeMods:checkMissingMaps()

	if self.loadGameFolder then
		local saveFolder = self.loadGameFolder
		self.loadGameFolder = nil
		manipulateSavefile(saveFolder, "WriteModsDotTxt")

		-- Setting 'currentGame' to 'default' in case other places forget to set it
		-- before starting a game (DebugScenarios.lua, etc).
		local defaultMods = ActiveMods.getById("default")
		local currentMods = ActiveMods.getById("currentGame")
		currentMods:copyFrom(defaultMods)

		LoadGameScreen.instance:onSavefileModsChanged(saveFolder)
		LoadGameScreen.instance:setVisible(true, self.joyfocus)
		return
	end

	if self.isNewGame then
		NewGameScreen.instance:setVisible(true, self.joyfocus)
	else
		saveModsFile()

		-- Setting 'currentGame' to 'default' in case other places forget to set it
		-- before starting a game (DebugScenarios.lua, etc).
		local defaultMods = ActiveMods.getById("default")
		local currentMods = ActiveMods.getById("currentGame")
		currentMods:copyFrom(defaultMods)

		MainScreen.instance.bottomPanel:setVisible(true)
		if self.joyfocus then
			self.joyfocus.focus = MainScreen.instance
			updateJoypadFocus(self.joyfocus)
		end
	end

	local reset = self.ModsEnabled ~= getCore():getOptionModsEnabled()
	if ActiveMods.requiresResetLua(activeMods) then
		reset = true
	end
	if reset then
		if self.isNewGame then
			getCore():ResetLua("currentGame", "NewGameMods")
		else
			getCore():ResetLua("default", "modsChanged")
		end
	end
end

function EMS_ModSelector:onOptionMouseDown(button, x, y)
	if button.internal == "DONE" then
		self:onAccept()
	elseif button.internal == "BACK" then
		if self.modsWasChanged then
			local w,h = 350,120
			self.modal = ISModalDialog:new((getCore():getScreenWidth() / 2) - w / 2,
				(getCore():getScreenHeight() / 2) - h / 2, w, h,
				getText("UI_optionscreen_ConfirmPrompt"), true, self, function(self, button, x, y)
					if button.internal == "YES" then
						self:onAccept()
					else
						self:onBack()
					end
				end);
			self.modal:initialise()
			self.modal:setCapture(true)
			self.modal:setAlwaysOnTop(true)
			self.modal:addToUIManager()
			if self.joyfocus then
				self.joyfocus.focus = self.modal
				updateJoypadFocus(self.joyfocus)
			end
		else
			self:onBack()
		end
	elseif button.internal == "TOGGLE" then
		local item = self.listbox.items[self.listbox.selected].item
		self:forceActivateMods(item.modInfo, not self:isModActive(item.modInfo))
	elseif button.internal == "URL" then
		if button.workshopID then
			activateSteamOverlayToWorkshopItem(button.workshopID)
		else
			openUrl(button.url);
		end
    elseif button.internal == "OPEN_WORKSHOP" then
		if getSteamModeActive() then
			if isSteamOverlayEnabled() then
				activateSteamOverlayToWorkshop()
			else
				openUrl("steam://url/SteamWorkshopPage/108600")
			end
		else
		openUrl("http://theindiestone.com/forums/index.php/forum/58-mods/");
		end
    elseif button.internal == "MODSORDER" then
		self:setVisible(false)
		self.modorderui = ModOrderUI:new(0, 0, 700, 400);
		self.modorderui:initialise();
		self.modorderui:addToUIManager();
	elseif button.internal == "SAVE_PRESET" then
		self.inputModal = self:inputModal(true, nil, nil, nil, nil, "", EMS_ModSelector.inputModalOnMouseDown, self);
		self.inputModal.backgroundColor.a = 0.9
		self.inputModal:setValidateFunction(self, self.saveBuildValidate)
	elseif button.internal == "DELETE_PRESET" then
		local delBuild = self.savedPresets.options[self.savedPresets.selected];

		local builds = self:readSaveFile();
		builds[delBuild] = nil;
	
		local options = {};
		self:writeSaveFile(builds);
		for key,val in pairs(builds) do
			if key ~= nil and val ~= nil then
				options[key] = 1;
			end
		end
	
		self.savedPresets.options = {};
		self.savedPresets:addOption(getText("UI_characreation_SelectToLoad"))
		for key,val in pairs(options) do
			table.insert(self.savedPresets.options, key);
		end
		if self.savedPresets.selected > #self.savedPresets.options then
			self.savedPresets.selected = #self.savedPresets.options
		end
		self:loadPreset(self.savedPresets)
	elseif button.internal == "TURN_ON_ALL_PRESET" then
		for i,k in ipairs(self.listbox.items) do
			local modInfo2 = k.item.modInfo
			self:forceActivateMods(modInfo2, true);
		end
	elseif button.internal == "DISABLE_ALL_PRESET" then
		for i,k in ipairs(self.listbox.items) do
			local modInfo2 = k.item.modInfo
			self:forceActivateMods(modInfo2, false);
		end
	elseif button.internal == "COPY_LINK" or button.internal == "COPY_LOCATION" or button.internal == "COPY_ID" or button.internal == "COPY_WORKSHOP_ID" then
		Clipboard.setClipboard(button.data)
	end
end

function EMS_ModSelector:onGainJoypadFocus(joypadData)
    ISPanelJoypad.onGainJoypadFocus(self, joypadData);
    self.listbox:setISButtonForB(self.backButton);
    self.infoPanel:setISButtonForB(self.backButton);
--    self.listbox:setJoypadFocused(true, joypadData);
	self.hasJoypadFocus = true
    joypadData.focus = self.listbox;
end

function EMS_ModSelector:onResolutionChange(oldw, oldh, neww, newh)
	self.listbox:setWidth(self:getWidth() / 2 - self.listbox:getX())
	self.listbox:recalcSize()
	self.listbox.vscroll:setX(self.listbox:getWidth() - 16)
	local urlX = self:getWidth() / 2 + 16

	self.infoPanel:setWidth(self.width - 20 - urlX)
	self.infoPanel:setX(urlX)
end

function EMS_ModSelector:onJoypadBeforeDeactivate(joypadData)
	self.backButton:clearJoypadButton()
	self.hasJoypadFocus = false
	-- focus is on listbox or infoPanel
	self.joyfocus = nil
end

function EMS_ModSelector:new(x, y, width, height)
    local o = {}
    --o.data = {}
    o = ISPanelJoypad:new(x, y, width, height);
    EMS_ModSelector.instance = o;
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    o.backgroundColor = {r=0, g=0, b=0, a=0.3};
    o.borderColor = {r=1, g=1, b=1, a=0.2};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.itemheightoverride = {}
    o.tickTexture = getTexture("Quest_Succeed");
	o.cantTexture = getTexture("Quest_Failed");
	o.abutton =  Joypad.Texture.AButton;
    o.selected = 1;
    o.mapGroups = MapGroups.new()
    return o
end

function EMS_ModSelector_onModsModified()
	local self = EMS_ModSelector.instance
	if self and self.listbox and self:isReallyVisible() then
		local index = self.listbox.selected
		self:populateListBox(getModDirectoryTable())
		if self.listbox.items[index] then
			self.listbox.selected = index
		end
	end
end

Events.OnModsModified.Add(EMS_ModSelector_onModsModified)

-----

function EMS_ModSelector.showNagPanel()
	EMS_ModSelector.turnedOnModsOnOpenWindow = {}
	for i,k in ipairs(EMS_ModSelector.instance.listbox.items) do
		if k.item.isActive then
			EMS_ModSelector.turnedOnModsOnOpenWindow[k.item.modInfo:getId()] = true
		end
	end

	if getCore():isModsPopupDone() then
		return
	end
	getCore():setModsPopupDone(true)

	EMS_ModSelector.instance:setVisible(false)

	local width = 650
	local height = 400
	local nagPanel = ISModsNagPanel:new(
		(getCore():getScreenWidth() - width)/2,
		(getCore():getScreenHeight() - height)/2,
		width, height)
	nagPanel:initialise()
	nagPanel:addToUIManager()
	nagPanel:setAlwaysOnTop(true)
	local joypadData = JoypadState.getMainMenuJoypad()
	if joypadData then
		joypadData.focus = nagPanel
		updateJoypadFocus(joypadData)
	end
end

----- Preset functions
function EMS_ModSelector:loadPreset(box)
	local preset = box.options[box.selected]
	if preset == nil then return end

	for i,k in ipairs(self.listbox.items) do
        self:forceActivateMods(k.item.modInfo, false);
    end	

	local saved_presets = self:readSaveFile()
	local build = saved_presets[preset];

	if build == nil then return end;

	local failed_mods = "";
	local count_fail = 0;
	local active_mods = luautils.split(build, ";");
	for i=1, #active_mods do
		local modInfo = getModInfoByID(active_mods[i]);
		if not modInfo then
			count_fail = count_fail + 1;
			failed_mods = failed_mods .. active_mods[i] .. ", "
		else
			self:forceActivateMods(modInfo, true);
		end
	end
	saveModsFile();

	if count_fail > 0 then
		luautils.okModal("Mods failed to load: "..count_fail.."\n\n"..failed_mods, true);
	end

	self.modsWasChanged = true
end

function EMS_ModSelector:readSaveFile()
	local retVal = {};

	local saveFile = getFileReader("CAPI_mod_presets.txt", true);
	if not saveFile then return retVal end
	local line = saveFile:readLine();
	while line ~= nil do
		local s = luautils.split(line, "=");
		retVal[s[1]] = s[2];
		line = saveFile:readLine();
	end
	saveFile:close();

	return retVal;
end

function EMS_ModSelector:writeSaveFile(options)
	local saved_presets = getFileWriter("CAPI_mod_presets.txt", true, false)
	for key,val in pairs(options) do
		saved_presets:write(key.."="..val.."\n");
	end
	saved_presets:close();
end

function EMS_ModSelector:inputModal(_centered, _width, _height, _posX, _posY, _text, _onclick, target, param1, param2) -- {{{
    -- based on luautils.okModal
    local posX = _posX or 0;
    local posY = _posY or 0;
    local width = _width or 230;
    local height = _height or 120;
    local centered = _centered;
    local txt = _text;
    local core = getCore();

    -- center the modal if necessary
    if centered then
        posX = core:getScreenWidth() * 0.5 - width * 0.5;
        posY = core:getScreenHeight() * 0.5 - height * 0.5;
    end

    -- ISModalDialog:new(x, y, width, height, text, yesno, target, onclick, player, param1, param2)
    local modal = ISTextBox:new(posX, posY, width, height, getText("UI_characreation_BuildSavePrompt"), _text or "", target, _onclick, param1, param2);
    modal:initialise();
    modal:setAlwaysOnTop(true)
    modal:setCapture(true)
    modal:addToUIManager();
    modal.yes:setTitle(getText("UI_btn_save"))
    modal.entry:focus()

    return modal;
end

function EMS_ModSelector:inputModalOnMouseDown(button, joypadData)
	if button.internal == "CANCEL" then
		button.parent.colorPicker:removeFromUIManager();
		return
	end

	local builds = self:readSaveFile();

	local savestring = "";
	for i,k in ipairs(self.listbox.items) do
		if self:isModActive(k.item.modInfo) then
			savestring = savestring..k.item.modInfo:getId()..";"
		end
    end

	local savename = button.parent.entry:getText()
	if savename == '' then return end
	builds[savename] = savestring;

	local options = {};
	options[getText("UI_characreation_SelectToLoad")] = 1;
	self:writeSaveFile(builds)
	for key,val in pairs(builds) do
		options[key] = 1;
	end

	self.savedPresets.options = {};
	local i = 1;
	for key,val in pairs(options) do
		table.insert(self.savedPresets.options, key);
		if key == savename then
			self.savedPresets.selected = i;
		end
		i = i + 1;
	end

	button.parent.colorPicker:removeFromUIManager();
end

function EMS_ModSelector:saveBuildValidate(text)
	return text ~= "" and not text:contains("/") and not text:contains("\\") and
		not text:contains(":") and not text:contains(";") and not text:contains('"') and not text:contains('=')
end

function EMS_ModSelector:readInfoExtra(modId)
	local modInfo = getModInfoByID(modId)
	local modInfoExtra = {}
	
	local mapList = getMapFoldersForMod(modId)
	if mapList ~= nil and mapList:size() > 0 then
		modInfoExtra.isMap = mapList:size() > 0
	end
		
	-- extra data from mod.info
	local file = getModFileReader(modId, "mod.info", false)
	if not file then return modInfoExtra end
	local line = file:readLine()
	while line ~= nil do
		--split key and value (by first "=", no luautils.split)
		local sep = string.find(line, "=")
		local key, val = "", ""
		if sep ~= nil then
			key = string.lower(luautils.trim(string.sub(line, 0, sep - 1)))
			val = luautils.trim(string.sub(line, sep + 1))
		end
		
		-- new key icon, incompatibility list and reread again url to get any url
		if key == "url" then
			modInfoExtra.url = val
		elseif key == "icon" then
			modInfoExtra.icon = getTexture(modInfo:getDir() .. getFileSeparator() .. val)
		elseif key == "incompatibility" then
			local t = luautils.split(val, ";");
			modInfoExtra.incompatible = {}
			for i, value in ipairs(t) do
				if string.gsub(value, "%s+", "") ~= "" then
					table.insert(modInfoExtra.incompatible, value)
				end
			end
		end
		
		line = file:readLine()
	end
	file:close()
	
	return modInfoExtra
end

function EMS_ModSelector:updateIncompatibility()
	for _, i in ipairs(self.listbox.items) do
		local item = i.item

		if item.modInfoExtra.incompatible ~= nil then
			if EMS_ModSelector.incompatible[item.modInfo:getId()] == nil then
				EMS_ModSelector.incompatible[item.modInfo:getId()] = {}
			end
			for _, val in ipairs(item.modInfoExtra.incompatible) do
				EMS_ModSelector.incompatible[item.modInfo:getId()][val] = true
				if EMS_ModSelector.incompatible[val] == nil then
					EMS_ModSelector.incompatible[val] = {}
				end
				EMS_ModSelector.incompatible[val][item.modInfo:getId()] = true
			end
		end
	end
end

function EMS_ModSelector:isModIncompatible(modId)
	if EMS_ModSelector.incompatible[modId] ~= nil then
		for val, _ in pairs(EMS_ModSelector.incompatible[modId]) do
			if self:getActiveMods():isModActive(val) then
				return true
			end
		end
	end
	return false
end

local cAPISettingSection = ModSettingAPI.GetModSettingSection("CommunityAPI", "Main")
if cAPISettingSection == nil then
	cAPISettingSection = ModSettingAPI.CreateModSettingSection("CommunityAPI", "Main")
end
cAPISettingSection:addSetting("ExpandedModSelector", "Expanded Mod Selector", "Enable Expanded mod selector", ModSettingAPI.ValueType.CheckBox, true)

if ModSettingAPI.GetModSettingValue("CommunityAPI", "ExpandedModSelector") then
	ModSelector = EMS_ModSelector
	ModInfoPanel = EMS_ModInfoPanel
	ModListBox = EMS_ModListBox
	ModPosterPanel = EMS_ModPosterPanel
	ModThumbnailPanel = EMS_ModThumbnailPanel
end

