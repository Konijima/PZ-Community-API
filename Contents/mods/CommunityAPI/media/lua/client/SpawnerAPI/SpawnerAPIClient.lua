require("CommunityAPI")

local EventAPI = CommunityAPI.Shared.Event
local StringUtils = CommunityAPI.Utils.String

---@class SpawnerAPI
local SpawnerAPI = {
	OnItemSpawned = {},
	OnZombieSpawned = {},
	OnVehicleSpawned = {},
}

local modData

--- Retrieve the SpawnerAPI global modata
local function getOrSetPendingSpawnsList()
	modData = modData or ModData.getOrCreate("SpawnerAPI")
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

	local squareId = StringUtils.SquareToId(square)
	local spawns = farSquarePendingSpawns[squareId]

	if #spawns > 0 then

		for _, spawn in pairs(spawns) do
			local spawnFunc = SpawnerAPI["spawn"..spawn.spawnFuncType]

			if type(spawnFunc) == "function" then
				if not pcall(spawnFunc, spawn.objectType, spawn.x, spawn.y, spawn.z, spawn.extraData, spawn.femaleChance) then
					print("SpawnerAPI: Error spawning ["..spawn.objectType.."] at ("..spawn.x..", "..spawn.y..", "..spawn.z..")")
				end
			end

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
---@param _extraData table|nil Table of extra data returned in the spawned event for custom handling
function SpawnerAPI.SpawnItem(itemType, x, y, z, _extraData)
	if not itemType then return; end

	if not _extraData then _extraData = {} end

	local square = getCell():getGridSquare(x, y, z)
	if square then
		local item = square:AddWorldInventoryItem(itemType, 0, 0, 0)
		if item then
			EventAPI.Trigger("SpawnerAPI", "OnItemSpawned", item, square, _extraData)
		end
	else
		setToSpawn("Item", itemType, x, y, z, _extraData)
	end
end

--- Spawn a vehicle of type
---@param vehicleType string The vehicle type to spawn e.g: Base.Vehicle_PickUpVan
---@param x number The X coordinate to spawn the object at
---@param y number The Y coordinate to spawn the object at
---@param z number The Z coordinate to spawn the object at
---@param _extraData table|nil Table of extra data returned in the spawned event for custom handling
function SpawnerAPI.SpawnVehicle(vehicleType, x, y, z, _extraData)
	if not vehicleType then return; end

	if not _extraData then _extraData = {} end

	local square = getCell():getGridSquare(x, y, z)
	if square then
		local vehicle = addVehicleDebug(vehicleType, IsoDirections.getRandom(), nil, square)
		if vehicle then
			EventAPI.Trigger("SpawnerAPI", "OnVehicleSpawned", vehicle, square, _extraData)
		end
	else
		setToSpawn("Vehicle", vehicleType, x, y, z, _extraData)
	end
end

--- Spawn a Zombie with a specific outfit ID
---@param outfitID string The outfit ID the zombie will spawn with, e.g: PoliceState
---@param x number The X coordinate to spawn the object at
---@param y number The Y coordinate to spawn the object at
---@param z number The Z coordinate to spawn the object at
---@param _extraData table|nil Table of extra data returned in the spawned event for custom handling
---@param _femaleChance number|nil The chance the zombie will be a female between 0 to 100, default: 50
function SpawnerAPI.SpawnZombie(outfitID, x, y, z, _extraData, _femaleChance)
	if not outfitID then return; end

	if not _extraData then _extraData = {} end

	if not _femaleChance then _femaleChance = 50 end

	local square = getCell():getGridSquare(x, y, z)
	if square then
		local zombies = addZombiesInOutfit(x, y, z, 1, outfitID, _femaleChance)
		if zombies and zombies:size() > 0 then
			EventAPI.Trigger("SpawnerAPI", "OnZombieSpawned", zombies:get(0), square, _extraData)
		end
	else
		setToSpawn("Zombie", outfitID, x, y, z, _extraData, _femaleChance)
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
