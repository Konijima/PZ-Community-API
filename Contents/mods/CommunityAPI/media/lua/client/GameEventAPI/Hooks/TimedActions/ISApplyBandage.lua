require("CommunityAPI")

--- start

local original_ISApplyBandage_start = ISApplyBandage.start
function ISApplyBandage:start(...)
    original_ISApplyBandage_start(self, ...)
    CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnApplyBandageStart", self.character, self.otherPlayer, self.item)
end

--- stop

local original_ISApplyBandage_stop = ISApplyBandage.stop
function ISApplyBandage:stop(...)
    original_ISApplyBandage_stop(self, ...)
    CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnApplyBandageStop", self.character, self.otherPlayer, self.item)
end

--- perform

local original_ISApplyBandage_perform = ISApplyBandage.perform
function ISApplyBandage:perform(...)
    original_ISApplyBandage_perform(self, ...)
    CommunityAPI.Shared.Event.Trigger("GameEventAPI", "OnApplyBandagePerform", self.character, self.otherPlayer, self.item)
end
