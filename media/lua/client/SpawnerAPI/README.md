# SpawnerAPI [Client]
**Developer:** Chuck  
**Contributors:** Konijima, Shurutsue 

## Description
Allows for pending the spawns of vehicles, items, zombies (with added functions supported) 
in order to spawn things anywhere in the world. Upon loading the cell in question the item becomes spawned in.

## How to use:
**Parameters:**

- itemType/vehicleType/outfitID `string` String matching the item/vehicle type (module optional); outfit ID as per the GUID table.
- x `number`, y `number`, z `number` Numbers matches the x, y, z you want the object spawned on.
- extraFunctions `table` Functions listed in a table to be ran against all spawned objects. Note: Zombies are spawned into an array, any added functions should take this into account.
- extraParam `any` An additional parameter to apply. Note: For Zombie spawns this acts as `FemaleChance`.
- processSquare `function` Function to run against the found square.

**Returns:** `InventoryItem`


## Methods
```lua
function SpawnerAPI.spawnItem(itemType, x, y, z, extraFunctions, extraParam, processSquare)
```
```lua
function SpawnerAPI.spawnVehicle(vehicleType, x, y, z, extraFunctions, extraParam, processSquare)
```
```lua
function SpawnerAPI.spawnZombie(outfitID, x, y, z, extraFunctions, femaleChance, processSquare)
```

## Example
```lua
--Auto Ages InventoryItems.
---@param item InventoryItem
function ageInventoryItem(item)
    if item then
        item:setAutoAge()
    end
end


--Checks and returns square if outside.
---@param square IsoGridSquare
---@return IsoGridSquare
function checkIfOutside(square)
    if not square then
        return
    end
	if square:isOutside() then
		return square
	end
end


--Example of SpawnerAPI.spawn- use.
---@param player IsoPlayer | IsoGameCharacter | IsoMovingObject | IsoObject
function dropTrash(player)

	local X, Y, Z = player:getX(), player:getY(), player:getZ()
	local trashItems = {"MayonnaiseEmpty","SmashedBottle","Pop3Empty","PopEmpty","Pop2Empty","WhiskeyEmpty","BeerCanEmpty","BeerEmpty"}
	local iterations = 10

	for i=1, iterations do

		X = X+ZombRand(-2,3)
		Y = Y+ZombRand(-2,3)

		local trashType = trashItems[(ZombRand(#trashItems)+1)]
		--more likely to drop the same thing
		table.insert(trashItems, trashType)

		SpawnerAPI.spawnItem(trashType, X, Y, Z, {ageInventoryItem}, nil, checkIfOutside)
	end
end
```