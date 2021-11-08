--- Save turned on generator in ModData
---@param generator IsoGenerator
local function updateGeneratorState(generator)
    local modData = ModData.getOrCreate("GeneratorAPI")
    if not modData.Generators then modData.Generators = {} end

    ---@type IsoGridSquare
    local square = generator:getSquare()
    local position = { x=square:getX(), y=square:getY(), z=square:getZ() }
    local id = tostring(position.x) .. "|" .. tostring(position.y) .. "|" .. tostring(position.z)

    if not modData.Generators[id] and generator:isActivated() then
        modData.Generators[id] = position
    else
        modData.Generators[id] = nil
    end
end

local original_ISActivateGenerator_perform = ISActivateGenerator.perform
function ISActivateGenerator:perform()
    original_ISActivateGenerator_perform(self)
    updateGeneratorState(self.generator)
end