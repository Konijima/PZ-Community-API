require("ISBaseObject")

local DEBUG = getCore():getDebug()

---@class LightObject
local LightObject = ISBaseObject:derive("LightObject")

function LightObject:update()
    local cell = getCell()
    if cell then
        local square = cell:getGridSquare(self.position.x, self.position.y, self.position.z)
        if square then
            if self.lightSource == nil then
                self.lightSource = IsoLightSource.new(self.position.x, self.position.y, self.position.z, 0.0, 0.0, 1.0, self.radius)
                cell:addLamppost(self.lightSource)
                IsoGridSquare.RecalcLightTime = -1
                if DEBUG then print("Light source ['"..self.name.."'] created at x:"..self.position.x.." y:"..self.position.y.." z:"..self.position.z) end
            end
            self.lightSource:setRadius(self.radius)
            self.lightSource:setR(self.color.r)
            self.lightSource:setG(self.color.g)
            self.lightSource:setB(self.color.b)
        else
            self:destroy()
        end
    end
end

function LightObject:destroy()
    if self.lightSource ~= nil then
        self.lightSource:setActive(false)
        getCell():removeLamppost(self.lightSource)
        self.lightSource = nil
        if DEBUG then print("Light source ['"..self.name.."'] destroyed at x:"..self.position.x.." y:"..self.position.y.." z:"..self.position.z) end
    end
end

function LightObject:setRadius(radius)
    if type(radius) == "number" and radius > 0 then
        self.radius = radius
        self:update()
    end
end

function LightObject:setColor(color)
    if type(color) == "table" then
        if type(color.r) == "number" then self.color.r = color.r end
        if type(color.g) == "number" then self.color.g = color.g end
        if type(color.b) == "number" then self.color.b = color.b end
        self:update()
    end
end

function LightObject:new(name, x ,y ,z, radius, color)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    o.lightSource = nil

    o.name = name
    o.position = { x=x, y=y, z=z }
    o.radius = 1
    o.color = { r=1, g=1, b=1 }

    o:setRadius(radius)
    o:setColor(color)

    return o
end

-----------------------------------------------------------------------

---@class LightAPI
local LightAPI = {}

---@type table<string,table>
local Lights = {}

local function positionToId(x, y, z)
    return tostring(x) .. "|" .. tostring(y) .. "|" .. tostring(z)
end

---@param name string
---@param x number
---@param y number
---@param z number
---@param newColor table
function LightAPI.SetLightColorAt(name, x, y, z, newColor)
    local id = positionToId(x, y, z)
    if Lights[id] and Lights[id][name] then
        Lights[id][name]:setColor(newColor)
    end
end

---@param name string
---@param x number
---@param y number
---@param z number
---@param newRadius number
function LightAPI.SetLightRadiusAt(name, x, y, z, newRadius)
    local id = positionToId(x, y, z)
    if Lights[id] and Lights[id][name] then
        Lights[id][name]:setRadius(newRadius)
    end
end

---@param name string
---@param x number
---@param y number
---@param z number
---@param radius number
---@param color table
function LightAPI.AddLightAt(name, x, y, z, radius, color)
    local id = positionToId(x, y, z)
    if not Lights[id] then
        Lights[id] = {}
    end
    if Lights[id] and Lights[id][name] then
        Lights[id][name]:destroy()
        Lights[id][name] = nil
    end

    Lights[id][name] = LightObject:new(name, x ,y, z, radius, color)
    if DEBUG then print("Light ['"..name.."'] added at x:"..x.." y:"..y.." z:"..z) end
end

---@param name string
---@param x number
---@param y number
---@param z number
function LightAPI.RemoveLightAt(name, x, y, z)
    local id = positionToId(x, y, z)
    if Lights[id] and Lights[id][name] then
        Lights[id][name]:destroy()
        Lights[id][name] = nil
        if DEBUG then print("Light ['"..name.."'] removed at x:"..x.." y:"..y.." z:"..z) end
    end
end

---@param square IsoGridSquare
local function onLoadGridsquare(square)
    local id = positionToId(square:getX(), square:getY(), square:getZ())
    if Lights[id] then
        ---@param v LightObject
        for k, v in pairs(Lights[id]) do
            v:destroy()
            v:update()
        end
    end
end
Events.LoadGridsquare.Add(onLoadGridsquare)

return LightAPI