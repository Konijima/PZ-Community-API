---
--- Created by Konijima.
--- DateTime: 2021-11-20 6:20 a.m.
---

local UnitTest = require("CommunityAPI/UnitTest")

local EventAPI = require("EventAPI/EventAPIShared")

local function onGameStart()

    local test = UnitTest.Start("CommunityAPI -> EventAPI")

    local function testHandler(param1)
        test:equalTo("Handler param1: Should return 'testParam1'", "testParam1", param1)
    end

    test:isNil("Add: Should return nil", EventAPI.Add, "modName", "testHandler", testHandler)
    test:isNil("Trigger: Should return nil", EventAPI.Trigger, "modName", "testHandler", "testParam1")
    test:isNil("Remove: Should return nil", EventAPI.Remove, "modName", "testHandler", testHandler)

    UnitTest.End(test)

end

Events.OnGameStart.Add(onGameStart)
