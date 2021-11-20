---
--- Created by Konijima.
--- DateTime: 2021-11-20 6:35 a.m.
---

require("ISBaseObject")

local UnitTest = require("CommunityAPI/UnitTest")

local newTest = UnitTest.Start("UnitTest")

local function func(returnValue)
    return returnValue
end

local newBaseObject = ISBaseObject:new()

local function onGameStart()

    local playerObj = getPlayer()

    newTest:isMetatableOf("newTest: should have a metatable of type 'UnitTestInstance'", "UnitTestInstance", newTest)
    newTest:isMetatableOf("newBaseObject: should have a metatable of type 'ISBaseObject'", ISBaseObject, newBaseObject)

    newTest:isNil("nil: should be nil", nil)
    newTest:isNil("func: should be nil", func)

    newTest:isNotNil("true: should be not nil", true)
    newTest:isNotNil("func(true): should be not nil", func, true)

    newTest:equalTo("1+1: should be equal to 2", 2, 1+1)
    newTest:equalTo("func(1+1): should be equal to 2", 2, func, 1+1)

    newTest:greaterThan("1: should be greater then 0", 0, 1)
    newTest:greaterThan("func(1): should be greater then 0", 0, func, 1)

    newTest:lesserThan("1: should be lesser then 2", 2, 1)
    newTest:lesserThan("func(1): should be lesser then 2", 2, func, 1)

    newTest:typeOf("'string': should be a string", "string", "string")
    newTest:typeOf("func('string'): should be a string", "string", func, "string")

    newTest:typeOf("123: should be a string", "number", 123)
    newTest:typeOf("func(123): should be a string", "number", func, 123)

    newTest:typeOf("{}: should be a table", "table", {})
    newTest:typeOf("func({}): should be a table", "table", func, {})

    newTest:typeOf("func(func): should return a function", "function", func, func)

    newTest:instanceOf("getPlayer(): should be an instance of IsoPlayer", "IsoPlayer", getPlayer)
    newTest:instanceOf("playerObj:getSquare(): should be an instance of IsoGridSquare", "IsoGridSquare", playerObj.getSquare, playerObj)

    UnitTest.End(newTest)

end

Events.OnGameStart.Add(onGameStart)
