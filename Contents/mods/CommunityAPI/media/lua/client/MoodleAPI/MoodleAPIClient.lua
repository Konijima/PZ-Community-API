---@class MoodleAPI
local MoodleAPI = {}
MoodleAPI.MoodleList = {}
MoodleAPI.Type = {}
MoodleAPI.Type.Neutral = "NEUTRAL"
MoodleAPI.Type.Good = "GOOD"
MoodleAPI.Type.Bad = "BAD"

---Adds Moodle for main player. Not correct work in splitscreen.
---@param moodleName string
---@param texturePath string
---@param moodleType any  MoodleAPI.Type
---@param labelName string  (MoodleAPI will add at the end to this string level num)
---@param descriptionName string  (MoodleAPI will add at the end to this string level num)
---@param getLevelFunc function  Get moodle value (from 0.0 to 1.0) and return level (from 0 to 4)
function MoodleAPI.AddMoodle(moodleName, texturePath, moodleType, labelName, descriptionName, getLevelFunc)
    MoodleAPI.MoodleList[moodleName] = { name = moodleName, ["texturePath"] = texturePath, type = moodleType, descr = descriptionName, label = labelName, ["getLevelFunc"] = getLevelFunc }
end

return MoodleAPI