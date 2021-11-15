require("CommunityAPI")
require("ISBaseObject")

local StringUtils = CommunityAPI.Utils.String

local DEBUG = getCore():getDebug()

---@class WorldSoundObject
local WorldSoundObject = ISBaseObject:derive("WorldSoundObject")

function WorldSoundObject:isPlaying()
    return self.audio ~= nil and self.soundEmitter:isPlaying(self.audio)
end

function WorldSoundObject:update()
    if self.completed then return false; end

    self.soundEmitter:tick()

    if self.audio == nil or not self.soundEmitter:isPlaying(self.audio) then
        self.index = self.index + 1
        if self.soundList[self.index] then
            self.audio = self.soundEmitter:playSound(self.soundList[self.index])
        else
            self.completed = true
            self.soundEmitter = nil
            return false
        end
    end
    return true
end

function WorldSoundObject:destroy()
    if self.soundEmitter then
        self.soundEmitter:stopAll()
        self.soundEmitter = nil

    end
end

function WorldSoundObject:new(name, x ,y ,z, soundList)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    if type(soundList) == "table" then
        o.soundList = soundList
    elseif type(soundList) == "string" then
        o.soundList = {soundList}
    else
        error("WorldSoundAPI: Parameter soundList must be a string or a table of string.")
    end

    o.name = name
    o.position = { x=x, y=y, z=z }

    o.index = 0
    o.audio = nil
    o.completed = false
    o.soundEmitter = fmod.fmod.FMODSoundEmitter.new()
    o.soundEmitter:setPos(x, y, z)

    return o
end

-----------------------------------------------------------

local WorldSoundAPI = {}

---@type table<string,table>
local Sounds = {}

---@param name string
---@param x number
---@param y number
---@param z number
---@param soundList string|string[]
function WorldSoundAPI.AddSoundAt(name, x, y, z, soundList)
    local id = StringUtils.PositionToId(x, y, z)
    if not Sounds[id] then
        Sounds[id] = {}
    end
    if Sounds[id] and Sounds[id][name] then
        Sounds[id][name]:destroy()
        Sounds[id][name] = nil
    end

    Sounds[id][name] = WorldSoundObject:new(name, x ,y, z, soundList)
    if DEBUG then print("World sound ['"..name.."'] added at x:"..x.." y:"..y.." z:"..z) end
end

---@param name string
---@param x number
---@param y number
---@param z number
function WorldSoundAPI.RemoveSoundAt(name, x, y, z)
    local id = StringUtils.PositionToId(x, y, z)
    if Sounds[id] and Sounds[id][name] then
        Sounds[id][name]:destroy()
        Sounds[id][name] = nil
        if DEBUG then print("World sound ['"..name.."'] removed at x:"..x.." y:"..y.." z:"..z) end
    end
end

---@param x number
---@param y number
---@param z number
function WorldSoundAPI.RemoveAllSoundAt(x, y, z)
    local id = StringUtils.PositionToId(x, y, z)
    if Sounds[id] then
        for name in pairs(Sounds[id]) do
            Sounds[id][name]:destroy()
            Sounds[id][name] = nil
            if DEBUG then print("World sound ['"..name.."'] removed at x:"..x.." y:"..y.." z:"..z) end
        end
        Sounds[id] = {}
    end
end

local function Tick()
    for id in pairs(Sounds) do
        for name in pairs(Sounds[id]) do
            if not Sounds[id][name].completed then
                Sounds[id][name]:update()
            else
                local position = Sounds[id][name].position
                Sounds[id][name] = nil
                if DEBUG then print("World sound ['"..name.."'] completed at x:"..position.x.." y:"..position.y.." z:"..position.z) end
            end
        end
    end
end
Events.OnTick.Add(Tick)

return WorldSoundAPI