# Project Zomboid Community API
**Developers:** Konijima, Yuhiko, Star, Tchernobill, ...  
**Contributors:** ...  
**Game Version:** 41.56-IWBUMS  
  
## API List
- [BodyLocationsAPI](https://github.com/Konijima/PZ-Community-API/tree/master/media/lua/client/BodyLocationsAPI)
- [DistributionAPI](https://github.com/Konijima/PZ-Community-API/tree/master/media/lua/server/DistributionAPI)
- [ItemTooltipAPI](https://github.com/Konijima/PZ-Community-API/tree/master/media/lua/client/ItemTooltipAPI)
- [ItemTweakerAPI](https://github.com/Konijima/PZ-Community-API/tree/master/media/lua/client/ItemTweakerAPI)
- [ModOptionAPI](https://github.com/Konijima/PZ-Community-API/tree/master/media/lua/client/ModOptionAPI)

## Guideline
- Each API create new branch for new update.
- When an update is ready we create a pull request to merge it with master.
- Commits should be prefixed with the API name.
- Each API has a Project to organize itself.
- Workshop update weekly or daily if hotfix are required.
- Developer need to talk to each other to push changes into someone else API.
- Each API must be well written and optimized.
- Each API can be used in mods using `require("the_api_directory/api")`.
  