-- ExperienceTracker.lua

XpFrame.startTime = GetTime()
XpFrame.startXP = UnitXP("player")

-- Variables for tracking mob XP
XpFrame.totalXP = 0
XpFrame.mobCount = 0
XpFrame.xpGains = {}

XpFrame.CalculateAverageMobXP = function()
    return XpFrame.mobCount == 0 and 0 or XpFrame.mobXP / XpFrame.mobCount
end

XpFrame.CalculateModeXP = function()
    local modeXP = 0
    local modeCount = 0

    for xp, count in pairs(XpFrame.xpGains) do
        if count > modeCount then
            modeCount = count
            modeXP = xp
        end
    end

    return modeXP
end

XpFrame.UpdateDisplayText = function()
    local xpDiff = UnitXP("player") - XpFrame.startXP
    local currentTime = GetTime()
    local timeDiff = (currentTime - XpFrame.startTime) / 60 -- in minutes

    local xpPerMin = timeDiff == 0 and 0 or xpDiff / timeDiff
    local xpPerHour = xpPerMin * 60
    local modeMobXP = XpFrame.CalculateModeXP()
    local xpToLevel = UnitXPMax("player") - UnitXP("player")
    local mobsToLevel = modeMobXP == 0 and 0 or xpToLevel / modeMobXP
    local timeToLevel = xpPerMin == 0 and 0 or xpToLevel / xpPerMin -- in minutes


    XpFrame.frame.totalXpText:SetText(string.format("Total XP: %d", XpFrame.totalXP))
    XpFrame.frame.mobXpText:SetText(string.format("Total Mob XP: %d", XpFrame.mobXP))
    XpFrame.frame.questXpText:SetText(string.format("Total Quest XP: %d", XpFrame.questXP))
    XpFrame.frame.locationXpText:SetText(string.format("Total Location XP: %d", XpFrame.locationXP))

    XpFrame.frame.xpPerMinText:SetText(string.format("XP/Min: %d", xpPerMin))
    XpFrame.frame.xpPerHourText:SetText(string.format("XP/Hour: %d", xpPerHour))

    XpFrame.frame.LastXpGainedText:SetText(string.format("Last Mob XP: %d", XpFrame.xpGained))
    XpFrame.frame.avgMobXPText:SetText(string.format("Mode Mob XP: %d", modeMobXP))
    XpFrame.frame.mobsToLevelText:SetText(string.format("Mobs to Level: %d", mobsToLevel))
    XpFrame.frame.XpToLevelText:SetText(string.format("XP To Level: %d", xpToLevel))
    XpFrame.frame.XpToLevelText:SetTextColor(1, 1, 1)

    XpFrame.frame.startTimeText:SetText("Start Time: " .. date("%H:%M:%S"))
    XpFrame.frame.TrackedTimeText:SetText(string.format("Tracked Time: %.2f min", timeDiff))
    XpFrame.frame.TimeToLevelText:SetText(string.format("Time to Level: %.2f min", timeToLevel))
    XpFrame.frame.TimeToLevelText:SetTextColor(1, 1, 1)
end

XpFrame.frame:RegisterEvent("PLAYER_XP_UPDATE")
XpFrame.frame:RegisterEvent("QUEST_TURNED_IN")
XpFrame.frame:RegisterEvent("ZONE_CHANGED")
XpFrame.frame:RegisterEvent("PLAYER_LEVEL_UP")
XpFrame.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
XpFrame.frame:RegisterEvent("PLAYER_REGEN_ENABLED")

XpFrame.isInCombat = false
XpFrame.lastXP = XpFrame.startXP

local prevXP = UnitXP("player")
XpFrame.mobXP, XpFrame.questXP, XpFrame.locationXP = 0, 0, 0
local isZoneChange = false
local lastQuestTurnInTime = 0
local lastSubzone = GetSubZoneText()

XpFrame.frame:SetScript("OnEvent", function(self, event, ...)
    
    if event == "PLAYER_XP_UPDATE" then
        local currXP = UnitXP("player")
        local diffXP = currXP - prevXP

        if currXP < prevXP then
            -- Account for overflow XP that contributed to level-up.
            local xpToLevelBeforeLevelUp = UnitXPMax("player") - prevXP
            diffXP = xpToLevelBeforeLevelUp + currXP
        end

        local isMobXP = true

        if not questXPAdded and GetTime() - lastQuestTurnInTime <= 2  and not XpFrame.isInCombat then
            -- This is XP from a quest turn-in
            XpFrame.questXP = XpFrame.questXP + diffXP
            questXPAdded = true  -- Set flag to true so we don't add quest XP again
            isMobXP = false
        elseif isZoneChange and not XpFrame.isInCombat and not questXPAdded then
            -- This is location XP
            XpFrame.locationXP = XpFrame.locationXP + diffXP
            isZoneChange = false
            isMobXP = false
        elseif isMobXP then
            XpFrame.mobXP = XpFrame.mobXP + diffXP
            XpFrame.mobCount = XpFrame.mobCount + 1
        end

        prevXP = currXP

        if currXP < XpFrame.lastXP then
            XpFrame.lastXP = 0
        end
            
        XpFrame.xpGained = currXP - XpFrame.lastXP
        XpFrame.xpGains[XpFrame.xpGained] = (XpFrame.xpGains[XpFrame.xpGained] or 0) + 1
        XpFrame.lastXP = currXP
        XpFrame.totalXP = XpFrame.totalXP + XpFrame.xpGained

        -- Use the UpdateDisplayText function here
        XpFrame.UpdateDisplayText()
    
    elseif event == "PLAYER_REGEN_DISABLED" then
        XpFrame.isInCombat = true
    
    elseif event == "PLAYER_REGEN_ENABLED" then
        XpFrame.isInCombat = false

    elseif event == "QUEST_TURNED_IN" then
        local _, xpGained = ...
        XpFrame.questXP = XpFrame.questXP + xpGained
        lastQuestTurnInTime = GetTime()  -- Set the time of the last quest turn-in
        questXPAdded = false  -- Reset the quest XP added flag

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        isZoneChange = true
    
    elseif event == "ZONE_CHANGED" then
        isZoneChange = true

    elseif event == "PLAYER_LEVEL_UP" then
        prevXP = 0
        XpFrame.startXP = 0
        XpFrame.lastXP = 0
        XpFrame.mobCount = 0
        XpFrame.totalXP = 0
        XpFrame.xpGains = {}
    end
end)




