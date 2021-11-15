# SpawnerAPI [Client]
**Developer:** Chuck  
**Contributors:** Konijima, Shurutsue  
**Package:** CommunityAPI.Client.Spawner  

<br>

## Description

Spawn Item, Vehicle and Zombie anywhere in the world.

<br>

## Methods

### SpawnItem(itemType, x, y, z, _extraData)
Spawn an item of type

| Param      | Type       | Description                                                           |
|------------|------------|-----------------------------------------------------------------------|
| itemType   | string     | The item type to spawn e.g: Base.Axe                                  |
| x          | number     | The X coordinate to spawn the object at                               |
| y          | number     | The Y coordinate to spawn the object at                               |
| z          | number     | The Z coordinate to spawn the object at                               |
| _extraData | table\|nil | Table of extra data returned in the spawned event for custom handling |

**return:** nil

<br>

### SpawnVehicle(vehicleType, x, y, z, _extraData)
Spawn a vehicle of type

| Param       | Type       | Description                                                           |
|-------------|------------|-----------------------------------------------------------------------|
| vehicleType | string     | The vehicle type to spawn e.g: Base.Vehicle_PickUpVan                 |
| x           | number     | The X coordinate to spawn the object at                               |
| y           | number     | The Y coordinate to spawn the object at                               |
| z           | number     | The Z coordinate to spawn the object at                               |
| _extraData  | table\|nil | Table of extra data returned in the spawned event for custom handling |

**return:** nil

<br>

### SpawnZombie(outfitID, x, y, z, _extraData, _femaleChance)
Spawn a Zombie with a specific outfit ID

| Param         | Type        | Description                                                           |
|---------------|-------------|-----------------------------------------------------------------------|
| outfitID      | string      | The outfit ID the zombie will spawn with, e.g: PoliceState            |
| x             | number      | The X coordinate to spawn the object at                               |
| y             | number      | The Y coordinate to spawn the object at                               |
| z             | number      | The Z coordinate to spawn the object at                               |
| _extraData    | table\|nil  | Table of extra data returned in the spawned event for custom handling |
| _femaleChance | number\|nil | The chance the zombie will be a female between 0 to 100, default: 50  |

**return:** nil

<br>

## Events

### OnItemSpawned.Add(func)
Add a function handler for when an item has been spawned

| Param | Type     | Description                 |
|-------|----------|-----------------------------|
| func  | function | The function handler to add |

Function handler

| Param     | Type                                                                                                   | Description                                     |
|-----------|--------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| item      | [InventoryItem](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/inventory/InventoryItem.html) | The spawned item                                |
| square    | [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)       | The square the item spawned on                  |
| extraData | table\<any\>                                                                                           | The extra data passed when SpawnItem was called |

<br>

### OnItemSpawned.Remove(func)
Remove a function handler previously added

| Param | Type     | Description                    |
|-------|----------|--------------------------------|
| func  | function | The function handler to remove |

<br>

### OnVehicleSpawned.Add(func)
Add a function handler for when a vehicle has been spawned

| Param | Type     | Description                 |
|-------|----------|-----------------------------|
| func  | function | The function handler to add |

Function handler

| Param     | Type                                                                                              | Description                                        |
|-----------|---------------------------------------------------------------------------------------------------|----------------------------------------------------|
| vehicle   | [BaseVehicle](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/vehicles/BaseVehicle.html) | The spawned vehicle                                |
| square    | [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)  | The square the vehicle spawned on                  |
| extraData | table\<any\>                                                                                      | The extra data passed when SpawnVehicle was called |

<br>

### OnVehicleSpawned.Remove(func)
Remove a function handler previously added

| Param | Type     | Description                    |
|-------|----------|--------------------------------|
| func  | function | The function handler to remove |

<br>

### OnZombieSpawned.Add(func)
Add a function handler for when a zombie has been spawned

| Param | Type     | Description                 |
|-------|----------|-----------------------------|
| func  | function | The function handler to add |

Function handler

| Param     | Type                                                                                                   | Description                                       |
|-----------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| zombie    | [IsoZombie](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/characters/IsoZombie.html)        | The spawned zombie                                |
| square    | [IsoGridSquare](https://quarantin.github.io/zomboid-javadoc/41.56/zombie/iso/IsoGridSquare.html)       | The square the zombie spawned on                  |
| extraData | table\<any\>                                                                                           | The extra data passed when SpawnZombie was called |

<br>

### OnZombieSpawned.Remove(func)
Remove a function handler previously added

| Param | Type     | Description                    |
|-------|----------|--------------------------------|
| func  | function | The function handler to remove |

<br>

## Example

```lua
require("CommunityAPI")

local SpawnerAPI = CommunityAPI.Client.Spawner

local function onItemSpawned(item, square, extraData)
    if type(extraData) == "table" and type(extraData.myMod) == "table" then
    
        if extraData.myMod.spawnOutside and square and not square:isOutside() then
            square:removeWorldObject(item:getWorldItem())
            item = nil
        end

        if item and extraData.myMod.setRandomCondition then
            item:setCondition(ZombRand(0, 100)
        end
    
    end
end
SpawnerAPI.OnItemSpawned.Add(onItemSpawned)

-- Spawn an item
SpawnerAPI.SpawnItem("Base.Axe", X, Y, Z, {
    myMod = {
        spawnOutside = true,
        setRandomCondition = true,
    }
})

-- Spawn a zombie
SpawnerAPI.SpawnZombie("PoliceState", X, Y, Z, {}, 50)

-- Spawn a vehicle
SpawnerAPI.SpawnVehicle("Base.Vehicle_PickUpVan", X, Y, Z, {})

```
