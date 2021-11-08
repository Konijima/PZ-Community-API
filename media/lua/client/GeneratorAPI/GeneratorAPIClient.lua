local Utilities = require("CommunityAPI/Utilities")

local GeneratorAPI = {}

local function getModData()
    local modData = ModData.getOrCreate("GeneratorAPI")
    if not modData.Generators then modData.Generators = {} end
    if not modData.ObjectConsumptions then modData.ObjectConsumptions = {} end
    return modData
end

---@param square IsoGridSquare
---@param objectPosition table
---@return IsoGenerator|nil
local function getNearestGenerator(square)
    local modData = getModData()
    if not modData.Generators then return; end
    local position = { x=square:getX(), y=square:getY(), z=square:getZ() }

    -- Search nearest known Generators
    local nearestDistance = 999
    local nearestPosition = nil
    for _, generatorPosition in pairs(modData.Generators) do
        local distance = Utilities.GetDistance(generatorPosition.x, generatorPosition.y, position.x, position.y)
        if distance < nearestDistance then
            nearestDistance = distance
            nearestPosition = generatorPosition
        end
    end

    if nearestPosition and nearestDistance <= 20 then
        local generatorSquare = getCell():getGridSquare(nearestPosition.x, nearestPosition.y, nearestPosition.z)
        local objects = generatorSquare:getObjects()
        for i=0, objects:size()-1 do
            local obj = objects:get(i)
            if instanceof(obj, "IsoGenerator") then
                return obj
            end
        end
    end
end

function GeneratorAPI.GetAllObjectConsumptions()
    local modData = getModData()
    if modData.ObjectConsumptions then
        return modData.ObjectConsumptions
    end
end

function GeneratorAPI.AddObjectConsumption(name, square, fuelConsumption)
    if instanceof(square, "IsoGridSquare") then
        local position = { x=square:getX(), y=square:getY(), z=square:getZ() }
        local id = Utilities.PositionToId(position.x, position.y, position.z)

        local modData = getModData()
        modData.ObjectConsumptions[id] = {
            name = name,
            position = position,
            fuelConsumption = fuelConsumption,
        }

        local generator = getNearestGenerator(square)
        if generator then
            local totalPower = generator:getTotalPowerUsing()
            totalPower = totalPower + fuelConsumption
            generator:setTotalPowerUsing(totalPower)
            print("Added to a generator! ", totalPower)
        end
    end
end

function GeneratorAPI.RemoveObjectConsumption(square)
    if instanceof(square, "IsoGridSquare") then
        local id = Utilities.PositionToId(square:getX(), square:getY(), square:getZ())

        local modData = getModData()
        if modData.ObjectConsumptions[id] then
            local generator = getNearestGenerator(square)
            if generator then
                local totalPower = generator:getTotalPowerUsing()
                totalPower = totalPower - modData.ObjectConsumptions[id].fuelConsumption
                generator:setTotalPowerUsing(totalPower)
                print("Remove from a generator! ", totalPower)
            end
            modData.ObjectConsumptions[id] = nil
        end
    end
end

return GeneratorAPI