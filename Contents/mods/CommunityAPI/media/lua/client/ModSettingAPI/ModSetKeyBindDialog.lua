
---@class ModSetKeyBindDialog
ModSetKeyBindDialog = ISPanel:derive("ModSetKeyBindDialog")

function ModSetKeyBindDialog:createChildren()
	local btnWid = 200
	local btnHgt = 40
	local pad = 10
	local buttonsHgt = btnHgt * 3 + pad * 2

	local fontHgt = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
	local actionName = getText(self.keybindName):trim()
	local text = getText("UI_optionscreen_pressKeyToBind", actionName)
	local label = ISLabel:new(self.width / 2, 20, fontHgt, text:gsub("\\n", "\n"):gsub("\\\"", "\""), 1, 1, 1, 1, UIFont.Medium, true)
	label.center = true
	label:initialise()
	self:addChild(label)

	local labelBottom = label:getY() + fontHgt * 2
	local btnY = labelBottom + (self.height - labelBottom - buttonsHgt) / 2

	self.cancel = ISButton:new((self:getWidth() - btnWid) / 2, btnY,
		btnWid, btnHgt, getText("UI_Cancel"), self, self.onCancel)
	self.cancel:initialise()
	self.cancel:instantiate()
	self.cancel.borderColor = {r=1, g=1, b=1, a=0.1}
	self:addChild(self.cancel)
end

function ModSetKeyBindDialog:destroy()
	self:setVisible(false)
	self:removeFromUIManager()
	GameKeyboard.setDoLuaKeyPressed(true)
end

function ModSetKeyBindDialog:onCancel()
	self:destroy()
end

function ModSetKeyBindDialog:isKeyConsumed(key)
	return true
end

function ModSetKeyBindDialog:onKeyRelease(key)
	ModSetKeyBindDialog.keyPressHandler(self, key)
end

function ModSetKeyBindDialog.keyPressHandler(self, key)
	self.onAccept(key)
	self:destroy()
end

function ModSetKeyBindDialog:new(keybindName)
	local width = 500
	local height = 300
	local x = (getCore():getScreenWidth() - width) / 2
	local y = (getCore():getScreenHeight() - height) / 2
	local o = ISPanel:new(x, y, width, height)
	o.backgroundColor.a = 0.9
	setmetatable(o, self)
	self.__index = self
	o.keybindName = keybindName
	o:setWantKeyEvents(true)
	return o
end

