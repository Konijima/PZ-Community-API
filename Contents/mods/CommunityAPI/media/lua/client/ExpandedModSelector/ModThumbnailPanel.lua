require("OptionsScreens/ModSelector")

local EMS_ModThumbnailPanel = ISPanelJoypad:derive("EMS_ModThumbnailPanel")

function EMS_ModThumbnailPanel:render()
	ISPanelJoypad.render(self)

	if self.modInfo and (self.modInfo:getPosterCount() > 0) then
		self.index = math.max(self.index, 1)
		self.index = math.min(self.index, self.modInfo:getPosterCount())
		local left = 1
		local top = 1
		local alpha = 1.0

		local width = self.thumbnailWidth
		local height = self.thumbnailHeight
		local x = 0
		local y = 0
		for i=1,self.modInfo:getPosterCount() do
			local tex = getTexture(self.modInfo:getPoster(i-1)) or Texture:getWhite()
			if tex == Texture.getWhite() then alpha = 0.1 end
			self:drawRect(x + self.padX, y + self.padY, width, height, 1, 0.1, 0.1, 0.1)
			self:drawTextureScaledAspect(tex, x + self.padX, y + (self.height - height) / 2, width, height, alpha, 1, 1, 1)

			if not self.pressed and self:isMouseOver() and self:getIndexAt(self:getMouseX(), self:getMouseY()) + 1 == i then
				self:drawRectBorder(x + self.padX - 2, y + self.padY - 2, width + 4, height + 4, 1, 0.5, 0.5, 0.5)
			end
			
			x = x + self.padX + width
		end

		if x > self.width then
			self:setXScroll(math.min(self:getXScroll(), 0))
			self:setXScroll(math.max(self:getXScroll(), -(x - self.width)))
		else
			self:setXScroll(0)
		end
	end
end

function EMS_ModThumbnailPanel:onMouseDown(x, y)
	self.index = self:getIndexAt(x, y) + 1
	self.pressed = true
end

function EMS_ModThumbnailPanel:onMouseUp(x, y)
	self.pressed = false
end

function EMS_ModThumbnailPanel:onMouseUpOutside(x, y)
	self.pressed = false
end

function EMS_ModThumbnailPanel:onMouseMove(dx, dy)
	if self.pressed then
		self:setXScroll(self:getXScroll() + dx)
	end
end

function EMS_ModThumbnailPanel:onMouseMoveOutside(dx, dy)
	if self.pressed then
		self:onMouseMove(dx, dy)
	end
end

function EMS_ModThumbnailPanel:getIndexAt(x, y)
	if not self.modInfo or self.modInfo:getPosterCount() == 0 then
		return -1
	end
	local index = (x - 5) / (self.thumbnailWidth + 10)
	index = math.floor(index)
	if index >= self.modInfo:getPosterCount() then
		return -1
	end
	return index
end

function EMS_ModThumbnailPanel:setJoypadFocused(focused)
end

function EMS_ModThumbnailPanel:setModInfo(modInfo)
	self.modInfo = modInfo
end

function EMS_ModThumbnailPanel:new(x, y, width, height)
	local o = ISPanelJoypad.new(self, x, y, width, height)
	o.padX = 10
	o.padY = 8
	o.thumbnailWidth = 116
	o.thumbnailHeight = height - o.padY * 2 -- 64
	o.index = 1
	return o
end

return EMS_ModThumbnailPanel