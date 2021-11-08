local Utilities = require("CommunityAPI/Utilities")

local original_ISGeneratorInfoWindow_getRichText = ISGeneratorInfoWindow.getRichText

---@param generator IsoGenerator
function ISGeneratorInfoWindow.getRichText(generator, displayStats)
    local originalText = original_ISGeneratorInfoWindow_getRichText(generator, displayStats)

    -- Find all nearby custom object that consume power
    local consumingObjects = {}
    local modData = ModData.getOrCreate("GeneratorAPI")
    if modData.ObjectConsumptions then
        local square = generator:getSquare()
        local generatorPosition = { x=square:getX(), y=square:getY(), z=square:getZ() }
        for _, obj in pairs(modData.ObjectConsumptions) do
            local distance = Utilities.GetDistance(generatorPosition.x, generatorPosition.y, obj.position.x, obj.position.y)
            local distanceZ = math.abs(generatorPosition.z - obj.position.z)
            if distance <= 20 and distanceZ < 4 then -- Generator power 20 squares and 3 floor
                if not consumingObjects[obj.name] then
                    consumingObjects[obj.name] = {
                        count = 1,
                        totalConsumption = obj.fuelConsumption
                    }
                else
                    consumingObjects[obj.name].count = consumingObjects[obj.name].count + 1
                    consumingObjects[obj.name].totalConsumption = consumingObjects[obj.name].totalConsumption + obj.fuelConsumption
                end
            end
        end
    end

    local text = originalText

    -- Make custom text on if we have custom elements
    if Utilities.CountTableEntries(consumingObjects) > 0 then
        text = "" -- reset text

        local textTable = Utilities.SplitString(originalText, " <LINE> ")

        -- Get the line to insert new element from
        local insertLine = -1;
        for i,v in ipairs(textTable) do
            if luautils.stringStarts(v, "Total:") then
                insertLine = i;
                break;
            end
        end

        -- Insert the new elements
        if insertLine == -1 then error("GeneratorAPI: Error finding insert point in tooltip.", 2) end
        for name, obj in pairs(consumingObjects) do
            if obj.count > 1 then
                table.insert(textTable, insertLine, name.." x"..obj.count.." ("..tostring(obj.totalConsumption).."L/h)")
            else
                table.insert(textTable, insertLine, name.." ("..tostring(obj.totalConsumption).."L/h)")
            end
        end

        -- Join back the text
        for i=1, #textTable do
            text = text .. textTable[i]
            if i < #textTable then
                text = text .. " <LINE> "
            end
        end
    end

    return text
end