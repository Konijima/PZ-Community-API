require("OptionsScreens/ModSelector")

local FONT_HGT_TITLE = getTextManager():getFontHeight(UIFont.Title)
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

local MAP_ICON = getTexture("media/ui/ExpandedModSelector/MapIcon.png")
local DEFAULT_ICON = getTexture("media/ui/ExpandedModSelector/DefaultIcon.png")

local _ModListBox = ISScrollingListBox:derive("_ModListBox")

function _ModListBox:onMouseDown(x, y)
	-- stop you from changing mods while in mod order UI
	if not self.parent.modorderui or not self.parent.modorderui:isVisible() then
		if #self.items == 0 then return end
		local row = self:rowAt(x, y)
		if row > #self.items then
			row = #self.items
		end
		if row < 1 then
			row = 1
		end
		getSoundManager():playUISound("UISelectListItem")
		if self.mouseOverButton then
			self.parent:forceActivateMods(self.mouseOverButton.item.modInfo, not self.parent:isModActive(self.mouseOverButton.item.modInfo));
			self.parent.savedPresets.selected = 1
			self.parent.modsWasChanged = true
		else
			self.selected = row
		end
	end
end

function _ModListBox:doDrawItem(y, item, alt)
	if item.item.visible == nil then return y end

	local modInfo = item.item.modInfo
	local tex = nil;
	local isMouseOver = self.mouseoverselected == item.index

	if self.selected == item.index then
		self:drawRect(0, (y), self:getWidth(), item.height-1, 0.3, 0.7, 0.35, 0.15);
	elseif isMouseOver and not self:isMouseOverScrollBar() then
		self:drawRect(1, y + 1, self:getWidth() - 2, item.height - 2, 0.95, 0.05, 0.05, 0.05);
	end

	-- border over text and description
	self:drawRectBorder(0, (y), self:getWidth(), item.height-1, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b);

	-- icon
	local icon = item.item.modInfoExtra.icon
	if item.item.modInfoExtra.isMap and icon == nil then 
		icon = MAP_ICON
	end
	if icon == nil then
		icon = DEFAULT_ICON
	end
	self:drawTextureScaled(icon, 10, y+10, FONT_HGT_MEDIUM, FONT_HGT_MEDIUM, 1)
	--

	local isIncompatible = false
	local r,g,b,a = 0.9, 0.9, 0.9, 0.9
	if self.parent:isModActive(modInfo) then
		r,g,b = 0.3, 0.9, 0.3

		if self.parent:isModIncompatible(modInfo:getId()) then
			r,g,b = 0.9, 0.5, 0.1
			isIncompatible = true
		end
	end

	if not modInfo:isAvailable() then
		r = 9.0
		g = 0.0
		b = 0.0
	end
	self:drawText(modInfo:getName(), 10 + FONT_HGT_MEDIUM + 10, y + 10, r, g, b, a, UIFont.Medium);

	local itemHgt = 10 + FONT_HGT_MEDIUM + 10

	local textDisabled = getText("UI_mods_ModDisabled")
	local textEnabled = getText("UI_mods_ModEnabled")
	local textDisabledWid = getTextManager():MeasureStringX(UIFont.Small, textDisabled)
	local textEnabledWid = getTextManager():MeasureStringX(UIFont.Small, textEnabled)
	local buttonWid = 8 + math.max(textEnabledWid, textDisabledWid) + 8
	local buttonHgt = FONT_HGT_MEDIUM
	local scrollBarWid = self:isVScrollBarVisible() and 13 or 0
	local buttonX = self.width - 16 - scrollBarWid - buttonWid
	local buttonY = y + 10
	local isMouseOverButton = isMouseOver and ((self:getMouseX() > buttonX - 16) and (self:getMouseX() < self.width - scrollBarWid) and (self:getMouseY() < buttonY + buttonHgt + 16))
	local isJoypadSelected = self.parent.hasJoypadFocus and self.selected == item.index
	
	if self.parent:isModActive(modInfo) then
		if isMouseOverButton then
			if isIncompatible then
				self:drawRect(buttonX, buttonY, buttonWid, buttonHgt, 1, 0.9, 0.5, 0.1)
			else
				self:drawRect(buttonX, buttonY, buttonWid, buttonHgt, 1, 0, 0.85, 0)
			end
			
			self.mouseOverButton = item
		else
			if isIncompatible then
				self:drawRect(buttonX, buttonY, buttonWid, buttonHgt, 1, 0.9, 0.5, 0.1)
			else
				self:drawRect(buttonX, buttonY, buttonWid, buttonHgt, 1, 0, 0.70, 0)
			end
		end
		self:drawTextCentre(textEnabled, buttonX +  buttonWid / 2, buttonY + (buttonHgt - FONT_HGT_SMALL) / 2 , 0, 0, 0, 1)
	elseif (isMouseOver and not self:isMouseOverScrollBar() or isJoypadSelected) and modInfo:isAvailable() then
		local rgb = (isMouseOverButton or isJoypadSelected) and 0.5 or 0.2
		self:drawRect(buttonX, buttonY, buttonWid, buttonHgt, 1, rgb, rgb, rgb)
		self:drawTextCentre(textDisabled, buttonX + buttonWid / 2, buttonY + (buttonHgt - FONT_HGT_SMALL) / 2 , 0, 0, 0, 1)
		self.mouseOverButton = isMouseOverButton and item or nil
	end

	if not modInfo:isAvailable() then
		local tex = ModSelector.instance.cantTexture
		self:drawTexture(tex, self.width - 16 - scrollBarWid - tex:getWidth(), y + (item.height - tex:getHeight()) / 2, 1, 1, 1, 1);
	end

	if self.parent.hasJoypadFocus and modInfo:isAvailable() and (self.selected == item.index) then
		local fontHgt = FONT_HGT_SMALL
		local tex = self.parent.abutton
		self:drawTextureScaled(tex, buttonX - 8 - buttonHgt, buttonY, buttonHgt, buttonHgt, 1,1,1,1)
	end
	
	y = y + itemHgt;

	return y;
