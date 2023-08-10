-- XpFrameContainer.lua

XpFrame = XpFrame or {}

XpFrame.frame = CreateFrame("Frame", "XPTrackerFrame", UIParent, "BackdropTemplate")

local frame = XpFrame.frame
frame:SetSize(210, 270)
frame:SetPoint("CENTER", UIParent, "CENTER")
frame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tileSize = 16,
    edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
})
frame:SetBackdropColor(0, 0, 0, .8)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Show()

frame.titleIcon = frame:CreateTexture(nil, "OVERLAY")
frame.titleIcon:SetTexture("Interface\\Icons\\Ability_DualWield")  -- Just an example icon
frame.titleIcon:SetSize(32, 32)
frame.titleIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)

frame.backdropFrame = CreateFrame("Frame", "NAVFRAME", frame, "BackdropTemplate")
frame.backdropFrame:SetSize(40, 100) 
frame.backdropFrame:SetPoint("TOP", frame.titleIcon, "BOTTOM", 0, -5)
frame.backdropFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
    tile = true, tileSize = 16, edgeSize = 16, 
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
frame.backdropFrame:SetBackdropColor(0, 0, 0, 0.5)

local function createEnhancedFontString(parent, anchorFrame, text, selfPoint, parentPoint, hPadding, vPadding, r, g, b)
    anchorPoints = {
        ["T"] = "TOP",
        ["TL"] = "TOPLEFT",
        ["TR"] = "TOPRIGHT",
        ["C"] = "CENTER",
        ["L"] = "LEFT",
        ["R"] = "RIGHT",
        ["B"] = "BOTTOM",
        ["BL"] = "BOTTOMLEFT",
        ["BR"] = "BOTTOMRIGHT"
    }
    local r = r or 1
    local g = g or 1
    local b = b or 1
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    -- fs:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -textPadding)
    fs:SetPoint(anchorPoints[selfPoint], anchorFrame, anchorPoints[parentPoint], hPadding, vPadding)
    fs:SetTextColor(r, g, b)
    fs:SetText(text)

    return fs
end



frame.titleText = createEnhancedFontString(frame, frame.titleIcon, "Experience Tracker","L","R", 5, 0, 1, 0.8, 0)
frame.titleText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

frame.totalXpText = createEnhancedFontString(frame, frame.backdropFrame, "Total XP: 0","TL","TR",5,0)
frame.mobXpText = createEnhancedFontString(frame, frame.totalXpText, "Total Mob XP: 0","TL","BL",0,-3)
frame.questXpText = createEnhancedFontString(frame, frame.mobXpText, "Total Quest XP: 0","TL","BL",0,-3)
frame.locationXpText = createEnhancedFontString(frame, frame.questXpText, "Total Location XP: 0","TL","BL",0,-3)

frame.xpPerMinText = createEnhancedFontString(frame, frame.locationXpText, "XP/Min: 0","TL","BL",0,-10)
frame.xpPerHourText = createEnhancedFontString(frame, frame.xpPerMinText, "XP/Hour: 0","TL","BL",0,-3)

frame.LastXpGainedText = createEnhancedFontString(frame, frame.xpPerHourText, "Last Mob XP: 0","TL","BL",0,-10)
frame.avgMobXPText = createEnhancedFontString(frame, frame.LastXpGainedText, "Mode Mob XP: 0","TL","BL",0,-3)
frame.mobsToLevelText = createEnhancedFontString(frame, frame.avgMobXPText, "Mobs to Level: 0","TL","BL",0,-3)
frame.XpToLevelText = createEnhancedFontString(frame, frame.mobsToLevelText, "XP to Level: 0","TL","BL", 0, -3, 1, 0, 0)

frame.startTimeText = createEnhancedFontString(frame, frame.XpToLevelText, "Start Time: 0","TL","BL",0,-10)
frame.TrackedTimeText = createEnhancedFontString(frame, frame.startTimeText, "Tracked Time: 0","TL","BL",0,-3)
frame.TimeToLevelText = createEnhancedFontString(frame, frame.TrackedTimeText, "Time to Level: 0","TL","BL", 0, -3, 1, 0, 0)
