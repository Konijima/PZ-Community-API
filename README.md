![Banner](https://github.com/Konijima/PZ-Community-API/blob/master/Images/banner.png?raw=true)
  
## Description
Community API is a team effort to centralize & give mod creators optimized tools for creating quality mods.  
For mod compatibility and efficiency, working as a team ensure that the API is updated and optimized.  
  
**Game Version:** 41.56-IWBUMS  
**Links:** [Wiki](https://github.com/Konijima/PZ-Community-API/wiki) | [Projects](https://github.com/Konijima/PZ-Community-API/projects) | [Workshop](https://github.com/Konijima/PZ-Community-API) | [Documentation](https://quarantin.github.io/zomboid-javadoc/41.56/) | [Emmylua](https://emmylua.github.io/)
  
## Team
**Developers:** 
- Konijima ([Steam](https://steamcommunity.com/id/konijima/myworkshopfiles/?appid=108600) | [Github](https://github.com/Konijima))  
- Shurutsue ([Steam](https://steamcommunity.com/id/Shurutsue/myworkshopfiles/?appid=108600) | [Github](https://github.com/Shurutsue))  
- Chuck ([Steam](https://steamcommunity.com/id/Chuckleberry_Finn/myworkshopfiles/?appid=108600) | [Github](https://github.com/ChuckTheSheep))  
- Co ([Steam](https://steamcommunity.com/profiles/76561198056536755/myworkshopfiles/?appid=108600) | [Github](https://github.com/quarantin))  
  
## Informations
[Coding Convention](https://github.com/Konijima/PZ-Community-API/blob/master/CodingConvention.md) | [Template API](https://github.com/Konijima/PZ-Community-API/blob/master/TemplateAPI.lua.md) | [Utilities](https://github.com/Konijima/PZ-Community-API/blob/master/Contents/mods/CommunityAPI/media/lua/shared/CommunityAPI)
  
## API List
- **BodyLocationsAPI** ([Shared](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/shared/BodyLocationsAPI))  
Tweak body locations without overwritting BodyLocations.lua.  
- **DistributionAPI** ([Server](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/server/DistributionAPI))  
Easily manage your distribution tables.
- **ItemTooltipAPI** ([Client](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/client/ItemTooltipAPI))  
Make complex custom item tooltip for your new items.  
- **LightAPI** ([Client](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/client/LightAPI))  
Add persistent light anywhere in the world.  
- **SpawnerAPI** ([Client](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/client/SpawnerAPI) | [Server](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/server/SpawnerAPI))  
Spawn vehicles, items and zombies anywhere in the world.
- **WorldSoundAPI** ([Client](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/client/WorldSoundAPI))  
Add persistent sounds anywhere in the world.  
  
## Workflow
- Create/Publish a new branch named `<api_name> - <feature>`.  
- Do your work on that branch.  
- Commit your changes by prefixing your API name in the title.  
*Example -> `DistributionAPI: Added new feature`*  
- When you are ready to release an update create a **Pull Request**.  
- Assign the Pull Request to your project and assignees.  
- After quality control the merge will be completed.  
- The branch will be deleted.  
- Repeat the same process.  
  
## Guideline
- Commits should be prefixed with the API name.  
- Each API have a Github [Project](https://github.com/Konijima/PZ-Community-API/projects) to organize itself.  
- Each API have a Github [Wiki](https://github.com/Konijima/PZ-Community-API/wiki) section for instruction on how to use the API.  
- Workshop update weekly or daily if hotfix are required.  
- API Developers must agree together to work on someone else API.  
- Each API must be annoted and optimized.  
- Readme can be updated without creating new branches.
