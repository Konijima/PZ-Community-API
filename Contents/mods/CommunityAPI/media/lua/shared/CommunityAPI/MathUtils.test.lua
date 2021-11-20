---
--- Created by Konijima.
--- DateTime: 2021-11-19 9:29 p.m.
---

local UnitTest = require("CommunityAPI/UnitTest")

local MathUtils = require("CommunityAPI/MathUtils")

local function onGameStart()

    local test = UnitTest.Start("CommunityAPI -> MathUtils")

    test:typeOf("GetDistanceFromTo: Should return a number", "number", MathUtils.GetDistanceFromTo, 0, 0, 1, 1)
    test:equalTo("GetDistanceFromTo: Should return 1.4142135381698608", 1.4142135381698608, MathUtils.GetDistanceFromTo, 0, 0, 1, 1)

    test:typeOf("GetDistance3DFromTo: Should return a number", "number", MathUtils.GetDistance3DFromTo, 0, 0, 0, 1, 1, 1)
    test:equalTo("GetDistance3DFromTo: Should return 1.7320507764816284", 1.7320507764816284, MathUtils.GetDistance3DFromTo, 0, 0, 0, 1, 1, 1)

    UnitTest.End(test)

end

Events.OnGameStart.Add(onGameStart)
