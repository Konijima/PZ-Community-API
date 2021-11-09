---@class SpawnerAPI
local SpawnerAPI = {}

local function getOrSetPendingSpawnsList()
	local modData = ModData.getOrCreate("SpawnerAPI")
	if not modData.FarSquarePendingSpawns then modData.FarSquarePendingSpawns = {} end
	return modData.FarSquarePendingSpawns
end

---@param spawned IsoObject | ArrayList
---@param functions table table of functions
local function processExtraFunctionsOnto(spawned,functions)
	if spawned and functions and (type(functions)=="table") then
		for _,func in pairs(functions) do
			if func then
				func(spawned)
			end
		end
	end
end

---@param spawnFuncType string This string is concated to the end of 'SpawnerAPI.spawn' to run a corresponding function.
---@param objectType string Module.Type for Items and Vehicles, OutfitID for Zombies
---@param x number
---@param y number
---@param z number
---@param funcsToApply table Table of functions which gets applied on the results of whatever is spawned.
local function setToSpawn(spawnFuncType, objectType, x, y, z, funcsToApply, extraParam, processSquare)
	local farSquarePendingSpawns = getOrSetPendingSpawnsList()
	table.insert(farSquarePendingSpawns,{ spawnFuncType=spawnFuncType, objectType=objectType, x=x, y=y, z=z,
										  funcsToApply=funcsToApply, extraParam=extraParam, processSquare=processSquare })
end

---@param itemType string
---@param x number
---@param y number
---@param z number
---@param extraFunctions table
---@param extraParam any
---@param processSquare function
---@return InventoryItem
function SpawnerAPI.SpawnItem(itemType, x, y, z, extraFunctions, extraParam, processSquare)
	if not itemType then
		return
	end

	local currentSquare = getSquare(x,y,z)
	if processSquare then
		currentSquare = processSquare(currentSquare)
	end

	if currentSquare then
		x, y, z = currentSquare:getX(), currentSquare:getY(), currentSquare:getZ()
		local item = currentSquare:AddWorldInventoryItem(itemType, x, y, z)
		if item then
			processExtraFunctionsOnto(item,extraFunctions)
		end
	else
		setToSpawn("Item", itemType, x, y, z, extraFunctions, extraParam, processSquare)
	end
end

---@param vehicleType string
---@param x number
---@param y number
---@param z number
---@param extraFunctions table
---@param extraParam any
---@param processSquare function
---@return InventoryItem
function SpawnerAPI.SpawnVehicle(vehicleType, x, y, z, extraFunctions, extraParam, processSquare)
	if not vehicleType then
		return
	end

	local currentSquare = getSquare(x,y,z)
	if processSquare then
		currentSquare = processSquare(currentSquare)
	end

	if currentSquare then
		local vehicle = addVehicleDebug(vehicleType, IsoDirections.getRandom(), nil, currentSquare)
		if vehicle then
			processExtraFunctionsOnto(vehicle,extraFunctions)
		end
	else
		setToSpawn("Vehicle", vehicleType, x, y, z, extraFunctions, extraParam, processSquare)
	end
end

---@param outfitID string
---@param x number
---@param y number
---@param z number
---@param extraFunctions table
---@param femaleChance number extraParam for other spawners 0-100
---@param processSquare function
---@return InventoryItem
function SpawnerAPI.SpawnZombie(outfitID, x, y, z, extraFunctions, femaleChance, processSquare)
	if not outfitID then
		return
	end

	local currentSquare = getSquare(x,y,z)
	if processSquare then
		currentSquare = processSquare(currentSquare)
	end

	if currentSquare then
		x, y, z = currentSquare:getX(), currentSquare:getY(), currentSquare:getZ()
		local zombies = addZombiesInOutfit(x, y, z, 1, outfitID, femaleChance)
		if zombies and zombies:size()>0 then
			processExtraFunctionsOnto(zombies,extraFunctions)
		end
	else
		setToSpawn("Zombie", outfitID, x, y, z, extraFunctions, femaleChance, processSquare)
	end
end

---@param square IsoGridSquare
local function parseSquare(square)
	local farSquarePendingSpawns = getOrSetPendingSpawnsList()

	if #farSquarePendingSpawns < 1 then
		return
	end

	local sqX, sqY, sqZ = square:getX(), square:getY(), square:getZ()
	for key,entry in pairs(farSquarePendingSpawns) do
		if (not entry.spawned) and entry.x==sqX and entry.y==sqY and entry.z==sqZ then


			local shiftedSquare = square
			if entry.processSquare then
				shiftedSquare = entry.processSquare(shiftedSquare)
			end

			if shiftedSquare then
				local spawnFunc = SpawnerAPI["spawn"..entry.spawnFuncType]

				if type(spawnFunc) == "function" then
					local spawnedObject = spawnFunc(entry.objectType, sqX, sqY, sqZ, entry.funcsToApply, entry.extraParam)
					if not spawnedObject then
						print("SpawnerAPI: ERR: item not spawned: "..entry.objectType.." ("..sqX..","..sqY..","..sqZ..")")
					end
				end
			end
			farSquarePendingSpawns[key] = nil
		end
	end
end
Events.LoadGridsquare.Add(parseSquare)

return SpawnerAPI