-- ExperienceTracker.lua
XpFrame.startDateTime = time()
XpFrame.startTime = GetTime()
XpFrame.startXP = UnitXP("player")

-- Variables for tracking XP
XpFrame.totalXP = 0
XpFrame.mobCount = 0
XpFrame.mobXP, XpFrame.questXP, XpFrame.locationXP = 0, 0, 0
XpFrame.xpGains = {}

XpFrame.frame:RegisterEvent("CHAT_MSG_SYSTEM")
XpFrame.frame:RegisterEvent("PLAYER_LEVEL_UP")
XpFrame.frame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")

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
    C_Timer.After(1, function()
        local maxXP = UnitXPMax("player")
        local currentXP = UnitXP("player")
        local xpDiff = currentXP - XpFrame.startXP
        local xpToLevel = maxXP - currentXP
        local currentTime = GetTime()
        local timeDiff = (currentTime - XpFrame.startTime) / 60 -- in minutes

        local xpPerMin = timeDiff == 0 and 0 or xpDiff / timeDiff
        local xpPerHour = xpPerMin * 60
        local modeMobXP = XpFrame.CalculateModeXP()

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
        XpFrame.frame.mobsToLevelText:SetText(string.format("Mobs to Level: %.1f", mobsToLevel))
        XpFrame.frame.XpToLevelText:SetText(string.format("XP To Level: %d", xpToLevel))
        XpFrame.frame.XpToLevelText:SetTextColor(1, 1, 1)

        XpFrame.frame.startTimeText:SetText("Start Time: " .. date("%H:%M:%S", XpFrame.startDateTime))
        XpFrame.frame.TrackedTimeText:SetText(string.format("Tracked Time: %.2f min", timeDiff))
        XpFrame.frame.TimeToLevelText:SetText(string.format("Time to Level: %.2f min", timeToLevel))
        XpFrame.frame.TimeToLevelText:SetTextColor(1, 1, 1)
    end)

end

XpFrame.frame:SetScript("OnEvent", function(self, event, ...)

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_COMBAT_XP_GAIN" then
        local message = ...
        local xpGained = 0
        -- Parse XP from Mob Kills
        local creature, xp = string.match(message, "(.-) dies, you gain (%d+) experience.")
        if creature and xp then
            xpGained = tonumber(xp)
            XpFrame.mobXP = XpFrame.mobXP + xpGained
            XpFrame.totalXP = XpFrame.totalXP + xpGained
            XpFrame.mobCount = XpFrame.mobCount + 1
            XpFrame.xpGained = xpGained

            XpFrame.xpGains[xpGained] = (XpFrame.xpGains[xpGained] or 0) + 1
            XpFrame.UpdateDisplayText()
            return
        end

        -- Parse XP from Quest Turn-ins
        local questXP = string.match(message, "Experience gained: (%d+).")
        if questXP then
            xpGained = tonumber(questXP)
            XpFrame.questXP = XpFrame.questXP + xpGained
            XpFrame.totalXP = XpFrame.totalXP + xpGained
            XpFrame.UpdateDisplayText()
            return
        end

        -- Parse XP from Location Discovery
        local locationXP = string.match(message, "You discovered .- You gain (%d+) experience")
        locationXP = locationXP or string.match(message, "Discovered .-: (%d+) experience gained")
        if locationXP then
            xpGained = tonumber(locationXP)
            XpFrame.locationXP = XpFrame.locationXP + xpGained
            XpFrame.totalXP = XpFrame.totalXP + xpGained
            XpFrame.UpdateDisplayText()
            return
        end

    elseif event == "PLAYER_LEVEL_UP" then
        XpFrame.startDateTime = time()
        XpFrame.startTime = GetTime()
        XpFrame.startXP = 0
        XpFrame.mobCount = 0
        XpFrame.totalXP = 0
        XpFrame.mobXP = 0
        XpFrame.questXP = 0
        XpFrame.locationXP = 0
        XpFrame.xpGains = {}
        XpFrame.UpdateDisplayText()
    end
end)
