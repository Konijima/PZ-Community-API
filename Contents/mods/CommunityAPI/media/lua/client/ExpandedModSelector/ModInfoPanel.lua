
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local EMS_ModInfoPanel = ISPanelJoypad:derive("EMS_ModInfoPanel")

function EMS_ModInfoPanel:createChildren()
	local scrollBarWid = 13

	local panel = ModPosterPanel:new(0, 0, self.width - scrollBarWid, 360)
	panel:setAnchorRight(true)
	self:addChild(panel)
	self.posterPanel = panel

	panel = ModThumbnailPanel:new(0, self.posterPanel:getBottom() - 1, self.width - scrollBarWid, 80)
	panel:setAnchorRight(true)
	self:addChild(panel)
	self.thumbnailPanel = panel

	local buttonHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
	local buttonWid = 150

	local button1 = ISButton:new(self.width - scrollBarWid - 16 - buttonWid, panel:getBottom() + 24, buttonWid, buttonHgt, getText("UI_mods_ModEnable"), ModSelector.instance, ModSelector.onOptionMouseDown)
	button1.internal = "TOGGLE"
	button1:initialise()
	button1:instantiate()
	button1:setAnchorLeft(false)
	button1:setAnchorRight(true)
	button1:setAnchorTop(false)
	button1:setAnchorBottom(false)
	button1.borderColor = {r=1, g=1, b=1, a=0.1}
	self:addChild(button1)
	self.buttonToggle = button1

	local button3 = ISButton:new(16, panel:getBottom() + 24, buttonWid, buttonHgt, getText("UI_EMS_CopyLink"), ModSelector.instance, ModSelector.onOptionMouseDown)
	button3.internal = "COPY_LINK"
	button3:initialise()
	button3:instantiate()
	button3:setAnchorLeft(false)
	button3:setAnchorRight(true)
	button3:setAnchorTop(false)
	button3:setAnchorBottom(false)
	button3.borderColor = {r=1, g=1, b=1, a=0.1}
	self:addChild(button3)
	self.buttonCopyLink = button3

	local button2 = ISButton:new(button1.x - 20 - buttonWid, button1.y, buttonWid, buttonHgt, getText("UI_mods_ModOptions"), ModSelector.instance, ModSelector.onOptionMouseDown)
	button2.internal = "OPTIONS"
	button2:initialise()
	button2:instantiate()
	button2:setAnchorLeft(false)
	button2:setAnchorRight(true)
	button2:setAnchorTop(false)
	button2:setAnchorBottom(false)
	button2.borderColor = {r=1, g=1, b=1, a=0.1}
	button2:setEnable(false)
	button2:setVisible(false)
	self:addChild(button2)
	self.buttonOptions = button2

	local richText = ISRichTextLayout:new(self.width - scrollBarWid - 200)
	richText.defaultFont = UIFont.Medium
	self.richText = richText

	local infoRichText = ISRichTextLayout:new(180)
	self.infoRichText = infoRichText

	self.urlButton = ISButton:new(16, 0, self.width - scrollBarWid - 16 * 2, buttonHgt, getText("UI_mods_OpenWebBrowser"), ModSelector.instance, ModSelector.onOptionMouseDown)
	self.urlButton.internal = "URL"
	self.urlButton.url = ""
	self.urlButton:initialise()
	self.urlButton:instantiate()
	self.urlButton:setAnchorLeft(true)
	self.urlButton:setAnchorRight(true)
	self.urlButton:setAnchorTop(false)
	self.urlButton:setAnchorBottom(false)
	self.urlButton.borderColor = {r=1, g=1, b=1, a=0.1}
	self.urlButton:setEnable(false)
	self:addChild(self.urlButton)

	-- Copy buttons --
	self.copyLocationButton = ISButton:new(16, 0, buttonWid, buttonHgt, getText("UI_EMS_CopyLocation"), ModSelector.instance, ModSelector.onOptionMouseDown)
	self.copyLocationButton.internal = "COPY_LOCATION"
	self.copyLocationButton:initialise()
	self.copyLocationButton:instantiate()
	self.copyLocationButton:setAnchorLeft(true)
	self.copyLocationButton:setAnchorRight(true)
	self.copyLocationButton:setAnchorTop(false)
	self.copyLocationButton:setAnchorBottom(false)
	self.copyLocationButton.borderColor = {r=1, g=1, b=1, a=0.1}
	self.copyLocationButton:setEnable(true)
	self:addChild(self.copyLocationButton)

	self.copyIDButton = ISButton:new(self.copyLocationButton:getRight() + 16, 0, buttonWid, buttonHgt, getText("UI_EMS_CopyID"), ModSelector.instance, ModSelector.onOptionMouseDown)
	self.copyIDButton.internal = "COPY_ID"
	self.copyIDButton:initialise()
	self.copyIDButton:instantiate()
	self.copyIDButton:setAnchorLeft(true)
	self.copyIDButton:setAnchorRight(true)
	self.copyIDButton:setAnchorTop(false)
	self.copyIDButton:setAnchorBottom(false)
	self.copyIDButton.borderColor = {r=1, g=1, b=1, a=0.1}
	self.copyIDButton:setEnable(true)
	self:addChild(self.copyIDButton)

	self.copyWorkshopIDButton = ISButton:new(self.copyIDButton:getRight() + 16, 0, buttonWid, buttonHgt, getText("UI_EMS_CopyWorkshopID"), ModSelector.instance, ModSelector.onOptionMouseDown)
	self.copyWorkshopIDButton.internal = "COPY_WORKSHOP_ID"
	self.copyWorkshopIDButton:initialise()
	self.copyWorkshopIDButton:instantiate()
	self.copyWorkshopIDButton:setAnchorLeft(true)
	self.copyWorkshopIDButton:setAnchorRight(true)
	self.copyWorkshopIDButton:setAnchorTop(false)
	self.copyWorkshopIDButton:setAnchorBottom(false)
	self.copyWorkshopIDButton.borderColor = {r=1, g=1, b=1, a=0.1}
	self.copyWorkshopIDButton:setEnable(true)
	self:addChild(self.copyWorkshopIDButton)

	---
	local label = ISLabel:new(richText.marginLeft, 0, FONT_HGT_SMALL + 2 * 2, getText("UI_mods_Location"), 1.0, 1.0, 1.0, 1.0, UIFont.Small, true)
	label:setColor(0.7, 0.7, 0.7)
	self:addChild(label)
	self.locationLabel = label

	-- URL
	label = ISLabel:new(20, 6, FONT_HGT_SMALL + 2 * 2, "URL: ", 1.0, 1.0, 1.0, 1.0, UIFont.Small, true)
	label:setColor(0.8, 0.8, 0.8)
	self:addChild(label)
	self.URLLabel = label
	
	local entryX = self.locationLabel:getRight() + 6
	local entry = ISTextEntryBox:new("", entryX, 0, self.width - scrollBarWid - 16 - entryX, FONT_HGT_SMALL + 2 * 2)
	entry:setAnchorRight(true)
	self:addChild(entry)
	entry:setEditable(false)
	entry:setSelectable(true)
	self.locationEntry = entry

	local y = self.buttonToggle:getBottom() + 16
	self.locationLabel:setY(y)
	self.locationEntry:setY(y)
	self.copyLocationButton:setY(self.locationEntry:getBottom() + 24)
	self.copyIDButton:setY(self.locationEntry:getBottom() + 24)
	self.copyWorkshopIDButton:setY(self.locationEntry:getBottom() + 24)
	self.urlButton:setY(self.copyLocationButton:getBottom() + 24)
	self:setScrollHeight(self.urlButton:getBottom() + 20)
	self.URLLabel:setY(self.buttonToggle:getBottom() + 3)

    self:insertNewLineOfButtons(self.posterPanel)
    self:insertNewLineOfButtons(self.thumbnailPanel)
    self:insertNewLineOfButtons(self.buttonToggle)
    self.joypadIndexY = 1
    self.joypadIndex = 1
