require("OptionsScreens/ModSelector")

local EMS_ModPosterPanel = ISPanelJoypad:derive("EMS_ModPosterPanel")

function EMS_ModPosterPanel:render()
	ISPanelJoypad.render(self)

	if self.modInfo and (self.modInfo:getPosterCount() > 0) then
		local index = self.parent.thumbnailPanel.index
		index = math.max(index, 1)
		index = math.min(index, self.modInfo:getPosterCount())
		local texName = self.modInfo:getPoster(index - 1)
		local tex = texName and getTexture(texName) or Texture.getWhite()
		local left = 1
		local top = 1
		local alpha = 1.0
		if tex == Texture.getWhite() then alpha = 0.1 end
		local scrollBarWid = (self:getScrollHeight() > self.height) and self.vscroll:getWidth() or 0
		self:drawTextureScaledAspect(tex, left, top, self.width - scrollBarWid - left, self.height - 1 - top, alpha, 1, 1, 1)
	end
end

function EMS_ModPosterPanel:setJoypadFocused(focused)
end

function EMS_ModPosterPanel:setModInfo(modInfo)
	self.modInfo = modInfo
end

function EMS_ModPosterPanel:new(x, y, width, height)
	local o = ISPanelJoypad.new(self, x, y, width, height)
	return o
end

return EMS_ModPosterPanel