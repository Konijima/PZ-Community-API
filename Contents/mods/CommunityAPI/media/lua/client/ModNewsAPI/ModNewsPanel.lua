require("CommunityAPI")
local ModNewsAPI = CommunityAPI.Client.ModNews
local JsonAPI = CommunityAPI.Utils.Json

local ModNewsPanel = ISPanelJoypad:derive("ModNewsPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function ModNewsPanel:createChildren()
	self.modListBox = ISScrollingListBox:new(25, 50, self.width*0.2, self.height - 100)
    self.modListBox:initialise()
    self.modListBox:instantiate()
    self.modListBox:setFont(UIFont.Medium, 2)
    self.modListBox:setAnchorLeft(true)
    self.modListBox:setAnchorRight(true)
    self.modListBox:setAnchorTop(true)
    self.modListBox:setAnchorBottom(true)
    self.modListBox.doDrawItem = self.modListBoxItemDraw
    self.modListBox.drawBorder = true
	self.modListBox:setOnMouseDownFunction(self, self.onModListClick)
    self:addChild(self.modListBox)

    local lWid = getTextManager():MeasureStringX(UIFont.Medium, getText("UI_NewGame_Mods"))
    self.modsLabel = ISLabel:new(25 + self.modListBox.width/2 - lWid/2, 16, FONT_HGT_MEDIUM, getText("UI_NewGame_Mods"), 1, 1, 1, 1, UIFont.Medium, true)
	self.modsLabel:initialise()
	self.modsLabel:instantiate()
	self:addChild(self.modsLabel)

	self.modArticleList = ISScrollingListBox:new(self.modListBox:getRight() + 25, 50, self.width*0.2, self.height - 100)
    self.modArticleList:initialise()
    self.modArticleList:instantiate()
    self.modArticleList:setFont(UIFont.Medium, 2)
    self.modArticleList:setAnchorLeft(true)
    self.modArticleList:setAnchorRight(true)
    self.modArticleList:setAnchorTop(true)
    self.modArticleList:setAnchorBottom(true)
    self.modArticleList.doDrawItem = self.modArticleItemDraw
    self.modArticleList.drawBorder = true
	self.modArticleList:setOnMouseDownFunction(self, self.onArcticleListClick)
    self:addChild(self.modArticleList)

    lWid = getTextManager():MeasureStringX(UIFont.Medium, getText("UI_modNews_articleLabel"))
    self.articleLabel = ISLabel:new(self.modArticleList:getX() + self.modArticleList.width/2 - lWid/2, 16, FONT_HGT_MEDIUM, getText("UI_modNews_articleLabel"), 1, 1, 1, 1, UIFont.Medium, true)
	self.articleLabel:initialise()
	self.articleLabel:instantiate()
	self:addChild(self.articleLabel)

	local buttonHgt = FONT_HGT_SMALL + 3 * 2
    self.backButton = ISButton:new(16, self.height - 10 - buttonHgt, 100, buttonHgt, getText("UI_btn_back"), self, self.onOptionMouseDown)
	self.backButton.internal = "BACK"
	self.backButton:initialise()
	self.backButton:instantiate()
	self.backButton:setAnchorLeft(true)
	self.backButton:setAnchorTop(false)
	self.backButton:setAnchorBottom(true)
	self.backButton.borderColor = {r=1, g=1, b=1, a=0.1}
	self:addChild(self.backButton)

    self.articleText = ISRichTextPanel:new(self.modArticleList:getRight() + 50, 0, self.width - self.modArticleList:getRight() - 50, self.height)
    self.articleText.marginRight = self.articleText.marginLeft
    self.articleText:initialise()
    self:addChild(self.articleText)
    self.articleText:addScrollBars()

    self.articleText.background = false
    self.articleText.clip = true
    self.articleText.autosetheight = false
    self.articleText.text = ""
    self.articleText:paginate()

	self:populateModList()
end

function ModNewsPanel:onModListClick()
    self:populateArticleList()
end

function ModNewsPanel:onArcticleListClick()
    local item = self.modArticleList.items[self.modArticleList.selected].item
    self:updateSettingView(item)
    ModNewsAPI.SetArticleAsViewed(item.modID, item.articleName)
end

function ModNewsPanel:updateSettingView(item)
    self.articleText.text = getText(item.articleTextName)
    self.articleText:paginate()
end

function ModNewsPanel:populateArticleList()
    local item = self.modListBox.items[self.modListBox.selected].item
    self.modArticleList:clear()

    for articleName, data in pairs(item) do
        self.modArticleList:addItem(articleName, data)
    end
end

function ModNewsPanel:populateModList()
	self.modListBox:clear()

    local Data = ModNewsAPI.GetAll()
    for modID, modArticleData in pairs(Data) do
        local modInfo = getModInfoByID(modID)
        if modInfo == nil then
            self.modListBox:addItem("IncorrectModID - " .. modID, modArticleData)
        else
            self.modListBox:addItem(modInfo:getName(), modArticleData)
        end
    end
end

function ModNewsPanel:modListBoxItemDraw(y, item)
	local dy = (self.itemheight - FONT_HGT_MEDIUM) / 2
    self:drawText(item.text, 16, y + dy, 1, 1, 1, 1, UIFont.Medium)
    self:drawRectBorder(0, y, self:getWidth(), self.itemheight, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    
    for _, data in pairs(item.item) do
        local article = ModNewsAPI.GetArticle(data.modID, data.articleName)
        if article and article.isViewed == false then
            self:drawText("[!!!]", self.width - 50, y + dy, 0, 1, 0, 1, UIFont.Medium)
        end
    end
    return y + self.itemheight
end

function ModNewsPanel:modArticleItemDraw(y, item)
    local dy = (self.itemheight - FONT_HGT_MEDIUM) / 2
	self:drawText(item.text, 16, y + dy, 1, 1, 1, 1, UIFont.Medium)
	self:drawRectBorder(0, y, self:getWidth(), self.itemheight, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    local article = ModNewsAPI.GetArticle(item.item.modID, item.item.articleName)
    if article and article.isViewed == false then
        self:drawText("[!!!]", self.width - 50, y + dy, 0, 1, 0, 1, UIFont.Medium)
    end

    return y + self.itemheight
end

function ModNewsPanel:onOptionMouseDown(button, x, y)
	if button.internal == "BACK" then
		self:setVisible(false)
        self:removeFromUIManager()

        local Data = ModNewsAPI.GetAll()
        local fileWriter = getFileWriter("CAPI_modNewsData.txt", true, false)
        fileWriter:write(JsonAPI.Encode(Data))
        fileWriter:close()
	end
end

function ModNewsPanel:instantiate()
	self.javaObject = UIElement.new(self)
	self.javaObject:setX(self.x)
	self.javaObject:setY(self.y)
	self.javaObject:setHeight(self.height)
	self.javaObject:setWidth(self.width)
	self.javaObject:setAnchorLeft(self.anchorLeft)
	self.javaObject:setAnchorRight(self.anchorRight)
	self.javaObject:setAnchorTop(self.anchorTop)
	self.javaObject:setAnchorBottom(self.anchorBottom)
	self:createChildren()
end

function ModNewsPanel:new(x, y, width, height)
	local o = {}
	o = ISPanelJoypad:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self

	o.backgroundColor = {r=0, g=0, b=0, a=0.0}
	o.borderColor = {r=1, g=1, b=1, a=0.0}
	o.itemheightoverride = {}
	o.anchorLeft = true
	o.anchorRight = false
	o.anchorTop = true
	o.anchorBottom = false
	o.colorPanel = {}

	return o
end

return ModNewsPanel
