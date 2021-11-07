![Banner](https://github.com/Konijima/PZ-Community-API/blob/master/banner.png?raw=true)
  
**Developers:** Konijima, Yuhiko, Star, Tchernobill, ...  
**Contributors:** ...  
**Game Version:** 41.56-IWBUMS  
**Links:** [Wiki](https://github.com/Konijima/PZ-Community-API/wiki) | [Projects](https://github.com/Konijima/PZ-Community-API/projects) | [Workshop](https://github.com/Konijima/PZ-Community-API) | [Documentation](https://quarantin.github.io/zomboid-javadoc/41.56/) | [Emmylua](https://emmylua.github.io/)
  
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
- Each API have a Project to organize itself.
- Each API have a Wiki section for instruction on how to use the API.
- Workshop update weekly or daily if hotfix are required.
- Developer need to talk to each other to push changes into someone else API.
- Each API must be well written and optimized.
- Proper usage of `require("the_api_directory/api")`.
  
