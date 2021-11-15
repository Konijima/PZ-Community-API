
---@class ModSettingHorizontalLine
local ModSettingHorizontalLine = ISPanel:derive("ModSettingHorizontalLine")

function ModSettingHorizontalLine:prerender()
end

function ModSettingHorizontalLine:render()
	self:drawRect(0, 0, self.width, 1, 1.0, 0.5, 0.5, 0.5)
end

function ModSettingHorizontalLine:new(x, y, width)
	local o = ISPanel.new(self, x, y, width, 2)
	return o
end

return ModSettingHorizontalLine