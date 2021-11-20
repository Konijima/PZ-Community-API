---
--- Created by Konijima.
--- DateTime: 2021-11-19 9:20 p.m.
---

require("CommunityAPI")
local UnitTest = require("CommunityAPI/UnitTest")

local LightAPI = CommunityAPI.Client.Light

local function onGameStart()

    local test = UnitTest.Start("CommunityAPI -> LightAPI")

    local playerObj = getPlayer()
    local pos = { x = playerObj:getX(), y = playerObj:getZ(), z = playerObj:getZ() }
    local col = { r = 1, g = 1, b = 1, a = 1}

    test:isNil("AddLightAt: Should return nil", LightAPI.AddLightAt, "lightTest", pos.x, pos.y, pos.z, 2, col)
    test:isNil("SetLightColorAt: Should return nil", LightAPI.SetLightColorAt, "lightTest", pos.x, pos.y, pos.z, col)
    test:isNil("SetLightRadiusAt: Should return nil", LightAPI.SetLightRadiusAt, "lightTest", pos.x, pos.y, pos.z, 2)
    test:isNil("RemoveLightAt: Should return nil", LightAPI.RemoveLightAt, "lightTest", pos.x, pos.y, pos.z)

    UnitTest.End(test)

end

Events.OnGameStart.Add(onGameStart)
