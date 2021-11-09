# Distribution API
**Developer:** Konijima  
**Contributors:** -  
  
## Description
Add your new items to the distribution tables in a safer and more effective way.
  
If a game update changes a distribution location, mods that are using this API will still works.  
Only the faulty location path will be canceled and the rest of the distribution will be added.  
It will logs everything so that you can easily debug if an item was added to the distribution table.  
Also help the users to know which mod adds what to each tables.
  
## How to use
  
1) Create your distribution file in `mods\YourMod\media\lua\server\MyServerDistributionFile.lua` as usual.  
2) Use one of the example below to suit your preference.
3) Add `require=CommunityAPI` to your `mod.info` to make sure the API is enabled as well.
  
Only paths to `SuburbsDistributions` and `ProceduralDistributions` works and must be written with dots in between.  
  
## Methods
```lua

```

### Example 1
```lua
require("CommunityAPI")

local DistributionAPI = CommunityAPI.Server.Distribution

local modName = "My_Mod_Name"
local distributionTable = {}

local CrateCompactDiscs = DistributionAPI.CreateLocation("ProceduralDistributions.list.CrateCompactDiscs.items", distributionTable)
CrateCompactDiscs:AddItem("Base.Screwdriver", 6)
CrateCompactDiscs:AddItem("Base.Disc", 4)

DistributionAPI.Add(modName, distributionTable)
```

### Example 2
```lua
require("CommunityAPI")

local modName = "My_Mod_Name"
local distributionTable = {

    {
        location = "ProceduralDistributions.list.CrateCompactDiscs.items",
        items = {
            { "Base.Screwdriver", 6 },
            { "Base.Disc", 4 },
        }
    },

}

CommunityAPI.Server.Distribution.Add(modName, distributionTable)
```

**Example of Logs Output**

If no error:
```
LOG  : General     , > ---------------------------------------------------------------------------------------
LOG  : General     , > My_Mod_Name: Distribution added 'Base.Screwdriver':'6' to table 'ProceduralDistributions.list.CrateCompactDiscs.items'!
LOG  : General     , > My_Mod_Name: Distribution added 'Base.Disc':'4' to table 'ProceduralDistributions.list.CrateCompactDiscs.items'!
LOG  : General     , > My_Mod_Name: Adding to the distribution table process completed!
LOG  : General     , > ---------------------------------------------------------------------------------------
```

If one of the game distribution location changed after a game update:
```
LOG  : General     , > ---------------------------------------------------------------------------------------
ERROR: General     , > My_Mod_Name: Error distribution invalid location at 'ProceduralDistributions.list.CrateCompactDiscs.items2'!
LOG  : General     , > My_Mod_Name: Distribution added 'Base.Screwdriver':'6' to table 'ProceduralDistributions.list.CrateCompactDiscs.items'!
LOG  : General     , > My_Mod_Name: Distribution added 'Base.Disc':'4' to table 'ProceduralDistributions.list.CrateCompactDiscs.items'!
LOG  : General     , > My_Mod_Name: Adding to the distribution table process completed with 1 error(s)!
```
