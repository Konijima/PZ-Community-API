require("CommunityAPI")
local MoodleAPI = CommunityAPI.Client.Moodle

---@class MoodleManager
local MoodleManager = {}
MoodleManager.__index = MoodleManager

---@param moodlesData table  Table with moodle data
---@return table
function MoodleManager:new(moodlesData)
    local o = {}
	setmetatable(o, self)
	self.__index = self
    
    o.UI = nil
    o.moodles = {}

    for moodName, data in pairs(MoodleAPI.MoodleList) do
        local val = 0
        if moodlesData[moodName] ~= nil then
            val = moodlesData[moodName]
        end
        o.moodles[moodName] = MoodleAPI.Moodle:new(data.name, data.texturePath, data.type, data.label, data.descr, data.getLevelFunc, val)
    end

    return o
end

---Adds MoodlesUI for MoodleManager
---@param defaultMoodles table  Default java Moodles obj
---@param x number
---@param y number
function MoodleManager:addRender(defaultMoodles, x, y)
    self.UI = MoodleAPI.MoodlesUI:new(x, y, self.moodles, defaultMoodles)  
    self.UI:initialise() 
    self.UI:addToUIManager()
end

---Return moodle obj
---@param moodleName string
---@return any Moodle
function MoodleManager:getMoodle(moodleName)
    return self.moodles[moodleName]
end


MoodleAPI.MoodleManager = MoodleManager