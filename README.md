![Banner](https://github.com/Konijima/PZ-Community-API/blob/master/Images/banner.png?raw=true)
  
  
# CommunityAPI
Community API is a team effort to centralize & give mod creators optimized tools for creating quality mods.  
For mod compatibility and efficiency, working as a team ensure that the API is updated and optimized for the long term.  
  
[![Percentage of issues still open](http://isitmaintained.com/badge/open/Konijima/PZ-Community-API.svg)](http://isitmaintained.com/project/Konijima/PZ-Community-API "Percentage of issues still open")
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/Konijima/PZ-Community-API.svg)](http://isitmaintained.com/project/Konijima/PZ-Community-API "Average time to resolve an issue")
  
**Project Zomboid Version Support:**
```
master  41.56-IWBUMS
dev     41.56-IWBUMS
```
  
[![Discord](https://github.com/Konijima/PZ-Community-API/blob/dev/Images/discord.png?raw=true)](https://discord.gg/3rjszKXQ)  
  
### Usefull Links:
[Our Coding Convention](https://github.com/Konijima/PZ-Community-API/blob/master/CodingConvention.md)  
[CommunityAPI Wiki](https://github.com/Konijima/PZ-Community-API/wiki)  
[CommunityAPI Utilities](https://github.com/Konijima/PZ-Community-API/blob/master/Contents/mods/CommunityAPI/media/lua/shared/CommunityAPI)  
[Git Projects](https://github.com/Konijima/PZ-Community-API/projects)  
[Our Steam Workshop](https://steamcommunity.com/profiles/76561199220019224/myworkshopfiles/?appid=108600)  
[Annotation with Emmylua](https://emmylua.github.io/)  
[PZ Documentation](https://quarantin.github.io/zomboid-javadoc/41.56/)
[Template API](https://github.com/Konijima/PZ-Community-API/blob/master/TemplateAPI.lua.md)  
  
___
  
## Modders Team
**Developers:** 
- Konijima ([Steam](https://steamcommunity.com/id/konijima/myworkshopfiles/?appid=108600) | [Github](https://github.com/Konijima))  
- Shurutsue ([Steam](https://steamcommunity.com/id/Shurutsue/myworkshopfiles/?appid=108600) | [Github](https://github.com/Shurutsue))  
- Chuck ([Steam](https://steamcommunity.com/id/Chuckleberry_Finn/myworkshopfiles/?appid=108600) | [Github](https://github.com/ChuckTheSheep))  
- co ([Steam](https://steamcommunity.com/profiles/76561198056536755/myworkshopfiles/?appid=108600) | [Github](https://github.com/quarantin))  
- Aiteron ([Steam](https://steamcommunity.com/profiles/76561198211669377/myworkshopfiles/?appid=108600) | [Github](https://github.com/aiteron))
  
**3D Modeling & Animations**  
- shark ([Steam](https://steamcommunity.com/profiles/76561198004947199/myworkshopfiles/?appid=108600) | [Github](https://github.com/sharkster91))  
- AuthenticPeach ([Steam](https://steamcommunity.com/id/authentic_peach/myworkshopfiles/?appid=108600) | [Github](https://github.com/AuthenticPeach))
  
___
  
## Available API
- **BodyLocationsAPI** ([Shared](https://github.com/Konijima/PZ-Community-API/tree/master/Contents/mods/CommunityAPI/media/lua/shared/BodyLocationsAPI))  
Tweak body locations without overwriting BodyLocations.lua.
  
  
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

___
  
## Git Guideline
- Commit title must describe correctly the changes being pushed.  
- Commit that fixes an `issue` must contain the number of the issue in the comment. e.g: ```#13```
- **Pull Request** to `master` and `dev` must be reviewed by at least one contributor to be merged.
- Workshop update are automated when a `release` is merged into `master`.
- Each feature must be properly annotated and optimized as well.
- Documentation must be kept up-to-date with the features.
- Each feature have a  [Git Project](https://github.com/Konijima/PZ-Community-API/projects) page to keep track of `Todo`, `In progress`, `Completed` pull requests.
- Every feature **Pull Request** must be assigned with appropriated `label`, `assignee`, `project`.
  
### Main Branches:
- `master`  = Stable released version.
- `dev` = Development version.
  
### Temporary Branches:
- `feature` = Created from `dev` branch when creating or developing a feature.
- `release` = Created from `dev` branch target features are ready for an update.
- `hotfix`  = Created from `master` branch when a hotfix need to be done.
  
### Feature branches:
May **branch off from**: `dev`  
Must **merge back into**: `dev`
  
### Release branches:
May **branch off from**: `dev`  
Must **merge back into**: `dev` & `master`
  
### Hotfix branches:
May **branch off from**: `master`  
Must **merge back into**: `dev` & `master`
  
___