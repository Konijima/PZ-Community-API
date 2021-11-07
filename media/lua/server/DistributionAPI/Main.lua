require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

local MainDistributionTable = {}

---@param s string
local function split(s)
    if type(s) == "string" then
        local result = {}
        for i in string.gmatch(s, "[^%.]+") do
            table.insert(result, i)
        end
        return result
    end
end

---@param locationParts table<string>
local function getLocation(locationParts)
    if type(locationParts) == "table" then
        local partCount = #locationParts
        --local location = _G[locationParts[1]]; TODO: Fix to this?
        local location = ProceduralDistributions
        local locationString = locationParts[1]

        if locationParts[1] == "SuburbsDistributions" then
            location = SuburbsDistributions
        elseif locationParts[1] == "ProceduralDistributions" then
            location = ProceduralDistributions
        else
            return
        end

        for i=2, #locationParts do
            if location[locationParts[i]] then
                locationString = locationString .. "-" .. locationParts[i]
                location = location[locationParts[i]]
            else
                return -- Break out of it and return nil instead of allowing incomplete location!
            end
            if i >= partCount then
                return location
            end
        end
    end
end

---@param location table
---@param item string
---@param odd number
---@return boolean
local function add(location, item, odd)
    if type(location) == "table" then
        table.insert(location, item)
        table.insert(location, odd)
        return true
    end
end

---@param modName string
---@param table table
---@param location table
local function process_location(modName, table, location)
    if location then
        for e=1, #table.items do
            local item = table.items[e][1]
            local odd = table.items[e][2]

            if not add(location, item, odd) then
                print(modName..": Error distribution adding table '"..item.."':'"..odd.."' at '"..table.location.."'!")
                error(modName..": Error distribution adding table '"..item.."':'"..odd.."' at '"..table.location.."'!")
            else
                print(modName..": Distribution added '"..item.."':'"..odd.."' to table '"..table.location.."'!")
            end
        end
    else
        print(modName..": Error distribution invalid location at '"..table.location.."'!")
        error(modName..": Error distribution invalid location at '"..table.location.."'!")
    end
end

---@param modName string
---@return number
local function process(modName)
    local errorCount = 0
    for t=1, #MainDistributionTable do
        local table = MainDistributionTable[t]
        local locationParts = split(table.location)
        local location = getLocation(locationParts)

        if not pcall(process_location, modName, table, location) then
            errorCount = errorCount + 1
        end
    end
    return errorCount
end

---@param modName string
---@param locationEntry table
local function addLocation(modName, locationEntry)
    if type(locationEntry) ~= "table" then
        print(modName..": AddDistributionTable error a Location Entry must be a table, got a " .. type(locationEntry) .. "!")
        error(modName..": AddDistributionTable error a Location Entry must be a table, got a " .. type(locationEntry) .. "!")
    end
    if type(locationEntry.location) ~= "string" then
        print(modName..": AddDistributionTable error 'location' must be a string, got a " .. type(locationEntry.location) .. "!")
        error(modName..": AddDistributionTable error 'location' must be a string, got a " .. type(locationEntry.location) .. "!")
    end
    if type(locationEntry.items) ~= "table" then
        print(modName..": AddDistributionTable error 'items' must be a table, got a " .. type(locationEntry.items) .. "!")
        error(modName..": AddDistributionTable error 'items' must be a table, got a " .. type(locationEntry.items) .. "!")
    end
    if locationEntry.AddItem then
        locationEntry.AddItem = nil
    end

    table.insert(MainDistributionTable, locationEntry)
end

---@param modName string
---@param locationsTable table
local function addLocations(modName, locationsTable)
    if type(locationsTable) == "table" then
        for i=1, #locationsTable do
            addLocation(modName, locationsTable[i])
        end
    else
        print(modName..": AddDistributionTable did not receive a locations table!")
    end
end

--- Add locations table
---@param modName string
---@param locationsTable table
function AddDistributionTable(modName, locationsTable)
    if type(modName) ~= "string" then
        print("Distribution API: An addon didn't specify a name using the method ComputerAddDistributionLocations!")
        return
    end
    if not pcall(addLocations, modName, locationsTable) then
        print(modName..": There was an error trying to add distribution locations!")
    else
        if #locationsTable > 0 then
            print("---------------------------------------------------------------------------------------")
            local errorCount = process(modName)
            if errorCount == 0 then
                print(modName..": Adding to the distribution table process completed!")
            else
                print(modName..": Adding to the distribution table process completed with "..errorCount.." error(s)!")
            end
            print("---------------------------------------------------------------------------------------")
            MainDistributionTable = {}
        end
    end
end

---@param locationPath string
---@param distributionTable table
function CreateDistributionLocation(locationPath, distributionTable)
    local location = {
        location = locationPath,
        items = {},
    }

    function location:AddItem(itemFullType, odd)
        table.insert(self.items, {itemFullType, odd})
    end

    table.insert(distributionTable, location)
    return location
end
