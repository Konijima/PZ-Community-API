---
--- Created by Konijima.
--- DateTime: 2021-11-19 9:20 p.m.
---

require("CommunityAPI")
local UnitTest = require("CommunityAPI/UnitTest")

local WorldSoundAPI = CommunityAPI.Client.WorldSound

local function onGameStart()

    local test = UnitTest.Start("CommunityAPI -> WorldSoundAPI")

    local playerObj = getPlayer()
    local pos = { x = playerObj:getX(), y = playerObj:getZ(), z = playerObj:getZ() }
    local soundList = { "CatchFish" }

    test:isNil("AddSoundAt: Should return nil", WorldSoundAPI.AddSoundAt, "soundTest", pos.x, pos.y, pos.z, soundList)
    test:isNil("RemoveSoundAt: Should return nil", WorldSoundAPI.RemoveSoundAt, "soundTest", pos.x, pos.y, pos.z)
    test:isNil("RemoveAllSoundAt: Should return nil", WorldSoundAPI.RemoveAllSoundAt, pos.x, pos.y, pos.z)

    UnitTest.End(test)

end

Events.OnGameStart.Add(onGameStart)
