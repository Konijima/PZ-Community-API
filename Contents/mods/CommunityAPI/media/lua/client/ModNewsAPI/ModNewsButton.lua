require("CommunityAPI")
local ModNewsAPI = CommunityAPI.Client.ModNews

local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

local function renderModNewsButton(self)
    ISButton.render(self)
    
    local isNewArticles = false
    for _, modData in pairs(ModNewsAPI.Data) do
        for _, articleData in pairs(modData) do
            if articleData.isViewed == false then
                isNewArticles = true
            end
        end
    end

    if isNewArticles then
        local x = - self.notifyIcon:getWidthOrig()/2 + self.width
        local y = - self.notifyIcon:getHeightOrig()/2 - 2
        self:drawTexture(self.notifyIcon, x, y, 1, 1, 1, 1)
    end
end

local function onClickModNews(self)
    local w = self.width * 0.8
    local h = self.height * 0.8
    local modNewsPanel = ModNewsPanel:new((self.width - w)/2, (self.height - h)/2, w, h)
    modNewsPanel.backgroundColor = {r=0, g=0, b=0, a=0.95}
	modNewsPanel.borderColor = {r=1, g=1, b=1, a=0.5}
    modNewsPanel:initialise()
    modNewsPanel:instantiate()
    modNewsPanel:setCapture(true)
    modNewsPanel:setAlwaysOnTop(true)
    modNewsPanel:setAnchorRight(true)
	modNewsPanel:setAnchorLeft(true)
	modNewsPanel:setAnchorBottom(true)
	modNewsPanel:setAnchorTop(true)
    modNewsPanel:addToUIManager()
end

-- Hook
local defaultMainScreen_instantiate = MainScreen.instantiate
function MainScreen:instantiate()
    defaultMainScreen_instantiate(self)

    self.modNewsDetail = ISButton:new(self.width - 40 - 400, self.height - FONT_HGT_MEDIUM - 20, 120, FONT_HGT_MEDIUM + 1 * 2, getText("UI_modNews_button"), self, onClickModNews)
    self.modNewsDetail.font = UIFont.Medium
    self.modNewsDetail:initialise()
    self.modNewsDetail.borderColor = {r=1, g=1, b=1, a=0.7}
    self.modNewsDetail.textColor =  {r=1, g=1, b=1, a=0.7}
    self:addChild(self.modNewsDetail)
    self.modNewsDetail:setAnchorLeft(false)
    self.modNewsDetail:setAnchorTop(false)
    self.modNewsDetail:setAnchorRight(true)
    self.modNewsDetail:setAnchorBottom(true)
    self.modNewsDetail.notifyIcon = getTexture("media/ui/ModNews/notifyIcon.png")
    self.modNewsDetail.render = renderModNewsButton
end

-- Hook
local defaultMainScreen_setBottomPanelVisible = MainScreen.setBottomPanelVisible
function MainScreen:setBottomPanelVisible(visible)
    defaultMainScreen_setBottomPanelVisible(self, visible)
    if self.parent and self.parent.modNewsDetail then
        self.parent.modNewsDetail:setVisible(visible)
    end
end