end

function _ModListBox:onJoypadDirRight(joypadData)
	self:setJoypadFocused(false, joypadData)
	joypadData.focus = self.parent.infoPanel
	updateJoypadFocus(joypadData)
end

function _ModListBox:onJoypadBeforeDeactivate(joypadData)
	self.parent:onJoypadBeforeDeactivate(joypadData)
end

function _ModListBox:new(x, y, width, height)
	local o = ISScrollingListBox.new(self, x, y, width, height)
	return o
end

----- Filter functions -----

function _ModListBox:checkFilter(item)
	local filterEntry = self.parent.filterEntry
	local modInfo = item.modInfo
	local modInfoExtra = item.modInfoExtra

	-- ComboBox filter
	if self.parent.chooseModCatComboBox.selected == 1 then
	elseif self.parent.chooseModCatComboBox.selected == 2 then
		if not modInfoExtra.isMap then return false end
	elseif self.parent.chooseModCatComboBox.selected == 3 then
		if not item.isActive then return false end
	end

	-- Entry filter
	local keyWord = filterEntry:getInternalText() or ""
	if keyWord == "" then return true end

	if string.find(string.lower(modInfo:getName()), string.lower(keyWord), 1, true) ~= nil then return true end
	if string.find(string.lower(modInfo:getId()), string.lower(keyWord), 1, true) ~= nil then return true end
	if modInfo:getWorkshopID() ~= nil and string.find(string.lower(modInfo:getWorkshopID()), string.lower(keyWord), 1, true) ~= nil then return true end

	return false
end

function _ModListBox:updateFilter()
	for _, i in ipairs(self.items) do
		local item = i.item

		if self:checkFilter(item) then
			item.visible = true
		else
			item.visible = nil
		end
	end
end

return _ModListBox