-- Buttons.lua

-- Create the Reset Mode Data button
-- local resetModeButton = CreateFrame("Button", nil, XpFrame.frame, "GameMenuButtonTemplate")
-- resetModeButton:SetSize(100, 25)
-- resetModeButton:SetPoint("BOTTOM", XpFrame.frame, "BOTTOM", 0, 5) -- Centered and positioned above Reset Mode Data
-- resetModeButton:SetText("Reset Mode XP")
-- resetModeButton:SetFrameLevel(XpFrame.backdropFrame:GetFrameLevel() + 1)

-- resetModeButton:SetScript("OnClick", function()
--     local modeMobXP = XpFrame.CalculateModeXP()
--     XpFrame.xpGains = {}
--     XpFrame.xpGains[modeMobXP] = (XpFrame.xpGains[modeMobXP] or 0) + 1
--     XpFrame.UpdateDisplayText()  -- using the previously created function to update the display
-- end)

-- Create a button frame
local playButton = CreateFrame("Button", "XPTrackerPlayButton", XpFrame.frame, "UIPanelButtonTemplate")
playButton:SetSize(30, 30)
playButton:SetPoint("TOP", XpFrame.frame.backdropFrame, "TOP", 0, -5)

-- Use a built-in WoW texture for the button
local texturePath = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"  -- This is an arrow, but serves as a simple example
playButton:SetNormalTexture(texturePath)
playButton:SetPushedTexture(texturePath)
playButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Set the OnEnter handler for the button to display the tooltip
playButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 10)
    GameTooltip:SetText("Begin tracking XP", 1, 1, 1)  -- Tooltip content with RGB colors for white text
    GameTooltip:Show()  -- Show the tooltip
end)

-- Set the OnLeave handler for the button to hide the tooltip
playButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()  -- Hide the tooltip
end)

-- Action when the button is clicked
playButton:SetScript("OnClick", function()
    print("XP Tracking Started")
    XpFrame.startTime = GetTime()
    XpFrame.UpdateDisplayText()
end)


-- Create a reload button frame
local reloadButton = CreateFrame("Button", "XPTrackerReloadButton", XpFrame.frame, "UIPanelButtonTemplate")
reloadButton:SetSize(30, 30)
reloadButton:SetPoint("TOP", playButton, "BOTTOM", 0, 5)  -- position it slightly to the right of center

-- Use a built-in WoW texture for the reload button (for demonstration)
local reloadTexturePath = "Interface\\Buttons\\UI-RotationRight-Button-Up"  -- This is not an ideal texture for "reload", but serves as a simple example
reloadButton:SetNormalTexture(reloadTexturePath)
reloadButton:SetPushedTexture(reloadTexturePath)
reloadButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
-- reloadButton:SetFrameLevel(XpFrame.backdropFrame:GetFrameLevel() + 1)

-- Set the OnEnter handler for the button to display the tooltip
reloadButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 10) -- Position tooltip to the right of the button
    GameTooltip:SetText("Reset the data", 1, 1, 1)  -- Tooltip content with RGB colors for white text
    GameTooltip:Show()  -- Show the tooltip
end)

-- Set the OnLeave handler for the button to hide the tooltip
reloadButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()  -- Hide the tooltip
end)

-- Action when the reload button is clicked
reloadButton:SetScript("OnClick", function()
    print("XP Tracking Reset")
    XpFrame.mobXP, XpFrame.questXP, XpFrame.locationXP = 0, 0, 0
    XpFrame.startTime = GetTime()
    XpFrame.startXP = UnitXP("player")
    XpFrame.xpGains = {}
    XpFrame.mobCount = 0
    XpFrame.totalXP = 0
    XpFrame.UpdateDisplayText()
end)