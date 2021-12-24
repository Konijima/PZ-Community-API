require("CommunityAPI")
local MoodleAPI = CommunityAPI.Client.Moodle

local Moodle = {}
Moodle.__index = Moodle

---@param name string
---@param texturePath string
---@param moodleType string  MoodleAPI.Type
---@param labelName string  (MoodleAPI will add at the end to this string level num)
---@param descriptionName string  (MoodleAPI will add at the end to this string level num)
---@param getLevelFunc function  Get moodle value (from 0.0 to 1.0) and return level (from 0 to 4)
---@param value number
---@return table
function Moodle:new(name, texturePath, moodleType, labelName, descriptionName, getLevelFunc, value)
    local o = {}
	setmetatable(o, self)
	self.__index = self
    
    o.name = name
    o.type = moodleType
    o.value = value
    o.getLevelFunc = getLevelFunc
    o.tex = getTexture(texturePath)
    o.labelName = labelName
    o.descriptionName = descriptionName

    return o
end

---Get level of moodle 
---@return number  (from 0 to 4)
function Moodle:getLevel()
    return self.getLevelFunc(self.value)
end

---Set moodle value
---@param val number  (from 0.0 to 1.0)
function Moodle:setValue(val)
    if val > 1.0 then val = 1 end
    if val < 0 then val = 0 end
    self.value = val
end

---Get moodle value
---@return number  (from 0.0 to 1.0)
function Moodle:getValue()
    return self.value
end

MoodleAPI.Moodle = Moodle