end

function EMS_ModInfoPanel:onMouseWheel(del)
	self:setYScroll(self:getYScroll() - (del * 40))
	return true
end

function EMS_ModInfoPanel:prerender()
	self:setStencilRect(0, 0, self:getWidth(), self:getHeight())
	ISPanelJoypad.prerender(self)
end

function EMS_ModInfoPanel:render()
	ISPanelJoypad.render(self)

	local x = 200
	local y = self.buttonToggle:getBottom() + 16
	self.richText:render(x, y, self)

	self.infoRichText:render(0, y, self)

    self:clearStencilRect()

	self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

	if self.joyfocus then
		self:drawRectBorder(0, -self:getYScroll(), self:getWidth(), self:getHeight(), 0.4, 0.2, 1.0, 1.0);
		self:drawRectBorder(1, 1-self:getYScroll(), self:getWidth()-2, self:getHeight()-2, 0.4, 0.2, 1.0, 1.0);
	end
end

function EMS_ModInfoPanel:setModInfo(modInfo)
	if modInfo == self.modInfo then return end
	self.modInfo = modInfo

	self.posterPanel:setModInfo(modInfo)
	self.thumbnailPanel:setModInfo(modInfo)

	local modInfoExtra = self.parent:readInfoExtra(modInfo:getId())
	if modInfoExtra.url ~= nil and modInfoExtra.url ~= "" then
		self.URLLabel:setName("URL: " .. modInfoExtra.url)
		self.buttonCopyLink:setEnable(true)
		self.buttonCopyLink.data = modInfoExtra.url
	else
		self.URLLabel:setName("")
		self.buttonCopyLink:setEnable(false)
	end

	local description = ""

	if modInfo:getDescription() ~= "" then
		description = description .. modInfo:getDescription()
		description = description .. " <LINE> "
		description = description .. " <LINE> "
	end

	self.richText:setText(description)
	self.richText:paginate()

	-- Info rich text update
	description = ""

	local needBlank = false

	if ModSelector.incompatible[modInfo:getId()] ~= nil then
		description = description .. " <TEXT> " .. "Incompatible with: <LINE> "
		for val, _ in pairs(ModSelector.incompatible[modInfo:getId()]) do
			if self.parent:getActiveMods():isModActive(val) then
				description = description .. " <ORANGE> " .. val .. " <LINE> "
			else
				print(val)
				description = description .. " <TEXT> " .. val .. " <LINE> "
			end
		end
		needBlank = true
	end

	if modInfo:getVersionMax() and modInfo:getVersionMax():isLessThan(getCore():getGameVersion()) then
		description = description .. " <RED> " .. getText("UI_mods_RequiredVersionMax", modInfo:getVersionMax():toString())
		description = description .. " <LINE> "
		needBlank = true
	end

	if modInfo:getVersionMin() and modInfo:getVersionMin():isGreaterThan(getCore():getGameVersion()) then
		description = description .. " <RED> " .. getText("UI_mods_RequiredVersionMin", modInfo:getVersionMin():toString())
		description = description .. " <LINE> "
		needBlank = true
	end

	if modInfo:getRequire() and not modInfo:getRequire():isEmpty() then
		if needBlank then
			description = description .. " <LINE> "
		end
		description = description .. " <TEXT> " .. getText("UI_mods_require")
		description = description .. " <LINE> <INDENT:20> "
		for i=1,modInfo:getRequire():size() do
			local modID = modInfo:getRequire():get(i-1)
			local modInfo1 = getModInfoByID(modID)
			if modInfo1 == nil then
				description = description .. " <RED> " .. modID
			elseif not modInfo1:isAvailable() then
				description = description .. " <RED> " .. modInfo1:getName()
			else
				description = description .. " <TEXT> " .. modInfo1:getName()
			end
			description = description .. " <LINE> "
		end
		description = description .. " <INDENT:0> "
		needBlank = true
	end

	if needBlank then
		description = description .. " <LINE> "
	end

	description = description .. " <TEXT> " .. getText("UI_mods_ID", modInfo:getId())
	description = description .. " <LINE> "

	if getSteamModeActive() and modInfo:getWorkshopID() then
		description = description .. getText("UI_WorkshopSubmit_ItemID") .. " " .. modInfo:getWorkshopID()
		description = description .. " <LINE> "
	end

	self.infoRichText:setText(description)
	self.infoRichText:paginate()

	local y = self.buttonToggle:getBottom() + 16 + math.max(self.richText:getHeight(), self.infoRichText:getHeight()) 
	self.locationLabel:setY(y)
	self.locationEntry:setY(y)
	self.locationEntry:setText(modInfo:getDir())
	self.copyLocationButton.data = modInfo:getDir()
	self.copyIDButton.data = modInfo:getId()
	
	local workshopID = modInfo:getWorkshopID()
	if workshopID == nil or workshopID == "" then
		self.copyWorkshopIDButton:setEnable(false)
	else
		self.copyWorkshopIDButton:setEnable(true)
		self.copyWorkshopIDButton.data = workshopID
	end

	self.copyLocationButton:setY(self.locationEntry:getBottom() + 12)
	self.copyIDButton:setY(self.locationEntry:getBottom() + 12)
	self.copyWorkshopIDButton:setY(self.locationEntry:getBottom() + 12)
	self.urlButton:setY(self.copyLocationButton:getBottom() + 12)
	self:setScrollHeight(self.urlButton:getBottom() + 20)
end

function EMS_ModInfoPanel:onJoypadDirLeft(joypadData)
	self.parent.listbox:setJoypadFocused(true, joypadData)
end

function EMS_ModInfoPanel:onLoseJoypadFocus(joypadData)
	self:clearJoypadFocus()
	ISPanelJoypad.onLoseJoypadFocus(self, joypadData)
end

function EMS_ModInfoPanel:onJoypadBeforeDeactivate(joypadData)
	self.parent:onJoypadBeforeDeactivate(joypadData)
end

function EMS_ModInfoPanel:new(x, y, width, height)
	local o = ISPanelJoypad.new(self, x, y, width, height)
	o.backgroundColor.a = 1.0
	return o
end

return EMS_ModInfoPanel