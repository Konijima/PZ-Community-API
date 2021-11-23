require("CommunityAPI")
local MoodleAPI = CommunityAPI.Client.Moodle

local MoodlesUI = ISUIElement:derive("MoodlesUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function MoodlesUI:render()
    local y = self:getNumOfActiveMoodles()*36
    local dx = 0
    for _, moodleObj in pairs(self.moodles) do
        -- If too many moodles - draw them in second column
        if y > 36 * 15 then
            y = 0
            dx = -40
        end
        local lvl = moodleObj:getLevel()
        if lvl > 0 then
            local x = self:getToggleX(moodleObj.name, lvl) + dx
            if moodleObj.type == MoodleAPI.Type.Neutral then
                self:drawTexture(self.tex_Bkg_Neutral, x, y, 1, 1, 1, 1)
            elseif moodleObj.type == MoodleAPI.Type.Good then                
                self:drawTexture(self["tex_Bkg_Good" .. lvl], x, y, 1, 1, 1, 1)
            else
                self:drawTexture(self["tex_Bkg_Bad" .. lvl], x, y, 1, 1, 1, 1)
            end
            self:drawTexture(moodleObj.tex, x, y+1, 1, 1, 1, 1)
            if self:isMouseOverCustomMoodle(self.x + x, self.y + y) then
                local descrWid = getTextManager():MeasureStringX(UIFont.Small, getText(moodleObj.descriptionName .. lvl))
                local lableWid = getTextManager():MeasureStringX(UIFont.Small, getText(moodleObj.labelName .. lvl))
                self:drawRect(x - (descrWid + 12 + 6), y, descrWid + 12, 32, 0.6, 0, 0, 0)
                self:drawText(getText(moodleObj.labelName .. lvl), x - 12 - lableWid, y + 2, 1, 1, 1, 1)
                self:drawText(getText(moodleObj.descriptionName .. lvl), x - descrWid - 12, y + 32 - 2 - FONT_HGT_SMALL, 1, 1, 1, 1)
            end
            
            y = y + 40
        end
    end
end

function MoodlesUI:isMouseOverCustomMoodle(x, y)
    if getMouseX() > x and getMouseX() < x + 32 and getMouseY() > y and getMouseY() < y + 32 then
        return true
    end
    return false
end

function MoodlesUI:getNumOfActiveMoodles()
    local res = 0
    for i=0, self.defaultMoodles:getNumMoodles()-1 do
        if self.defaultMoodles:getMoodleLevel(i) > 0 then
            res = res + 1
        end
    end
    return res
end

function MoodlesUI:getToggleX(name, lvl)
    local x = 0
    if lvl ~= self.lastLevels[name] then
        self.lastLevels[name] = lvl
        self.toggleData[name].isToggle = true
        self.toggleData[name].toggleImpulse = -2
    end
    if self.toggleData[name].isToggle then
        x = self.toggleData[name].lastX + self.toggleData[name].toggleImpulse
        if x < -5 or x > 5 then
            self.toggleData[name].toggleImpulse = self.toggleData[name].toggleImpulse * (-0.8)
        end
        if math.abs(self.toggleData[name].toggleImpulse) < 0.2 then
            self.toggleData[name].isToggle = false
            self.toggleData[name].toggleImpulse = 0
        end
    end
    if not self.toggleData[name].isToggle and math.abs(self.toggleData[name].lastX) >= 0.5 then
        if self.toggleData[name].lastX > 0 then
            x = -0.5 + self.toggleData[name].lastX
        else
            x = 0.5 + self.toggleData[name].lastX
        end
    end
    self.toggleData[name].lastX = x
    return x
end

function MoodlesUI:new(x, y, moodles, defaultMoodles)
	local o = {}
	o = ISUIElement:new(x, y, 0, 720);
    setmetatable(o, self)
    self.__index = self
	o.x = x;
	o.y = y;
    o.width = 0;
	o.height = 720;
	o.anchorLeft = true;
	o.anchorRight = true;
	o.anchorTop = true;
	o.anchorBottom = true;

    o.moodles = moodles
    o.defaultMoodles = defaultMoodles
    o.lastLevels = {}
    o.toggleData = {}
    for _, moodleObj in pairs(o.moodles) do
        o.lastLevels[moodleObj.name] = moodleObj:getLevel()
        o.toggleData[moodleObj.name] = { isToggle = false, toggleImpulse = 0, lastX = 0 }
    end

    o.tex_Bkg_Neutral = getTexture("media/ui/Moodle_Bkg_Bad_1.png")
    o.tex_Bkg_Bad1 = getTexture("media/ui/Moodle_Bkg_Bad_1.png")
    o.tex_Bkg_Bad2 = getTexture("media/ui/Moodle_Bkg_Bad_2.png")
    o.tex_Bkg_Bad3 = getTexture("media/ui/Moodle_Bkg_Bad_3.png")
    o.tex_Bkg_Bad4 = getTexture("media/ui/Moodle_Bkg_Bad_4.png")
    o.tex_Bkg_Good1 = getTexture("media/ui/Moodle_Bkg_Good_1.png")
    o.tex_Bkg_Good2 = getTexture("media/ui/Moodle_Bkg_Good_2.png")
    o.tex_Bkg_Good3 = getTexture("media/ui/Moodle_Bkg_Good_3.png")
    o.tex_Bkg_Good4 = getTexture("media/ui/Moodle_Bkg_Good_4.png")
    return o
end

MoodleAPI.MoodlesUI = MoodlesUI