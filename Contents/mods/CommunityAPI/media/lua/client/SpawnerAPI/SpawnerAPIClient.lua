require("CommunityAPI")

local EventAPI = CommunityAPI.Shared.Event
local StringUtils = CommunityAPI.Utils.String

---@class SpawnerAPI
local SpawnerAPI = {
	OnItemSpawned = {},
	OnZombieSpawned = {},
	OnVehicleSpawned = {},
}

--- Retrieve the SpawnerAPI global modata
local function getOrSetPendingSpawnsList()
	local modData = ModData.getOrCreate("SpawnerAPI")
	if not modData.FarSquarePendingSpawns then modData.FarSquarePendingSpawns = {} end
	return modData.FarSquarePendingSpawns
end

--- Internal function to set an object to spawn later
local function setToSpawn(spawnFuncType, objectType, x, y, z, extraData, _femaleChance)
	local farSquarePendingSpawns = getOrSetPendingSpawnsList()

	local positionID = StringUtils.PositionToId(x, y, z)

	if not farSquarePendingSpawns[positionID] then
		farSquarePendingSpawns[positionID] = {}
	end

	local objToAdd = {
		spawnFuncType = spawnFuncType,
		objectType = objectType,
		x = x,
		y = y,
		z = z,
		extraData = extraData,
		femaleChance = _femaleChance
	}

	table.insert(farSquarePendingSpawns[positionID], objToAdd)
end

--- Internal function to spawn pending objects
local function parseSquare(square)
	local farSquarePendingSpawns = getOrSetPendingSpawnsList()

	if #farSquarePendingSpawns == 0 then return; end

	local squareId = StringUtils.SquareToId(square)
	local spawns = farSquarePendingSpawns[squareId]

	if #spawns > 0 then

		for key, spawn in pairs(spawns) do
			local spawnFunc = SpawnerAPI["spawn"..spawn.spawnFuncType]

			if type(spawnFunc) == "function" then
				if not pcall(spawnFunc, spawn.objectType, spawn.x, spawn.y, spawn.z, spawn.extraData, spawn.femaleChance) then
					print("SpawnerAPI: Error spawning ["..spawn.objectType.."] at ("..spawn.x..", "..spawn.y..", "..spawn.z..")")
				end
			end

			farSquarePendingSpawns[squareId][key] = nil
		end
		farSquarePendingSpawns[squareId] = nil

	end
end
Events.LoadGridsquare.Add(parseSquare)

--- Spawn an item of type
---@param itemType string The item type to spawn e.g: Base.Axe
---@param x number The X coordinate to spawn the object at
---@param y number The Y coordinate to spawn the object at
---@param z number The Z coordinate to spawn the object at
---@param extraData table Table of extra data returned in the spawned event for custom handling
function SpawnerAPI.SpawnItem(itemType, x, y, z, extraData)
	if not itemType then return; end

	if not extraData then extraData = {} end

	local square = getCell():getGridSquare(x, y, z)
	if square then
		x, y, z = square:getX(), square:getY(), square:getZ()
		local item = square:AddWorldInventoryItem(itemType, x, y, z)
		if item then
			EventAPI.Trigger("SpawnerAPI", "OnItemSpawned", item, square, extraData)
		end
	else
		setToSpawn("Item", itemType, x, y, z, extraData)
	end
end

--- Spawn a vehicle of type
---@param vehicleType string The vehicle type to spawn e.g: Base.Vehicle_PickUpVan
---@param x number The X coordinate to spawn the object at
---@param y number The Y coordinate to spawn the object at
---@param z number The Z coordinate to spawn the object at
---@param extraData table Table of extra data returned in the spawned event for custom handling
function SpawnerAPI.SpawnVehicle(vehicleType, x, y, z, extraData)
	if not vehicleType then return; end

	if not extraData then extraData = {} end

	local square = getCell():getGridSquare(x, y, z)
	if square then
		local vehicle = addVehicleDebug(vehicleType, IsoDirections.getRandom(), nil, square)
		if vehicle then
			EventAPI.Trigger("SpawnerAPI", "OnVehicleSpawned", vehicle, square, extraData)
		end
	else
		setToSpawn("Vehicle", vehicleType, x, y, z, extraData)
	end
end

--- Spawn a Zombie with a specific outfit ID
---@param outfitID string The outfit ID the zombie will spawn with
---@param x number The X coordinate to spawn the object at
---@param y number The Y coordinate to spawn the object at
---@param z number The Z coordinate to spawn the object at
---@param extraData table Table of extra data returned in the spawned event for custom handling
---@param _femaleChance number|nil The chance the zombie will be a female between 0 to 100, default: 50
function SpawnerAPI.SpawnZombie(outfitID, x, y, z, extraData, _femaleChance)
	if not outfitID then return; end

	if not extraData then extraData = {} end

	if not _femaleChance then _femaleChance = 50 end

	local square = getCell():getGridSquare(x, y, z)
	if square then
		x, y, z = square:getX(), square:getY(), square:getZ()
		local zombies = addZombiesInOutfit(x, y, z, 1, outfitID, _femaleChance)
		if zombies and zombies:size() > 0 then
			EventAPI.Trigger("SpawnerAPI", "OnZombieSpawned", zombies:get(0), square, extraData)
		end
	else
		setToSpawn("Zombie", outfitID, x, y, z, extraData, _femaleChance)
	end
end

--- Add a function handler for when an item has been spawned
---@param func function The function handler to add
function SpawnerAPI.OnItemSpawned.Add(func)
	EventAPI.Add("SpawnerAPI", "OnItemSpawned", func)
end

--- Remove a function handler previously added
---@param func function The function handler to remove
function SpawnerAPI.OnItemSpawned.Remove(func)
	EventAPI.Remove("SpawnerAPI", "OnItemSpawned", func)
end

--- Add a function handler for when a vehicle has been spawned
---@param func function The function handler to add
function SpawnerAPI.OnVehicleSpawned.Add(func)
	EventAPI.Add("SpawnerAPI", "OnVehicleSpawned", func)
end

--- Remove a function handler previously added
---@param func function The function handler to remove
function SpawnerAPI.OnVehicleSpawned.Remove(func)
	EventAPI.Remove("SpawnerAPI", "OnVehicleSpawned", func)
end

--- Add a function handler for when a zombie has been spawned
---@param func function The function handler to add
function SpawnerAPI.OnZombieSpawned.Add(func)
	EventAPI.Add("SpawnerAPI", "OnZombieSpawned", func)
end

--- Remove a function handler previously added
---@param func function The function handler to remove
function SpawnerAPI.OnZombieSpawned.Remove(func)
	EventAPI.Remove("SpawnerAPI", "OnZombieSpawned", func)
end

return SpawnerAPI
