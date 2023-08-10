-- SlashCommands.lua

SLASH_XPTRACKER1 = "/xptracker"
SlashCmdList["XPTRACKER"] = function(msg)
    if XpFrame.frame:IsShown() then
        XpFrame.frame:Hide()
    else
        XpFrame.frame:Show()
    end
end
