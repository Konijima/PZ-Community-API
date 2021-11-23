# ModNewsAPI
**Developer:** Aiteron  
**Contributors:** -  
**Package:** CommunityAPI.Client.ModNews

## Description
Add news article for your mod updates.

## Methods

### AddArticle(modID, articleName, articleTextName, lastUpdateDate)
Add a new Article for your mod

| Param           | Type   | Description                                                                                                         |
|-----------------|--------|---------------------------------------------------------------------------------------------------------------------|
| modID           | string | The mod ID                                                                                                          |
| articleName     | string | The article Name                                                                                                    |
| articleTextName | string | Article text name from Translate                                                                                    |
| lastUpdateDate  | string | String with date of last update. If you changed article and want to notify that article updated - change this param |

## Examples
```lua
require("CommunityAPI")
local ModNewsAPI = CommunityAPI.Client.ModNews

--- Add an article for your mod
ModNewsAPI.AddArticle(
        "MyModId",
        "The article name in the list",
        "The article text here\nwith line breaks if desired",
        "November 1st, 2021");

--- Add a translatable article for your mod
ModNewsAPI.AddArticle(
        "MyModId",
        getText("Translate_Article_Name"),
        getText("Translate_Article_Text"),
        "November 1st, 2021");
```